package com.ciphio.vault.ui

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.ciphio.vault.crypto.CryptoService
import com.ciphio.vault.data.HistoryRepository
import com.ciphio.vault.data.UserPreferencesRepository
import com.ciphio.vault.password.PasswordGenerator
import com.ciphio.vault.premium.PremiumManager

class HomeViewModelFactory(
    private val cryptoService: CryptoService,
    private val historyRepository: HistoryRepository,
    private val passwordGenerator: PasswordGenerator,
    private val userPreferencesRepository: UserPreferencesRepository,
    private val premiumManager: PremiumManager
) : ViewModelProvider.Factory {
    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        return HomeViewModel(cryptoService, historyRepository, passwordGenerator, userPreferencesRepository, premiumManager) as T
    }
}

