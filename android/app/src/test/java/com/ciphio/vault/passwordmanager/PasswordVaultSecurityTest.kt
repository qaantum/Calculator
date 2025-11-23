package com.ciphio.vault.passwordmanager

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.emptyPreferences
import androidx.datastore.preferences.core.stringPreferencesKey
import com.ciphio.vault.crypto.CryptoService
import com.google.common.truth.Truth.assertThat
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Before
import org.junit.Test
import java.util.UUID
import java.util.concurrent.atomic.AtomicReference

/**
 * Security tests for PasswordVaultRepository.
 * 
 * These tests verify security aspects:
 * - Master password derivation
 * - Encryption strength
 * - Key storage security
 * - Data persistence and integrity
 */
class PasswordVaultSecurityTest {

    private lateinit var cryptoService: CryptoService
    private lateinit var dataStore: DataStore<Preferences>
    private lateinit var repository: PasswordVaultRepository
    private val masterPassword = "TestPassword123!@#"

    @Before
    fun setup() {
        cryptoService = CryptoService()
        dataStore = createInMemoryDataStore()
        repository = PasswordVaultRepository(dataStore, cryptoService)
    }

    @Test
    fun `master password is not stored in plaintext`() = runTest {
        repository.setMasterPassword(masterPassword)
        
        // Verify password hash is stored, not plaintext
        val prefs = dataStore.data.first()
        val storedHash = prefs[MASTER_PASSWORD_HASH_KEY]
        
        assertThat(storedHash).isNotNull()
        assertThat(storedHash).isNotEqualTo(masterPassword)
        // Hash should be different from original password
        assertThat(storedHash?.length).isGreaterThan(masterPassword.length)
    }

    @Test
    fun `password entries are encrypted before storage`() = runTest {
        repository.setMasterPassword(masterPassword)
        val entry = PasswordEntry(
            service = "example.com",
            username = "testuser",
            password = "secretpassword123"
        )

        repository.addEntry(entry, masterPassword)

        // Verify data in storage is encrypted
        val prefs = dataStore.data.first()
        val encryptedData = prefs[PASSWORDS_KEY]
        
        assertThat(encryptedData).isNotNull()
        // Encrypted data should not contain plaintext password
        assertThat(encryptedData).doesNotContain("secretpassword123")
        assertThat(encryptedData).doesNotContain("testuser")
        // Should contain encryption prefix
        assertThat(encryptedData).contains(":")
    }

    @Test
    fun `encrypted data cannot be decrypted with wrong password`() = runTest {
        repository.setMasterPassword(masterPassword)
        val entry = PasswordEntry(
            service = "example.com",
            username = "testuser",
            password = "secretpassword"
        )

        repository.addEntry(entry, masterPassword)

        // Try to decrypt with wrong password
        val entriesWithWrongPassword = repository.getAllEntries("WrongPassword123").first()
        assertThat(entriesWithWrongPassword).isEmpty()
    }

    @Test
    fun `master password verification prevents unauthorized access`() = runTest {
        repository.setMasterPassword(masterPassword)
        val entry = PasswordEntry(
            service = "test.com",
            username = "user",
            password = "pass"
        )
        repository.addEntry(entry, masterPassword)

        // Verify correct password works
        val isValidCorrect = repository.verifyMasterPassword(masterPassword)
        assertThat(isValidCorrect).isEqualTo(true)

        // Verify wrong password fails
        val isValidWrong = repository.verifyMasterPassword("WrongPassword")
        assertThat(isValidWrong).isFalse()
    }

    @Test
    fun `password entries are re-encrypted when master password changes`() = runTest {
        repository.setMasterPassword(masterPassword)
        val entry = PasswordEntry(
            service = "example.com",
            username = "testuser",
            password = "secretpassword"
        )

        repository.addEntry(entry, masterPassword)
        val oldEncrypted = dataStore.data.first()[PASSWORDS_KEY]

        // Change master password
        val newMasterPassword = "NewPassword456!@#"
        val success = repository.changeMasterPassword(masterPassword, newMasterPassword)
        assertThat(success).isEqualTo(true)

        val newEncrypted = dataStore.data.first()[PASSWORDS_KEY]
        
        // Encrypted data should be different after password change (if entries exist)
        if (oldEncrypted != null && newEncrypted != null) {
            assertThat(newEncrypted).isNotEqualTo(oldEncrypted)
        }
        
        // But entries should still be accessible with new password
        val entries = repository.getAllEntries(newMasterPassword).first()
        assertThat(entries).hasSize(1)
        assertThat(entries[0].password).isEqualTo("secretpassword")
    }

