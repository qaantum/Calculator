package com.ciphio.vault.passwordmanager

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.emptyPreferences
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.core.booleanPreferencesKey
import com.ciphio.vault.crypto.CryptoService
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.io.IOException
import java.util.UUID

/**
 * Repository for managing password entries with encryption.
 * 
 * Features:
 * - Encrypted storage using master password
 * - CRUD operations
 * - Search/filter functionality
 * - 10-item limit for free tier
 * 
 * This is a separate, modular feature that can be easily removed.
 */
class PasswordVaultRepository(
    private val dataStore: DataStore<Preferences>,
    private val cryptoService: CryptoService,
    private val keystoreHelper: KeystoreHelper? = null
) {
    private val json = Json { ignoreUnknownKeys = true; encodeDefaults = true }

    /**
     * Get all password entries (decrypted).
     * Requires master password to be set.
     */
    fun getAllEntries(masterPassword: String): Flow<List<PasswordEntry>> {
        return dataStore.data
            .catch { exception ->
                if (exception is IOException) emit(emptyPreferences()) else throw exception
            }
            .map { prefs ->
                prefs[PASSWORDS_KEY]?.let { encryptedData ->
                    try {
                        // Decrypt the stored data
                        val (_, decryptedJson) = cryptoService.decrypt(encryptedData, masterPassword)
                        json.decodeFromString<List<PasswordEntry>>(decryptedJson)
                    } catch (e: Exception) {
                        emptyList() // If decryption fails, return empty list
                    }
                } ?: emptyList()
            }
    }

    /**
     * Add a new password entry.
     * Returns true if successful, false on error.
     * Optimized: crypto operations happen outside dataStore.edit{} on IO dispatcher.
     * 
     * @param currentEntries Optional: If provided, avoids decrypting all entries (much faster!)
     */
    suspend fun addEntry(entry: PasswordEntry, masterPassword: String, currentEntries: List<PasswordEntry>? = null): Boolean {
        return kotlinx.coroutines.withContext(kotlinx.coroutines.Dispatchers.IO) {
            try {
                // Step 1: Get current entries (use provided cache if available, otherwise decrypt)
                val current = currentEntries ?: getCurrentEntries(masterPassword)
                
                android.util.Log.d("PasswordVault", "Current entries count: ${current.size}, adding entry: ${entry.service}, usingCache=${currentEntries != null}")
                
                // Step 2: Deduplicate and prepare updated list (in-memory operation)
                val entriesMap = mutableMapOf<String, PasswordEntry>()
                current.forEach { entriesMap[it.id] = it }
                entriesMap[entry.id] = entry
                val updated = entriesMap.values.toList().sortedByDescending { it.updatedAt }
                val finalCount = updated.size
                
                // Step 3: Encrypt BEFORE entering edit block (expensive operation on IO thread)
                val jsonData = json.encodeToString(updated)
                android.util.Log.d("PasswordVault", "Encrypting $finalCount entries")
                val encrypted = cryptoService.encrypt(jsonData, masterPassword, com.ciphio.vault.crypto.AesMode.AES_GCM)
                
                // Step 4: Quick write to DataStore (no crypto, just storage)
                dataStore.edit { editPrefs ->
                    editPrefs[PASSWORDS_KEY] = encrypted.encoded
                }
                
                android.util.Log.d("PasswordVault", "Entry added successfully, total entries: $finalCount")
                true
            } catch (e: Exception) {
                android.util.Log.e("PasswordVault", "Failed to add entry: ${e.message}", e)
                false
            }
        }
    }

    /**
     * Update an existing password entry.
     * Optimized: crypto operations happen outside dataStore.edit{} on IO dispatcher.
     * 
     * @param currentEntries Optional: If provided, avoids decrypting all entries (much faster!)
     */
    suspend fun updateEntry(entry: PasswordEntry, masterPassword: String, currentEntries: List<PasswordEntry>? = null) {
        kotlinx.coroutines.withContext(kotlinx.coroutines.Dispatchers.IO) {
            try {
                // Step 1: Get current entries (use provided cache if available, otherwise decrypt)
                val current = currentEntries ?: getCurrentEntries(masterPassword)
                
                android.util.Log.d("PasswordVault", "Updating entry: ${entry.service}, current count: ${current.size}, usingCache=${currentEntries != null}")
                
                // Step 2: Update the entry (in-memory operation)
                val updated = current.map { 
                    if (it.id == entry.id) entry.copy(updatedAt = System.currentTimeMillis()) else it 
                }
                
                // Step 3: Encrypt BEFORE entering edit block (expensive operation on IO thread)
                val jsonData = json.encodeToString(updated)
                val encrypted = cryptoService.encrypt(jsonData, masterPassword, com.ciphio.vault.crypto.AesMode.AES_GCM)
                
                // Step 4: Quick write to DataStore (no crypto, just storage)
                dataStore.edit { prefs ->
                    prefs[PASSWORDS_KEY] = encrypted.encoded
                }
            } catch (e: Exception) {
                android.util.Log.e("PasswordVault", "Failed to update entry: ${e.message}", e)
            }
        }
    }

    /**
     * Delete a password entry.
     * Optimized: crypto operations happen outside dataStore.edit{} on IO dispatcher.
     * 
     * @param currentEntries Optional: If provided, avoids decrypting all entries (much faster!)
     */
    suspend fun deleteEntry(id: String, masterPassword: String, currentEntries: List<PasswordEntry>? = null) {
        kotlinx.coroutines.withContext(kotlinx.coroutines.Dispatchers.IO) {
            try {
                // Step 1: Get current entries (use provided cache if available, otherwise decrypt)
                val current = currentEntries ?: getCurrentEntries(masterPassword)
                
                android.util.Log.d("PasswordVault", "Deleting entry: $id, current count: ${current.size}, usingCache=${currentEntries != null}")
                
                // Step 2: Filter out the deleted entry (in-memory operation)
                val updated = current.filterNot { it.id == id }
                
                // Step 3: Either remove key or encrypt new list
                dataStore.edit { prefs ->
                    if (updated.isEmpty()) {
                        prefs.remove(PASSWORDS_KEY)
                    } else {
                        // Encrypt BEFORE entering edit block (expensive operation on IO thread)
                        val jsonData = json.encodeToString(updated)
                        val encrypted = cryptoService.encrypt(jsonData, masterPassword, com.ciphio.vault.crypto.AesMode.AES_GCM)
                        prefs[PASSWORDS_KEY] = encrypted.encoded
                    }
                }
            } catch (e: Exception) {
                android.util.Log.e("PasswordVault", "Failed to delete entry: ${e.message}", e)
            }
        }
    }

    /**
     * Get entry count (for free tier limit check).
     */
    suspend fun getEntryCount(masterPassword: String): Int {
        val prefs = dataStore.data.first()
        return prefs[PASSWORDS_KEY]?.let { encryptedData ->
            try {
                val (_, decryptedJson) = cryptoService.decrypt(encryptedData, masterPassword)
                json.decodeFromString<List<PasswordEntry>>(decryptedJson).size
            } catch (e: Exception) {
                0
            }
        } ?: 0
    }

    /**
     * Check if master password is set.
     */
    suspend fun hasMasterPassword(): Boolean {
        val prefs = dataStore.data.first()
        return prefs[MASTER_PASSWORD_HASH_KEY] != null
    }

    /**
     * Set master password (stores hash for verification).
     * Uses SHA-256 for deterministic password hashing.
     */
    suspend fun setMasterPassword(masterPassword: String, enableBiometric: Boolean = false) {
        android.util.Log.d("PasswordVault", "setMasterPassword: setting up master password")
        dataStore.edit { prefs ->
            // Use SHA-256 for deterministic password hashing
            val digest = java.security.MessageDigest.getInstance("SHA-256")
            val hashBytes = digest.digest(masterPassword.toByteArray(Charsets.UTF_8))
            val hash = java.util.Base64.getEncoder().encodeToString(hashBytes)
            prefs[MASTER_PASSWORD_HASH_KEY] = hash
            android.util.Log.d("PasswordVault", "Master password hash stored: ${hash.take(10)}...")
            
            // If biometric is enabled, store master password in Android Keystore
            if (enableBiometric && keystoreHelper != null) {
                val success = keystoreHelper.storeMasterPassword(masterPassword)
                if (success) {
                    // Store encrypted master password data in DataStore
                    // The actual encryption key is in Android Keystore, so this is safe
                    // We'll store the encrypted bytes + IV as base64
                    val encryptedData = keystoreHelper.getEncryptedMasterPasswordData()
                    if (encryptedData != null) {
                        val encryptedDataBase64 = java.util.Base64.getEncoder().encodeToString(encryptedData)
                        prefs[ENCRYPTED_MASTER_PASSWORD_KEY] = encryptedDataBase64
                        android.util.Log.d("PasswordVault", "Master password stored in Android Keystore for biometric unlock")
                    }
                } else {
                    android.util.Log.w("PasswordVault", "Failed to store master password in Android Keystore")
                }
            }
        }
        android.util.Log.d("PasswordVault", "Master password setup complete")
    }

    /**
     * Verify master password.
     * Tries to decrypt existing data or verify against stored hash.
     * Supports both old (encrypted test data) and new (SHA-256) hash formats.
     */
    suspend fun verifyMasterPassword(masterPassword: String): Boolean {
        val prefs = dataStore.data.first()
        
        android.util.Log.d("PasswordVault", "verifyMasterPassword: checking password")
        android.util.Log.d("PasswordVault", "has PASSWORDS_KEY: ${prefs[PASSWORDS_KEY] != null}")
        android.util.Log.d("PasswordVault", "has MASTER_PASSWORD_HASH_KEY: ${prefs[MASTER_PASSWORD_HASH_KEY] != null}")
        
        // If no data exists, any password is valid for first setup
        if (prefs[PASSWORDS_KEY] == null && prefs[MASTER_PASSWORD_HASH_KEY] == null) {
            android.util.Log.d("PasswordVault", "No data exists, accepting any password for first setup")
            return true
        }
        
        // If we have encrypted data, try to decrypt it first (most reliable method)
        var decryptionSucceeded = false
        prefs[PASSWORDS_KEY]?.let { encryptedData ->
            android.util.Log.d("PasswordVault", "Found encrypted data, attempting decryption...")
            try {
                cryptoService.decrypt(encryptedData, masterPassword)
                android.util.Log.d("PasswordVault", "Decryption successful, password is valid")
                decryptionSucceeded = true
                // Migrate to new hash format if using old format
                prefs[MASTER_PASSWORD_HASH_KEY]?.let { oldHash ->
                    if (oldHash.length <= 20) { // Old format was first 20 chars
                        android.util.Log.d("PasswordVault", "Migrating old hash to new SHA-256 format")
                        migrateHashToNewFormat(masterPassword)
                    }
                }
                return true
            } catch (e: Exception) {
                android.util.Log.e("PasswordVault", "Decryption failed: ${e.message}", e)
                // Don't return false yet - check hash as fallback
            }
        }
        
        // If decryption failed or we don't have encrypted data, check hash
        prefs[MASTER_PASSWORD_HASH_KEY]?.let { storedHash ->
            android.util.Log.d("PasswordVault", "Found hash, length: ${storedHash.length}")
            
            // Check if it's the old format (first 20 chars of encrypted data - non-deterministic)
            if (storedHash.length <= 20) {
                android.util.Log.w("PasswordVault", "Detected old hash format (non-deterministic). Cannot verify properly.")
                android.util.Log.w("PasswordVault", "If you have encrypted data, we can verify by decrypting it.")
                android.util.Log.w("PasswordVault", "Otherwise, you'll need to reset the password.")
                
                // If we have encrypted data, we already tried decrypting it above
                // If decryption failed, the password is wrong
                if (prefs[PASSWORDS_KEY] != null) {
                    // We already tried decrypting, so if we're here, decryption failed
                    return false
                }
                
                // No encrypted data and old hash format - we can't verify, but we can try
                // to decrypt with the password to see if it works (but this won't work reliably)
                // Actually, the best approach is to clear the old hash and let them set a new one
                android.util.Log.w("PasswordVault", "Old hash format detected without encrypted data. Clearing old hash.")
                clearOldHash()
                return false // Force them to set a new password
            }
            
            // New format: SHA-256 hash
            android.util.Log.d("PasswordVault", "Using new SHA-256 hash format")
            val digest = java.security.MessageDigest.getInstance("SHA-256")
            val hashBytes = digest.digest(masterPassword.toByteArray(Charsets.UTF_8))
            val computedHash = java.util.Base64.getEncoder().encodeToString(hashBytes)
            val matches = computedHash == storedHash
            android.util.Log.d("PasswordVault", "Hash verification result: $matches")
            
            // If password is correct and we have encrypted data, ensure hash is migrated
            if (matches && prefs[PASSWORDS_KEY] != null) {
                // Already using new format, nothing to do
            }
            
            return matches
        }
        
        // If we had encrypted data but decryption failed and no hash exists, password is wrong
        if (prefs[PASSWORDS_KEY] != null && !decryptionSucceeded) {
            android.util.Log.w("PasswordVault", "Decryption failed and no hash available, password is invalid")
            return false
        }
        
        android.util.Log.w("PasswordVault", "No verification method available, returning false")
        return false
    }
    
    /**
     * Migrate old hash format to new SHA-256 format.
     */
    private suspend fun migrateHashToNewFormat(masterPassword: String) {
        dataStore.edit { prefs ->
            val digest = java.security.MessageDigest.getInstance("SHA-256")
            val hashBytes = digest.digest(masterPassword.toByteArray(Charsets.UTF_8))
            val newHash = java.util.Base64.getEncoder().encodeToString(hashBytes)
            prefs[MASTER_PASSWORD_HASH_KEY] = newHash
            android.util.Log.d("PasswordVault", "Hash migrated to new format")
        }
    }
    
    /**
     * Clear old hash format (for migration/reset).
     */
    private suspend fun clearOldHash() {
        dataStore.edit { prefs ->
            prefs.remove(MASTER_PASSWORD_HASH_KEY)
            android.util.Log.d("PasswordVault", "Old hash cleared")
        }
    }

    /**
     * Change master password.
     * Decrypts all entries with old password and re-encrypts with new password.
     */
    suspend fun changeMasterPassword(oldPassword: String, newPassword: String): Boolean {
        android.util.Log.d("PasswordVault", "changeMasterPassword: starting password change")
        
        // Verify old password first
        if (!verifyMasterPassword(oldPassword)) {
            android.util.Log.e("PasswordVault", "changeMasterPassword: old password verification failed")
            return false
        }
        
        // Get all entries decrypted with old password
        val prefs = dataStore.data.first()
        val entries = prefs[PASSWORDS_KEY]?.let { encryptedData ->
            try {
                val (_, decryptedJson) = cryptoService.decrypt(encryptedData, oldPassword)
                json.decodeFromString<List<PasswordEntry>>(decryptedJson)
            } catch (e: Exception) {
                android.util.Log.e("PasswordVault", "changeMasterPassword: failed to decrypt entries: ${e.message}", e)
                return false
            }
        } ?: emptyList()
        
        android.util.Log.d("PasswordVault", "changeMasterPassword: decrypted ${entries.size} entries")
        
        // Re-encrypt all entries with new password
        dataStore.edit { editPrefs ->
            if (entries.isEmpty()) {
                // No entries, just update the hash
                android.util.Log.d("PasswordVault", "changeMasterPassword: no entries, just updating hash")
            } else {
                // Re-encrypt all entries
                val jsonData = json.encodeToString(entries)
                val encrypted = cryptoService.encrypt(jsonData, newPassword, com.ciphio.vault.crypto.AesMode.AES_GCM)
                editPrefs[PASSWORDS_KEY] = encrypted.encoded
                android.util.Log.d("PasswordVault", "changeMasterPassword: re-encrypted ${entries.size} entries")
            }
            
            // Update master password hash
            val digest = java.security.MessageDigest.getInstance("SHA-256")
            val hashBytes = digest.digest(newPassword.toByteArray(Charsets.UTF_8))
            val newHash = java.util.Base64.getEncoder().encodeToString(hashBytes)
            editPrefs[MASTER_PASSWORD_HASH_KEY] = newHash
            android.util.Log.d("PasswordVault", "changeMasterPassword: updated master password hash")
        }
        
        android.util.Log.d("PasswordVault", "changeMasterPassword: password change complete")
        return true
    }
    
    /**
     * Clear all password entries (for testing/reset).
     */
    suspend fun clearAll() {
        dataStore.edit { prefs ->
            prefs.remove(PASSWORDS_KEY)
            prefs.remove(MASTER_PASSWORD_HASH_KEY)
        }
    }

    /**
     * Export all password entries as encrypted JSON string.
     * Returns the encrypted data that can be saved to a file.
     */
    suspend fun exportEntries(masterPassword: String): String? {
        return try {
            val entries = getCurrentEntries(masterPassword)
            val jsonData = json.encodeToString(entries)
            val encrypted = cryptoService.encrypt(jsonData, masterPassword, com.ciphio.vault.crypto.AesMode.AES_GCM)
            encrypted.encoded
        } catch (e: Exception) {
            android.util.Log.e("PasswordVault", "Failed to export entries: ${e.message}", e)
            null
        }
    }
    
    /**
     * Result of import operation.
     */
    data class ImportResult(
        val newEntriesCount: Int,
        val existingEntriesCount: Int,
        val totalEntriesCount: Int,
        val isError: Boolean = false
    ) {
        companion object {
            fun error() = ImportResult(0, 0, 0, isError = true)
        }
    }
    
    /**
     * Import password entries from encrypted JSON string or CSV format.
     * @param data The encrypted JSON string or CSV text
     * @param masterPassword The master password to decrypt (for encrypted format)
     * @param merge If true, merge with existing entries. If false, replace all entries.
     * @return ImportResult with details about the import, or ImportResult.error() on error
     */
    suspend fun importEntries(
        data: String,
        masterPassword: String,
        merge: Boolean = true
    ): ImportResult {
        return try {
            val importedEntries: List<PasswordEntry>
            
            // Try to detect format: encrypted (starts with "gcm:" or "cbc:" or "ctr:") or CSV
            val isEncrypted = data.trimStart().startsWith("gcm:") || 
                             data.trimStart().startsWith("cbc:") || 
                             data.trimStart().startsWith("ctr:")
            
            if (isEncrypted) {
                // Decrypt the imported data (our own format)
                val (_, decryptedJson) = cryptoService.decrypt(data, masterPassword)
                importedEntries = json.decodeFromString<List<PasswordEntry>>(decryptedJson)
            } else {
                // Try to parse as CSV (common password manager export format)
                importedEntries = parseCsvImport(data)
            }
            
            if (merge) {
                // Merge with existing entries (avoid duplicates by ID)
                // This preserves existing entries that aren't in the import
                // and adds new entries from the import
                val existing = getCurrentEntries(masterPassword)
                
                // Deduplicate existing entries by ID (in case there are any duplicates)
                val existingDeduplicated = existing.distinctBy { it.id }
                val existingIds = existingDeduplicated.map { it.id }.toSet()
                
                // Deduplicate imported entries by ID as well
                val importedDeduplicated = importedEntries.distinctBy { it.id }
                
                // Filter out entries that already exist
                val newEntries = importedDeduplicated.filter { it.id !in existingIds }
                
                // Combine: existing entries + new entries from import
                // Use a map to ensure final deduplication by ID (prefer existing over imported if same ID)
                val allEntriesMap = mutableMapOf<String, PasswordEntry>()
                // First add existing entries (these take precedence)
                existingDeduplicated.forEach { allEntriesMap[it.id] = it }
                // Then add new entries (won't overwrite existing due to filter above)
                newEntries.forEach { allEntriesMap[it.id] = it }
                val allEntries = allEntriesMap.values.toList()
                
                android.util.Log.d("PasswordVault", "Import merge: existing=${existingDeduplicated.size}, imported=${importedDeduplicated.size}, new=${newEntries.size}, total=${allEntries.size}")
                
                // Save merged entries
                val jsonData = json.encodeToString(allEntries)
                val encrypted = cryptoService.encrypt(jsonData, masterPassword, com.ciphio.vault.crypto.AesMode.AES_GCM)
                dataStore.edit { prefs ->
                    prefs[PASSWORDS_KEY] = encrypted.encoded
                }
                // Return detailed result
                ImportResult(
                    newEntriesCount = newEntries.size,
                    existingEntriesCount = existingDeduplicated.size,
                    totalEntriesCount = allEntries.size
                )
            } else {
                // Replace all entries
                // Deduplicate imported entries by ID (in case there are any duplicates in the import)
                val importedDeduplicated = importedEntries.distinctBy { it.id }
                
                android.util.Log.d("PasswordVault", "Import replace: imported=${importedDeduplicated.size} (deduplicated from ${importedEntries.size})")
                
                val jsonData = json.encodeToString(importedDeduplicated)
                val encrypted = cryptoService.encrypt(jsonData, masterPassword, com.ciphio.vault.crypto.AesMode.AES_GCM)
                dataStore.edit { prefs ->
                    prefs[PASSWORDS_KEY] = encrypted.encoded
                }
                ImportResult(
                    newEntriesCount = importedDeduplicated.size,
                    existingEntriesCount = 0,
                    totalEntriesCount = importedDeduplicated.size
                )
            }
        } catch (e: Exception) {
            android.util.Log.e("PasswordVault", "Failed to import entries: ${e.message}", e)
            ImportResult.error()
        }
    }
    
    /**
     * Parse CSV format from common password managers (NordPass, LastPass, 1Password, etc.).
     * Supports common CSV formats with fields like: url, username, password, name, notes, etc.
     */
    private fun parseCsvImport(csvData: String): List<PasswordEntry> {
        val entries = mutableListOf<PasswordEntry>()
        val lines = csvData.trim().split("\n")
        
        if (lines.isEmpty()) return entries
        
        // Parse header to detect column order
        val header = lines[0].split(",").map { it.trim().removeSurrounding("\"") }
        val urlIndex = header.indexOfFirst { it.equals("url", ignoreCase = true) || it.equals("website", ignoreCase = true) || it.equals("site", ignoreCase = true) }
        val usernameIndex = header.indexOfFirst { it.equals("username", ignoreCase = true) || it.equals("login", ignoreCase = true) || it.equals("email", ignoreCase = true) }
        val passwordIndex = header.indexOfFirst { it.equals("password", ignoreCase = true) || it.equals("pass", ignoreCase = true) }
        val nameIndex = header.indexOfFirst { it.equals("name", ignoreCase = true) || it.equals("title", ignoreCase = true) || it.equals("service", ignoreCase = true) }
        val notesIndex = header.indexOfFirst { it.equals("notes", ignoreCase = true) || it.equals("note", ignoreCase = true) || it.equals("extra", ignoreCase = true) }
        
        // Parse data rows
        for (i in 1 until lines.size) {
            val line = lines[i].trim()
            if (line.isEmpty()) continue
            
            // Simple CSV parsing (handles quoted fields)
            val values = parseCsvLine(line)
            
            if (values.size <= maxOf(urlIndex, usernameIndex, passwordIndex, nameIndex, notesIndex)) {
                continue // Skip malformed rows
            }
            
            val service = when {
                urlIndex >= 0 && urlIndex < values.size -> {
                    val url = values[urlIndex].trim().removeSurrounding("\"")
                    // Extract domain from URL (prioritize URL over name for service identification)
                    try {
                        val uri = java.net.URI(url)
                        uri.host ?: url
                    } catch (e: Exception) {
                        url
                    }
                }
                nameIndex >= 0 && nameIndex < values.size -> values[nameIndex].trim().removeSurrounding("\"")
                else -> "Imported Entry"
            }
            
            val username = if (usernameIndex >= 0 && usernameIndex < values.size) {
                values[usernameIndex].trim().removeSurrounding("\"")
            } else ""
            
            val password = if (passwordIndex >= 0 && passwordIndex < values.size) {
                values[passwordIndex].trim().removeSurrounding("\"")
            } else ""
            
            val notes = if (notesIndex >= 0 && notesIndex < values.size) {
                values[notesIndex].trim().removeSurrounding("\"")
            } else ""
            
            if (service.isNotBlank() && username.isNotBlank() && password.isNotBlank()) {
                entries.add(
                    PasswordEntry(
                        id = UUID.randomUUID().toString(),
                        service = service,
                        username = username,
                        password = password,
                        notes = notes,
                        categories = emptyList()
                    )
                )
            }
        }
        
        android.util.Log.d("PasswordVault", "Parsed ${entries.size} entries from CSV")
        return entries
    }
    
    /**
     * Simple CSV line parser that handles quoted fields.
     */
    private fun parseCsvLine(line: String): List<String> {
        val result = mutableListOf<String>()
        var current = StringBuilder()
        var inQuotes = false
        var i = 0
        
        while (i < line.length) {
            val char = line[i]
            when {
                char == '"' -> {
                    if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
                        // Escaped quote
                        current.append('"')
                        i += 2 // Skip both quotes
                        continue
                    } else {
                        // Toggle quote state
                        inQuotes = !inQuotes
                    }
                }
                char == ',' && !inQuotes -> {
                    result.add(current.toString())
                    current = StringBuilder()
                }
                else -> current.append(char)
            }
            i++
        }
        result.add(current.toString())
        return result
    }

    /**
     * Get current entries synchronously (for manual refresh).
     * This reads directly from dataStore without using the flow.
     */
    suspend fun getCurrentEntries(masterPassword: String): List<PasswordEntry> {
        val prefs = dataStore.data.first()
        val hasKey = prefs[PASSWORDS_KEY] != null
        android.util.Log.d("PasswordVault", "getCurrentEntries: hasKey=$hasKey")
        
        return prefs[PASSWORDS_KEY]?.let { encryptedData ->
            try {
                android.util.Log.d("PasswordVault", "Decrypting data, length: ${encryptedData.length}")
                val (_, decryptedJson) = cryptoService.decrypt(encryptedData, masterPassword)
                android.util.Log.d("PasswordVault", "Decrypted JSON length: ${decryptedJson.length}, content: ${decryptedJson.take(100)}")
                val entries = json.decodeFromString<List<PasswordEntry>>(decryptedJson)
                android.util.Log.d("PasswordVault", "Successfully decrypted ${entries.size} entries")
                entries
            } catch (e: Exception) {
                android.util.Log.e("PasswordVault", "Failed to decrypt entries: ${e.message}", e)
                e.printStackTrace()
                emptyList()
            }
        } ?: run {
            android.util.Log.d("PasswordVault", "No encrypted data found in dataStore")
            emptyList()
        }
    }

    /**
     * Check if biometric unlock is enabled.
     */
    suspend fun isBiometricEnabled(): Boolean {
        val prefs = dataStore.data.first()
        return prefs[BIOMETRIC_ENABLED_KEY] ?: false
    }
    
    /**
     * Enable or disable biometric unlock.
     */
    suspend fun setBiometricEnabled(enabled: Boolean) {
        dataStore.edit { prefs ->
            prefs[BIOMETRIC_ENABLED_KEY] = enabled
        }
    }

    /**
     * Retrieve master password from Android Keystore using biometric authentication.
     * 
     * @param cryptoObject The BiometricPrompt.CryptoObject from successful biometric auth
     * @return The master password, or null if failed
     */
    suspend fun retrieveMasterPasswordFromKeystore(
        cryptoObject: androidx.biometric.BiometricPrompt.CryptoObject?
    ): String? {
        if (keystoreHelper == null) {
            android.util.Log.e("PasswordVault", "retrieveMasterPasswordFromKeystore: keystoreHelper is null")
            return null
        }
        
        val prefs = dataStore.data.first()
        val encryptedDataBase64 = prefs[ENCRYPTED_MASTER_PASSWORD_KEY]
        if (encryptedDataBase64 == null) {
            android.util.Log.e("PasswordVault", "retrieveMasterPasswordFromKeystore: no encrypted master password found in DataStore")
            return null
        }
        
        android.util.Log.d("PasswordVault", "retrieveMasterPasswordFromKeystore: found encrypted data, length=${encryptedDataBase64.length}")
        
        return try {
            val encryptedData = java.util.Base64.getDecoder().decode(encryptedDataBase64)
            android.util.Log.d("PasswordVault", "retrieveMasterPasswordFromKeystore: decoded encrypted data, length=${encryptedData.size}")
            val masterPassword = keystoreHelper.retrieveMasterPassword(encryptedData, cryptoObject)
            if (masterPassword != null) {
                android.util.Log.d("PasswordVault", "retrieveMasterPasswordFromKeystore: master password retrieved successfully, length=${masterPassword.length}")
            } else {
                android.util.Log.e("PasswordVault", "retrieveMasterPasswordFromKeystore: keystoreHelper.retrieveMasterPassword returned null")
            }
            masterPassword
        } catch (e: Exception) {
            android.util.Log.e("PasswordVault", "Failed to retrieve master password from Keystore: ${e.message}", e)
            e.printStackTrace()
            null
        }
    }

    companion object {
        private val PASSWORDS_KEY = stringPreferencesKey("password_vault")
        private val MASTER_PASSWORD_HASH_KEY = stringPreferencesKey("master_password_hash")
        private val BIOMETRIC_ENABLED_KEY = booleanPreferencesKey("biometric_enabled")
        private val ENCRYPTED_MASTER_PASSWORD_KEY = stringPreferencesKey("encrypted_master_password_keystore")
    }
}

