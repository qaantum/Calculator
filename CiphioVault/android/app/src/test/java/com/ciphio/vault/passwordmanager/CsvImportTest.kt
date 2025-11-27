package com.ciphio.vault.passwordmanager

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.emptyPreferences
import com.ciphio.vault.crypto.CryptoService
import com.google.common.truth.Truth.assertThat
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Before
import org.junit.Test
import java.util.concurrent.atomic.AtomicReference

/**
 * Unit tests for CSV import parsing functionality.
 */
class CsvImportTest {

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
    fun `parse CSV with standard format`() = runTest {
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
    fun `parse CSV with quoted fields`() = runTest {
        repository.setMasterPassword(masterPassword)
        val csvData = """
            "url","username","password","name","notes"
            "https://example.com","testuser","password123","Example Site","Test notes"
        """.trimIndent()

        val result = repository.importEntries(csvData, masterPassword, merge = false)
        assertThat(result.isError).isFalse()
        assertThat(result.newEntriesCount).isEqualTo(1)

        val entries = repository.getAllEntries(masterPassword).first()
        assertThat(entries).hasSize(1)
        assertThat(entries[0].username).isEqualTo("testuser")
    }

    @Test
    fun `parse CSV with different column order`() = runTest {
        repository.setMasterPassword(masterPassword)
        val csvData = """
            name,password,username,url
            Example Site,password123,testuser,https://example.com
        """.trimIndent()

        val result = repository.importEntries(csvData, masterPassword, merge = false)
        assertThat(result.isError).isFalse()
        assertThat(result.newEntriesCount).isEqualTo(1)

        val entries = repository.getAllEntries(masterPassword).first()
        assertThat(entries).hasSize(1)
        assertThat(entries[0].service).isEqualTo("example.com")
        assertThat(entries[0].username).isEqualTo("testuser")
    }

    @Test
    fun `parse CSV with missing optional fields`() = runTest {
        repository.setMasterPassword(masterPassword)
        val csvData = """
            url,username,password
            https://example.com,testuser,password123
        """.trimIndent()

        val result = repository.importEntries(csvData, masterPassword, merge = false)
        assertThat(result.isError).isFalse()
        assertThat(result.newEntriesCount).isEqualTo(1)

        val entries = repository.getAllEntries(masterPassword).first()
        assertThat(entries).hasSize(1)
        assertThat(entries[0].service).isEqualTo("example.com")
    }

    @Test
    fun `parse CSV extracts domain from URL`() = runTest {
        repository.setMasterPassword(masterPassword)
        val csvData = """
            url,username,password
            https://www.example.com,testuser,password123
        """.trimIndent()

        val result = repository.importEntries(csvData, masterPassword, merge = false)
        assertThat(result.isError).isFalse()

        val entries = repository.getAllEntries(masterPassword).first()
        assertThat(entries).hasSize(1)
        // Should extract domain from URL
        assertThat(entries[0].service).contains("example.com")
    }

    @Test
    fun `parse CSV handles empty lines`() = runTest {
        repository.setMasterPassword(masterPassword)
        val csvData = """
            url,username,password,name
            
            https://example.com,testuser,password123,Example Site
            
        """.trimIndent()

        val result = repository.importEntries(csvData, masterPassword, merge = false)
        assertThat(result.isError).isFalse()
        assertThat(result.newEntriesCount).isEqualTo(1)
    }

    @Test
    fun `parse CSV handles missing password field`() = runTest {
        repository.setMasterPassword(masterPassword)
        val csvData = """
            url,username,name
            https://example.com,testuser,Example Site
        """.trimIndent()

        val result = repository.importEntries(csvData, masterPassword, merge = false)
        // Should fail or skip entries without password
        // The implementation should handle this gracefully
        val entries = repository.getAllEntries(masterPassword).first()
        // Entry without password should be skipped
        assertThat(entries).isEmpty()
    }

    @Test
    fun `parse CSV handles various column name variations`() = runTest {
        repository.setMasterPassword(masterPassword)
        val csvVariations = listOf(
            "website,login,password,title",
            "site,email,pass,name",
            "url,username,password,service"
        )

        for (header in csvVariations) {
            val csvData = """
                $header
                https://example.com,testuser,password123,Example Site
            """.trimIndent()

            val result = repository.importEntries(csvData, masterPassword, merge = false)
            // Should handle at least one of these formats
            assertThat(result.isError).isFalse()
            assertThat(result.newEntriesCount).isGreaterThan(0)
            val entries = repository.getAllEntries(masterPassword).first()
            assertThat(entries).isNotEmpty()
        }
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

