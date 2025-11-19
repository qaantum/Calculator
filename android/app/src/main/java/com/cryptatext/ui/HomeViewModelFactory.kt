package com.cryptatext.ui

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.cryptatext.crypto.CryptoService
import com.cryptatext.data.HistoryRepository
import com.cryptatext.data.UserPreferencesRepository
import com.cryptatext.password.PasswordGenerator
import com.cryptatext.premium.PremiumManager

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

