package com.ciphio.vault.passwordmanager

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.emptyPreferences
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
 * Unit tests for PasswordVaultRepository.
 * 
 * Note: These tests use a simple in-memory DataStore implementation.
 * For more complex scenarios, consider using integration tests with a real DataStore.
 */
class PasswordVaultRepositoryTest {

    private lateinit var cryptoService: CryptoService
    private lateinit var dataStore: DataStore<Preferences>
    private lateinit var repository: PasswordVaultRepository
    private val masterPassword = "TestPassword123!"

    @Before
    fun setup() {
        cryptoService = CryptoService()
        dataStore = createInMemoryDataStore()
        repository = PasswordVaultRepository(dataStore, cryptoService)
    }

    @Test
    fun `addEntry adds new entry successfully`() = runTest {
        // Set master password first
        repository.setMasterPassword(masterPassword)
        
        val entry = PasswordEntry(
            service = "example.com",
            username = "testuser",
            password = "password123"
        )

        val result = repository.addEntry(entry, masterPassword)
        assertThat(result).isEqualTo(true)

        val entries = repository.getAllEntries(masterPassword).first()
        assertThat(entries).hasSize(1)
        assertThat(entries[0].service).isEqualTo("example.com")
        assertThat(entries[0].username).isEqualTo("testuser")
    }

    @Test
    fun `addEntry encrypts data before storing`() = runTest {
        repository.setMasterPassword(masterPassword)
        val entry = PasswordEntry(
            service = "example.com",
            username = "testuser",
            password = "secretpassword"
        )

        repository.addEntry(entry, masterPassword)

        // Verify data is encrypted by trying to decrypt with wrong password
        val entriesWithWrongPassword = repository.getAllEntries("WrongPassword").first()
        assertThat(entriesWithWrongPassword).isEmpty()
    }

    @Test
    fun `updateEntry modifies existing entry`() = runTest {
        repository.setMasterPassword(masterPassword)
        val originalEntry = PasswordEntry(
            id = UUID.randomUUID().toString(),
            service = "example.com",
            username = "testuser",
            password = "password123"
        )

        repository.addEntry(originalEntry, masterPassword)

        val updatedEntry = originalEntry.copy(
            username = "updateduser",
            password = "newpassword"
        )

        repository.updateEntry(updatedEntry, masterPassword)

        val entries = repository.getAllEntries(masterPassword).first()
        assertThat(entries).hasSize(1)
        assertThat(entries[0].username).isEqualTo("updateduser")
        assertThat(entries[0].password).isEqualTo("newpassword")
    }

    @Test
    fun `deleteEntry removes entry successfully`() = runTest {
        repository.setMasterPassword(masterPassword)
        val entry1 = PasswordEntry(
            id = UUID.randomUUID().toString(),
            service = "example.com",
            username = "user1",
            password = "pass1"
        )
        val entry2 = PasswordEntry(
            id = UUID.randomUUID().toString(),
            service = "test.com",
            username = "user2",
            password = "pass2"
        )

        repository.addEntry(entry1, masterPassword)
        repository.addEntry(entry2, masterPassword)

        repository.deleteEntry(entry1.id, masterPassword)

        val entries = repository.getAllEntries(masterPassword).first()
        assertThat(entries).hasSize(1)
        assertThat(entries[0].id).isEqualTo(entry2.id)
    }

    @Test
    fun `getAllEntries returns empty list when no entries exist`() = runTest {
        repository.setMasterPassword(masterPassword)
        val entries = repository.getAllEntries(masterPassword).first()
        assertThat(entries).isEmpty()
    }

    @Test
    fun `getAllEntries returns all entries in descending order by updatedAt`() = runTest {
        repository.setMasterPassword(masterPassword)
        val entry1 = PasswordEntry(
            id = UUID.randomUUID().toString(),
            service = "old.com",
            username = "user1",
            password = "pass1",
            updatedAt = 1000L
        )
        val entry2 = PasswordEntry(
            id = UUID.randomUUID().toString(),
            service = "new.com",
            username = "user2",
            password = "pass2",
            updatedAt = 2000L
        )

        repository.addEntry(entry1, masterPassword)
        repository.addEntry(entry2, masterPassword)

        val entries = repository.getAllEntries(masterPassword).first()
        assertThat(entries).hasSize(2)
        // Should be sorted by updatedAt descending (newest first)
        assertThat(entries[0].service).isEqualTo("new.com")
        assertThat(entries[1].service).isEqualTo("old.com")
    }

