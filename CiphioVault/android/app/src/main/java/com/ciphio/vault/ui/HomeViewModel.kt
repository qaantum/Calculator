package com.ciphio.vault.ui

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.ciphio.vault.crypto.AesMode
import com.ciphio.vault.crypto.CryptoService
import com.ciphio.vault.data.HistoryEntry
import com.ciphio.vault.data.HistoryRepository
import com.ciphio.vault.data.OperationType
import com.ciphio.vault.data.PasswordPreferences
import com.ciphio.vault.data.ThemeOption
import com.ciphio.vault.data.UserPreferencesRepository
import com.ciphio.vault.password.PasswordConfig
import com.ciphio.vault.password.PasswordGenerator
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch

class HomeViewModel(
    private val cryptoService: CryptoService,
    private val historyRepository: HistoryRepository,
    private val passwordGenerator: PasswordGenerator,
    private val userPreferencesRepository: UserPreferencesRepository,
    private val premiumManager: com.ciphio.vault.premium.PremiumManager = com.ciphio.vault.premium.MockPremiumManager() // Inject or default
) : ViewModel() {

    private val _uiState = MutableStateFlow(HomeUiState())
    val uiState: StateFlow<HomeUiState> = _uiState.asStateFlow()

    private var historyJob: Job
    private var toggleJob: Job
    private var passwordPrefsJob: Job
    private var themeJob: Job
    private var premiumJob: Job

    init {
        toggleJob = viewModelScope.launch {
            historyRepository.saveToggle.collectLatest { enabled ->
                _uiState.value = _uiState.value.copy(
                    encryption = _uiState.value.encryption.copy(saveEnabled = enabled)
                )
            }
        }

        historyJob = viewModelScope.launch {
            historyRepository.history.collectLatest { entries ->
                _uiState.value = _uiState.value.copy(history = entries)
            }
        }

        passwordPrefsJob = viewModelScope.launch {
            userPreferencesRepository.passwordPreferences.collectLatest { prefs ->
                _uiState.value = _uiState.value.copy(
                    passwordGenerator = _uiState.value.passwordGenerator.copy(
                        length = prefs.length,
                        includeUppercase = prefs.includeUppercase,
                        includeLowercase = prefs.includeLowercase,
                        includeDigits = prefs.includeDigits,
                        includeSymbols = prefs.includeSymbols
                    )
                )
                recalculateStrength()
            }
        }

        themeJob = viewModelScope.launch {
            userPreferencesRepository.themeOption.collectLatest { option ->
                _uiState.value = _uiState.value.copy(themeOption = option)
            }
        }

        premiumJob = viewModelScope.launch {
            premiumManager.isPremium.collectLatest { isPremium ->
                _uiState.value = _uiState.value.copy(isPremium = isPremium)
            }
        }
    }

    fun updateInputText(value: String) {
        _uiState.value = _uiState.value.copy(
            encryption = _uiState.value.encryption.copy(inputText = value)
        )
    }

    fun updateSecretKey(value: String) {
        _uiState.value = _uiState.value.copy(
            encryption = _uiState.value.encryption.copy(secretKey = value)
        )
    }

    fun updateAlgorithm(mode: AesMode) {
        _uiState.value = _uiState.value.copy(
            encryption = _uiState.value.encryption.copy(algorithm = mode)
        )
    }

    fun updateSaveToggle(enabled: Boolean) {
        viewModelScope.launch { historyRepository.setSaveToggle(enabled) }
    }

    fun encrypt() {
        val state = _uiState.value.encryption
        if (state.secretKey.isBlank()) {
            showToast("Secret key required")
            return
        }
        viewModelScope.launch {
            setProcessing(true)
            // Run on Default dispatcher (background thread)
            val result = runCatching {
                kotlinx.coroutines.withContext(kotlinx.coroutines.Dispatchers.Default) {
                    cryptoService.encrypt(state.inputText, state.secretKey, state.algorithm)
                }
            }
            
            result.onSuccess { encryptionResult ->
                val output = encryptionResult.encoded
                updateEncryptionState(outputText = output, successMessage = "Encrypted", lastOperation = OperationType.ENCRYPT)
                maybePersistHistory(OperationType.ENCRYPT, state.inputText, output, state.algorithm, state.secretKey)
            }.onFailure { throwable ->
                updateEncryptionState(errorMessage = throwable.localizedMessage ?: "Encryption failed")
            }
            setProcessing(false)
        }
    }

    fun decrypt() {
        val state = _uiState.value.encryption
        if (state.secretKey.isBlank()) {
            showToast("Secret key required")
            return
        }
        viewModelScope.launch {
            setProcessing(true)
            // Run on Default dispatcher (background thread)
            val result = runCatching {
                kotlinx.coroutines.withContext(kotlinx.coroutines.Dispatchers.Default) {
                    cryptoService.decrypt(state.inputText, state.secretKey)
                }
            }
            
            result.onSuccess { (resolvedMode, plaintext) ->
                updateEncryptionState(outputText = plaintext, successMessage = "Decrypted", lastOperation = OperationType.DECRYPT)
                updateAlgorithm(resolvedMode)
                maybePersistHistory(OperationType.DECRYPT, state.inputText, plaintext, resolvedMode, state.secretKey)
            }.onFailure { throwable ->
                updateEncryptionState(errorMessage = throwable.localizedMessage ?: "Decryption failed")
            }
            setProcessing(false)
        }
    }

    private suspend fun maybePersistHistory(
        type: OperationType,
        input: String,
        output: String,
        algorithm: AesMode,
        secretKey: String
    ) {
        if (!_uiState.value.encryption.saveEnabled) return
        
        // Check premium limit
        val isPremium = premiumManager.isPremium.value
        val currentHistorySize = _uiState.value.history.size
        if (!isPremium && currentHistorySize >= 5) {
            showToast("History limit reached (5 items). Upgrade to Premium for unlimited history.")
            return
        }

        val hint = buildKeyHint(secretKey)
        val entry = HistoryEntry(
            action = type,
            algorithm = algorithm.displayName,
            input = input,
            output = output,
            timestamp = System.currentTimeMillis(),
            keyHint = hint
        )
        historyRepository.appendEntry(entry)
    }

    fun clearHistory() {
        viewModelScope.launch { historyRepository.clearHistory() }
    }

    fun deleteHistoryEntry(id: String) {
        viewModelScope.launch { historyRepository.deleteEntry(id) }
    }

    fun useHistoryEntry(entry: HistoryEntry) {
        val mode = AesMode.fromDisplayName(entry.algorithm)
        val current = _uiState.value.encryption
        _uiState.value = _uiState.value.copy(
            encryption = current.copy(
                algorithm = mode,
                inputText = entry.input,
                outputText = entry.output,
                successMessage = null,
                errorMessage = null
            )
        )
        showToast("History entry loaded")
    }

    fun updatePasswordLength(length: Int) {
        _uiState.value = _uiState.value.copy(
            passwordGenerator = _uiState.value.passwordGenerator.copy(length = length)
        )
        recalculateStrength()
        persistPasswordPreferences()
    }

    fun updatePasswordToggles(
        uppercase: Boolean? = null,
        lowercase: Boolean? = null,
        digits: Boolean? = null,
        symbols: Boolean? = null
    ) {
        val current = _uiState.value.passwordGenerator
        val newState = current.copy(
            includeUppercase = uppercase ?: current.includeUppercase,
            includeLowercase = lowercase ?: current.includeLowercase,
            includeDigits = digits ?: current.includeDigits,
            includeSymbols = symbols ?: current.includeSymbols
        )
        if (!listOf(
                newState.includeUppercase,
                newState.includeLowercase,
                newState.includeDigits,
                newState.includeSymbols
            ).any { it }
        ) {
            showToast("Select at least one character set")
            return
        }
        _uiState.value = _uiState.value.copy(passwordGenerator = newState)
        recalculateStrength()
        persistPasswordPreferences()
    }

    fun generatePassword() {
        val config = currentPasswordConfig()
        runCatching { passwordGenerator.generate(config) }
            .onSuccess { password ->
                val strength = passwordGenerator.calculateStrength(config)
                _uiState.value = _uiState.value.copy(
                    passwordGenerator = _uiState.value.passwordGenerator.copy(
                        generatedPassword = password,
                        entropyBits = strength.entropyBits,
                        strengthLabel = strength.label
                    )
                )
            }
            .onFailure { showToast(it.localizedMessage ?: "Unable to generate password") }
    }

    fun consumeToast() {
        _uiState.value = _uiState.value.copy(toastMessage = null)
    }

    private fun recalculateStrength() {
        val config = currentPasswordConfig()
        val strength = passwordGenerator.calculateStrength(config)
        _uiState.value = _uiState.value.copy(
            passwordGenerator = _uiState.value.passwordGenerator.copy(
                entropyBits = strength.entropyBits,
                strengthLabel = strength.label
            )
        )
    }

    private fun currentPasswordConfig(): PasswordConfig {
        val state = _uiState.value.passwordGenerator
        return PasswordConfig(
            length = state.length,
            includeUppercase = state.includeUppercase,
            includeLowercase = state.includeLowercase,
            includeDigits = state.includeDigits,
            includeSymbols = state.includeSymbols
        )
    }

    private fun updateEncryptionState(
        outputText: String? = null,
        successMessage: String? = null,
        errorMessage: String? = null,
        lastOperation: com.ciphio.vault.data.OperationType? = null
    ) {
        val current = _uiState.value.encryption
        _uiState.value = _uiState.value.copy(
            encryption = current.copy(
                outputText = outputText ?: current.outputText,
                successMessage = successMessage,
                errorMessage = errorMessage,
                lastOperation = lastOperation ?: current.lastOperation
            )
        )
    }

    private fun setProcessing(processing: Boolean) {
        _uiState.value = _uiState.value.copy(
            encryption = _uiState.value.encryption.copy(isProcessing = processing)
        )
    }

    private fun showToast(message: String) {
        _uiState.value = _uiState.value.copy(toastMessage = message)
    }

    private fun buildKeyHint(secret: String): String {
        if (secret.isEmpty()) return ""
        val visible = secret.take(4)
        val obscuredLength = (secret.length - visible.length).coerceAtLeast(0)
        return visible + "*".repeat(obscuredLength)
    }

    private fun persistPasswordPreferences() {
        val prefs = _uiState.value.passwordGenerator
        val passwordPrefs = PasswordPreferences(
            length = prefs.length,
            includeUppercase = prefs.includeUppercase,
            includeLowercase = prefs.includeLowercase,
            includeDigits = prefs.includeDigits,
            includeSymbols = prefs.includeSymbols
        )
        viewModelScope.launch { userPreferencesRepository.updatePasswordPreferences(passwordPrefs) }
    }

    fun setTheme(option: ThemeOption) {
        viewModelScope.launch { userPreferencesRepository.setTheme(option) }
    }
    
    fun upgradeToPremium(activity: Any) {
        premiumManager.startPurchaseFlow(activity)
    }

    override fun onCleared() {
        super.onCleared()
        historyJob.cancel()
        toggleJob.cancel()
        passwordPrefsJob.cancel()
        themeJob.cancel()
        premiumJob.cancel()
    }
}

