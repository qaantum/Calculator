package com.ciphio.vault.ui

import android.content.Intent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import com.ciphio.vault.crypto.AesMode
import com.ciphio.vault.ui.theme.LocalCiphioColors
import kotlinx.coroutines.launch
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.foundation.BorderStroke
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.ChevronRight
import androidx.compose.material.icons.filled.ContentCopy
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.History
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.Share
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.filled.Visibility
import androidx.compose.material.icons.filled.VisibilityOff
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuDefaults
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ListItem
import androidx.compose.material3.ListItemDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.RadioButton
import androidx.compose.material3.RadioButtonDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Slider
import androidx.compose.material3.SliderDefaults
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Surface
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
import androidx.compose.material3.Tab
import androidx.compose.material3.TabRow
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.foundation.clickable
import com.ciphio.vault.data.ThemeOption
import com.ciphio.vault.data.HistoryEntry
import com.ciphio.vault.data.OperationType
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import com.ciphio.vault.ui.theme.CiphioColors

private enum class HomeTab(val title: String) {
    Encrypt("Text Encryption"),
    Password("Password Generator")
}

@Composable
fun HomeRoute(
    viewModel: HomeViewModel,
    isPremium: Boolean,
    onOpenSettings: () -> Unit, 
    onOpenHistory: () -> Unit,
    onOpenPasswordManager: (() -> Unit)? = null // Optional - modular feature
) {
    val snackbarHostState = remember { SnackbarHostState() }
    val clipboard = LocalClipboardManager.current
    val scope = rememberCoroutineScope()
    val uiState by viewModel.uiState.collectAsState()
    val palette = LocalCiphioColors.current

    LaunchedEffect(uiState.toastMessage) {
        uiState.toastMessage?.let { message ->
            scope.launch { snackbarHostState.showSnackbar(message) }
            viewModel.consumeToast()
        }
    }

    val context = LocalContext.current
    
    Box(modifier = Modifier.fillMaxSize().background(palette.background)) {
        HomeScreen(
            state = uiState,
            snackbarHostState = snackbarHostState,
            isPremium = isPremium,
            onOpenSettings = onOpenSettings,
            onShowHistory = onOpenHistory,
            onOpenPasswordManager = onOpenPasswordManager,
            onInputChange = viewModel::updateInputText,
            onSecretKeyChange = viewModel::updateSecretKey,
            onAlgorithmChange = viewModel::updateAlgorithm,
            onEncrypt = viewModel::encrypt,
            onDecrypt = viewModel::decrypt,
            onSaveToggleChange = viewModel::updateSaveToggle,
            onCopyOutput = { text ->
                clipboard.setText(AnnotatedString(text))
                scope.launch { snackbarHostState.showSnackbar("Copied") }
            },
            onShareOutput = { text ->
                val shareIntent = Intent(Intent.ACTION_SEND).apply {
                    type = "text/plain"
                    putExtra(Intent.EXTRA_TEXT, text)
                }
                context.startActivity(Intent.createChooser(shareIntent, "Share encrypted text"))
            },
            onPasteInput = {
                clipboard.getText()?.let { annotatedString ->
                    val text = annotatedString.text
                    if (text.isNotEmpty()) {
                        viewModel.updateInputText(text)
                        scope.launch { snackbarHostState.showSnackbar("Pasted") }
                    }
                }
            },
            onPasswordLengthChange = viewModel::updatePasswordLength,
            onToggleUppercase = { viewModel.updatePasswordToggles(uppercase = it) },
            onToggleLowercase = { viewModel.updatePasswordToggles(lowercase = it) },
            onToggleDigits = { viewModel.updatePasswordToggles(digits = it) },
            onToggleSymbols = { viewModel.updatePasswordToggles(symbols = it) },
            onGeneratePassword = viewModel::generatePassword,
            onCopyPassword = { password ->
                clipboard.setText(AnnotatedString(password))
                scope.launch { snackbarHostState.showSnackbar("Password copied") }
            }
        )
    }
}

