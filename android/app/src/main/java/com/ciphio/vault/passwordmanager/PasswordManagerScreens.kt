package com.ciphio.vault.passwordmanager

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyListState
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ContentCopy
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Visibility
import androidx.compose.material.icons.filled.VisibilityOff
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.filled.Fingerprint
import androidx.compose.material.icons.filled.Share
import androidx.compose.material.icons.filled.Description
import androidx.compose.material.icons.filled.Download
import androidx.compose.material.icons.filled.Sort
import androidx.compose.material.icons.filled.SortByAlpha
import androidx.compose.material.icons.filled.DateRange
import androidx.compose.material.icons.filled.ArrowUpward
import androidx.compose.material.icons.filled.ArrowDownward
import androidx.compose.material3.*
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuDefaults
import androidx.compose.material3.SwipeToDismissBox
import androidx.compose.material3.SwipeToDismissBoxValue
import androidx.compose.material3.rememberSwipeToDismissBoxState
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.activity.compose.BackHandler
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.platform.LocalContext
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import android.content.ContextWrapper
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import com.ciphio.vault.ui.theme.LocalCiphioColors
import kotlinx.coroutines.launch
import kotlinx.coroutines.delay
import androidx.compose.ui.platform.AndroidUiDispatcher
import kotlinx.coroutines.withContext
import android.net.Uri
import android.content.ContentResolver
import java.io.InputStream
import java.io.OutputStream

/**
 * Helper function to get FragmentActivity from Context.
 */
private fun getFragmentActivity(context: android.content.Context): FragmentActivity? {
    var ctx: android.content.Context? = context
    while (ctx != null) {
        if (ctx is FragmentActivity) {
            return ctx
        }
        if (ctx is ContextWrapper) {
            ctx = ctx.baseContext
        } else {
            break
        }
    }
    return null
}

/**
 * Password Manager UI Screens.
 * 
 * This is a separate, modular feature that can be easily removed
 * without affecting text encryption or password generation.
 */

