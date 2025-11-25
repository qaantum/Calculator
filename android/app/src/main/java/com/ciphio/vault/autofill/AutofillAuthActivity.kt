package com.ciphio.vault.autofill

import android.content.Intent
import android.os.Bundle
import android.service.autofill.FillResponse
import android.view.autofill.AutofillId
import android.view.autofill.AutofillValue
import android.widget.RemoteViews
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.clickable
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowForward
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.collectAsState
import androidx.lifecycle.lifecycleScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.ui.text.input.KeyboardType
import androidx.fragment.app.FragmentActivity
import com.ciphio.vault.data.ciphioDataStore
import com.ciphio.vault.crypto.CryptoService
import com.ciphio.vault.passwordmanager.*
import com.ciphio.vault.ui.theme.CiphioTheme
import com.ciphio.vault.data.ThemeOption
import com.ciphio.vault.data.UserPreferencesRepository
import kotlinx.coroutines.launch
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

/**
 * Activity for authenticating before autofill.
 * This is shown when autofill is requested but user needs to authenticate.
 * After authentication, it retrieves matching credentials and fills them.
 */
class AutofillAuthActivity : FragmentActivity() {
    
    companion object {
        @Volatile
        var currentActivity: AutofillAuthActivity? = null
    }
    
    private lateinit var vaultRepository: PasswordVaultRepository
    private lateinit var biometricHelper: BiometricHelper
    private lateinit var keystoreHelper: KeystoreHelper
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        val dataStore = applicationContext.ciphioDataStore
        val cryptoService = CryptoService()
        keystoreHelper = KeystoreHelper(applicationContext)
        vaultRepository = PasswordVaultRepository(dataStore, cryptoService, keystoreHelper)
        biometricHelper = BiometricHelper(applicationContext, keystoreHelper)
        
        val isSaveRequest = intent.getBooleanExtra("is_save_request", false)
        val fillRequestId = intent.getIntExtra("fill_request_id", -1)
        val saveRequestId = intent.getIntExtra("save_request_id", -1)
        val domain = intent.getStringExtra("domain") ?: ""
        val packageName = intent.getStringExtra("package_name") ?: ""
        val saveUsername = intent.getStringExtra("username") ?: ""
        val savePassword = intent.getStringExtra("password") ?: ""
        
