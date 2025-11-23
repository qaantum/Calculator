package com.ciphio.vault.passwordmanager

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.ciphio.vault.crypto.CryptoService
import com.ciphio.vault.data.ciphioDataStore

/**
 * Factory for creating PasswordManagerViewModel.
 * 
 * This is a separate, modular feature that can be easily removed.
 */
class PasswordManagerViewModelFactory(
    private val vaultRepository: PasswordVaultRepository,
    private val isPremium: Boolean = false
) : ViewModelProvider.Factory {
    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(PasswordManagerViewModel::class.java)) {
            return PasswordManagerViewModel(vaultRepository, isPremium) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}