    @Test
    fun `addEntry prevents duplicate entries by ID`() = runTest {
        repository.setMasterPassword(masterPassword)
        val entryId = UUID.randomUUID().toString()
        val entry1 = PasswordEntry(
            id = entryId,
            service = "example.com",
            username = "user1",
            password = "pass1"
        )
        val entry2 = PasswordEntry(
            id = entryId, // Same ID
            service = "example.com",
            username = "user2",
            password = "pass2"
        )

        repository.addEntry(entry1, masterPassword)
        repository.addEntry(entry2, masterPassword)

        val entries = repository.getAllEntries(masterPassword).first()
        assertThat(entries).hasSize(1)
        // Should keep the latest entry
        assertThat(entries[0].username).isEqualTo("user2")
    }

    @Test
    fun `exportEntries returns encrypted JSON string`() = runTest {
        repository.setMasterPassword(masterPassword)
        val entry = PasswordEntry(
            service = "example.com",
            username = "testuser",
            password = "password123"
        )

        repository.addEntry(entry, masterPassword)

        val exported = repository.exportEntries(masterPassword)
        assertThat(exported).isNotNull()
        assertThat(exported).isNotEmpty()
        // Should start with encryption prefix
        assertThat(exported).contains(":")
    }

    @Test
    fun `importEntries from encrypted format works correctly`() = runTest {
        repository.setMasterPassword(masterPassword)
        val entry = PasswordEntry(
            service = "example.com",
            username = "testuser",
            password = "password123"
        )

        repository.addEntry(entry, masterPassword)
        val exported = repository.exportEntries(masterPassword)!!

        // Create new repository instance to simulate import
        val newDataStore = createInMemoryDataStore()
        val newRepository = PasswordVaultRepository(newDataStore, cryptoService)
        newRepository.setMasterPassword(masterPassword)

        val result = newRepository.importEntries(exported, masterPassword, merge = false)
        assertThat(result.isError).isFalse()
        assertThat(result.newEntriesCount).isEqualTo(1)

        val importedEntries = newRepository.getAllEntries(masterPassword).first()
        assertThat(importedEntries).hasSize(1)
        assertThat(importedEntries[0].service).isEqualTo("example.com")
    }

    @Test
    fun `importEntries from CSV format works correctly`() = runTest {
        repository.setMasterPassword(masterPassword)
        val csvData = """
            url,username,password,name,notes
            https://example.com,testuser,password123,Example Site,Test notes
            https://test.com,user2,pass456,Test Site,More notes
        """.trimIndent()

        val result = repository.importEntries(csvData, masterPassword, merge = false)
        assertThat(result.isError).isFalse()
        assertThat(result.newEntriesCount).isEqualTo(2)

        val entries = repository.getAllEntries(masterPassword).first()
        assertThat(entries).hasSize(2)
        assertThat(entries.any { it.service == "example.com" }).isEqualTo(true)
        assertThat(entries.any { it.service == "test.com" }).isEqualTo(true)
    }

    @Test
    fun `importEntries with merge mode adds to existing entries`() = runTest {
        repository.setMasterPassword(masterPassword)
        val existingEntry = PasswordEntry(
            service = "existing.com",
            username = "existinguser",
            password = "existingpass"
        )
        repository.addEntry(existingEntry, masterPassword)

        val csvData = """
            url,username,password,name
            https://new.com,newuser,newpass,New Site
        """.trimIndent()

        val result = repository.importEntries(csvData, masterPassword, merge = true)
        assertThat(result.isError).isFalse()
        assertThat(result.newEntriesCount).isEqualTo(1)

        val entries = repository.getAllEntries(masterPassword).first()
        assertThat(entries).hasSize(2)
    }

    @Test
    fun `setMasterPassword stores password hash`() = runTest {
        repository.setMasterPassword(masterPassword)

        val hasPassword = repository.hasMasterPassword()
        assertThat(hasPassword).isEqualTo(true)
    }

    @Test
    fun `verifyMasterPassword returns true for correct password`() = runTest {
        repository.setMasterPassword(masterPassword)
        val entry = PasswordEntry(
            service = "test.com",
            username = "user",
            password = "pass"
        )
        repository.addEntry(entry, masterPassword)

        val isValid = repository.verifyMasterPassword(masterPassword)
        assertThat(isValid).isEqualTo(true)
    }

    @Test
    fun `verifyMasterPassword returns false for incorrect password`() = runTest {
        repository.setMasterPassword(masterPassword)
        val entry = PasswordEntry(
            service = "test.com",
            username = "user",
            password = "pass"
        )
        repository.addEntry(entry, masterPassword)

        val isValid = repository.verifyMasterPassword("WrongPassword")
        assertThat(isValid).isFalse()
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
}