@Composable
private fun HomeScreen(
    state: HomeUiState,
    snackbarHostState: SnackbarHostState,
    isPremium: Boolean,
    onOpenSettings: () -> Unit,
    onShowHistory: () -> Unit,
    onOpenPasswordManager: (() -> Unit)? = null, // Optional - modular feature
    onInputChange: (String) -> Unit,
    onSecretKeyChange: (String) -> Unit,
    onAlgorithmChange: (AesMode) -> Unit,
    onEncrypt: () -> Unit,
    onDecrypt: () -> Unit,
    onSaveToggleChange: (Boolean) -> Unit,
    onCopyOutput: (String) -> Unit,
    onShareOutput: (String) -> Unit,
    onPasteInput: () -> Unit,
    onPasswordLengthChange: (Int) -> Unit,
    onToggleUppercase: (Boolean) -> Unit,
    onToggleLowercase: (Boolean) -> Unit,
    onToggleDigits: (Boolean) -> Unit,
    onToggleSymbols: (Boolean) -> Unit,
    onGeneratePassword: () -> Unit,
    onCopyPassword: (String) -> Unit
) {
    val palette = LocalCiphioColors.current
    var selectedTab by remember { mutableStateOf(HomeTab.Encrypt) }

    Scaffold(
        containerColor = palette.background,
        topBar = {
            CenterAlignedTopAppBar(
                title = { 
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.Center
                    ) {
                        Text(
                            text = "Ciphio",
                            color = palette.foreground,
                            fontWeight = FontWeight.SemiBold
                        )
                        if (isPremium) {
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                text = "Premium",
                                fontSize = 12.sp,
                                color = palette.primary,
                                fontWeight = FontWeight.Bold,
                                modifier = Modifier
                                    .background(palette.primary.copy(alpha = 0.1f), RoundedCornerShape(4.dp))
                                    .padding(horizontal = 6.dp, vertical = 2.dp)
                            )
                        }
                    }
                },
                actions = {
                    IconButton(onClick = onOpenSettings) {
                        Icon(
                            imageVector = Icons.Filled.Settings,
                            tint = palette.foreground,
                            contentDescription = "Settings"
                        )
                    }
                },
                navigationIcon = {
                    IconButton(onClick = onShowHistory) {
                        Icon(
                            imageVector = Icons.Filled.History,
                            tint = palette.foreground,
                            contentDescription = "History"
                        )
                    }
                },
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
                    containerColor = palette.card,
                    navigationIconContentColor = palette.foreground,
                    titleContentColor = palette.foreground,
                    actionIconContentColor = palette.foreground
                )
            )
        },
        snackbarHost = { SnackbarHost(hostState = snackbarHostState) }
    ) { paddingValues ->
        val scrollState = rememberScrollState()
        Column(
            modifier = Modifier
                .padding(paddingValues)
                .fillMaxSize()
                .imePadding()
                .verticalScroll(scrollState)
                .padding(horizontal = 12.dp)
        ) {
            TabRow(
                selectedTabIndex = selectedTab.ordinal,
                containerColor = palette.muted,
                contentColor = palette.mutedForeground,
                indicator = {}
            ) {
                HomeTab.values().forEach { tab ->
                    val isSelected = selectedTab == tab
                    Tab(
                        selected = isSelected,
                        onClick = { selectedTab = tab }
                    ) {
                        Text(
                            text = tab.title,
                            color = if (isSelected) palette.foreground else palette.mutedForeground,
                            modifier = Modifier
                                .padding(vertical = 10.dp, horizontal = 12.dp)
                                .background(
                                    color = if (isSelected) palette.card else Color.Transparent,
                                    shape = RoundedCornerShape(12.dp)
                                )
                                .padding(horizontal = 10.dp, vertical = 6.dp)
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(12.dp))
            
            // Password Manager Quick Access Card (if available)
            onOpenPasswordManager?.let { onOpenPM ->
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clickable(onClick = onOpenPM),
                    colors = CardDefaults.cardColors(containerColor = palette.card),
                    elevation = CardDefaults.cardElevation(defaultElevation = 2.dp),
                    border = BorderStroke(1.dp, palette.border),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Row(
                            horizontalArrangement = Arrangement.spacedBy(12.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(
                                imageVector = Icons.Filled.Visibility,
                                contentDescription = null,
                                tint = palette.primary,
                                modifier = Modifier.size(32.dp)
                            )
                            Column {
                                Text(
                                    text = "Password Manager",
                                    style = MaterialTheme.typography.titleMedium.copy(
                                        fontWeight = FontWeight.SemiBold
                                    ),
                                    color = palette.foreground
                                )
                                Text(
                                    text = "Securely store your passwords",
                                    style = MaterialTheme.typography.bodySmall,
                                    color = palette.mutedForeground
                                )
                            }
                        }
                        Icon(
                            imageVector = Icons.Filled.ChevronRight,
                            contentDescription = null,
                            tint = palette.mutedForeground
                        )
                    }
                }
                Spacer(modifier = Modifier.height(12.dp))
            }

            when (selectedTab) {
                HomeTab.Encrypt -> EncryptionCard(
                    state = state.encryption,
                    onInputChange = onInputChange,
                    onSecretKeyChange = onSecretKeyChange,
                    onAlgorithmChange = onAlgorithmChange,
                    onEncrypt = onEncrypt,
                    onDecrypt = onDecrypt,
                    onSaveToggleChange = onSaveToggleChange,
                    onCopyOutput = onCopyOutput,
                    onShareOutput = onShareOutput,
                    onPasteInput = onPasteInput
                )

                HomeTab.Password -> PasswordGeneratorCard(
                    state = state.passwordGenerator,
                    onLengthChange = onPasswordLengthChange,
                    onToggleUppercase = onToggleUppercase,
                    onToggleLowercase = onToggleLowercase,
                    onToggleDigits = onToggleDigits,
                    onToggleSymbols = onToggleSymbols,
                    onGenerate = onGeneratePassword,
                    onCopyPassword = onCopyPassword
                )
            }
            
            // Add bottom padding to ensure content is accessible above keyboard
            Spacer(modifier = Modifier.height(16.dp))
        }
    }
}

@Composable
private fun EncryptionCard(
    state: EncryptionUiState,
    onInputChange: (String) -> Unit,
    onSecretKeyChange: (String) -> Unit,
    onAlgorithmChange: (AesMode) -> Unit,
    onEncrypt: () -> Unit,
    onDecrypt: () -> Unit,
    onSaveToggleChange: (Boolean) -> Unit,
    onCopyOutput: (String) -> Unit,
    onShareOutput: (String) -> Unit,
    onPasteInput: () -> Unit
) {
    val palette = LocalCiphioColors.current
    var keyVisible by remember { mutableStateOf(false) }
    var expanded by remember { mutableStateOf(false) }
    val textFieldColors = OutlinedTextFieldDefaults.colors(
        focusedContainerColor = palette.input,
        unfocusedContainerColor = palette.input,
        focusedBorderColor = palette.primary,
        unfocusedBorderColor = palette.border,
        cursorColor = palette.primary,
        focusedLabelColor = palette.primary,
        unfocusedTextColor = palette.foreground,
        focusedTextColor = palette.foreground
    )

    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = palette.card),
        elevation = CardDefaults.cardElevation(defaultElevation = 8.dp),
        shape = RoundedCornerShape(18.dp),
        border = BorderStroke(1.dp, palette.border)
    ) {
        Column(
            modifier = Modifier.padding(14.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(
                    text = "Text Encryptor",
                    style = MaterialTheme.typography.titleMedium.copy(
                        fontWeight = FontWeight.SemiBold,
                        fontSize = 18.sp
                    ),
                    color = palette.foreground
                )
                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text(
                        text = "Save",
                        style = MaterialTheme.typography.bodyMedium.copy(
                            fontWeight = FontWeight.Medium
                        ),
                        color = palette.mutedForeground
                    )
                    Switch(
                        checked = state.saveEnabled,
                        onCheckedChange = onSaveToggleChange,
                        colors = SwitchDefaults.colors(
                            checkedTrackColor = palette.primary,
                            checkedThumbColor = palette.onPrimary,
                            uncheckedThumbColor = palette.card,
                            uncheckedTrackColor = palette.border
                        )
                    )
                }
            }

            OutlinedTextField(
                value = state.inputText,
                onValueChange = onInputChange,
                minLines = 3,
                maxLines = 4,
                modifier = Modifier.fillMaxWidth(),
                label = { Text("Input Text", color = palette.mutedForeground) },
                colors = textFieldColors
            )
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                if (state.inputText.isNotEmpty()) {
                    TextButton(onClick = { onInputChange("") }) {
                        Icon(imageVector = Icons.Filled.Delete, contentDescription = "Clear", tint = palette.foreground)
                        Spacer(modifier = Modifier.width(4.dp))
                        Text("Clear", color = palette.foreground)
                    }
                }
                Spacer(modifier = Modifier.weight(1f))
                TextButton(onClick = onPasteInput) {
                    Icon(imageVector = Icons.Filled.ContentCopy, contentDescription = "Paste", tint = palette.foreground)
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("Paste", color = palette.foreground)
                }
            }

            OutlinedTextField(
                value = state.secretKey,
                onValueChange = onSecretKeyChange,
                modifier = Modifier.fillMaxWidth(),
                label = { Text("Secret Key", color = palette.mutedForeground) },
                visualTransformation = if (keyVisible) VisualTransformation.None else PasswordVisualTransformation(),
                trailingIcon = {
                    IconButton(onClick = { keyVisible = !keyVisible }) {
                        Icon(
                            imageVector = if (keyVisible) Icons.Filled.Visibility else Icons.Filled.VisibilityOff,
                            contentDescription = if (keyVisible) "Hide key" else "Show key",
                            tint = palette.mutedForeground
                        )
                    }
                },
                colors = textFieldColors
            )

            ExposedDropdownMenuBox(expanded = expanded, onExpandedChange = { expanded = !expanded }) {
                OutlinedTextField(
                    value = state.algorithm.displayName,
                    onValueChange = {},
                    readOnly = true,
                    label = { Text("Algorithm", color = palette.mutedForeground) },
                    trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded) },
                    modifier = Modifier
                        .fillMaxWidth()
                        .menuAnchor(),
                    colors = textFieldColors
                )
                DropdownMenu(expanded = expanded, onDismissRequest = { expanded = false }) {
                    AesMode.values().forEach { mode ->
                        DropdownMenuItem(
                            text = { Text(mode.displayName) },
                            onClick = {
                                onAlgorithmChange(mode)
                                expanded = false
                            }
                        )
                    }
                }
            }

            Row(horizontalArrangement = Arrangement.spacedBy(12.dp), modifier = Modifier.fillMaxWidth()) {
                // Each button shows its own state: green if it was last pressed, gray otherwise
                val isEncryptActive = state.lastOperation == com.ciphio.vault.data.OperationType.ENCRYPT || state.lastOperation == null
                val isDecryptActive = state.lastOperation == com.ciphio.vault.data.OperationType.DECRYPT
                
                val encryptColor = if (isEncryptActive) palette.primary else palette.secondary
                val encryptContentColor = if (isEncryptActive) palette.onPrimary else palette.onSecondary
                val decryptColor = if (isDecryptActive) palette.primary else palette.secondary
                val decryptContentColor = if (isDecryptActive) palette.onPrimary else palette.onSecondary
                
                Button(
                    onClick = onEncrypt,
                    enabled = !state.isProcessing,
                    modifier = Modifier.weight(1f),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = encryptColor,
                        contentColor = encryptContentColor,
                        disabledContainerColor = encryptColor.copy(alpha = 0.4f),
                        disabledContentColor = encryptContentColor.copy(alpha = 0.6f)
                    ),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Text(
                        text = "Encrypt",
                        style = MaterialTheme.typography.bodyLarge.copy(
                            fontWeight = FontWeight.SemiBold
                        )
                    )
                }
                Button(
                    onClick = onDecrypt,
                    enabled = !state.isProcessing,
                    modifier = Modifier.weight(1f),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = decryptColor,
                        contentColor = decryptContentColor,
                        disabledContainerColor = decryptColor.copy(alpha = 0.5f)
                    ),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Text(
                        text = "Decrypt",
                        style = MaterialTheme.typography.bodyLarge.copy(
                            fontWeight = FontWeight.SemiBold
                        )
                    )
                }
            }

            if (state.outputText.isNotBlank()) {
                OutlinedTextField(
                    value = state.outputText,
                    onValueChange = {},
                    modifier = Modifier.fillMaxWidth(),
                    readOnly = true,
                    minLines = 3,
                    maxLines = 4,
                    label = { Text("Output", color = palette.mutedForeground) },
                    colors = textFieldColors
                )
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    TextButton(onClick = { onCopyOutput(state.outputText) }) {
                        Icon(imageVector = Icons.Filled.ContentCopy, contentDescription = null, tint = palette.foreground)
                        Spacer(modifier = Modifier.width(4.dp))
                        Text("Copy", color = palette.foreground)
                    }
                    TextButton(onClick = { onShareOutput(state.outputText) }) {
                        Icon(imageVector = Icons.Filled.Share, contentDescription = null, tint = palette.foreground)
                        Spacer(modifier = Modifier.width(4.dp))
                        Text("Share", color = palette.foreground)
                    }
                }
            }

            state.errorMessage?.let {
                Text(text = it, color = palette.destructive, style = MaterialTheme.typography.bodySmall)
            }
            state.successMessage?.let {
                Text(text = it, color = palette.success, style = MaterialTheme.typography.bodySmall)
            }
        }
    }
}