/**
 * Master Password Setup Screen (first-time setup).
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MasterPasswordSetupScreen(
    viewModel: PasswordManagerViewModel = viewModel(),
    onSetupComplete: () -> Unit
) {
    val palette = LocalCiphioColors.current
    val state by viewModel.uiState.collectAsState()
    
    var password by remember { mutableStateOf("") }
    var confirmPassword by remember { mutableStateOf("") }
    var passwordVisible by remember { mutableStateOf(false) }
    var confirmPasswordVisible by remember { mutableStateOf(false) }
    
    LaunchedEffect(state.hasMasterPassword) {
        if (state.hasMasterPassword) {
            onSetupComplete()
        }
    }
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(palette.background)
            .padding(24.dp)
            .verticalScroll(rememberScrollState()),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(24.dp)
    ) {
        Icon(
            imageVector = Icons.Filled.Visibility,
            contentDescription = null,
            modifier = Modifier.size(64.dp),
            tint = palette.primary
        )
        
        Text(
            text = "Set Master Password",
            style = MaterialTheme.typography.headlineMedium.copy(
                fontWeight = androidx.compose.ui.text.font.FontWeight.Bold
            ),
            color = palette.foreground
        )
        
        Text(
            text = "Create a master password to secure your password vault. This password will be required to access your stored passwords.",
            style = MaterialTheme.typography.bodyLarge,
            color = palette.mutedForeground,
            modifier = Modifier.padding(horizontal = 16.dp)
        )
        
        OutlinedTextField(
            value = password,
            onValueChange = { password = it },
            label = { Text("Master Password", color = palette.foreground) },
            placeholder = { Text("Enter password", color = palette.mutedForeground) },
            visualTransformation = if (passwordVisible) VisualTransformation.None else PasswordVisualTransformation(),
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
            modifier = Modifier.fillMaxWidth(),
            colors = OutlinedTextFieldDefaults.colors(
                focusedTextColor = palette.foreground,
                unfocusedTextColor = palette.foreground,
                focusedLabelColor = palette.foreground,
                unfocusedLabelColor = palette.mutedForeground,
                focusedContainerColor = palette.input,
                unfocusedContainerColor = palette.input,
                focusedBorderColor = palette.primary,
                unfocusedBorderColor = palette.border
            ),
            trailingIcon = {
                IconButton(onClick = { passwordVisible = !passwordVisible }) {
                    Icon(
                        imageVector = if (passwordVisible) Icons.Filled.Visibility else Icons.Filled.VisibilityOff,
                        contentDescription = if (passwordVisible) "Hide password" else "Show password",
                        tint = palette.foreground
                    )
                }
            }
        )
        
        OutlinedTextField(
            value = confirmPassword,
            onValueChange = { confirmPassword = it },
            label = { Text("Confirm Password", color = palette.foreground) },
            placeholder = { Text("Re-enter password", color = palette.mutedForeground) },
            visualTransformation = if (confirmPasswordVisible) VisualTransformation.None else PasswordVisualTransformation(),
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
            modifier = Modifier.fillMaxWidth(),
            colors = OutlinedTextFieldDefaults.colors(
                focusedTextColor = palette.foreground,
                unfocusedTextColor = palette.foreground,
                focusedLabelColor = palette.foreground,
                unfocusedLabelColor = palette.mutedForeground,
                focusedContainerColor = palette.input,
                unfocusedContainerColor = palette.input,
                focusedBorderColor = palette.primary,
                unfocusedBorderColor = palette.border
            ),
            trailingIcon = {
                IconButton(onClick = { confirmPasswordVisible = !confirmPasswordVisible }) {
                    Icon(
                        imageVector = if (confirmPasswordVisible) Icons.Filled.Visibility else Icons.Filled.VisibilityOff,
                        contentDescription = if (confirmPasswordVisible) "Hide password" else "Show password",
                        tint = palette.foreground
                    )
                }
            }
        )
        
        if (state.errorMessage != null) {
            Text(
                text = state.errorMessage!!,
                color = palette.destructive,
                style = MaterialTheme.typography.bodyMedium,
                modifier = Modifier.padding(horizontal = 16.dp)
            )
        }
        
        Button(
            onClick = {
                viewModel.setMasterPassword(password, confirmPassword)
            },
            enabled = password.isNotEmpty() && confirmPassword.isNotEmpty(),
            modifier = Modifier.fillMaxWidth(),
            colors = ButtonDefaults.buttonColors(
                containerColor = palette.primary,
                contentColor = palette.onPrimary
            ),
            shape = RoundedCornerShape(12.dp)
        ) {
            Text(
                text = "Set Master Password",
                style = MaterialTheme.typography.bodyLarge.copy(
                    fontWeight = androidx.compose.ui.text.font.FontWeight.SemiBold
                ),
                modifier = Modifier.padding(vertical = 8.dp)
            )
        }
    }
}

/**
 * Master Password Unlock Screen.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MasterPasswordUnlockScreen(
    viewModel: PasswordManagerViewModel = viewModel(),
    onUnlockComplete: () -> Unit,
    @Suppress("UNUSED_PARAMETER") isPremium: Boolean = false // Reserved for future use
) {
    val palette = LocalCiphioColors.current
    val state by viewModel.uiState.collectAsState()
    val context = LocalContext.current
    val activity = getFragmentActivity(context)
    val keystoreHelper = remember { KeystoreHelper(context) }
    val biometricHelper = remember { BiometricHelper(context, keystoreHelper) }
    
    var password by remember { mutableStateOf("") }
    var passwordVisible by remember { mutableStateOf(false) }
    var biometricAvailable by remember { mutableStateOf(false) }
    
    // Check if biometric is available - update when state changes (available to everyone now)
    LaunchedEffect(state.biometricEnabled) {
        val isAvailable = biometricHelper.isBiometricAvailable() && state.biometricEnabled
        biometricAvailable = isAvailable
        android.util.Log.d("PasswordManager", "Biometric available: $isAvailable (enabled: ${state.biometricEnabled}, hardware: ${biometricHelper.isBiometricAvailable()})")
    }
    
    // Try biometric unlock on screen load if enabled
    LaunchedEffect(biometricAvailable, activity) {
        if (biometricAvailable && activity != null) {
            android.util.Log.d("PasswordManager", "Attempting biometric unlock...")
            // Small delay to let screen render first
            kotlinx.coroutines.delay(300)
            biometricHelper.authenticate(
                activity = activity,
                forUnlock = true,
                onSuccess = { cryptoObject ->
                    android.util.Log.d("PasswordManager", "Biometric authentication succeeded, unlocking vault...")
                    // Retrieve master password from Android Keystore and unlock vault
                    viewModel.unlockWithBiometric(cryptoObject)
                },
                onError = { error ->
                    // Biometric failed or cancelled - user can still use password
                    android.util.Log.d("PasswordManager", "Biometric authentication failed: $error")
                }
            )
        } else {
            android.util.Log.d("PasswordManager", "Biometric unlock not triggered: available=$biometricAvailable, isFragmentActivity=${activity != null}")
        }
    }
    
    LaunchedEffect(state.isUnlocked) {
        if (state.isUnlocked) {
            onUnlockComplete()
        }
    }
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(palette.background)
            .padding(24.dp)
            .verticalScroll(rememberScrollState()),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(24.dp)
    ) {
        Icon(
            imageVector = Icons.Filled.VisibilityOff,
            contentDescription = null,
            modifier = Modifier.size(64.dp),
            tint = palette.primary
        )
        
        Text(
            text = "Unlock Password Vault",
            style = MaterialTheme.typography.headlineMedium.copy(
                fontWeight = androidx.compose.ui.text.font.FontWeight.Bold
            ),
            color = palette.foreground
        )
        
        Text(
            text = "Enter your master password to access your stored passwords.",
            style = MaterialTheme.typography.bodyLarge,
            color = palette.mutedForeground,
            modifier = Modifier.padding(horizontal = 16.dp)
        )
        
        OutlinedTextField(
            value = password,
            onValueChange = { password = it },
            label = { Text("Master Password", color = palette.foreground) },
            placeholder = { Text("Enter password", color = palette.mutedForeground) },
            visualTransformation = if (passwordVisible) VisualTransformation.None else PasswordVisualTransformation(),
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
            modifier = Modifier.fillMaxWidth(),
            colors = OutlinedTextFieldDefaults.colors(
                focusedTextColor = palette.foreground,
                unfocusedTextColor = palette.foreground,
                focusedLabelColor = palette.foreground,
                unfocusedLabelColor = palette.mutedForeground,
                focusedContainerColor = palette.input,
                unfocusedContainerColor = palette.input,
                focusedBorderColor = palette.primary,
                unfocusedBorderColor = palette.border
            ),
            trailingIcon = {
                IconButton(onClick = { passwordVisible = !passwordVisible }) {
                    Icon(
                        imageVector = if (passwordVisible) Icons.Filled.Visibility else Icons.Filled.VisibilityOff,
                        contentDescription = if (passwordVisible) "Hide password" else "Show password",
                        tint = palette.foreground
                    )
                }
            }
        )
        
        if (state.errorMessage != null) {
            Text(
                text = state.errorMessage!!,
                color = palette.destructive,
                style = MaterialTheme.typography.bodyMedium,
                modifier = Modifier.padding(horizontal = 16.dp)
            )
        }
        
        // Biometric unlock button (if available and enabled)
        val activityForButton = getFragmentActivity(context)
        
        if (biometricAvailable && activityForButton != null) {
            OutlinedButton(
                onClick = {
                    biometricHelper.authenticate(
                        activity = activityForButton,
                        forUnlock = true,
                        onSuccess = { cryptoObject ->
                            // Retrieve master password from Android Keystore and unlock vault
                            viewModel.unlockWithBiometric(cryptoObject)
                        },
                        onError = { error ->
                            // Show error or just let user use password
                            android.util.Log.d("PasswordManager", "Biometric authentication failed: $error")
                        }
                    )
                },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.outlinedButtonColors(
                    contentColor = palette.primary
                ),
                border = androidx.compose.foundation.BorderStroke(1.dp, palette.primary),
                shape = RoundedCornerShape(12.dp)
            ) {
                Icon(
                    imageVector = Icons.Filled.Fingerprint,
                    contentDescription = null,
                    modifier = Modifier.size(20.dp)
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = "Unlock with Biometric",
                    style = MaterialTheme.typography.bodyLarge.copy(
                        fontWeight = androidx.compose.ui.text.font.FontWeight.SemiBold
                    ),
                    modifier = Modifier.padding(vertical = 8.dp)
                )
            }
            
            HorizontalDivider(
                modifier = Modifier.padding(vertical = 8.dp),
                color = palette.border
            )
            
            Text(
                text = "Or enter password",
                style = MaterialTheme.typography.bodySmall,
                color = palette.mutedForeground
            )
        }
        
        Button(
            onClick = {
                viewModel.unlockVault(password)
            },
            enabled = password.isNotEmpty(),
            modifier = Modifier.fillMaxWidth(),
            colors = ButtonDefaults.buttonColors(
                containerColor = palette.primary,
                contentColor = palette.onPrimary
            ),
            shape = RoundedCornerShape(12.dp)
        ) {
            Text(
                text = "Unlock",
                style = MaterialTheme.typography.bodyLarge.copy(
                    fontWeight = androidx.compose.ui.text.font.FontWeight.SemiBold
                ),
                modifier = Modifier.padding(vertical = 8.dp)
            )
        }
    }
}

/**
 * Password Manager List Screen (main screen after unlock).
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PasswordManagerListScreen(
    viewModel: PasswordManagerViewModel = viewModel(),
    onBack: () -> Unit,
    onAddEntry: () -> Unit,
    onViewEntry: (PasswordEntry) -> Unit,
    onEditEntry: (PasswordEntry) -> Unit,
    onChangePassword: () -> Unit,
    onLock: () -> Unit,
    onPremiumPurchase: () -> Unit = { /* Premium upgrade */ },
    onExport: () -> Unit = { /* Export is handled directly in the function */ },
    @Suppress("UNUSED_PARAMETER") onImport: () -> Unit = { /* Import is handled directly in the function */ },
    isPremium: Boolean = false
) {
    val palette = LocalCiphioColors.current
    val state by viewModel.uiState.collectAsState()
    val context = LocalContext.current
    val clipboard = androidx.compose.ui.platform.LocalClipboardManager.current
    val scope = rememberCoroutineScope()
    val keystoreHelper = remember { KeystoreHelper(context) }
    val biometricHelper = remember { BiometricHelper(context, keystoreHelper) }
    
    var searchQuery by remember { mutableStateOf("") }
    var showDeleteDialog by remember { mutableStateOf<PasswordEntry?>(null) }
    var showImportDialog by remember { mutableStateOf(false) }
    var importText by remember { mutableStateOf("") }
    
    // File picker for import
    val importFilePickerLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.GetContent()
    ) { uri: Uri? ->
        uri?.let { fileUri ->
            scope.launch {
                try {
                    val contentResolver = context.contentResolver
                    val inputStream: InputStream? = contentResolver.openInputStream(fileUri)
                    inputStream?.use { stream ->
                        val fileContent = stream.bufferedReader().use { it.readText() }
                        if (fileContent.isNotBlank()) {
                            val count = viewModel.importEntries(fileContent, merge = true)
                            if (count > 0) {
                                // Success message already shown in ViewModel
                                // Close the import dialog after successful import
                                showImportDialog = false
                                importText = ""
                            } else if (count == -1) {
                                // Error already shown in state.errorMessage
                            }
                        } else {
                            viewModel.setError("File is empty or could not be read")
                        }
                    } ?: run {
                        viewModel.setError("Could not read file")
                    }
                } catch (e: Exception) {
                    android.util.Log.e("PasswordManager", "Failed to read import file: ${e.message}", e)
                    viewModel.setError("Failed to read file: ${e.message}")
                }
            }
        }
    }
    
    // File picker for export
    val exportFilePickerLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.CreateDocument("text/plain")
    ) { uri: Uri? ->
        uri?.let { fileUri ->
            scope.launch {
                try {
                    val exported = viewModel.exportEntries()
                    exported?.let { data ->
                        val contentResolver = context.contentResolver
                        val outputStream: OutputStream? = contentResolver.openOutputStream(fileUri)
                        outputStream?.use { stream ->
                            stream.bufferedWriter().use { writer ->
                                writer.write(data)
                            }
                            viewModel.setSuccess("Passwords exported successfully")
                        } ?: run {
                            viewModel.setError("Could not write to file")
                        }
                    } ?: run {
                        viewModel.setError("Failed to export passwords")
                    }
                } catch (e: Exception) {
                    android.util.Log.e("PasswordManager", "Failed to write export file: ${e.message}", e)
                    viewModel.setError("Failed to write file: ${e.message}")
                }
            }
        }
    }
    
    // Check biometric availability (available to everyone now)
    LaunchedEffect(Unit) {
        val biometricAvailable = biometricHelper.isBiometricAvailable()
        viewModel.setBiometricAvailable(biometricAvailable)
    }
    
    // Ensure entries are loaded when the screen is displayed
    LaunchedEffect(Unit) {
        viewModel.reloadEntries()
    }
    
    // Debounce search to improve performance
    LaunchedEffect(searchQuery) {
        kotlinx.coroutines.delay(300) // Wait 300ms after user stops typing
        viewModel.searchEntries(searchQuery)
    }
    
    LaunchedEffect(state.successMessage) {
        state.successMessage?.let {
            viewModel.clearSuccess()
        }
    }
    
    LaunchedEffect(state.errorMessage) {
        state.errorMessage?.let {
            viewModel.clearError()
        }
    }
    
    // Import dialog
    if (showImportDialog) {
        AlertDialog(
            onDismissRequest = { 
                showImportDialog = false
                importText = ""
            },
            title = {
                Text(
                    "Import Passwords",
                    style = MaterialTheme.typography.titleLarge,
                    color = palette.foreground
                )
            },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                    // File picker button
                    OutlinedButton(
                        onClick = {
                            importFilePickerLauncher.launch("*/*")
                        },
                        modifier = Modifier.fillMaxWidth(),
                        colors = ButtonDefaults.outlinedButtonColors(
                            contentColor = palette.primary
                        ),
                        border = androidx.compose.foundation.BorderStroke(1.dp, palette.primary),
                        shape = RoundedCornerShape(8.dp)
                    ) {
                        Icon(
                            imageVector = Icons.Filled.Description,
                            contentDescription = null,
                            modifier = Modifier.size(20.dp)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Text("Select File")
                    }
                    
                    HorizontalDivider(
                        modifier = Modifier.padding(vertical = 4.dp),
                        color = palette.border
                    )
                    
                    Text(
                        "Or paste the export data below (encrypted format or CSV from other password managers):",
                        style = MaterialTheme.typography.bodyMedium,
                        color = palette.foreground
                    )
                    OutlinedTextField(
                        value = importText,
                        onValueChange = { importText = it },
                        modifier = Modifier.fillMaxWidth(),
                        label = { Text("Export Data", color = palette.foreground) },
                        placeholder = { Text("Paste encrypted data or CSV here", color = palette.mutedForeground) },
                        minLines = 3,
                        maxLines = 5,
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedTextColor = palette.foreground,
                            unfocusedTextColor = palette.foreground,
                            focusedLabelColor = palette.foreground,
                            unfocusedLabelColor = palette.mutedForeground,
                            focusedContainerColor = palette.input,
                            unfocusedContainerColor = palette.input,
                            focusedBorderColor = palette.primary,
                            unfocusedBorderColor = palette.border
                        )
                    )
                    if (state.errorMessage != null) {
                        Text(
                            text = state.errorMessage!!,
                            color = palette.destructive,
                            style = MaterialTheme.typography.bodySmall
                        )
                    }
                    if (state.successMessage != null) {
                        Text(
                            text = state.successMessage!!,
                            color = palette.success,
                            style = MaterialTheme.typography.bodySmall
                        )
                    }
                }
            },
            confirmButton = {
                Button(
                    onClick = {
                        scope.launch {
                            if (importText.isNotBlank()) {
                                val count = viewModel.importEntries(importText, merge = true)
                                if (count > 0) {
                                    showImportDialog = false
                                    importText = ""
                                } else if (count == -1) {
                                    // Error already shown in state.errorMessage
                                }
                            }
                        }
                    },
                    enabled = importText.isNotBlank(),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = palette.primary,
                        contentColor = palette.onPrimary
                    )
                ) {
                    Text("Import from Text")
                }
            },
            dismissButton = {
                OutlinedButton(
                    onClick = { 
                        showImportDialog = false
                        importText = ""
                        viewModel.clearError()
                    },
                    colors = ButtonDefaults.outlinedButtonColors(
                        contentColor = palette.foreground
                    ),
                    border = androidx.compose.foundation.BorderStroke(1.dp, palette.border)
                ) {
                    Text("Cancel")
                }
            },
            containerColor = palette.card,
            shape = RoundedCornerShape(16.dp)
        )
    }
    
    // Delete confirmation dialog
    showDeleteDialog?.let { entryToDelete ->
        androidx.compose.material3.AlertDialog(
            onDismissRequest = { showDeleteDialog = null },
            title = {
                Text(
                    "Delete Password?",
                    style = MaterialTheme.typography.titleLarge,
                    color = palette.foreground
                )
            },
            text = {
                Text(
                    "Are you sure you want to delete the password for \"${entryToDelete.service}\"? This action cannot be undone.",
                    style = MaterialTheme.typography.bodyMedium,
                    color = palette.foreground
                )
            },
            confirmButton = {
                Button(
                    onClick = {
                        viewModel.deleteEntry(entryToDelete.id)
                        showDeleteDialog = null
                    },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = palette.destructive,
                        contentColor = palette.onPrimary
                    )
                ) {
                    Text("Delete")
                }
            },
            dismissButton = {
                OutlinedButton(
                    onClick = { showDeleteDialog = null },
                    colors = ButtonDefaults.outlinedButtonColors(
                        contentColor = palette.foreground
                    ),
                    border = androidx.compose.foundation.BorderStroke(1.dp, palette.border)
                ) {
                    Text("Cancel")
                }
            },
            containerColor = palette.card,
            shape = RoundedCornerShape(16.dp)
        )
    }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { 
                    Text(
                        "Password Manager",
                        color = palette.foreground,
                        fontWeight = FontWeight.SemiBold
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back",
                            tint = palette.foreground
                        )
                    }
                },
                actions = {
                    var showMenu by remember { mutableStateOf(false) }
                    
                    IconButton(onClick = { showMenu = true }) {
                        Icon(
                            imageVector = Icons.Filled.MoreVert,
                            contentDescription = "More options",
                            tint = palette.foreground
                        )
                    }
                    
                    DropdownMenu(
                        expanded = showMenu,
                        onDismissRequest = { showMenu = false },
                        modifier = Modifier.background(palette.card)
                    ) {
                        DropdownMenuItem(
                            text = { Text("Change Master Password", color = palette.foreground) },
                            onClick = {
                                showMenu = false
                                onChangePassword()
                            },
                            leadingIcon = {
                                Icon(
                                    imageVector = Icons.Filled.Lock,
                                    contentDescription = null,
                                    tint = palette.foreground
                                )
                            }
                        )
                        if (viewModel.uiState.value.biometricAvailable) {
                            val biometricKeystoreHelper = remember { KeystoreHelper(context) }
                            val biometricAuthHelper = remember { BiometricHelper(context, biometricKeystoreHelper) }
                            val activity = getFragmentActivity(context)
                            
                            DropdownMenuItem(
                                text = { 
                                    Row(
                                        modifier = Modifier.fillMaxWidth(),
                                        horizontalArrangement = Arrangement.SpaceBetween,
                                        verticalAlignment = Alignment.CenterVertically
                                    ) {
                                        Text(
                                            "Biometric Unlock",
                                            color = palette.foreground
                                        )
                                        Switch(
                                            checked = viewModel.uiState.value.biometricEnabled,
                                            onCheckedChange = { enabled ->
                                                if (enabled && activity != null) {
                                                    // Trigger biometric authentication to enable
                                                    biometricAuthHelper.authenticate(
                                                        activity = activity,
                                                        onSuccess = { _ ->
                                                            android.util.Log.d("PasswordManager", "Biometric auth succeeded, storing master password...")
                                                            viewModel.storeMasterPasswordAfterBiometricAuth()
                                                        },
                                                        onError = { error ->
                                                            android.util.Log.e("PasswordManager", "Biometric auth failed: $error")
                                                            viewModel.setBiometricEnabled(false)
                                                        }
                                                    )
                                                } else {
                                                    // Disable biometric
                                                    viewModel.setBiometricEnabled(false)
                                                }
                                            },
                                            modifier = Modifier.size(36.dp, 20.dp),
                                            colors = SwitchDefaults.colors(
                                                checkedTrackColor = palette.primary,
                                                checkedThumbColor = palette.onPrimary,
                                                uncheckedThumbColor = palette.card,
                                                uncheckedTrackColor = palette.border
                                            )
                                        )
                                    }
                                },
                                onClick = {
                                    // Toggle handled by switch
                                },
                                leadingIcon = {
                                    Icon(
                                        imageVector = Icons.Filled.Fingerprint,
                                        contentDescription = null,
                                        tint = palette.foreground
                                    )
                                }
                            )
                        }
                        DropdownMenuItem(
                            text = { Text("Export Passwords (Share)", color = palette.foreground) },
                            onClick = {
                                showMenu = false
                                onExport()
                            },
                            leadingIcon = {
                                Icon(
                                    imageVector = Icons.Filled.Share,
                                    contentDescription = null,
                                    tint = palette.foreground
                                )
                            }
                        )
                        DropdownMenuItem(
                            text = { Text("Export Passwords (Save to File)", color = palette.foreground) },
                            onClick = {
                                showMenu = false
                                exportFilePickerLauncher.launch("ciphio_passwords_export.txt")
                            },
                            leadingIcon = {
                                Icon(
                                    imageVector = Icons.Filled.Download,
                                        contentDescription = null,
                                        tint = palette.foreground
                                    )
                                }
                            )
                        DropdownMenuItem(
                            text = { Text("Import Passwords", color = palette.foreground) },
                            onClick = {
                                showMenu = false
                                showImportDialog = true
                                importText = ""
                                viewModel.clearError()
                                viewModel.clearSuccess()
                            },
                            leadingIcon = {
                                Icon(
                                    imageVector = Icons.Filled.ContentCopy,
                                    contentDescription = null,
                                    tint = palette.foreground
                                )
                            }
                        )
                        DropdownMenuItem(
                            text = { Text("Lock Vault", color = palette.foreground) },
                            onClick = {
                                showMenu = false
                                onLock()
                            },
                            leadingIcon = {
                                Icon(
                                    imageVector = Icons.Filled.VisibilityOff,
                                    contentDescription = null,
                                    tint = palette.foreground
                                )
                            }
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = palette.card,
                    titleContentColor = palette.foreground,
                    navigationIconContentColor = palette.foreground
                )
            )
        },
        floatingActionButton = {
            FloatingActionButton(
                onClick = onAddEntry,
                containerColor = palette.primary,
                contentColor = palette.onPrimary
            ) {
                Icon(
                    imageVector = Icons.Filled.Add,
                    contentDescription = "Add Password"
                )
            }
        },
        containerColor = palette.background
    ) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize()
        ) {
            // Password count indicator
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(12.dp),
                colors = CardDefaults.cardColors(containerColor = palette.card),
                border = androidx.compose.foundation.BorderStroke(1.dp, palette.border)
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(12.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column {
                        Text(
                            text = if (isPremium) {
                                "${state.entries.size} passwords"
                            } else {
                                "${state.entries.size} of 10 passwords"
                            },
                            style = MaterialTheme.typography.titleMedium.copy(
                                fontWeight = FontWeight.SemiBold
                            ),
                            color = palette.foreground
                        )
                        Text(
                            text = if (isPremium) {
                                "Premium • Unlimited"
                            } else {
                                "Free"
                            },
                            style = MaterialTheme.typography.bodySmall,
                            color = if (isPremium) palette.primary else palette.mutedForeground
                        )
                    }
                }
            }
            
            // Search bar
            OutlinedTextField(
                value = searchQuery,
                onValueChange = { searchQuery = it },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(12.dp),
                placeholder = { Text("Search passwords...", color = palette.mutedForeground) },
                leadingIcon = {
                    Icon(
                        imageVector = Icons.Filled.Search,
                        contentDescription = null,
                        tint = palette.foreground
                    )
                },
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = palette.foreground,
                    unfocusedTextColor = palette.foreground,
                    focusedLabelColor = palette.foreground,
                    unfocusedLabelColor = palette.mutedForeground,
                    focusedContainerColor = palette.input,
                    unfocusedContainerColor = palette.input,
                    focusedBorderColor = palette.primary,
                    unfocusedBorderColor = palette.border
                ),
                singleLine = true
            )
            
            // Category filter chips (if categories exist)
            if (state.availableCategories.isNotEmpty()) {
                LazyRow(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 12.dp, vertical = 8.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    item {
                        FilterChip(
                            selected = state.categoryFilter == null,
                            onClick = { viewModel.filterByCategory(null) },
                            label = { Text("All", style = MaterialTheme.typography.bodySmall) },
                            colors = FilterChipDefaults.filterChipColors(
                                selectedContainerColor = palette.primary,
                                selectedLabelColor = palette.onPrimary,
                                containerColor = palette.card,
                                labelColor = palette.foreground
                            )
                        )
                    }
                    items(state.availableCategories) { category ->
                        FilterChip(
                            selected = state.categoryFilter == category,
                            onClick = { viewModel.filterByCategory(category) },
                            label = { Text(category, style = MaterialTheme.typography.bodySmall) },
                            colors = FilterChipDefaults.filterChipColors(
                                selectedContainerColor = palette.primary,
                                selectedLabelColor = palette.onPrimary,
                                containerColor = palette.card,
                                labelColor = palette.foreground
                            )
                        )
                    }
                }
            }
            
            // Entry count and sort options
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 12.dp, vertical = 8.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = if (isPremium) {
                        "${state.entries.size} passwords"
                    } else {
                        "${state.entries.size} of 10 passwords"
                    },
                    style = MaterialTheme.typography.bodySmall,
                    color = palette.mutedForeground
                )
                
                // Sort buttons
                Row(
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    // Alphabetical sort button (cycles: Off -> A-Z -> Z-A -> Off)
                    val isAlphabeticalActive = state.sortOption == com.ciphio.vault.passwordmanager.PasswordSortOption.ALPHABETICAL_ASC ||
                                              state.sortOption == com.ciphio.vault.passwordmanager.PasswordSortOption.ALPHABETICAL_DESC
                    val isAlphabeticalDesc = state.sortOption == com.ciphio.vault.passwordmanager.PasswordSortOption.ALPHABETICAL_DESC
                    
                    FilterChip(
                        selected = isAlphabeticalActive,
                        onClick = { viewModel.cycleAlphabeticalSort() },
                        label = {
                            Row(
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.spacedBy(4.dp)
                            ) {
                                Icon(
                                    imageVector = Icons.Filled.SortByAlpha,
                                    contentDescription = "Alphabetical",
                                    modifier = Modifier.size(16.dp)
                                )
                                if (isAlphabeticalActive) {
                                    Icon(
                                        imageVector = if (isAlphabeticalDesc) Icons.Filled.ArrowDownward else Icons.Filled.ArrowUpward,
                                        contentDescription = if (isAlphabeticalDesc) "Z-A" else "A-Z",
                                        modifier = Modifier.size(12.dp)
                                    )
                                } else {
                                    Text("A-Z", style = MaterialTheme.typography.labelSmall)
                                }
                            }
                        },
                        colors = FilterChipDefaults.filterChipColors(
                            selectedContainerColor = palette.primary,
                            selectedLabelColor = palette.onPrimary,
                            containerColor = palette.card,
                            labelColor = palette.foreground
                        )
                    )
                    
                    // Date sort button (cycles: Off -> Newest -> Oldest -> Off)
                    val isDateActive = state.sortOption == com.ciphio.vault.passwordmanager.PasswordSortOption.DATE_DESC ||
                                      state.sortOption == com.ciphio.vault.passwordmanager.PasswordSortOption.DATE_ASC
                    val isDateAsc = state.sortOption == com.ciphio.vault.passwordmanager.PasswordSortOption.DATE_ASC
                    
                    FilterChip(
                        selected = isDateActive,
                        onClick = { viewModel.cycleDateSort() },
                        label = {
                            Row(
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.spacedBy(4.dp)
                            ) {
                                Icon(
                                    imageVector = Icons.Filled.DateRange,
                                    contentDescription = "Date",
                                    modifier = Modifier.size(16.dp)
                                )
                                if (isDateActive) {
                                    Icon(
                                        imageVector = if (isDateAsc) Icons.Filled.ArrowUpward else Icons.Filled.ArrowDownward,
                                        contentDescription = if (isDateAsc) "Oldest first" else "Newest first",
                                        modifier = Modifier.size(12.dp)
                                    )
                                } else {
                                    Text("Date", style = MaterialTheme.typography.labelSmall)
                                }
                            }
                        },
                        colors = FilterChipDefaults.filterChipColors(
                            selectedContainerColor = palette.primary,
                            selectedLabelColor = palette.onPrimary,
                            containerColor = palette.card,
                            labelColor = palette.foreground
                        )
                    )
                }
            }
            
            // Password entries list
            if (state.entries.isEmpty()) {
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(24.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.spacedBy(16.dp)
                    ) {
                        Icon(
                            imageVector = Icons.Filled.Visibility,
                            contentDescription = null,
                            modifier = Modifier.size(64.dp),
                            tint = palette.mutedForeground
                        )
                        Text(
                            text = if (searchQuery.isNotBlank()) "No matching passwords" else "No passwords yet",
                            style = MaterialTheme.typography.titleMedium,
                            color = palette.foreground
                        )
                        Text(
                            text = if (searchQuery.isNotBlank()) "Try a different search term" else "Get started by adding your first password",
                            style = MaterialTheme.typography.bodyMedium,
                            color = palette.mutedForeground
                        )
                        if (searchQuery.isBlank()) {
                            Button(
                                onClick = onAddEntry,
                                colors = ButtonDefaults.buttonColors(
                                    containerColor = palette.primary,
                                    contentColor = palette.onPrimary
                                ),
                                modifier = Modifier.padding(top = 8.dp),
                                shape = RoundedCornerShape(12.dp)
                            ) {
                                Icon(
                                    imageVector = Icons.Filled.Add,
                                    contentDescription = null,
                                    modifier = Modifier.size(20.dp)
                                )
                                Spacer(modifier = Modifier.width(8.dp))
                                Text(
                                    "Add Your First Password",
                                    style = MaterialTheme.typography.bodyLarge.copy(
                                        fontWeight = FontWeight.SemiBold
                                    )
                                )
                            }
                        }
                    }
                }
            } else {
                // Use a single state for swipe-to-delete (outside LazyColumn for performance)
                var swipedEntryForDelete by remember { mutableStateOf<PasswordEntry?>(null) }
                
                val listState = rememberLazyListState()
                
                LazyColumn(
                    state = listState,
                        modifier = Modifier.fillMaxSize(),
                        contentPadding = PaddingValues(12.dp),
                        verticalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                    items(
                        items = state.entries,
                        key = { "${it.id}-${state.activeSortOption}" }, // Include activeSortOption to force scroll reset ONLY when sorted data updates
                        contentType = { "password_entry" } // Content type for better recomposition
                    ) { entry ->
                        // Stable callbacks - only recreate if entry changes
                        val onItemClick = remember(entry.id) { { onViewEntry(entry) } }
                        val onItemEdit = remember(entry.id) { { onEditEntry(entry) } }
                        val onItemDelete = remember(entry.id) { { showDeleteDialog = entry } }
                        val onItemCopyPassword = remember(entry.id) { 
                            { clipboard.setText(androidx.compose.ui.text.AnnotatedString(entry.password)) }
                        }
                        val onItemCopyUsername = remember(entry.id) { 
                            { clipboard.setText(androidx.compose.ui.text.AnnotatedString(entry.username)) }
                        }
                        
                        // Create swipe state for each item (automatically remembered per composition with stable key)
                        val swipeState = rememberSwipeToDismissBoxState(
                            confirmValueChange = { dismissValue ->
                                if (dismissValue == SwipeToDismissBoxValue.EndToStart) {
                                    swipedEntryForDelete = entry
                                    false // Don't dismiss yet, wait for confirmation
                                } else {
                                    false
                                }
                            }
                        )
                        
                        SwipeToDismissBox(
                            state = swipeState,
                            backgroundContent = {
                                Box(
                                    modifier = Modifier
                                        .fillMaxSize()
                                        .background(palette.destructive, RoundedCornerShape(12.dp))
                                        .padding(horizontal = 20.dp),
                                    contentAlignment = Alignment.CenterEnd
                                ) {
                                    Icon(
                                        imageVector = Icons.Filled.Delete,
                                        contentDescription = "Delete",
                                        tint = palette.onPrimary,
                                        modifier = Modifier.size(32.dp)
                                    )
                                }
                            },
                            content = {
                                PasswordEntryListItem(
                                    entry = entry,
                                    onClick = onItemClick,
                                    onEdit = onItemEdit,
                                    onDelete = onItemDelete,
                                    onCopyPassword = onItemCopyPassword,
                                    onCopyUsername = onItemCopyUsername
                                )
                            }
                        )
                    }
                }
                
                
                // Single delete dialog outside LazyColumn (better performance)
                swipedEntryForDelete?.let { entryToDelete ->
                    androidx.compose.material3.AlertDialog(
                        onDismissRequest = { swipedEntryForDelete = null },
                        title = {
                            Text(
                                "Delete Password?",
                                style = MaterialTheme.typography.titleLarge,
                                color = palette.foreground
                            )
                        },
                        text = {
                            Text(
                                "Are you sure you want to delete the password for \"${entryToDelete.service}\"? This action cannot be undone.",
                                style = MaterialTheme.typography.bodyMedium,
                                color = palette.foreground
                            )
                        },
                        confirmButton = {
                            Button(
                                onClick = {
                                    viewModel.deleteEntry(entryToDelete.id)
                                    swipedEntryForDelete = null
                                },
                                colors = ButtonDefaults.buttonColors(
                                    containerColor = palette.destructive,
                                    contentColor = palette.onPrimary
                                )
                            ) {
                                Text("Delete")
                            }
                        },
                        dismissButton = {
                            OutlinedButton(
                                onClick = { swipedEntryForDelete = null },
                                colors = ButtonDefaults.outlinedButtonColors(
                                    contentColor = palette.foreground
                                ),
                                border = androidx.compose.foundation.BorderStroke(1.dp, palette.border)
                            ) {
                                Text("Cancel")
                            }
                        },
                        containerColor = palette.card,
                        shape = RoundedCornerShape(16.dp)
                    )
                }
            }
        }
    }
}

