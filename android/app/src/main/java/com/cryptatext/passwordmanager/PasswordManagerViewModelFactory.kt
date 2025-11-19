package com.cryptatext.passwordmanager

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.cryptatext.crypto.CryptoService
import com.cryptatext.data.cryptatextDataStore

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