@Composable
private fun PasswordGeneratorCard(
    state: PasswordGeneratorUiState,
    onLengthChange: (Int) -> Unit,
    onToggleUppercase: (Boolean) -> Unit,
    onToggleLowercase: (Boolean) -> Unit,
    onToggleDigits: (Boolean) -> Unit,
    onToggleSymbols: (Boolean) -> Unit,
    onGenerate: () -> Unit,
    onCopyPassword: (String) -> Unit
) {
    val palette = LocalCiphioColors.current
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = palette.card),
        elevation = CardDefaults.cardElevation(defaultElevation = 8.dp),
        border = BorderStroke(1.dp, palette.border),
        shape = RoundedCornerShape(18.dp)
    ) {
        Column(
            modifier = Modifier.padding(14.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text(
                text = "Password Generator",
                style = MaterialTheme.typography.titleMedium.copy(
                    fontWeight = FontWeight.SemiBold,
                    fontSize = 18.sp
                ),
                color = palette.foreground
            )

            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "Length",
                        style = MaterialTheme.typography.bodyMedium.copy(
                            fontWeight = FontWeight.Medium
                        ),
                        color = palette.foreground
                    )
                    Text(
                        text = "${state.length}",
                        style = MaterialTheme.typography.bodyLarge.copy(
                            fontWeight = FontWeight.SemiBold
                        ),
                        color = palette.primary
                    )
                }
                Slider(
                    value = state.length.toFloat(),
                    onValueChange = { onLengthChange(it.toInt()) },
                    valueRange = 6f..64f,
                    colors = SliderDefaults.colors(
                        activeTrackColor = palette.primary,
                        inactiveTrackColor = palette.border,
                        thumbColor = palette.primary,
                        activeTickColor = palette.primary,
                        inactiveTickColor = palette.border
                    )
                )
            }

            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                ToggleRow("Uppercase (A-Z)", state.includeUppercase, onToggleUppercase)
                ToggleRow("Lowercase (a-z)", state.includeLowercase, onToggleLowercase)
                ToggleRow("Numbers (0-9)", state.includeDigits, onToggleDigits)
                ToggleRow("Symbols (!@#)", state.includeSymbols, onToggleSymbols)
            }

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Strength",
                    style = MaterialTheme.typography.bodyMedium.copy(
                        fontWeight = FontWeight.Medium
                    ),
                    color = palette.foreground
                )
                Text(
                    text = "${state.strengthLabel} (${state.entropyBits.toInt()} bits)",
                    style = MaterialTheme.typography.bodyMedium.copy(
                        fontWeight = FontWeight.SemiBold
                    ),
                    color = strengthColor(state.strengthLabel, palette)
                )
            }

            Button(
                onClick = onGenerate,
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(
                    containerColor = palette.primary,
                    contentColor = palette.onPrimary
                ),
                shape = RoundedCornerShape(12.dp)
            ) {
                Text(
                    text = "Generate New Password",
                    style = MaterialTheme.typography.bodyLarge.copy(
                        fontWeight = FontWeight.SemiBold
                    )
                )
            }

            if (state.generatedPassword.isNotEmpty()) {
                OutlinedTextField(
                    value = state.generatedPassword,
                    onValueChange = {},
                    readOnly = true,
                    modifier = Modifier.fillMaxWidth(),
                    label = { Text("Generated Password", color = palette.mutedForeground) },
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedContainerColor = palette.input,
                        unfocusedContainerColor = palette.input,
                        unfocusedBorderColor = palette.border,
                        focusedBorderColor = palette.primary,
                        unfocusedTextColor = palette.foreground,
                        focusedTextColor = palette.foreground
                    )
                )
                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.End) {
                    TextButton(onClick = { onCopyPassword(state.generatedPassword) }) {
                        Icon(imageVector = Icons.Filled.ContentCopy, contentDescription = null, tint = palette.foreground)
                        Spacer(modifier = Modifier.width(4.dp))
                        Text("Copy", color = palette.foreground)
                    }
                }
            }
        }
    }
}