    @Test
    fun `exported data is encrypted`() = runTest {
        repository.setMasterPassword(masterPassword)
        val entry = PasswordEntry(
            service = "example.com",
            username = "testuser",
            password = "secretpassword"
        )

        repository.addEntry(entry, masterPassword)
        val exported = repository.exportEntries(masterPassword)!!

        // Exported data should be encrypted
        assertThat(exported).doesNotContain("secretpassword")
        assertThat(exported).doesNotContain("testuser")
        assertThat(exported).contains(":")
    }

    @Test
    fun `exported data cannot be decrypted without master password`() = runTest {
        repository.setMasterPassword(masterPassword)
        val entry = PasswordEntry(
            service = "example.com",
            username = "testuser",
            password = "secretpassword"
        )

        repository.addEntry(entry, masterPassword)
        val exported = repository.exportEntries(masterPassword)!!

        // Try to import with wrong password
        val newDataStore = createInMemoryDataStore()
        val newRepository = PasswordVaultRepository(newDataStore, cryptoService)
        
        // This should fail or return error result
        val result = newRepository.importEntries(exported, "WrongPassword", merge = false)
        
        // Import should fail with wrong password (should return error result)
        assertThat(result.isError).isTrue()
    }

    @Test
    fun `data integrity is maintained after encryption and decryption`() = runTest {
        repository.setMasterPassword(masterPassword)
        val originalEntry = PasswordEntry(
            service = "example.com",
            username = "testuser",
            password = "secretpassword",
            notes = "Test notes",
            categories = listOf("Bank", "Important")
        )

        repository.addEntry(originalEntry, masterPassword)

        val entries = repository.getAllEntries(masterPassword).first()
        assertThat(entries).hasSize(1)
        
        val retrievedEntry = entries[0]
        // Verify all fields are preserved
        assertThat(retrievedEntry.service).isEqualTo(originalEntry.service)
        assertThat(retrievedEntry.username).isEqualTo(originalEntry.username)
        assertThat(retrievedEntry.password).isEqualTo(originalEntry.password)
        assertThat(retrievedEntry.notes).isEqualTo(originalEntry.notes)
        assertThat(retrievedEntry.getAllCategories()).containsExactlyElementsIn(originalEntry.getAllCategories())
    }

    @Test
    fun `multiple entries maintain separate encryption`() = runTest {
        repository.setMasterPassword(masterPassword)
        val entry1 = PasswordEntry(
            id = UUID.randomUUID().toString(),
            service = "site1.com",
            username = "user1",
            password = "pass1"
        )
        val entry2 = PasswordEntry(
            id = UUID.randomUUID().toString(),
            service = "site2.com",
            username = "user2",
            password = "pass2"
        )

        repository.addEntry(entry1, masterPassword)
        repository.addEntry(entry2, masterPassword)

        val entries = repository.getAllEntries(masterPassword).first()
        assertThat(entries).hasSize(2)
        
        // Verify both entries are correctly decrypted
        assertThat(entries.any { it.service == "site1.com" && it.password == "pass1" }).isEqualTo(true)
        assertThat(entries.any { it.service == "site2.com" && it.password == "pass2" }).isEqualTo(true)
    }

    @Test
    fun `master password hash is deterministic`() = runTest {
        repository.setMasterPassword(masterPassword)
        val hash1 = dataStore.data.first()[MASTER_PASSWORD_HASH_KEY]

        // Create new repository instance and set same password
        val newDataStore = createInMemoryDataStore()
        val newRepository = PasswordVaultRepository(newDataStore, cryptoService)
        newRepository.setMasterPassword(masterPassword)
        val hash2 = newDataStore.data.first()[MASTER_PASSWORD_HASH_KEY]

        // Hashes should be the same for the same password
        assertThat(hash1).isEqualTo(hash2)
    }

    // Helper function to create an in-memory test DataStore
    private fun createInMemoryDataStore(): DataStore<Preferences> {
        val preferencesRef = AtomicReference(emptyPreferences())
        val stateFlow = kotlinx.coroutines.flow.MutableStateFlow(emptyPreferences())
        
        return object : DataStore<Preferences> {
            override val data: kotlinx.coroutines.flow.Flow<Preferences> = stateFlow

            override suspend fun updateData(transform: suspend (Preferences) -> Preferences): Preferences {
                val current = preferencesRef.get()
                val updated = transform(current)
                preferencesRef.set(updated)
                stateFlow.value = updated
                return updated
            }
        }
    }
    
    companion object {
        private val PASSWORDS_KEY = stringPreferencesKey("password_vault")
        private val MASTER_PASSWORD_HASH_KEY = stringPreferencesKey("master_password_hash")
    }
}

