package com.ciphio.vault.passwordmanager

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.ciphio.vault.crypto.CryptoService
import com.ciphio.vault.data.ciphioDataStore
import com.ciphio.vault.data.UserPreferencesRepository

/**
 * Factory for creating PasswordManagerViewModel.
 * 
 * This is a separate, modular feature that can be easily removed.
 */
class PasswordManagerViewModelFactory(
    private val vaultRepository: PasswordVaultRepository,
    private val userPreferencesRepository: UserPreferencesRepository? = null
) : ViewModelProvider.Factory {
    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(PasswordManagerViewModel::class.java)) {
            return PasswordManagerViewModel(vaultRepository, userPreferencesRepository) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}