@Composable
private fun ToggleRow(label: String, checked: Boolean, onToggle: (Boolean) -> Unit) {
    val palette = LocalCiphioColors.current
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = label,
            style = MaterialTheme.typography.bodyMedium,
            color = palette.foreground
        )
        Switch(
            checked = checked,
            onCheckedChange = onToggle,
            colors = SwitchDefaults.colors(
                checkedTrackColor = palette.primary,
                checkedThumbColor = palette.onPrimary,
                uncheckedThumbColor = palette.card,
                uncheckedTrackColor = palette.border
            )
        )
    }
}

@Composable
fun HistoryScreen(
    entries: List<HistoryEntry>,
    onBack: () -> Unit,
    onClear: () -> Unit,
    onDelete: (String) -> Unit,
    onUse: (HistoryEntry) -> Unit
) {
    val palette = LocalCiphioColors.current
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("History", color = palette.foreground) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(imageVector = Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back", tint = palette.foreground)
                    }
                },
                actions = {
                    if (entries.isNotEmpty()) {
                        TextButton(onClick = onClear) { Text("Clear All", color = palette.destructive) }
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
        if (entries.isEmpty()) {
            Box(modifier = Modifier.padding(padding).fillMaxSize(), contentAlignment = Alignment.Center) {
                Text("No saved entries yet.", style = MaterialTheme.typography.bodyMedium, color = palette.mutedForeground)
            }
        } else {
            LazyColumn(
                modifier = Modifier
                    .padding(padding)
                    .fillMaxSize(),
                verticalArrangement = Arrangement.spacedBy(12.dp),
                contentPadding = PaddingValues(16.dp)
            ) {
                items(entries, key = { it.id }) { entry ->
                    HistoryListItem(entry = entry, onDelete = onDelete, onUse = onUse)
                }
            }
        }
    }
}