/**
 * Password Entry List Item.
 */
@Composable
private fun PasswordEntryListItem(
    entry: PasswordEntry,
    onClick: () -> Unit,
    onEdit: () -> Unit,
    onDelete: () -> Unit,
    onCopyPassword: () -> Unit,
    onCopyUsername: () -> Unit
) {
    val palette = LocalCiphioColors.current
    var passwordVisible by remember { mutableStateOf(false) }
    
    // Cache categories computation - only compute once per entry ID (stable across recompositions)
    val entryCategories = remember(entry.id) { entry.getAllCategories() }
    
    // Memoize entry properties to avoid recomputation
    val serviceText = remember(entry.id, entry.service) { entry.service }
    val usernameText = remember(entry.id, entry.username) { entry.username }
    
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick),
        colors = CardDefaults.cardColors(containerColor = palette.card),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp),
        border = androidx.compose.foundation.BorderStroke(1.dp, palette.border),
        shape = RoundedCornerShape(12.dp)
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = serviceText,
                    style = MaterialTheme.typography.titleMedium.copy(
                        fontWeight = FontWeight.SemiBold
                    ),
                    color = palette.foreground,
                    modifier = Modifier.weight(1f)
                )
                // Display all categories as chips - use Row instead of LazyRow for better performance
                if (entryCategories.isNotEmpty()) {
                    Row(
                        horizontalArrangement = Arrangement.spacedBy(4.dp),
                        modifier = Modifier.weight(1f, fill = false)
                    ) {
                        // Limit to 3 categories max to avoid layout issues
                        entryCategories.take(3).forEach { cat ->
                            androidx.compose.material3.Surface(
                                color = palette.secondary.copy(alpha = 0.2f),
                                shape = RoundedCornerShape(8.dp)
                            ) {
                                Text(
                                    text = cat,
                                    style = MaterialTheme.typography.bodySmall,
                                    color = palette.secondary,
                                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
                                    maxLines = 1,
                                    overflow = androidx.compose.ui.text.style.TextOverflow.Ellipsis
                                )
                            }
                        }
                        if (entryCategories.size > 3) {
                            Text(
                                text = "+${entryCategories.size - 3}",
                                style = MaterialTheme.typography.bodySmall,
                                color = palette.mutedForeground,
                                modifier = Modifier.padding(start = 4.dp)
                            )
                        }
                    }
                }
            }
            
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = usernameText,
                    style = MaterialTheme.typography.bodyMedium,
                    color = palette.mutedForeground,
                    modifier = Modifier.weight(1f)
                )
                IconButton(
                    onClick = onCopyUsername,
                    modifier = Modifier.size(32.dp)
                ) {
                    Icon(
                        imageVector = Icons.Filled.ContentCopy,
                        contentDescription = "Copy username",
                        modifier = Modifier.size(16.dp),
                        tint = palette.foreground
                    )
                }
            }
            
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = if (passwordVisible) entry.password else "••••••••",
                    style = MaterialTheme.typography.bodyMedium,
                    color = palette.foreground,
                    modifier = Modifier.weight(1f)
                )
                Row {
                    IconButton(
                        onClick = { passwordVisible = !passwordVisible },
                        modifier = Modifier.size(32.dp)
                    ) {
                        Icon(
                            imageVector = if (passwordVisible) Icons.Filled.VisibilityOff else Icons.Filled.Visibility,
                            contentDescription = if (passwordVisible) "Hide" else "Show",
                            modifier = Modifier.size(16.dp),
                            tint = palette.foreground
                        )
                    }
                    IconButton(
                        onClick = onCopyPassword,
                        modifier = Modifier.size(32.dp)
                    ) {
                        Icon(
                            imageVector = Icons.Filled.ContentCopy,
                            contentDescription = "Copy password",
                            modifier = Modifier.size(16.dp),
                            tint = palette.foreground
                        )
                    }
                }
            }
            
            if (entry.notes.isNotEmpty()) {
                Text(
                    text = entry.notes,
                    style = MaterialTheme.typography.bodySmall,
                    color = palette.mutedForeground,
                    maxLines = 2
                )
            }
            
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                OutlinedButton(
                    onClick = onEdit,
                    modifier = Modifier.weight(1f),
                    colors = ButtonDefaults.outlinedButtonColors(
                        contentColor = palette.foreground
                    ),
                    border = androidx.compose.foundation.BorderStroke(1.dp, palette.border),
                    shape = RoundedCornerShape(8.dp)
                ) {
                    Icon(
                        imageVector = Icons.Filled.Edit,
                        contentDescription = null,
                        modifier = Modifier.size(16.dp)
                    )
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("Edit", style = MaterialTheme.typography.bodySmall)
                }
                OutlinedButton(
                    onClick = onDelete,
                    modifier = Modifier.weight(1f),
                    colors = ButtonDefaults.outlinedButtonColors(
                        contentColor = palette.destructive
                    ),
                    border = androidx.compose.foundation.BorderStroke(1.dp, palette.destructive),
                    shape = RoundedCornerShape(8.dp)
                ) {
                    Icon(
                        imageVector = Icons.Filled.Delete,
                        contentDescription = null,
                        modifier = Modifier.size(16.dp)
                    )
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("Delete", style = MaterialTheme.typography.bodySmall)
                }
            }
        }
    }
}

