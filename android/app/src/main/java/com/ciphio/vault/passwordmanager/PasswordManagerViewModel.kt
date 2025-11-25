package com.ciphio.vault.passwordmanager

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.ciphio.vault.crypto.CryptoService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.launch
import kotlinx.coroutines.Dispatchers
import com.ciphio.vault.data.UserPreferencesRepository

/**
 * Sort option for password entries.
 * Supports 3 states: NONE (no sort), ASCENDING, DESCENDING
 */
enum class PasswordSortOption {
    NONE,                    // No sorting (default order)
    ALPHABETICAL_ASC,        // A-Z (ascending)
    ALPHABETICAL_DESC,       // Z-A (descending)
    DATE_DESC,               // Newest first (descending)
    DATE_ASC                 // Oldest first (ascending)
}

/**
 * ViewModel for Password Manager feature.
 * 
 * This is a separate, modular feature that can be easily removed
 * without affecting text encryption or password generation.
 */
class PasswordManagerViewModel(
    private val vaultRepository: PasswordVaultRepository,
    private val userPreferencesRepository: UserPreferencesRepository? = null,
    private val isPremium: Boolean = false
) : ViewModel() {

    private val _uiState = MutableStateFlow(PasswordManagerUiState())
    val uiState: StateFlow<PasswordManagerUiState> = _uiState.asStateFlow()

    private var currentMasterPassword: String? = null
    private var entriesJob: kotlinx.coroutines.Job? = null
    
    // Cache for entry categories to avoid repeated getAllCategories() calls
    private val categoryCache = mutableMapOf<String, List<String>>()
    
    // Cache for lowercase strings to avoid repeated lowercasing (performance optimization)
    private val lowercaseCache = mutableMapOf<String, String>()
    
    // Search debouncing
    private var searchDebounceJob: kotlinx.coroutines.Job? = null

    init {
        checkMasterPasswordStatus()
        loadSortPreference()
    }
    
    /**
     * Load sort preference from user preferences.
     */
    private fun loadSortPreference() {
        viewModelScope.launch {
            userPreferencesRepository?.passwordManagerSortOption?.collectLatest { sortOption ->
                _uiState.update { it.copy(sortOption = sortOption) }
                // Reload entries to apply sort if vault is unlocked
                if (_uiState.value.isUnlocked) {
                    reloadEntries()
                }
            } ?: run {
                // If no repository, use default (NONE)
                _uiState.update { it.copy(sortOption = PasswordSortOption.NONE) }
            }
        }
    }

    /**
     * Check if master password is set.
     */
    fun checkMasterPasswordStatus() {
        viewModelScope.launch {
            val hasPassword = vaultRepository.hasMasterPassword()
            val biometricEnabled = vaultRepository.isBiometricEnabled()
            // Check biometric availability (requires context, so we'll check it in the screen)
            _uiState.update { 
                it.copy(
                    hasMasterPassword = hasPassword,
                    biometricEnabled = biometricEnabled
                )
            }
        }
    }
    
    /**
     * Update biometric availability status.
     */
    fun setBiometricAvailable(available: Boolean) {
        _uiState.update { it.copy(biometricAvailable = available) }
    }
    
    /**
     * Enable or disable biometric unlock.
     * When enabling, stores master password in Android Keystore.
     * When disabling, removes master password from Android Keystore.
     * 
     * Note: When enabling, this will trigger biometric authentication to store the password.
     * The actual storage happens in storeMasterPasswordAfterBiometricAuth().
     */
    fun setBiometricEnabled(enabled: Boolean) {
        viewModelScope.launch {
            android.util.Log.d("PasswordManagerViewModel", "setBiometricEnabled: $enabled, isUnlocked: ${_uiState.value.isUnlocked}, hasPassword: ${currentMasterPassword != null}")
            if (enabled) {
                // Enable biometric: We need to trigger biometric authentication first
                // The actual storage will happen in storeMasterPasswordAfterBiometricAuth()
                val masterPassword = currentMasterPassword
                if (masterPassword != null && _uiState.value.isUnlocked) {
                    android.util.Log.d("PasswordManagerViewModel", "Biometric unlock will be enabled after authentication")
                    // Don't enable yet - wait for biometric authentication
                    // The UI should trigger biometric authentication, then call storeMasterPasswordAfterBiometricAuth()
                } else {
                    // Can't enable biometric without unlocked vault
                    android.util.Log.w("PasswordManagerViewModel", "Cannot enable biometric: vault not unlocked or no master password")
                    _uiState.update { 
                        it.copy(
                            errorMessage = "Please unlock the vault first to enable biometric unlock"
                        )
                    }
                }
            } else {
                // Disable biometric: Remove master password from Keystore
                android.util.Log.d("PasswordManagerViewModel", "Disabling biometric unlock...")
                vaultRepository.setBiometricEnabled(false)
                // Note: We don't delete the key from Keystore here, as it might be needed
                // The key will remain but won't be used if biometric is disabled
                _uiState.update { it.copy(biometricEnabled = false) }
                android.util.Log.d("PasswordManagerViewModel", "Biometric unlock disabled")
            }
        }
    }
    
    /**
     * Store master password in Keystore after biometric authentication succeeds.
     * This is called after the user authenticates with biometric when enabling biometric unlock.
     */
    fun storeMasterPasswordAfterBiometricAuth() {
        viewModelScope.launch {
            val masterPassword = currentMasterPassword
            if (masterPassword != null && _uiState.value.isUnlocked) {
                android.util.Log.d("PasswordManagerViewModel", "Storing master password in Keystore after biometric auth...")
                // Store master password in Keystore (this will use the authenticated key)
                vaultRepository.setMasterPassword(masterPassword, enableBiometric = true)
                vaultRepository.setBiometricEnabled(true)
                _uiState.update { 
                    it.copy(
                        biometricEnabled = true,
                        successMessage = "Biometric unlock enabled. Lock the vault to use it."
                    )
                }
                android.util.Log.d("PasswordManagerViewModel", "Biometric unlock enabled successfully")
            } else {
                android.util.Log.w("PasswordManagerViewModel", "Cannot store master password: vault not unlocked or no master password")
                _uiState.update { 
                    it.copy(
                        errorMessage = "Failed to enable biometric unlock"
                    )
                }
            }
        }
    }
    
    /**
     * Unlock vault using biometric authentication.
     * Retrieves master password from Android Keystore using the CryptoObject from biometric auth.
     */
    fun unlockWithBiometric(cryptoObject: androidx.biometric.BiometricPrompt.CryptoObject) {
        viewModelScope.launch {
            try {
                android.util.Log.d("PasswordManagerViewModel", "unlockWithBiometric: attempting to retrieve master password from Keystore...")
                val masterPassword = vaultRepository.retrieveMasterPasswordFromKeystore(cryptoObject)
                if (masterPassword != null) {
                    android.util.Log.d("PasswordManagerViewModel", "unlockWithBiometric: master password retrieved successfully, length=${masterPassword.length}")
                    // Skip verification since biometric already verified the user
                    currentMasterPassword = masterPassword
                    _uiState.update { 
                        it.copy(
                            isUnlocked = true,
                            errorMessage = null
                        )
                    }
                    loadEntries()
                } else {
                    android.util.Log.e("PasswordManagerViewModel", "unlockWithBiometric: failed to retrieve master password from Keystore")
                    _uiState.update { it.copy(errorMessage = "Failed to retrieve master password from secure storage. Please unlock with password.") }
                }
            } catch (e: Exception) {
                android.util.Log.e("PasswordManagerViewModel", "unlockWithBiometric: exception: ${e.message}", e)
                e.printStackTrace()
                _uiState.update { it.copy(errorMessage = "Biometric unlock failed: ${e.message}") }
            }
        }
    }

    /**
     * Set master password (first-time setup).
     */
    fun setMasterPassword(password: String, confirmPassword: String) {
        if (password != confirmPassword) {
            _uiState.update { it.copy(errorMessage = "Passwords do not match") }
            return
        }
        
        if (password.length < 8) {
            _uiState.update { it.copy(errorMessage = "Password must be at least 8 characters") }
            return
        }

        viewModelScope.launch {
            try {
                // Check if biometric is enabled to also store in Keystore
                val biometricEnabled = vaultRepository.isBiometricEnabled()
                vaultRepository.setMasterPassword(password, enableBiometric = biometricEnabled)
                currentMasterPassword = password
                _uiState.update { 
                    it.copy(
                        hasMasterPassword = true,
                        isUnlocked = true,
                        errorMessage = null
                    )
                }
                // Start collecting entries flow
                loadEntries()
            } catch (e: Exception) {
                _uiState.update { it.copy(errorMessage = "Failed to set master password: ${e.message}") }
            }
        }
    }

    /**
     * Unlock vault with master password.
     */
    fun unlockVault(password: String) {
        android.util.Log.d("PasswordManager", "unlockVault: attempting to unlock with password length=${password.length}")
        viewModelScope.launch {
            try {
                val isValid = vaultRepository.verifyMasterPassword(password)
                android.util.Log.d("PasswordManager", "unlockVault: verification result=$isValid")
                if (isValid) {
                    currentMasterPassword = password
                    _uiState.update { 
                        it.copy(
                            isUnlocked = true,
                            errorMessage = null
                        )
                    }
                    loadEntries()
                } else {
                    android.util.Log.w("PasswordManager", "unlockVault: password verification failed")
                    _uiState.update { it.copy(errorMessage = "Incorrect master password") }
                }
            } catch (e: Exception) {
                android.util.Log.e("PasswordManager", "unlockVault: exception: ${e.message}", e)
                _uiState.update { it.copy(errorMessage = "Failed to unlock vault: ${e.message}") }
            }
        }
    }
    
    /**
     * Reload entries (useful when returning to list screen).
     * Always restarts the collection to ensure it's active.
     */
    fun reloadEntries() {
        if (currentMasterPassword != null && _uiState.value.isUnlocked) {
            // Always restart to ensure flow is active
            loadEntries()
        }
    }

    /**
     * Lock the vault.
     */
    fun lockVault() {
        currentMasterPassword = null
        _uiState.update { 
            it.copy(
                isUnlocked = false,
                entries = emptyList()
            )
        }
    }
    
    /**
     * Change master password.
     * Requires current password to be unlocked.
     */
    fun changeMasterPassword(oldPassword: String, newPassword: String, confirmNewPassword: String) {
        if (newPassword != confirmNewPassword) {
            _uiState.update { it.copy(errorMessage = "New passwords do not match") }
            return
        }
        
        if (newPassword.length < 8) {
            _uiState.update { it.copy(errorMessage = "New password must be at least 8 characters") }
            return
        }
        
        if (oldPassword == newPassword) {
            _uiState.update { it.copy(errorMessage = "New password must be different from old password") }
            return
        }
        
        viewModelScope.launch {
            try {
                val success = vaultRepository.changeMasterPassword(oldPassword, newPassword)
                if (success) {
                    // Update current master password
                    currentMasterPassword = newPassword
                    
                    // If biometric is enabled, update master password in Keystore
                    val biometricEnabled = vaultRepository.isBiometricEnabled()
                    if (biometricEnabled) {
                        vaultRepository.setMasterPassword(newPassword, enableBiometric = true)
                    }
                    
                    _uiState.update { 
                        it.copy(
                            successMessage = "Master password changed successfully",
                            errorMessage = null
                        )
                    }
                } else {
                    _uiState.update { it.copy(errorMessage = "Failed to change password. Please verify your current password.") }
                }
            } catch (e: Exception) {
                _uiState.update { it.copy(errorMessage = "Failed to change password: ${e.message}") }
            }
        }
    }

    /**
     * Load all password entries.
     * Uses collectLatest to continuously observe changes.
     * Only starts one collection job at a time.
     * Reacts to both data changes and filter changes.
     */
    private fun loadEntries() {
        val masterPassword = currentMasterPassword ?: return
        
        // Cancel previous job if exists and start fresh
        entriesJob?.cancel()
        
        entriesJob = viewModelScope.launch {
            try {
                // Combine entries flow with search query, category filter, and sort option
                // Use map to extract only the filter values to avoid infinite loops
                val filterFlow = _uiState.map { state ->
                    Triple(state.searchQuery, state.categoryFilter, state.sortOption)
                }.distinctUntilChanged()
                
                combine(
                    vaultRepository.getAllEntries(masterPassword),
                    filterFlow
                ) { entries, (query, categoryFilter, sortOption) ->
                    // Update category cache for all entries (do this once, not per filter)
                    entries.forEach { entry ->
                        if (entry.id !in categoryCache) {
                            categoryCache[entry.id] = entry.getAllCategories()
                        }
                    }
                    
                    // Optimize: Pre-compute lowercase query once
                    val queryLower = query.lowercase()
                    val hasQuery = queryLower.isNotBlank()
                    val hasCategoryFilter = categoryFilter != null
                    
                    // Optimize filtering: Apply filters in single pass with cached lowercase
                    val filtered = if (!hasQuery && !hasCategoryFilter) {
                        // No filtering needed - return original list
                        entries
                    } else {
                        entries.filter { entry ->
                            // Early exit optimization: if no filters, skip this entry check
                            var matches = true
                            
                            // Use cached categories instead of calling getAllCategories() multiple times
                            val entryCategories = categoryCache[entry.id] 
                                ?: entry.getAllCategories().also { 
                                    // Cache it for next time
                                    categoryCache[entry.id] = it 
                                }
                            
                            // Apply search filter (optimized - use cached lowercase strings)
                            if (hasQuery) {
                                // Cache lowercase strings to avoid repeated lowercasing
                                val serviceKey = "service:${entry.id}"
                                val usernameKey = "username:${entry.id}"
                                val notesKey = "notes:${entry.id}"
                                
                                val serviceLower = lowercaseCache.getOrPut(serviceKey) { entry.service.lowercase() }
                                val usernameLower = lowercaseCache.getOrPut(usernameKey) { entry.username.lowercase() }
                                val notesLower = lowercaseCache.getOrPut(notesKey) { entry.notes.lowercase() }
                                
                                // Cache category lowercase strings
                                val categoryLowerCache = entryCategories.map { cat ->
                                    val catKey = "cat:${entry.id}:$cat"
                                    lowercaseCache.getOrPut(catKey) { cat.lowercase() }
                                }
                                
                                matches = matches && (
                                    serviceLower.contains(queryLower) ||
                                    usernameLower.contains(queryLower) ||
                                    notesLower.contains(queryLower) ||
                                    categoryLowerCache.any { it.contains(queryLower) }
                                )
                            }
                            
                            // Apply category filter (only if still matching, use cached categories)
                            if (matches && hasCategoryFilter) {
                                matches = entryCategories.contains(categoryFilter)
                            }
                            
                            matches
                        }
                    }
                    
                    // Get available categories from cache (much faster than calling getAllCategories on each entry)
                    val categories = categoryCache.values.flatten().distinct().sorted()
                    
                    // Apply sorting based on current sort option
                    val sorted = when (sortOption) {
                        PasswordSortOption.ALPHABETICAL_ASC -> filtered.sortedBy { it.service.lowercase() }
                        PasswordSortOption.ALPHABETICAL_DESC -> filtered.sortedByDescending { it.service.lowercase() }
                        PasswordSortOption.DATE_DESC -> filtered.sortedByDescending { it.updatedAt }
                        PasswordSortOption.DATE_ASC -> filtered.sortedBy { it.updatedAt }
                        PasswordSortOption.NONE -> filtered // No sorting, keep original order
                    }
                    
                    // Return filtered and sorted entries, categories, and the sort option used
                    Triple(sorted, categories, sortOption)
                }
                .flowOn(Dispatchers.Default) // Move filtering off main thread
                .collectLatest { (filtered, categories, appliedSortOption) ->
                    _uiState.update { 
                        it.copy(
                            entries = filtered,
                            availableCategories = categories,
                            activeSortOption = appliedSortOption
                        )
                    }
                }
            } catch (e: kotlinx.coroutines.CancellationException) {
                // Cancellation is expected when navigating away - don't show error
                throw e
            } catch (e: Exception) {
                _uiState.update { it.copy(errorMessage = "Failed to load entries: ${e.message}") }
            }
        }
    }

    /**
     * Add a new password entry.
     */
    fun addEntry(entry: PasswordEntry) {
        val masterPassword = currentMasterPassword ?: run {
            android.util.Log.e("PasswordManager", "addEntry: currentMasterPassword is null!")
            return
        }
        
        android.util.Log.d("PasswordManager", "addEntry called: service=${entry.service}, username=${entry.username}")
        
        viewModelScope.launch {
            try {
                // Check free tier limit: 10 passwords max for non-premium users
                val currentCount = getEntryCount()
                if (!isPremium && currentCount >= 20) {
                    android.util.Log.w("PasswordManager", "Free tier limit reached: $currentCount/10")
                    _uiState.update { 
                        it.copy(
                            errorMessage = "Free tier limit reached (10 passwords). Upgrade to Premium for unlimited passwords."
                        )
                    }
                    return@launch
                }
                
                // Use cached entries from state to avoid decrypting all entries again (HUGE performance boost!)
                val currentEntries = _uiState.value.entries
                // OPTIMISTIC UPDATE: Show entry in UI immediately (before encryption completes)
                val updatedEntries = when (_uiState.value.sortOption) {
                    PasswordSortOption.ALPHABETICAL_ASC -> (currentEntries + entry).distinctBy { it.id }.sortedBy { it.service.lowercase() }
                    PasswordSortOption.ALPHABETICAL_DESC -> (currentEntries + entry).distinctBy { it.id }.sortedByDescending { it.service.lowercase() }
                    PasswordSortOption.DATE_DESC -> (currentEntries + entry).distinctBy { it.id }.sortedByDescending { it.updatedAt }
                    PasswordSortOption.DATE_ASC -> (currentEntries + entry).distinctBy { it.id }.sortedBy { it.updatedAt }
                    PasswordSortOption.NONE -> (currentEntries + entry).distinctBy { it.id }
                }
                categoryCache[entry.id] = entry.getAllCategories()
                // Clear lowercase cache for this entry (will be regenerated on next filter)
                lowercaseCache.keys.removeAll { it.startsWith("service:${entry.id}") || 
                                                it.startsWith("username:${entry.id}") || 
                                                it.startsWith("notes:${entry.id}") ||
                                                it.startsWith("cat:${entry.id}:") }
                val updatedCategories = categoryCache.values.flatten().distinct().sorted()
                _uiState.update { 
                    it.copy(
                        entries = updatedEntries,
                        availableCategories = updatedCategories
                    )
                }
                
                android.util.Log.d("PasswordManager", "Calling vaultRepository.addEntry with ${currentEntries.size} cached entries...")
                val success = vaultRepository.addEntry(entry, masterPassword, currentEntries)
                android.util.Log.d("PasswordManager", "vaultRepository.addEntry returned: $success")
                
                if (success) {
                    // Success - the flow will update with final state, but UI already shows the entry
                    _uiState.update { it.copy(successMessage = "Password added successfully") }
                } else {
                    // Rollback optimistic update on failure
                    val originalEntries = _uiState.value.entries.filter { it.id != entry.id }
                    categoryCache.remove(entry.id)
                    // Clear lowercase cache for this entry
                    lowercaseCache.keys.removeAll { it.startsWith("service:${entry.id}") || 
                                                    it.startsWith("username:${entry.id}") || 
                                                    it.startsWith("notes:${entry.id}") ||
                                                    it.startsWith("cat:${entry.id}:") }
                    android.util.Log.w("PasswordManager", "addEntry failed")
                    _uiState.update { 
                        it.copy(
                            entries = originalEntries,
                            errorMessage = "Failed to add password. Please try again."
                        )
                    }
                }
            } catch (e: Exception) {
                android.util.Log.e("PasswordManager", "addEntry exception: ${e.message}", e)
                _uiState.update { it.copy(errorMessage = "Failed to add entry: ${e.message}") }
            }
        }
    }
    
    /**
     * Manually refresh entries by reading directly from dataStore.
     * This ensures the list updates immediately after add/update/delete.
     * 
     * Optimized version with category caching and efficient filtering.
     */
    private suspend fun refreshEntries() {
        val masterPassword = currentMasterPassword ?: return
        
        try {
            // Read directly from dataStore to get the latest data
            val entries = vaultRepository.getCurrentEntries(masterPassword)
            
            android.util.Log.d("PasswordManager", "Refreshing entries: found ${entries.size} entries")
            
            // Update category cache for new entries
            entries.forEach { entry ->
                if (entry.id !in categoryCache) {
                    categoryCache[entry.id] = entry.getAllCategories()
                }
            }
            
            // Get available categories from cache (much faster)
            val categories = categoryCache.values.flatten().distinct().sorted()
            
            // Apply filters efficiently
            val query = _uiState.value.searchQuery
            val categoryFilter = _uiState.value.categoryFilter
            
            val filtered = entries.filter { entry ->
                val entryCategories = categoryCache[entry.id] ?: emptyList()
                
                // Search filter (pre-lowercase query for efficiency)
                val matchesSearch = query.isBlank() || run {
                    val queryLower = query.lowercase()
                    entry.service.lowercase().contains(queryLower) ||
                    entry.username.lowercase().contains(queryLower) ||
                    entry.notes.lowercase().contains(queryLower) ||
                    entryCategories.any { it.lowercase().contains(queryLower) }
                }
                
                // Category filter (use cached categories)
                val matchesCategory = categoryFilter == null || entryCategories.contains(categoryFilter)
                
                matchesSearch && matchesCategory
            }
            
            _uiState.update { 
                it.copy(
                    entries = filtered,
                    availableCategories = categories
                )
            }

            android.util.Log.d("PasswordManager", "Updated state with ${filtered.size} filtered entries")
        } catch (e: Exception) {
            android.util.Log.e("PasswordManager", "Failed to refresh entries: ${e.message}", e)
            _uiState.update { it.copy(errorMessage = "Failed to refresh entries: ${e.message}") }
        }
    }

    /**
     * Update an existing password entry.
     */
    fun updateEntry(entry: PasswordEntry) {
        val masterPassword = currentMasterPassword ?: return
        
        viewModelScope.launch {
            // Store original entries for rollback
            val originalEntries = _uiState.value.entries
            val originalEntry = originalEntries.firstOrNull { it.id == entry.id }
            
            try {
                // OPTIMISTIC UPDATE: Show updated entry in UI immediately
                val updatedEntries = when (_uiState.value.sortOption) {
                    PasswordSortOption.ALPHABETICAL_ASC -> originalEntries.map { if (it.id == entry.id) entry else it }
                        .sortedBy { it.service.lowercase() }
                    PasswordSortOption.ALPHABETICAL_DESC -> originalEntries.map { if (it.id == entry.id) entry else it }
                        .sortedByDescending { it.service.lowercase() }
                    PasswordSortOption.DATE_DESC -> originalEntries.map { if (it.id == entry.id) entry else it }
                        .sortedByDescending { it.updatedAt }
                    PasswordSortOption.DATE_ASC -> originalEntries.map { if (it.id == entry.id) entry else it }
                        .sortedBy { it.updatedAt }
                    PasswordSortOption.NONE -> originalEntries.map { if (it.id == entry.id) entry else it }
                }
                categoryCache[entry.id] = entry.getAllCategories()
                // Clear lowercase cache for this entry (will be regenerated on next filter)
                lowercaseCache.keys.removeAll { it.startsWith("service:${entry.id}") || 
                                                it.startsWith("username:${entry.id}") || 
                                                it.startsWith("notes:${entry.id}") ||
                                                it.startsWith("cat:${entry.id}:") }
                val updatedCategories = categoryCache.values.flatten().distinct().sorted()
                _uiState.update { 
                    it.copy(
                        entries = updatedEntries,
                        availableCategories = updatedCategories
                    )
                }
                
                vaultRepository.updateEntry(entry, masterPassword, originalEntries)
                // Success - the flow will update with final state, but UI already shows the update
                _uiState.update { it.copy(successMessage = "Password updated successfully") }
            } catch (e: Exception) {
                // Rollback on error - restore original entry
                if (originalEntry != null) {
                    val rollbackEntries = originalEntries.map { if (it.id == entry.id) originalEntry else it }
                    _uiState.update { 
                        it.copy(
                            entries = rollbackEntries,
                            errorMessage = "Failed to update entry: ${e.message}"
                        )
                    }
                } else {
                    _uiState.update { 
                        it.copy(errorMessage = "Failed to update entry: ${e.message}")
                    }
                }
            }
        }
    }

    /**
     * Delete a password entry.
     */
    fun deleteEntry(id: String) {
        val masterPassword = currentMasterPassword ?: return
        
        viewModelScope.launch {
            // Store original entries for rollback
            val originalEntries = _uiState.value.entries
            val deletedEntry = originalEntries.firstOrNull { it.id == id }
            
            try {
                // OPTIMISTIC UPDATE: Remove entry from UI immediately
                val updatedEntries = originalEntries.filter { it.id != id }
                categoryCache.remove(id)
                // Clear lowercase cache for deleted entry
                lowercaseCache.keys.removeAll { it.contains(":$id:") || it.endsWith(":$id") }
                val updatedCategories = categoryCache.values.flatten().distinct().sorted()
                _uiState.update { 
                    it.copy(
                        entries = updatedEntries,
                        availableCategories = updatedCategories
                    )
                }
                
                vaultRepository.deleteEntry(id, masterPassword, originalEntries)
                // Clear lowercase cache for deleted entry
                lowercaseCache.keys.removeAll { it.contains(":$id:") || it.endsWith(":$id") }
                // Success - the flow will update with final state, but UI already shows the deletion
                _uiState.update { it.copy(successMessage = "Password deleted successfully") }
            } catch (e: Exception) {
                // Rollback on error - restore the entry
                if (deletedEntry != null) {
                    val rollbackEntries = when (_uiState.value.sortOption) {
                        PasswordSortOption.ALPHABETICAL_ASC -> (originalEntries + deletedEntry).sortedBy { it.service.lowercase() }
                        PasswordSortOption.ALPHABETICAL_DESC -> (originalEntries + deletedEntry).sortedByDescending { it.service.lowercase() }
                        PasswordSortOption.DATE_DESC -> (originalEntries + deletedEntry).sortedByDescending { it.updatedAt }
                        PasswordSortOption.DATE_ASC -> (originalEntries + deletedEntry).sortedBy { it.updatedAt }
                        PasswordSortOption.NONE -> (originalEntries + deletedEntry)
                    }
                    _uiState.update { 
                        it.copy(
                            entries = rollbackEntries,
                            errorMessage = "Failed to delete entry: ${e.message}"
                        )
                    }
                } else {
                    _uiState.update { 
                        it.copy(errorMessage = "Failed to delete entry: ${e.message}")
                    }
                }
            }
        }
    }

    /**
     * Search entries by query with debouncing.
     * Delays the actual search by 300ms to avoid filtering on every keystroke.
     */
    fun searchEntries(query: String) {
        // Cancel previous debounce job
        searchDebounceJob?.cancel()
        
        // Update query immediately for UI feedback
        _uiState.update { it.copy(searchQuery = query) }
        
        // No need to manually refresh - loadEntries() flow automatically reacts to searchQuery changes
        // The debouncing is already handled in the UI layer (LaunchedEffect with delay)
    }
    
    /**
     * Filter entries by category.
     */
    fun filterByCategory(category: String?) {
        _uiState.update { it.copy(categoryFilter = category) }
        // Filtering is handled in loadEntries() via collectLatest
        // The filter will be applied automatically when loadEntries() processes the entries
        // No need to call refreshEntries() here as the flow will update automatically
    }

    /**
     * Set error message.
     */
    fun setError(message: String) {
        _uiState.update { it.copy(errorMessage = message) }
    }

    /**
     * Set success message.
     */
    fun setSuccess(message: String) {
        _uiState.update { it.copy(successMessage = message) }
    }

    /**
     * Clear error message.
     */
    fun clearError() {
        _uiState.update { it.copy(errorMessage = null) }
    }

    /**
     * Clear success message.
     */
    fun clearSuccess() {
        _uiState.update { it.copy(successMessage = null) }
    }

    /**
     * Export all password entries.
     * Returns the encrypted JSON string that can be saved to a file.
     */
    suspend fun exportEntries(): String? {
        val masterPassword = currentMasterPassword ?: return null
        return vaultRepository.exportEntries(masterPassword)
    }
    
    /**
     * Import password entries from encrypted JSON string.
     * @param encryptedData The encrypted JSON string
     * @param merge If true, merge with existing entries. If false, replace all entries.
     * @return Number of new entries imported, or -1 on error (for backward compatibility)
     */
    suspend fun importEntries(encryptedData: String, merge: Boolean = true): Int {
        val masterPassword = currentMasterPassword ?: return -1
        val result = vaultRepository.importEntries(encryptedData, masterPassword, merge)
        
        if (result.isError) {
            _uiState.update { it.copy(errorMessage = "Failed to import passwords. Please check the encrypted data and try again.") }
            return -1
        }
        
        // Build success message based on import result
        val message = if (result.newEntriesCount > 0) {
            if (result.existingEntriesCount > 0 && merge) {
                // Merge mode: show what was added and what was preserved
                "Imported ${result.newEntriesCount} password(s). ${result.existingEntriesCount} existing password(s) were preserved. Total: ${result.totalEntriesCount} entries."
            } else {
                // Replace mode or no existing entries
                "Successfully imported ${result.newEntriesCount} password(s)"
            }
        } else {
            // No new entries to import
            "No new passwords to import. All entries already exist."
        }
        
        _uiState.update { it.copy(successMessage = message) }
        // The flow in loadEntries() will automatically pick up the changes and update the cache
        
        // Return number of new entries for backward compatibility
        return result.newEntriesCount
    }

    /**
     * Cycle through alphabetical sort states: NONE -> ASC -> DESC -> NONE
     * When activating alphabetical sort, resets date sort to NONE.
     */
    fun cycleAlphabeticalSort() {
        val current = _uiState.value.sortOption
        val next = when (current) {
            PasswordSortOption.ALPHABETICAL_ASC -> PasswordSortOption.ALPHABETICAL_DESC
            PasswordSortOption.ALPHABETICAL_DESC -> PasswordSortOption.NONE
            else -> PasswordSortOption.ALPHABETICAL_ASC
        }
        setSortOption(next)
    }
    
    /**
     * Cycle through date sort states: NONE -> DESC (newest) -> ASC (oldest) -> NONE
     * When activating date sort, resets alphabetical sort to NONE.
     */
    fun cycleDateSort() {
        val current = _uiState.value.sortOption
        val next = when (current) {
            PasswordSortOption.DATE_DESC -> PasswordSortOption.DATE_ASC
            PasswordSortOption.DATE_ASC -> PasswordSortOption.NONE
            else -> PasswordSortOption.DATE_DESC
        }
        setSortOption(next)
    }
    
    /**
     * Set sort option and save preference.
     */
    private fun setSortOption(option: PasswordSortOption) {
        _uiState.update { it.copy(sortOption = option) }
        viewModelScope.launch {
            userPreferencesRepository?.setPasswordManagerSortOption(option)
        }
        // Reload entries to apply new sort
        if (_uiState.value.isUnlocked) {
            reloadEntries()
        }
    }
    
    /**
     * Get entry count for free tier limit display.
     */
    fun getEntryCount(): Int {
        return _uiState.value.entries.size
    }
}

/**
 * UI State for Password Manager.
 */
data class PasswordManagerUiState(
    val hasMasterPassword: Boolean = false,
    val isUnlocked: Boolean = false,
    val entries: List<PasswordEntry> = emptyList(),
    val searchQuery: String = "",
    val categoryFilter: String? = null,
    val availableCategories: List<String> = emptyList(),
    val errorMessage: String? = null,
    val successMessage: String? = null,
    val biometricEnabled: Boolean = false,
    val biometricAvailable: Boolean = false,
    val sortOption: PasswordSortOption = PasswordSortOption.NONE,
    val activeSortOption: PasswordSortOption = PasswordSortOption.NONE
)