@Composable
private fun HistoryListItem(entry: HistoryEntry, onDelete: (String) -> Unit, onUse: (HistoryEntry) -> Unit) {
    val palette = LocalCiphioColors.current
    Card(
        colors = CardDefaults.cardColors(containerColor = palette.card),
        elevation = CardDefaults.cardElevation(defaultElevation = 6.dp),
        border = BorderStroke(1.dp, palette.border),
        shape = RoundedCornerShape(16.dp)
    ) {
        Column(modifier = Modifier.padding(18.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            Text("${entry.action.displayName()} • ${entry.algorithm}", style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.SemiBold, color = palette.foreground)
            Text("Input: ${entry.input.truncate()}", style = MaterialTheme.typography.bodySmall, color = palette.mutedForeground)
            Text("Output: ${entry.output.truncate()}", style = MaterialTheme.typography.bodySmall, color = palette.mutedForeground)
            Text("Key hint: ${entry.keyHint}", style = MaterialTheme.typography.bodySmall, color = palette.mutedForeground)
            Text(formatTimestamp(entry.timestamp), style = MaterialTheme.typography.labelSmall, color = palette.mutedForeground)
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                Button(
                    onClick = { onUse(entry) },
                    modifier = Modifier.weight(1f),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = palette.primary,
                        contentColor = palette.onPrimary
                    ),
                    shape = RoundedCornerShape(10.dp)
                ) {
                    Text(
                        "Use This Entry",
                        style = MaterialTheme.typography.bodyMedium.copy(
                            fontWeight = FontWeight.SemiBold
                        )
                    )
                }
                Button(
                    onClick = { onDelete(entry.id) },
                    modifier = Modifier.weight(1f),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = palette.destructive.copy(alpha = 0.1f),
                        contentColor = palette.destructive
                    ),
                    shape = RoundedCornerShape(10.dp)
                ) {
                    Icon(
                        imageVector = Icons.Filled.Delete,
                        contentDescription = null,
                        modifier = Modifier.width(16.dp)
                    )
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(
                        "Delete",
                        style = MaterialTheme.typography.bodyMedium.copy(
                            fontWeight = FontWeight.SemiBold
                        )
                    )
                }
            }
        }
    }
}

