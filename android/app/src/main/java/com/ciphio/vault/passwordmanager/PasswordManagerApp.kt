package com.ciphio.vault.passwordmanager

import androidx.compose.runtime.*
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.platform.LocalContext
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import android.content.Intent
import android.content.Context
import com.ciphio.vault.crypto.CryptoService
import com.ciphio.vault.data.ciphioDataStore
import com.ciphio.vault.data.UserPreferencesRepository
import com.ciphio.vault.navigation.AppDestination
import com.ciphio.vault.password.PasswordGenerator
import kotlinx.coroutines.launch
import java.util.UUID
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences

/**
 * Password Manager App Wrapper.
 * 
 * This manages the password manager flow:
 * 1. Check if master password is set
 * 2. Show setup screen if not set
 * 3. Show unlock screen if locked
 * 4. Show list screen if unlocked
 * 
 * This is a separate, modular feature that can be easily removed.
 */
@Composable
fun PasswordManagerApp(
    navController: NavHostController,
    onBack: () -> Unit,
    isPremium: Boolean = false,
    passwordGenerator: PasswordGenerator? = null
) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()
    val dataStore = remember { context.ciphioDataStore }
    val cryptoService = remember { CryptoService() }
    val keystoreHelper = remember { KeystoreHelper(context) }
    val userPreferencesRepository = remember { UserPreferencesRepository(dataStore) }
    val vaultRepository = remember { PasswordVaultRepository(dataStore, cryptoService, keystoreHelper) }
    
    val viewModel: PasswordManagerViewModel = viewModel(
        factory = PasswordManagerViewModelFactory(vaultRepository, userPreferencesRepository, isPremium)
    )
    
    val state by viewModel.uiState.collectAsState()
    
    // Check master password status and show appropriate screen
    LaunchedEffect(Unit) {
        viewModel.checkMasterPasswordStatus()
    }
    
    // Navigation state - use simple state management
    var showAddEditScreen by remember { mutableStateOf<PasswordEntry?>(null) }
    var showAddScreen by remember { mutableStateOf(false) }
    var showViewScreen by remember { mutableStateOf<PasswordEntry?>(null) }
    var showChangePasswordScreen by remember { mutableStateOf(false) }
    
    // Use BackHandler for proper back navigation
    androidx.activity.compose.BackHandler(
        enabled = showAddEditScreen != null || showAddScreen || showViewScreen != null || showChangePasswordScreen
    ) {
        when {
            showViewScreen != null -> showViewScreen = null
            showAddEditScreen != null || showAddScreen -> {
                showAddEditScreen = null
                showAddScreen = false
                viewModel.reloadEntries()
            }
            showChangePasswordScreen -> showChangePasswordScreen = false
        }
    }
    
    // Determine which screen to show
    when {
        !state.hasMasterPassword -> {
            MasterPasswordSetupScreen(
                viewModel = viewModel,
                onSetupComplete = {
                    // After setup, show list screen
                }
            )
        }
        !state.isUnlocked -> {
            MasterPasswordUnlockScreen(
                viewModel = viewModel,
                onUnlockComplete = {
                    // After unlock, show list screen
                },
                isPremium = isPremium
            )
        }
        showChangePasswordScreen -> {
            ChangeMasterPasswordScreen(
                viewModel = viewModel,
                onBack = {
                    showChangePasswordScreen = false
                    viewModel.clearSuccess()
                }
            )
        }
        showViewScreen != null -> {
            ViewPasswordEntryScreen(
                entry = showViewScreen!!,
                viewModel = viewModel,
                onBack = {
                    showViewScreen = null
                    viewModel.reloadEntries()
                },
                onEdit = { entry ->
                    showViewScreen = null
                    showAddEditScreen = entry
                }
            )
        }
        showAddEditScreen != null || showAddScreen -> {
            AddEditPasswordEntryScreen(
                entry = showAddEditScreen,
                viewModel = viewModel,
                onGeneratePassword = passwordGenerator?.let { gen ->
                    {
                        gen.generate(
                            com.ciphio.vault.password.PasswordConfig(
                                length = 16,
                                includeUppercase = true,
                                includeLowercase = true,
                                includeDigits = true,
                                includeSymbols = true
                            )
                        )
                    }
                },
                onBack = {
                    showAddEditScreen = null
                    showAddScreen = false
                    viewModel.clearSuccess()
                    viewModel.reloadEntries()
                },
                isPremium = isPremium,
                onPremiumPurchase = {
                    navController.navigate(AppDestination.Premium.route)
                }
            )
        }
        else -> {
            // List screen
            LaunchedEffect(state.isUnlocked, showAddEditScreen) {
                if (state.isUnlocked && showAddEditScreen == null) {
                    kotlinx.coroutines.delay(100)
                    viewModel.reloadEntries()
                }
            }
            
            PasswordManagerListScreen(
                viewModel = viewModel,
                onBack = onBack,
                onAddEntry = {
                    showAddScreen = true
                    showAddEditScreen = null
                },
                onViewEntry = { entry ->
                    showViewScreen = entry
                },
                onEditEntry = { entry ->
                    showAddEditScreen = entry
                },
                onChangePassword = {
                    showChangePasswordScreen = true
                },
                onPremiumPurchase = {
                    navController.navigate(AppDestination.Premium.route)
                },
                onExport = {
                    scope.launch {
                        val exported = viewModel.exportEntries()
                        exported?.let { data ->
                            val shareIntent = Intent(Intent.ACTION_SEND).apply {
                                type = "text/plain"
                                putExtra(Intent.EXTRA_TEXT, data)
                                putExtra(Intent.EXTRA_SUBJECT, "Ciphio Password Export")
                            }
                            context.startActivity(Intent.createChooser(shareIntent, "Export passwords"))
                        }
                    }
                },
                onLock = {
                    viewModel.lockVault()
                },
                isPremium = isPremium
            )
        }
    }
}
