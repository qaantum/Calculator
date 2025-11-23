package com.ciphio.vault.ui

import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.ciphio.vault.crypto.CryptoService
import com.ciphio.vault.data.HistoryRepository
import com.ciphio.vault.data.UserPreferencesRepository
import com.ciphio.vault.data.ciphioDataStore
import com.ciphio.vault.navigation.AppDestination
import com.ciphio.vault.password.PasswordGenerator
import com.ciphio.vault.passwordmanager.PasswordManagerApp
import com.ciphio.vault.ui.theme.CiphioTheme
import androidx.compose.runtime.collectAsState

@Composable
fun CiphioApp(initialSharedText: String? = null) {
    val context = androidx.compose.ui.platform.LocalContext.current
    val dataStore = remember { context.ciphioDataStore }
    val historyRepository = remember { HistoryRepository(dataStore) }
    val userPreferencesRepository = remember { UserPreferencesRepository(dataStore) }
    val cryptoService = remember { CryptoService() }
    val passwordGenerator = remember { PasswordGenerator() }
    val scope = androidx.compose.runtime.rememberCoroutineScope()
    // Use MockPremiumManager in debug builds for testing without licenses
    // Switch to RealPremiumManager for release builds
    val premiumManager = remember { 
        if (com.ciphio.vault.BuildConfig.DEBUG) {
            // Debug: Use mock for testing without Google Play Console setup
            com.ciphio.vault.premium.MockPremiumManager()
        } else {
            // Release: Use real billing manager
            com.ciphio.vault.premium.RealPremiumManager(context, scope)
        }
    }
    val isPremium by premiumManager.isPremium.collectAsState(initial = false)

    val viewModel: HomeViewModel = viewModel(
        factory = HomeViewModelFactory(
            cryptoService = cryptoService,
            historyRepository = historyRepository,
            passwordGenerator = passwordGenerator,
            userPreferencesRepository = userPreferencesRepository,
            premiumManager = premiumManager
        )
    )

    // Set shared text if provided
    androidx.compose.runtime.LaunchedEffect(initialSharedText) {
        initialSharedText?.let { text ->
            viewModel.updateInputText(text)
        }
    }

    val uiState by viewModel.uiState.collectAsState()
    val navController = rememberNavController()

    CiphioTheme(themeOption = uiState.themeOption) {
        Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.background) {
            NavHost(navController = navController, startDestination = AppDestination.Home.route) {
                composable(AppDestination.Home.route) {
                    HomeRoute(
                        viewModel = viewModel,
                        isPremium = isPremium,
                        onOpenSettings = { navController.navigate(AppDestination.Settings.route) },
                        onOpenHistory = { navController.navigate(AppDestination.History.route) },
                        onOpenPasswordManager = { navController.navigate(AppDestination.PasswordManager.route) }
                    )
                }
                composable(AppDestination.History.route) {
                    HistoryScreen(
                        entries = uiState.history,
                        onBack = { navController.popBackStack() },
                        onClear = viewModel::clearHistory,
                        onDelete = viewModel::deleteHistoryEntry,
                        onUse = { entry ->
                            viewModel.useHistoryEntry(entry)
                            navController.popBackStack()
                        }
                    )
                }
                composable(AppDestination.Settings.route) {
                    SettingsScreen(
                        themeOption = uiState.themeOption,
                        isPremium = isPremium,
                        onSelectTheme = viewModel::setTheme,
                        onOpenAlgorithms = { navController.navigate(AppDestination.Algorithms.route) },
                        onOpenTerms = { navController.navigate(AppDestination.Terms.route) },
                        onOpenPasswordManager = { navController.navigate(AppDestination.PasswordManager.route) },
                        onOpenPremium = { 
                            val activity = context as? android.app.Activity
                            if (activity != null) {
                                viewModel.upgradeToPremium(activity)
                            }
                        },
                        onRateUs = {
                            (context as? com.ciphio.vault.MainActivity)?.launchPlayStore()
                        },
                        onBack = { navController.popBackStack() }
                    )
                }
                composable(AppDestination.Algorithms.route) {
                    InfoScreen(
                        title = "Encryption Algorithms",
                        content = AlgorithmsInfo,
                        onBack = { navController.popBackStack() }
                    )
                }
                composable(AppDestination.Terms.route) {
                    InfoScreen(
                        title = "Terms of Service",
                        content = TermsContent,
                        onBack = { navController.popBackStack() }
                    )
                }
                
                // Password Manager route (modular - can be removed)
                composable(AppDestination.PasswordManager.route) {
                    PasswordManagerApp(
                        navController = navController,
                        onBack = { navController.popBackStack() },
                        isPremium = isPremium,
                        passwordGenerator = passwordGenerator
                    )
                }
            }
        }
    }
}