@Composable
private fun ThemeOptionRow(option: ThemeOption, selected: Boolean, onSelect: () -> Unit) {
    val palette = LocalCiphioColors.current
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onSelect),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        RadioButton(
            selected = selected,
            onClick = onSelect,
            colors = RadioButtonDefaults.colors(
                selectedColor = palette.primary,
                unselectedColor = palette.border
            )
        )
        Column {
            Text(option.label(), style = MaterialTheme.typography.bodyLarge, color = palette.foreground)
            Text(option.description(), style = MaterialTheme.typography.bodySmall, color = palette.mutedForeground)
        }
    }
}

@Composable
fun InfoScreen(title: String, content: List<String>, onBack: () -> Unit) {
    val scrollState = rememberScrollState()
    val palette = LocalCiphioColors.current
    Scaffold(
        containerColor = palette.background,
        topBar = {
            TopAppBar(
                title = { Text(title, color = palette.foreground) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(imageVector = Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back", tint = palette.foreground)
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = palette.card,
                    titleContentColor = palette.foreground,
                    navigationIconContentColor = palette.foreground
                )
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .verticalScroll(scrollState)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            content.forEach { paragraph ->
                Text(paragraph, style = MaterialTheme.typography.bodyMedium, color = palette.foreground)
            }
        }
    }
}

private fun ThemeOption.label(): String = when (this) {
    ThemeOption.LIGHT -> "Light"
    ThemeOption.DARK -> "Dark"
    ThemeOption.SYSTEM -> "System"
}

private fun ThemeOption.description(): String = when (this) {
    ThemeOption.LIGHT -> "Use a bright theme optimized for well-lit environments."
    ThemeOption.DARK -> "Reduce eye strain with a dimmed, OLED-friendly palette."
    ThemeOption.SYSTEM -> "Match your device's current appearance setting."
}

private fun strengthColor(label: String, palette: CiphioColors): Color = when (label.lowercase()) {
    "weak" -> palette.destructive
    "moderate" -> palette.warning
    "strong" -> palette.info
    "very strong" -> palette.success
    else -> palette.mutedForeground
}

private fun OperationType.displayName(): String = when (this) {
    OperationType.ENCRYPT -> "Encrypt"
    OperationType.DECRYPT -> "Decrypt"
}

private fun String.truncate(maxLength: Int = 48): String = if (length <= maxLength) this else take(maxLength) + "…"

private fun formatTimestamp(timestamp: Long): String {
    val formatter = SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault())
    return formatter.format(Date(timestamp))
}

@Composable
fun ExpirationScreen(onUpdateClick: () -> Unit) {
    val palette = LocalCiphioColors.current
    
    Surface(
        modifier = Modifier.fillMaxSize(),
        color = palette.background
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(24.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(24.dp, Alignment.CenterVertically)
        ) {
            Icon(
                imageVector = Icons.Filled.Settings,
                contentDescription = null,
                modifier = Modifier.size(64.dp),
                tint = palette.warning
            )
            
            Text(
                text = "Beta Version Expired",
                style = MaterialTheme.typography.headlineMedium.copy(
                    fontWeight = FontWeight.Bold
                ),
                color = palette.foreground
            )
            
            Text(
                text = "This beta version has expired. Please update to the latest version from the Play Store to continue using the app.",
                style = MaterialTheme.typography.bodyLarge,
                color = palette.mutedForeground,
                textAlign = TextAlign.Center
            )
            
            Button(
                onClick = onUpdateClick,
                colors = ButtonDefaults.buttonColors(
                    containerColor = palette.primary,
                    contentColor = palette.onPrimary
                ),
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(12.dp)
            ) {
                Text(
                    text = "Update from Play Store",
                    style = MaterialTheme.typography.bodyLarge.copy(
                        fontWeight = FontWeight.SemiBold
                    ),
                    modifier = Modifier.padding(vertical = 8.dp)
                )
            }
        }
    }
}