        // Safe getParcelableExtra for backward compatibility
        val usernameId = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra("username_id", AutofillId::class.java)
        } else {
            @Suppress("DEPRECATION")
            intent.getParcelableExtra("username_id")
        }
        
        val passwordId = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra("password_id", AutofillId::class.java)
        } else {
            @Suppress("DEPRECATION")
            intent.getParcelableExtra("password_id")
        }
        
        // Store activity reference for later use
        Companion.currentActivity = this
        
        // Handle save request differently
        if (isSaveRequest && saveUsername.isNotEmpty() && savePassword.isNotEmpty()) {
            lifecycleScope.launch {
                val biometricEnabled = vaultRepository.isBiometricEnabled()
                if (biometricEnabled && biometricHelper.isBiometricAvailable()) {
                    biometricHelper.authenticate(
                        activity = this@AutofillAuthActivity,
                        forUnlock = true,
                        onSuccess = { cryptoObject ->
                            kotlinx.coroutines.CoroutineScope(Dispatchers.Main).launch {
                                val masterPassword = withContext(Dispatchers.IO) {
                                    vaultRepository.retrieveMasterPasswordFromKeystore(cryptoObject)
                                }
                                if (masterPassword != null) {
                                    saveCredential(masterPassword, domain, saveUsername, savePassword)
                                } else {
                                    showPasswordPromptForSave(domain, saveUsername, savePassword)
                                }
                            }
                        },
                        onError = { error ->
                            showPasswordPromptForSave(domain, saveUsername, savePassword)
                        }
                    )
                } else {
                    showPasswordPromptForSave(domain, saveUsername, savePassword)
                }
            }
            return
        }
        
        // Try biometric first if available (for fill requests)
        lifecycleScope.launch {
            val biometricEnabled = vaultRepository.isBiometricEnabled()
            if (biometricEnabled && biometricHelper.isBiometricAvailable()) {
                biometricHelper.authenticate(
                    activity = this@AutofillAuthActivity,
                    forUnlock = true,
                    onSuccess = { cryptoObject ->
                        // Retrieve master password and fill credentials
                        kotlinx.coroutines.CoroutineScope(Dispatchers.Main).launch {
                            val masterPassword = withContext(Dispatchers.IO) {
                                vaultRepository.retrieveMasterPasswordFromKeystore(cryptoObject)
                            }
                            if (masterPassword != null) {
                                fillCredentials(masterPassword, domain, packageName, fillRequestId, usernameId, passwordId)
                            } else {
                                // Fallback to password entry
                                showPasswordPrompt(domain, packageName, fillRequestId, usernameId, passwordId)
                            }
                        }
                    },
                    onError = { error ->
                        // Fallback to password entry
                        showPasswordPrompt(domain, packageName, fillRequestId, usernameId, passwordId)
                    }
                )
            } else {
                // Show password entry UI
                showPasswordPrompt(domain, packageName, fillRequestId, usernameId, passwordId)
            }
        }
    }
    
    private fun showPasswordPrompt(domain: String, packageName: String, fillRequestId: Int, usernameId: AutofillId?, passwordId: AutofillId?) {
        setContent {
            val dataStore = remember { applicationContext.ciphioDataStore }
            val userPreferencesRepository = remember { UserPreferencesRepository(dataStore) }
            val themeOption by userPreferencesRepository.themeOption.collectAsState(initial = ThemeOption.SYSTEM)
            
            CiphioTheme(themeOption = themeOption) {
                var password by remember { mutableStateOf("") }
                var error by remember { mutableStateOf<String?>(null) }
                var isLoading by remember { mutableStateOf(false) }
                
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(24.dp),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    Text(
                        "Ciphio Vault Autofill",
                        style = MaterialTheme.typography.headlineMedium
                    )
                    Spacer(modifier = Modifier.height(16.dp))
                    Text(
                        "Enter master password to fill credentials",
                        style = MaterialTheme.typography.bodyMedium
                    )
                    Spacer(modifier = Modifier.height(24.dp))
                    
                    OutlinedTextField(
                        value = password,
                        onValueChange = { password = it },
                        label = { Text("Master Password") },
                        visualTransformation = androidx.compose.ui.text.input.PasswordVisualTransformation(),
                        modifier = Modifier.fillMaxWidth(),
                        enabled = !isLoading
                    )
                    
                    error?.let {
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            it,
                            color = MaterialTheme.colorScheme.error,
                            style = MaterialTheme.typography.bodySmall
                        )
                    }
                    
                    Spacer(modifier = Modifier.height(24.dp))
                    
                    Button(
                        onClick = {
                            if (password.isBlank()) {
                                error = "Please enter master password"
                            } else {
                                isLoading = true
                                kotlinx.coroutines.CoroutineScope(Dispatchers.Main).launch {
                                    val isValid = withContext(Dispatchers.IO) {
                                        vaultRepository.verifyMasterPassword(password)
                                    }
                                    if (isValid) {
                                        fillCredentials(password, domain, packageName, fillRequestId, usernameId, passwordId)
                                    } else {
                                        error = "Invalid password"
                                        isLoading = false
                                    }
                                }
                            }
                        },
                        enabled = !isLoading,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        if (isLoading) {
                            CircularProgressIndicator(modifier = Modifier.size(16.dp))
                        } else {
                            Text("Authenticate & Fill")
                        }
                    }
                }
            }
        }
    }
    
    private suspend fun fillCredentials(
        masterPassword: String,
        domain: String,
        packageName: String,
        fillRequestId: Int,
        usernameId: AutofillId?,
        passwordId: AutofillId?
    ) {
        withContext(Dispatchers.IO) {
            try {
                // Store master password temporarily for save functionality
                // This allows onSaveRequest to save new credentials without re-authentication
                val sharedPrefs = getSharedPreferences("autofill_selected", MODE_PRIVATE)
                sharedPrefs.edit().apply {
                    putString("temp_master_password", masterPassword)
                    putLong("temp_master_password_timestamp", System.currentTimeMillis())
                    apply()
                }
                android.util.Log.d("AutofillAuth", "Stored master password for save functionality")
                
                val entries = vaultRepository.getCurrentEntries(masterPassword)
                android.util.Log.d("AutofillAuth", "Searching for domain: $domain, total entries: ${entries.size}")
                
                // Find matching entries with improved matching logic
                val domainLower = domain.lowercase()
                val matchingEntries = entries.filter { entry ->
                    val serviceLower = entry.service.lowercase()
                    
                    // Direct match
                    val directMatch = serviceLower.contains(domainLower) || domainLower.contains(serviceLower)
                    
                    // Common domain aliases (e.g., google.com matches youtube.com, gmail.com)
                    val aliasMatch = when {
                        domainLower.contains("google") || domainLower.contains("youtube") || domainLower.contains("gmail") -> {
                            serviceLower.contains("google") || serviceLower.contains("youtube") || serviceLower.contains("gmail")
                        }
                        domainLower.contains("microsoft") || domainLower.contains("outlook") || domainLower.contains("hotmail") -> {
                            serviceLower.contains("microsoft") || serviceLower.contains("outlook") || serviceLower.contains("hotmail")
                        }
                        domainLower.contains("facebook") || domainLower.contains("instagram") || domainLower.contains("whatsapp") -> {
                            serviceLower.contains("facebook") || serviceLower.contains("instagram") || serviceLower.contains("whatsapp")
                        }
                        else -> false
                    }
                    
                    directMatch || aliasMatch
                }
                
                android.util.Log.d("AutofillAuth", "Found ${matchingEntries.size} matching entries")
                
                // If no matches and we have entries, show all entries for user to choose
                if (matchingEntries.isEmpty()) {
                    if (entries.isEmpty()) {
                        runOnUiThread {
                            android.widget.Toast.makeText(
                                this@AutofillAuthActivity,
                                "No passwords saved in Ciphio Vault",
                                android.widget.Toast.LENGTH_LONG
                            ).show()
                            finish()
                        }
                    } else {
                        // Show all entries since we couldn't match the domain
                        android.util.Log.d("AutofillAuth", "No domain match, showing all ${entries.size} entries")
                        runOnUiThread {
                            showCredentialSelection(entries, domain, packageName, fillRequestId, usernameId, passwordId)
                        }
                    }
                    return@withContext
                }
                
                // If single match, use it directly; otherwise show selection
                if (matchingEntries.size == 1) {
                    val entry = matchingEntries[0]
                    fillCredentialDirectly(entry, fillRequestId, usernameId, passwordId)
                } else {
                    // Multiple matches - show selection UI
                    runOnUiThread {
                        showCredentialSelection(matchingEntries, domain, packageName, fillRequestId, usernameId, passwordId)
                    }
                }
                
            } catch (e: Exception) {
                android.util.Log.e("AutofillAuth", "Error filling credentials: ${e.message}", e)
                runOnUiThread {
                    android.widget.Toast.makeText(
                        this@AutofillAuthActivity,
                        "Error: ${e.message}",
                        android.widget.Toast.LENGTH_LONG
                    ).show()
                    finish()
                }
            }
        }
    }
    

    private fun fillCredentialDirectly(entry: PasswordEntry, fillRequestId: Int, usernameId: AutofillId?, passwordId: AutofillId?) {
        android.util.Log.d("AutofillAuth", "✅ Returning credentials for ${entry.service}, requestId=$fillRequestId")
        
        // 1. Store selection in SharedPreferences (Required for the re-request to work)
        // Include domain to prevent cross-site credential leakage
        val sharedPrefs = getSharedPreferences("autofill_selected", MODE_PRIVATE)
        sharedPrefs.edit().apply {
            putString("username", entry.username)
            putString("password", entry.password)
            putString("service", entry.service)
            putString("domain", entry.service) // Store domain to validate on next request
            putLong("timestamp", System.currentTimeMillis())
            putInt("request_id", fillRequestId)
            apply()
        }
        
        // 2. Return RESULT_OK to signal success.
        // We do NOT return a dataset here. This forces Android to call onFillRequest() again.
        // This is the "FillResponse Authentication" flow, which is more robust for Chrome.
        setResult(RESULT_OK)
        android.util.Log.d("AutofillAuth", "Set result OK (no data) - triggering re-request")
        
        runOnUiThread {
            finish()
        }
    }
    
    private fun saveCredential(masterPassword: String, domain: String, username: String, password: String) {
        lifecycleScope.launch(Dispatchers.IO) {
            try {
                val entry = PasswordEntry(
                    service = domain,
                    username = username,
                    password = password
                )
                
                val success = vaultRepository.addEntry(entry, masterPassword)
                
                withContext(Dispatchers.Main) {
                    if (success) {
                        android.util.Log.d("AutofillAuth", "✅ Successfully saved credential for $domain")
                        android.widget.Toast.makeText(
                            this@AutofillAuthActivity,
                            "Credential saved to Ciphio Vault",
                            android.widget.Toast.LENGTH_SHORT
                        ).show()
                        finish()
                    } else {
                        android.util.Log.e("AutofillAuth", "Failed to save credential")
                        android.widget.Toast.makeText(
                            this@AutofillAuthActivity,
                            "Failed to save credential",
                            android.widget.Toast.LENGTH_SHORT
                        ).show()
                        finish()
                    }
                }
            } catch (e: Exception) {
                android.util.Log.e("AutofillAuth", "Error saving credential: ${e.message}", e)
                withContext(Dispatchers.Main) {
                    android.widget.Toast.makeText(
                        this@AutofillAuthActivity,
                        "Error: ${e.message}",
                        android.widget.Toast.LENGTH_SHORT
                    ).show()
                    finish()
                }
            }
        }
    }
    
    private fun showPasswordPromptForSave(domain: String, username: String, password: String) {
        setContent {
            val dataStore = remember { applicationContext.ciphioDataStore }
            val userPreferencesRepository = remember { UserPreferencesRepository(dataStore) }
            val themeOption by userPreferencesRepository.themeOption.collectAsState(initial = ThemeOption.SYSTEM)
            
            CiphioTheme(themeOption = themeOption) {
                var masterPassword by remember { mutableStateOf("") }
                var error by remember { mutableStateOf<String?>(null) }
                var isLoading by remember { mutableStateOf(false) }
                
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(24.dp),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    Text(
                        "Save Credential",
                        style = MaterialTheme.typography.headlineMedium
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        "Enter master password to save credential for $domain",
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    Spacer(modifier = Modifier.height(24.dp))
                    
                    OutlinedTextField(
                        value = masterPassword,
                        onValueChange = { masterPassword = it; error = null },
                        label = { Text("Master Password") },
                        visualTransformation = PasswordVisualTransformation(),
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                        modifier = Modifier.fillMaxWidth(),
                        isError = error != null
                    )
                    
                    error?.let {
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            it,
                            color = MaterialTheme.colorScheme.error,
                            style = MaterialTheme.typography.bodySmall
                        )
                    }
                    
                    Spacer(modifier = Modifier.height(24.dp))
                    
                    Button(
                        onClick = {
                            if (masterPassword.isEmpty()) {
                                error = "Please enter master password"
                                return@Button
                            }
                            
                            isLoading = true
                            lifecycleScope.launch(Dispatchers.IO) {
                                val isValid = vaultRepository.verifyMasterPassword(masterPassword)
                                withContext(Dispatchers.Main) {
                                    isLoading = false
                                    if (isValid) {
                                        saveCredential(masterPassword, domain, username, password)
                                    } else {
                                        error = "Incorrect master password"
                                    }
                                }
                            }
                        },
                        enabled = !isLoading,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        if (isLoading) {
                            CircularProgressIndicator(modifier = Modifier.size(20.dp))
                        } else {
                            Text("Save")
                        }
                    }
                    
                    Spacer(modifier = Modifier.height(8.dp))
                    
                    TextButton(
                        onClick = { finish() },
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("Cancel")
                    }
                }
            }
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        if (Companion.currentActivity == this) {
            Companion.currentActivity = null
        }
    }
    
    private fun showCredentialSelection(entries: List<PasswordEntry>, domain: String, packageName: String, fillRequestId: Int, usernameId: AutofillId?, passwordId: AutofillId?) {
        setContent {
            val dataStore = remember { applicationContext.ciphioDataStore }
            val userPreferencesRepository = remember { UserPreferencesRepository(dataStore) }
            val themeOption by userPreferencesRepository.themeOption.collectAsState(initial = ThemeOption.SYSTEM)
            
            CiphioTheme(themeOption = themeOption) {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxSize()
                            .padding(16.dp)
                    ) {
                        // Header
                        Text(
                            "Select Credential",
                            style = MaterialTheme.typography.headlineSmall,
                            modifier = Modifier.padding(bottom = 4.dp)
                        )
                        Text(
                            "Tap a credential to fill",
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            modifier = Modifier.padding(bottom = 16.dp)
                        )
                        
                        // Credential list
                        LazyColumn(
                            modifier = Modifier.weight(1f),
                            verticalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            items(entries.size) { index ->
                                val entry = entries[index]
                                Card(
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .clickable {
                                            fillCredentialDirectly(entry, fillRequestId, usernameId, passwordId)
                                        },
                                    colors = CardDefaults.cardColors(
                                        containerColor = MaterialTheme.colorScheme.surface,
                                        contentColor = MaterialTheme.colorScheme.onSurface
                                    ),
                                    elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
                                ) {
                                    Row(
                                        modifier = Modifier
                                            .fillMaxWidth()
                                            .padding(16.dp),
                                        verticalAlignment = Alignment.CenterVertically
                                    ) {
                                        Column(
                                            modifier = Modifier.weight(1f)
                                        ) {
                                            Text(
                                                text = entry.service,
                                                style = MaterialTheme.typography.titleMedium,
                                                maxLines = 1,
                                                overflow = androidx.compose.ui.text.style.TextOverflow.Ellipsis
                                            )
                                            Spacer(modifier = Modifier.height(4.dp))
                                            Text(
                                                text = entry.username,
                                                style = MaterialTheme.typography.bodyMedium,
                                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                                maxLines = 1,
                                                overflow = androidx.compose.ui.text.style.TextOverflow.Ellipsis
                                            )
                                        }
                                        Icon(
                                            imageVector = androidx.compose.material.icons.Icons.Default.ArrowForward,
                                            contentDescription = "Select",
                                            tint = MaterialTheme.colorScheme.primary,
                                            modifier = Modifier.padding(start = 8.dp)
                                        )
                                    }
                                }
                            }
                        }
                        
                        // Cancel button
                        OutlinedButton(
                            onClick = { 
                                setResult(RESULT_CANCELED)
                                finish() 
                            },
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(top = 8.dp)
                        ) {
                            Text("Cancel")
                        }
                    }
                }
            }
        }
    }
}

