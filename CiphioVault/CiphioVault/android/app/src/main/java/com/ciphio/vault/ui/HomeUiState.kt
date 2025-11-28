package com.ciphio.vault.ui

import com.ciphio.vault.crypto.AesMode
import com.ciphio.vault.data.HistoryEntry
import com.ciphio.vault.data.ThemeOption

data class EncryptionUiState(
    val inputText: String = "",
    val secretKey: String = "",
    val algorithm: AesMode = AesMode.AES_GCM,
    val outputText: String = "",
    val saveEnabled: Boolean = false,
    val isProcessing: Boolean = false,
    val errorMessage: String? = null,
    val successMessage: String? = null,
    val lastOperation: com.ciphio.vault.data.OperationType? = null
)

data class PasswordGeneratorUiState(
    val length: Int = 16,
    val includeUppercase: Boolean = true,
    val includeLowercase: Boolean = true,
    val includeDigits: Boolean = true,
    val includeSymbols: Boolean = true,
    val generatedPassword: String = "",
    val entropyBits: Double = 0.0,
    val strengthLabel: String = ""
)

data class HomeUiState(
    val encryption: EncryptionUiState = EncryptionUiState(),
    val passwordGenerator: PasswordGeneratorUiState = PasswordGeneratorUiState(),
    val history: List<HistoryEntry> = emptyList(),
    val themeOption: ThemeOption = ThemeOption.SYSTEM,
    val toastMessage: String? = null,
    val isPremium: Boolean = false
)