/**
 * View Password Entry Screen.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ViewPasswordEntryScreen(
    entry: PasswordEntry,
    viewModel: PasswordManagerViewModel = viewModel(),
    onBack: () -> Unit,
    onEdit: (PasswordEntry) -> Unit
) {
    val palette = LocalCiphioColors.current
    val clipboard = LocalClipboardManager.current
    val scope = rememberCoroutineScope()
    
    var passwordVisible by remember { mutableStateOf(false) }
    var showDeleteDialog by remember { mutableStateOf(false) }
    
    // Handle system back button - ensure it goes back to list screen, not home screen
    BackHandler(onBack = onBack)
    
    // Delete confirmation dialog
    if (showDeleteDialog) {
        AlertDialog(
            onDismissRequest = { showDeleteDialog = false },
            title = {
                Text(
                    "Delete Password?",
                    style = MaterialTheme.typography.titleLarge,
                    color = palette.foreground
                )
            },
            text = {
                Text(
                    "Are you sure you want to delete the password for \"${entry.service}\"? This action cannot be undone.",
                    style = MaterialTheme.typography.bodyMedium,
                    color = palette.foreground
                )
            },
            confirmButton = {
                Button(
                    onClick = {
                        viewModel.deleteEntry(entry.id)
                        showDeleteDialog = false
                        onBack()
                    },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = palette.destructive,
                        contentColor = palette.onPrimary
                    )
                ) {
                    Text("Delete")
                }
            },
            dismissButton = {
                OutlinedButton(
                    onClick = { showDeleteDialog = false },
                    colors = ButtonDefaults.outlinedButtonColors(
                        contentColor = palette.foreground
                    ),
                    border = androidx.compose.foundation.BorderStroke(1.dp, palette.border)
                ) {
                    Text("Cancel")
                }
            },
            containerColor = palette.card,
            shape = RoundedCornerShape(16.dp)
        )
    }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { 
                    Text(
                        entry.service,
                        color = palette.foreground,
                        fontWeight = FontWeight.SemiBold
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back",
                            tint = palette.foreground
                        )
                    }
                },
                actions = {
                    IconButton(onClick = { onEdit(entry) }) {
                        Icon(
                            imageVector = Icons.Filled.Edit,
                            contentDescription = "Edit",
                            tint = palette.foreground
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = palette.card,
                    titleContentColor = palette.foreground,
                    navigationIconContentColor = palette.foreground
                )
            )
        },
        containerColor = palette.background
    ) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Service name
            Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
                Text(
                    text = "Service/Website",
                    style = MaterialTheme.typography.labelMedium,
                    color = palette.mutedForeground
                )
                Text(
                    text = entry.service,
                    style = MaterialTheme.typography.titleLarge.copy(
                        fontWeight = FontWeight.SemiBold
                    ),
                    color = palette.foreground
                )
            }
            
            HorizontalDivider(color = palette.border)
            
            // Username
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column(modifier = Modifier.weight(1f)) {
                        Text(
                            text = "Username",
                            style = MaterialTheme.typography.labelMedium,
                            color = palette.mutedForeground
                        )
                        Text(
                            text = entry.username,
                            style = MaterialTheme.typography.bodyLarge,
                            color = palette.foreground
                        )
                    }
                    IconButton(
                        onClick = {
                            clipboard.setText(AnnotatedString(entry.username))
                            scope.launch {
                                // Could show a snackbar here
                            }
                        }
                    ) {
                        Icon(
                            imageVector = Icons.Filled.ContentCopy,
                            contentDescription = "Copy username",
                            tint = palette.primary
                        )
                    }
                }
            }
            
            HorizontalDivider(color = palette.border)
            
            // Password
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column(modifier = Modifier.weight(1f)) {
                        Text(
                            text = "Password",
                            style = MaterialTheme.typography.labelMedium,
                            color = palette.mutedForeground
                        )
                        Text(
                            text = if (passwordVisible) entry.password else "•".repeat(entry.password.length.coerceAtLeast(12)),
                            style = MaterialTheme.typography.bodyLarge.copy(
                                fontFamily = if (passwordVisible) null else androidx.compose.ui.text.font.FontFamily.Monospace
                            ),
                            color = palette.foreground
                        )
                    }
                    Row {
                        IconButton(
                            onClick = { passwordVisible = !passwordVisible }
                        ) {
                            Icon(
                                imageVector = if (passwordVisible) Icons.Filled.Visibility else Icons.Filled.VisibilityOff,
                                contentDescription = if (passwordVisible) "Hide password" else "Show password",
                                tint = palette.foreground
                            )
                        }
                        IconButton(
                            onClick = {
                                clipboard.setText(AnnotatedString(entry.password))
                                scope.launch {
                                    // Could show a snackbar here
                                }
                            }
                        ) {
                            Icon(
                                imageVector = Icons.Filled.ContentCopy,
                                contentDescription = "Copy password",
                                tint = palette.primary
                            )
                        }
                    }
                }
            }
            
            // Categories
            val entryCategories = entry.getAllCategories()
            if (entryCategories.isNotEmpty()) {
                HorizontalDivider(color = palette.border)
                Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text(
                        text = "Categories",
                        style = MaterialTheme.typography.labelMedium,
                        color = palette.mutedForeground
                    )
                    LazyRow(
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        items(entryCategories) { cat ->
                            Surface(
                                color = palette.secondary.copy(alpha = 0.2f),
                                shape = RoundedCornerShape(8.dp)
                            ) {
                                Text(
                                    text = cat,
                                    style = MaterialTheme.typography.bodyMedium,
                                    color = palette.secondary,
                                    modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp)
                                )
                            }
                        }
                    }
                }
            }
            
            // Notes
            if (entry.notes.isNotBlank()) {
                HorizontalDivider(color = palette.border)
                Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
                    Text(
                        text = "Notes",
                        style = MaterialTheme.typography.labelMedium,
                        color = palette.mutedForeground
                    )
                    Text(
                        text = entry.notes,
                        style = MaterialTheme.typography.bodyMedium,
                        color = palette.foreground
                    )
                }
            }
            
            Spacer(modifier = Modifier.height(24.dp))
            
            // Action buttons
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                OutlinedButton(
                    onClick = { showDeleteDialog = true },
                    modifier = Modifier.weight(1f),
                    colors = ButtonDefaults.outlinedButtonColors(
                        contentColor = palette.destructive
                    ),
                    border = androidx.compose.foundation.BorderStroke(1.dp, palette.destructive),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Icon(
                        imageVector = Icons.Filled.Delete,
                        contentDescription = null,
                        modifier = Modifier.size(18.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text("Delete")
                }
                
                Button(
                    onClick = { onEdit(entry) },
                    modifier = Modifier.weight(1f),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = palette.primary,
                        contentColor = palette.onPrimary
                    ),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Icon(
                        imageVector = Icons.Filled.Edit,
                        contentDescription = null,
                        modifier = Modifier.size(18.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text("Edit")
                }
            }
        }
    }
}

/**
 * Change Master Password Screen.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ChangeMasterPasswordScreen(
    viewModel: PasswordManagerViewModel = viewModel(),
    onBack: () -> Unit
) {
    val palette = LocalCiphioColors.current
    val state by viewModel.uiState.collectAsState()
    
    var oldPassword by remember { mutableStateOf("") }
    var newPassword by remember { mutableStateOf("") }
    var confirmNewPassword by remember { mutableStateOf("") }
    var oldPasswordVisible by remember { mutableStateOf(false) }
    var newPasswordVisible by remember { mutableStateOf(false) }
    var confirmPasswordVisible by remember { mutableStateOf(false) }
    
    LaunchedEffect(state.successMessage) {
        if (state.successMessage != null) {
            kotlinx.coroutines.delay(1000)
            onBack()
        }
    }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { 
                    Text(
                        "Change Master Password",
                        color = palette.foreground,
                        fontWeight = FontWeight.SemiBold
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back",
                            tint = palette.foreground
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = palette.card,
                    titleContentColor = palette.foreground,
                    navigationIconContentColor = palette.foreground
                )
            )
        },
        containerColor = palette.background
    ) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Text(
                text = "To change your master password, you'll need to enter your current password and choose a new one. All your password entries will be re-encrypted with the new password.",
                style = MaterialTheme.typography.bodyMedium,
                color = palette.mutedForeground
            )
            
            OutlinedTextField(
                value = oldPassword,
                onValueChange = { oldPassword = it },
                label = { Text("Current Master Password", color = palette.foreground) },
                placeholder = { Text("Enter current password", color = palette.mutedForeground) },
                visualTransformation = if (oldPasswordVisible) VisualTransformation.None else PasswordVisualTransformation(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                modifier = Modifier.fillMaxWidth(),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = palette.foreground,
                    unfocusedTextColor = palette.foreground,
                    focusedLabelColor = palette.foreground,
                    unfocusedLabelColor = palette.mutedForeground,
                    focusedContainerColor = palette.input,
                    unfocusedContainerColor = palette.input,
                    focusedBorderColor = palette.primary,
                    unfocusedBorderColor = palette.border
                ),
                trailingIcon = {
                    IconButton(onClick = { oldPasswordVisible = !oldPasswordVisible }) {
                        Icon(
                            imageVector = if (oldPasswordVisible) Icons.Filled.Visibility else Icons.Filled.VisibilityOff,
                            contentDescription = if (oldPasswordVisible) "Hide password" else "Show password",
                            tint = palette.foreground
                        )
                    }
                }
            )
            
            OutlinedTextField(
                value = newPassword,
                onValueChange = { newPassword = it },
                label = { Text("New Master Password", color = palette.foreground) },
                placeholder = { Text("Enter new password", color = palette.mutedForeground) },
                visualTransformation = if (newPasswordVisible) VisualTransformation.None else PasswordVisualTransformation(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                modifier = Modifier.fillMaxWidth(),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = palette.foreground,
                    unfocusedTextColor = palette.foreground,
                    focusedLabelColor = palette.foreground,
                    unfocusedLabelColor = palette.mutedForeground,
                    focusedContainerColor = palette.input,
                    unfocusedContainerColor = palette.input,
                    focusedBorderColor = palette.primary,
                    unfocusedBorderColor = palette.border
                ),
                trailingIcon = {
                    IconButton(onClick = { newPasswordVisible = !newPasswordVisible }) {
                        Icon(
                            imageVector = if (newPasswordVisible) Icons.Filled.Visibility else Icons.Filled.VisibilityOff,
                            contentDescription = if (newPasswordVisible) "Hide password" else "Show password",
                            tint = palette.foreground
                        )
                    }
                }
            )
            
            OutlinedTextField(
                value = confirmNewPassword,
                onValueChange = { confirmNewPassword = it },
                label = { Text("Confirm New Password", color = palette.foreground) },
                placeholder = { Text("Re-enter new password", color = palette.mutedForeground) },
                visualTransformation = if (confirmPasswordVisible) VisualTransformation.None else PasswordVisualTransformation(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                modifier = Modifier.fillMaxWidth(),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = palette.foreground,
                    unfocusedTextColor = palette.foreground,
                    focusedLabelColor = palette.foreground,
                    unfocusedLabelColor = palette.mutedForeground,
                    focusedContainerColor = palette.input,
                    unfocusedContainerColor = palette.input,
                    focusedBorderColor = palette.primary,
                    unfocusedBorderColor = palette.border
                ),
                trailingIcon = {
                    IconButton(onClick = { confirmPasswordVisible = !confirmPasswordVisible }) {
                        Icon(
                            imageVector = if (confirmPasswordVisible) Icons.Filled.Visibility else Icons.Filled.VisibilityOff,
                            contentDescription = if (confirmPasswordVisible) "Hide password" else "Show password",
                            tint = palette.foreground
                        )
                    }
                }
            )
            
            if (state.errorMessage != null) {
                Text(
                    text = state.errorMessage!!,
                    color = palette.destructive,
                    style = MaterialTheme.typography.bodyMedium
                )
            }
            
            if (state.successMessage != null) {
                Text(
                    text = state.successMessage!!,
                    color = palette.success,
                    style = MaterialTheme.typography.bodyMedium
                )
            }
            
            Spacer(modifier = Modifier.height(16.dp))
            
            Button(
                onClick = {
                    viewModel.changeMasterPassword(oldPassword, newPassword, confirmNewPassword)
                },
                enabled = oldPassword.isNotBlank() && newPassword.isNotBlank() && confirmNewPassword.isNotBlank(),
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(
                    containerColor = palette.primary,
                    contentColor = palette.onPrimary
                ),
                shape = RoundedCornerShape(12.dp)
            ) {
                Text(
                    text = "Change Master Password",
                    style = MaterialTheme.typography.bodyLarge.copy(
                        fontWeight = FontWeight.SemiBold
                    ),
                    modifier = Modifier.padding(vertical = 8.dp)
                )
            }
        }
    }
}

/**
 * Add/Edit Password Entry Screen.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddEditPasswordEntryScreen(
    entry: PasswordEntry? = null, // null = add, non-null = edit
    viewModel: PasswordManagerViewModel = viewModel(),
    onGeneratePassword: (() -> String)? = null, // Callback to generate password
    onBack: () -> Unit,
    isPremium: Boolean = false,
    onPremiumPurchase: () -> Unit = { /* Premium upgrade */ }
) {
    val palette = LocalCiphioColors.current
    val state by viewModel.uiState.collectAsState()
    
    var service by remember { mutableStateOf(entry?.service ?: "") }
    var username by remember { mutableStateOf(entry?.username ?: "") }
    var password by remember { mutableStateOf(entry?.password ?: "") }
    var notes by remember { mutableStateOf(entry?.notes ?: "") }
    var categories by remember { mutableStateOf(entry?.getAllCategories() ?: emptyList()) }
    var categoryInput by remember { mutableStateOf("") }
    var passwordVisible by remember { mutableStateOf(false) }
    var categoryExpanded by remember { mutableStateOf(false) }
    
    // Filter available categories based on what user types
    val categorySuggestions = remember(categoryInput, state.availableCategories, categories) {
        state.availableCategories
            .filter { it !in categories } // Don't show already selected categories
            .filter { if (categoryInput.isBlank()) true else it.contains(categoryInput, ignoreCase = true) }
    }
    
    // Load entries to get available categories for autocomplete
    LaunchedEffect(Unit) {
        viewModel.reloadEntries()
    }
    
    // Update fields when entry changes
    LaunchedEffect(entry) {
        service = entry?.service ?: ""
        username = entry?.username ?: ""
        password = entry?.password ?: ""
        notes = entry?.notes ?: ""
        categories = entry?.getAllCategories() ?: emptyList()
    }
    
    LaunchedEffect(state.successMessage) {
        if (state.successMessage != null) {
            // Wait a bit longer to ensure the data is saved before navigating back
            kotlinx.coroutines.delay(300)
            onBack()
        }
    }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { 
                    Text(
                        if (entry == null) "Add Password" else "Edit Password",
                        color = palette.foreground,
                        fontWeight = FontWeight.SemiBold
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back",
                            tint = palette.foreground
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = palette.card,
                    titleContentColor = palette.foreground,
                    navigationIconContentColor = palette.foreground
                )
            )
        },
        containerColor = palette.background
    ) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            OutlinedTextField(
                value = service,
                onValueChange = { service = it },
                label = { Text("Service/Website", color = palette.foreground) },
                placeholder = { Text("e.g., example.com", color = palette.mutedForeground) },
                modifier = Modifier.fillMaxWidth(),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = palette.foreground,
                    unfocusedTextColor = palette.foreground,
                    focusedLabelColor = palette.foreground,
                    unfocusedLabelColor = palette.mutedForeground,
                    focusedContainerColor = palette.input,
                    unfocusedContainerColor = palette.input,
                    focusedBorderColor = palette.primary,
                    unfocusedBorderColor = palette.border
                )
            )
            
            OutlinedTextField(
                value = username,
                onValueChange = { username = it },
                label = { Text("Username/Email", color = palette.foreground) },
                placeholder = { Text("Enter username", color = palette.mutedForeground) },
                modifier = Modifier.fillMaxWidth(),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = palette.foreground,
                    unfocusedTextColor = palette.foreground,
                    focusedLabelColor = palette.foreground,
                    unfocusedLabelColor = palette.mutedForeground,
                    focusedContainerColor = palette.input,
                    unfocusedContainerColor = palette.input,
                    focusedBorderColor = palette.primary,
                    unfocusedBorderColor = palette.border
                )
            )
            
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                OutlinedTextField(
                    value = password,
                    onValueChange = { password = it },
                    label = { Text("Password", color = palette.foreground) },
                    placeholder = { Text("Enter password", color = palette.mutedForeground) },
                    visualTransformation = if (passwordVisible) VisualTransformation.None else PasswordVisualTransformation(),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                    modifier = Modifier.weight(1f),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedTextColor = palette.foreground,
                        unfocusedTextColor = palette.foreground,
                        focusedLabelColor = palette.foreground,
                        unfocusedLabelColor = palette.mutedForeground,
                        focusedContainerColor = palette.input,
                        unfocusedContainerColor = palette.input,
                        focusedBorderColor = palette.primary,
                        unfocusedBorderColor = palette.border
                    ),
                    trailingIcon = {
                        IconButton(onClick = { passwordVisible = !passwordVisible }) {
                            Icon(
                                imageVector = if (passwordVisible) Icons.Filled.VisibilityOff else Icons.Filled.Visibility,
                                contentDescription = if (passwordVisible) "Hide" else "Show",
                                tint = palette.foreground
                            )
                        }
                    }
                )
                
                if (onGeneratePassword != null) {
                    Button(
                        onClick = { password = onGeneratePassword() },
                        colors = ButtonDefaults.buttonColors(
                            containerColor = palette.secondary,
                            contentColor = palette.onSecondary
                        ),
                        shape = RoundedCornerShape(8.dp)
                    ) {
                        Text("Generate", style = MaterialTheme.typography.bodySmall)
                    }
                }
            }
            
            // Categories section with chips
            Column(
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Text(
                    text = "Categories (optional)",
                    style = MaterialTheme.typography.labelMedium,
                    color = palette.foreground
                )
                
                // Display selected categories as chips
                if (categories.isNotEmpty()) {
                    LazyRow(
                        horizontalArrangement = Arrangement.spacedBy(8.dp),
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        items(categories) { cat ->
                            InputChip(
                                selected = true,
                                onClick = {
                                    categories = categories.filter { it != cat }
                                },
                                label = { Text(cat, style = MaterialTheme.typography.bodySmall) },
                                trailingIcon = {
                                    Icon(
                                        imageVector = Icons.Filled.Delete,
                                        contentDescription = "Remove",
                                        modifier = Modifier.size(16.dp)
                                    )
                                },
                                colors = InputChipDefaults.inputChipColors(
                                    selectedContainerColor = palette.primary,
                                    selectedLabelColor = palette.onPrimary,
                                    selectedTrailingIconColor = palette.onPrimary
                                )
                            )
                        }
                    }
                }
                
                // Category input with autocomplete dropdown
                ExposedDropdownMenuBox(
                    expanded = categoryExpanded && categorySuggestions.isNotEmpty(),
                    onExpandedChange = { categoryExpanded = it }
                ) {
                    OutlinedTextField(
                        value = categoryInput,
                        onValueChange = { 
                            categoryInput = it
                            categoryExpanded = true
                        },
                        label = { Text("Add category", color = palette.foreground) },
                        placeholder = { Text("Type or select a category", color = palette.mutedForeground) },
                        modifier = Modifier
                            .fillMaxWidth()
                            .menuAnchor(),
                        trailingIcon = { 
                            if (categorySuggestions.isNotEmpty()) {
                                ExposedDropdownMenuDefaults.TrailingIcon(expanded = categoryExpanded)
                            }
                        },
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedTextColor = palette.foreground,
                            unfocusedTextColor = palette.foreground,
                            focusedLabelColor = palette.foreground,
                            unfocusedLabelColor = palette.mutedForeground,
                            focusedContainerColor = palette.input,
                            unfocusedContainerColor = palette.input,
                            focusedBorderColor = palette.primary,
                            unfocusedBorderColor = palette.border
                        ),
                        keyboardOptions = KeyboardOptions(
                            imeAction = androidx.compose.ui.text.input.ImeAction.Done
                        ),
                        keyboardActions = androidx.compose.foundation.text.KeyboardActions(
                            onDone = {
                                if (categoryInput.isNotBlank() && categoryInput !in categories) {
                                    categories = categories + categoryInput.trim()
                                    categoryInput = ""
                                }
                            }
                        )
                    )
                    if (categorySuggestions.isNotEmpty()) {
                        DropdownMenu(
                            expanded = categoryExpanded,
                            onDismissRequest = { categoryExpanded = false },
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            categorySuggestions.forEach { suggestion ->
                                DropdownMenuItem(
                                    text = { Text(suggestion, color = palette.foreground) },
                                    onClick = {
                                        if (suggestion !in categories) {
                                            categories = categories + suggestion
                                        }
                                        categoryInput = ""
                                        categoryExpanded = false
                                    }
                                )
                            }
                        }
                    }
                }
            }
            
            OutlinedTextField(
                value = notes,
                onValueChange = { notes = it },
                label = { Text("Notes (optional)", color = palette.foreground) },
                placeholder = { Text("Add notes...", color = palette.mutedForeground) },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(100.dp),
                minLines = 3,
                maxLines = 5,
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = palette.foreground,
                    unfocusedTextColor = palette.foreground,
                    focusedLabelColor = palette.foreground,
                    unfocusedLabelColor = palette.mutedForeground,
                    focusedContainerColor = palette.input,
                    unfocusedContainerColor = palette.input,
                    focusedBorderColor = palette.primary,
                    unfocusedBorderColor = palette.border
                )
            )
            
            if (state.errorMessage != null) {
                Column(
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Text(
                        text = state.errorMessage!!,
                        color = palette.destructive,
                        style = MaterialTheme.typography.bodyMedium
                    )
                    // Show upgrade button if error is about free tier limit
                    if (state.errorMessage!!.contains("Free tier limit", ignoreCase = true)) {
                        Button(
                            onClick = onPremiumPurchase,
                            modifier = Modifier.fillMaxWidth(),
                            colors = ButtonDefaults.buttonColors(
                                containerColor = palette.primary,
                                contentColor = palette.onPrimary
                            )
                        ) {
                            Text("Upgrade to Premium")
                        }
                    }
                }
            }
            
            
            Spacer(modifier = Modifier.height(16.dp))
            
            Button(
                onClick = {
                    android.util.Log.d("PasswordManager", "Save button clicked: service=$service, username=$username, password=${password.take(3)}...")
                    if (service.isBlank() || username.isBlank() || password.isBlank()) {
                        android.util.Log.w("PasswordManager", "Save button: validation failed - service blank=${service.isBlank()}, username blank=${username.isBlank()}, password blank=${password.isBlank()}")
                        return@Button
                    }
                    val newEntry = if (entry == null) {
                    PasswordEntry(
                        service = service,
                        username = username,
                        password = password,
                        notes = notes,
                        categories = categories.filter { it.isNotBlank() }.distinct()
                    )
                } else {
                    entry.copy(
                        service = service,
                        username = username,
                        password = password,
                        notes = notes,
                        categories = categories.filter { it.isNotBlank() }.distinct()
                    )
                }
                    android.util.Log.d("PasswordManager", "Created entry: id=${newEntry.id}, service=${newEntry.service}")
                    if (entry == null) {
                        android.util.Log.d("PasswordManager", "Calling viewModel.addEntry...")
                        viewModel.addEntry(newEntry)
                    } else {
                        android.util.Log.d("PasswordManager", "Calling viewModel.updateEntry...")
                        viewModel.updateEntry(newEntry)
                    }
                },
                enabled = service.isNotBlank() && username.isNotBlank() && password.isNotBlank(),
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(
                    containerColor = palette.primary,
                    contentColor = palette.onPrimary
                ),
                shape = RoundedCornerShape(12.dp)
            ) {
                Text(
                    text = if (entry == null) "Add Password" else "Save Changes",
                    style = MaterialTheme.typography.bodyLarge.copy(
                        fontWeight = FontWeight.SemiBold
                    ),
                    modifier = Modifier.padding(vertical = 8.dp)
                )
            }
        }
    }
}

