package com.ciphio.vault.autofill

import android.app.assist.AssistStructure
import android.content.Context
import android.content.Intent
import android.content.IntentSender
import android.os.Build
import android.os.CancellationSignal
import android.service.autofill.AutofillService
import android.service.autofill.FillCallback
import android.service.autofill.FillRequest
import android.service.autofill.FillResponse
import android.service.autofill.SaveCallback
import android.service.autofill.SaveInfo
import android.service.autofill.SaveRequest
import android.view.View
import android.view.autofill.AutofillId
import android.view.autofill.AutofillValue
import android.widget.RemoteViews
import androidx.annotation.RequiresApi
import com.ciphio.vault.R
import com.ciphio.vault.data.ciphioDataStore
import com.ciphio.vault.crypto.CryptoService
import com.ciphio.vault.passwordmanager.KeystoreHelper
import com.ciphio.vault.passwordmanager.PasswordEntry
import com.ciphio.vault.passwordmanager.PasswordVaultRepository
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import java.net.URI
import java.util.regex.Pattern

/**
 * AutofillService implementation for Ciphio Vault.
 * 
 * This service allows Ciphio Vault to provide autofill credentials to other apps
 * (like Chrome, Instagram, etc.) when users are logging in.
 * 
 * Features:
 * - Domain/URL matching to find relevant credentials
 * - Secure credential retrieval with master password/biometric auth
 * - UI for credential selection when multiple matches found
 */
@RequiresApi(Build.VERSION_CODES.O)
class CiphioAutofillService : AutofillService() {

    companion object {
        @Volatile
        private var instance: CiphioAutofillService? = null
        
        // Cache to store fields from initial request to use in re-request
        // This is crucial for Chrome which might not provide full structure in re-request
        private val fieldsCache = android.util.LruCache<Int, AutofillFields>(10)
    }

    private val serviceScope = CoroutineScope(Dispatchers.Main + SupervisorJob())
    private lateinit var vaultRepository: PasswordVaultRepository
    private lateinit var cryptoService: CryptoService
    private lateinit var keystoreHelper: KeystoreHelper

    override fun onCreate() {
        super.onCreate()
        Companion.instance = this
        val dataStore = applicationContext.ciphioDataStore
        cryptoService = CryptoService()
        keystoreHelper = KeystoreHelper(applicationContext)
        vaultRepository = PasswordVaultRepository(dataStore, cryptoService, keystoreHelper)
    }
    
    override fun onDestroy() {
        super.onDestroy()
        if (Companion.instance == this) {
            Companion.instance = null
        }
    }

    override fun onFillRequest(
        request: FillRequest,
        cancellationSignal: CancellationSignal,
        callback: FillCallback
    ) {
        android.util.Log.d("CiphioAutofill", "onFillRequest called, requestId=${request.id}, flags=${request.flags}")
        
        // Check if this is a follow-up request after authentication
        // Android should automatically call this again after authentication completes
        
        serviceScope.launch {
            try {
                // Parse the assist structure to find username/password fields
                val structure = request.fillContexts.lastOrNull()?.structure
                    ?: run {
                        android.util.Log.w("CiphioAutofill", "No assist structure found")
                        callback.onFailure("No assist structure found")
                        return@launch
                    }

                val autofillFields = parseAutofillFields(structure)
                android.util.Log.d("CiphioAutofill", "Found fields - usernameId: ${autofillFields.usernameId}, passwordId: ${autofillFields.passwordId}")
                
                if (autofillFields.usernameId == null && autofillFields.passwordId == null) {
                    android.util.Log.w("CiphioAutofill", "No autofill fields detected")
                    // Don't fail - return empty response so system doesn't show error
                    callback.onSuccess(FillResponse.Builder().build())
                    return@launch
                }
                
                // Cache the fields for potential re-use
                if (autofillFields.usernameId != null || autofillFields.passwordId != null) {
                    fieldsCache.put(request.id, autofillFields)
                }
                
                // PRIORITY 1: Check if we have a recently selected credential (within last 60 seconds)
                // This handles the case where user authenticated and selected a credential
                // After authentication, Android should automatically call onFillRequest again
                val sharedPrefs = getSharedPreferences("autofill_selected", MODE_PRIVATE)
                val storedTimestamp = sharedPrefs.getLong("timestamp", 0)
                val storedUsername = sharedPrefs.getString("username", null)
                val storedPassword = sharedPrefs.getString("password", null)
                val storedRequestId = sharedPrefs.getInt("request_id", -1)
                val timeSinceSelection = System.currentTimeMillis() - storedTimestamp
                
                // Check if this is a follow-up request after authentication
                // Android automatically calls onFillRequest again after authentication completes
                // We extend the window to 5 minutes to give user time to tap fields
                val isAfterAuth = storedUsername != null && storedPassword != null && timeSinceSelection < 300000 // 5 minutes
                
                if (isAfterAuth) {
                    // We have recently authenticated credentials
                    // Instead of filling immediately, return a Dataset so user can tap any field
                    // and see "Ciphio Vault" in the dropdown
                    android.util.Log.d("CiphioAutofill", "✅ RETURNING DATASET: Using stored credential (${timeSinceSelection}ms ago, storedRequestId=$storedRequestId, currentRequestId=${request.id})")
                    
                    // Determine which fields to use
                    var targetFields = autofillFields
                    
                    // If current fields are empty (common in Chrome re-request), try to use cached fields from original request
                    if (targetFields.usernameId == null && targetFields.passwordId == null) {
                        val cachedFields = fieldsCache.get(storedRequestId)
                        if (cachedFields != null) {
                            android.util.Log.d("CiphioAutofill", "Current fields empty, using cached fields from request $storedRequestId")
                            targetFields = cachedFields
                        } else {
                            android.util.Log.w("CiphioAutofill", "Current fields empty and no cached fields found for request $storedRequestId")
                        }
                    }
                    
                    // Return a Dataset with the credentials (don't fill immediately)
                    // This allows user to tap any field and see "Ciphio Vault" in dropdown
                    fillCredentialsDirectly(callback, targetFields, storedUsername, storedPassword)
                    return@launch
                }
                
                // Check if vault has master password
                if (!vaultRepository.hasMasterPassword()) {
                    android.util.Log.w("CiphioAutofill", "No master password set")
                    callback.onFailure("No passwords saved in Ciphio Vault")
                    return@launch
                }

                val packageName = structure.activityComponent.packageName
                android.util.Log.d("CiphioAutofill", "Package: $packageName")

                // Extract domain
                val domain = extractDomainFromPackage(packageName, structure)
                android.util.Log.d("CiphioAutofill", "Domain: $domain")

                // Get all entries - we'll use authentication intent for secure access
                // For now, try to get entries without password (will fail, but we'll handle it)
                // The proper way is to use authentication intents
                
                // Create response with authentication requirement
                val responseBuilder = FillResponse.Builder()
                
                // Store request info for later use (for filling after authentication)
                val requestInfoKey = "autofill_request_${request.id}"
                val requestPrefs = getSharedPreferences("autofill_requests", MODE_PRIVATE)
                requestPrefs.edit().apply {
                    autofillFields.usernameId?.let { 
                        putString("${requestInfoKey}_username_id", it.toString())
                    }
                    autofillFields.passwordId?.let { 
                        putString("${requestInfoKey}_password_id", it.toString())
                    }
                    putString("${requestInfoKey}_package", packageName)
                    putString("${requestInfoKey}_domain", domain)
                    apply()
                }
                
                // Store which field was tapped for the re-request
                // This is critical for Chrome which changes AutofillIds between requests
                val tappedFieldType = when {
                    autofillFields.passwordId != null && autofillFields.usernameId == null -> "password"
                    autofillFields.usernameId != null && autofillFields.passwordId == null -> "username"
                    else -> "both" // Both fields visible, default to filling both
                }
                
                val selectedPrefs = getSharedPreferences("autofill_selected", MODE_PRIVATE)
                selectedPrefs.edit().apply {
                    putString("tapped_field_type", tappedFieldType)
                    apply()
                }
                android.util.Log.d("CiphioAutofill", "Stored tapped field type: $tappedFieldType")
                
                // Create authentication intent
                val authIntent = Intent(this@CiphioAutofillService, AutofillAuthActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    putExtra("fill_request_id", request.id)
                    putExtra("domain", domain)
                    putExtra("package_name", packageName)
                    // Store field IDs for later use
                    autofillFields.usernameId?.let { 
                        putExtra("username_id", it)
                    }
                    autofillFields.passwordId?.let { 
                        putExtra("password_id", it)
                    }
                }
                
                val authPendingIntent = android.app.PendingIntent.getActivity(
                    this@CiphioAutofillService,
                    request.id.hashCode(),
                    authIntent,
                    android.app.PendingIntent.FLAG_IMMUTABLE or android.app.PendingIntent.FLAG_UPDATE_CURRENT
                )
                
                // Create presentation
                val servicePackageName = this@CiphioAutofillService.packageName
                val presentation = RemoteViews(servicePackageName, com.ciphio.vault.R.layout.autofill_list_item).apply {
                    setTextViewText(com.ciphio.vault.R.id.text1, "Ciphio Vault - Authenticate to fill")
                }
                
                // Collect IDs that need authentication
                val ids = mutableListOf<AutofillId>()
                autofillFields.usernameId?.let { ids.add(it) }
                autofillFields.passwordId?.let { ids.add(it) }

                if (ids.isNotEmpty()) {
                    // Set authentication on the response itself (FillResponse Authentication)
                    // This tells Android: "Authenticate first, then ask me again"
                    responseBuilder.setAuthentication(ids.toTypedArray(), authPendingIntent.intentSender, presentation)
                    
                    // Add SaveInfo - CRITICAL for password saving
                    // This must be present for Android to show "Save password?" prompt
                    val saveInfo = SaveInfo.Builder(
                        SaveInfo.SAVE_DATA_TYPE_PASSWORD or SaveInfo.SAVE_DATA_TYPE_USERNAME,
                        ids.toTypedArray()
                    )
                    // Set FLAG_SAVE_ON_ALL_VIEWS_INVISIBLE to trigger save even if fields become invisible
                    .setFlags(SaveInfo.FLAG_SAVE_ON_ALL_VIEWS_INVISIBLE)
                    .build()
                    
                    responseBuilder.setSaveInfo(saveInfo)
                    
                    val response = responseBuilder.build()
                    
                    android.util.Log.d("CiphioAutofill", "Returning fill response with AUTHENTICATION and SaveInfo (FLAG_SAVE_ON_ALL_VIEWS_INVISIBLE)")
                    callback.onSuccess(response)
                } else {
                    android.util.Log.w("CiphioAutofill", "No fields to fill, returning empty response")
                    callback.onSuccess(FillResponse.Builder().build())
                }

            } catch (e: Exception) {
                android.util.Log.e("CiphioAutofill", "Error in onFillRequest: ${e.message}", e)
                e.printStackTrace()
                // Return empty response instead of failure to avoid system errors
                callback.onSuccess(FillResponse.Builder().build())
            }
        }
    }

    override fun onSaveRequest(request: SaveRequest, callback: SaveCallback) {
        serviceScope.launch {
            try {
                android.util.Log.d("CiphioAutofill", "onSaveRequest called")
                
                val structure = request.fillContexts.lastOrNull()?.structure
                    ?: run {
                        android.util.Log.e("CiphioAutofill", "No assist structure found in save request")
                        callback.onFailure("No assist structure found")
                        return@launch
                    }

                val autofillFields = parseAutofillFields(structure)
                val packageName = structure.activityComponent.packageName
                val domain = extractDomainFromPackage(packageName, structure)
                
                android.util.Log.d("CiphioAutofill", "Save request for domain: $domain")

                // Extract username and password from the AutofillValue objects
                var username = ""
                var password = ""
                
                // Traverse the structure to find the actual values
                for (i in 0 until structure.windowNodeCount) {
                    val windowNode = structure.getWindowNodeAt(i)
                    windowNode.rootViewNode?.let { root ->
                        extractValuesFromNode(root, autofillFields) { user, pass ->
                            if (user.isNotEmpty()) username = user
                            if (pass.isNotEmpty()) password = pass
                        }
                    }
                }
                
                android.util.Log.d("CiphioAutofill", "Extracted credentials - username: $username, password: ${if (password.isNotEmpty()) "[REDACTED]" else "[EMPTY]"}")

                if (username.isBlank() && password.isBlank()) {
                    android.util.Log.w("CiphioAutofill", "No credentials to save")
                    callback.onFailure("No credentials to save")
                    return@launch
                }

                // Create new entry
                val entry = PasswordEntry(
                    service = domain,
                    username = username,
                    password = password
                )

                // Get master password - we need to authenticate
                // For now, we'll save without master password check (will be encrypted when vault is next accessed)
                // TODO: Implement proper authentication flow for save
                
                // Try to get the master password from keystore if available
                val sharedPrefs = getSharedPreferences("autofill_selected", MODE_PRIVATE)
                val masterPassword = sharedPrefs.getString("temp_master_password", null)
                
                if (masterPassword != null) {
                    // Save to vault
                    val success = vaultRepository.addEntry(entry, masterPassword)
                    if (success) {
                        android.util.Log.d("CiphioAutofill", "Successfully saved credential for $domain")
                        callback.onSuccess()
                    } else {
                        android.util.Log.e("CiphioAutofill", "Failed to save credential")
                        callback.onFailure("Failed to save credential")
                    }
                } else {
                    // No master password available - need to authenticate
                    android.util.Log.w("CiphioAutofill", "No master password available for save")
                    callback.onFailure("Authentication required to save")
                }

            } catch (e: Exception) {
                android.util.Log.e("CiphioAutofill", "Error in onSaveRequest: ${e.message}", e)
                callback.onFailure("Error: ${e.message}")
            }
        }
    }
    
    private fun extractValuesFromNode(node: AssistStructure.ViewNode, fields: AutofillFields, callback: (String, String) -> Unit) {
        // Check if this node matches our target fields
        node.autofillId?.let { id ->
            node.autofillValue?.let { value ->
                when {
                    id == fields.usernameId && value.isText -> {
                        val username = value.textValue.toString()
                        android.util.Log.d("CiphioAutofill", "Found username value: $username")
                        callback(username, "")
                    }
                    id == fields.passwordId && value.isText -> {
                        val password = value.textValue.toString()
                        android.util.Log.d("CiphioAutofill", "Found password value: [REDACTED ${password.length} chars]")
                        callback("", password)
                    }
                }
            }
        }
        
        // Traverse children
        for (i in 0 until node.childCount) {
            extractValuesFromNode(node.getChildAt(i), fields, callback)
        }
    }

    /**
     * Parse autofill fields from assist structure.
     */
    private fun parseAutofillFields(structure: AssistStructure): AutofillFields {
        var usernameId: AutofillId? = null
        var passwordId: AutofillId? = null
        var usernameHint: String? = null
        var passwordHint: String? = null

        fun traverseView(node: AssistStructure.ViewNode, depth: Int = 0) {
            val hints = node.autofillHints?.toList() ?: emptyList()
            val id = node.autofillId
            val className = node.className
            val hint = node.hint
            val idEntry = node.idEntry
            val htmlInfo = node.htmlInfo
            val isVisible = node.visibility == android.view.View.VISIBLE
            
            // Log for debugging
            if (id != null && (hints.isNotEmpty() || hint != null || idEntry != null)) {
                android.util.Log.d("CiphioAutofill", "Field found: class=$className, hints=$hints, hint=$hint, idEntry=$idEntry, htmlInfo=${htmlInfo?.tag}, visible=$isVisible")
            }

            // Check autofill hints first (most reliable)
            when {
                hints.contains(android.view.View.AUTOFILL_HINT_USERNAME) ||
                hints.contains(android.view.View.AUTOFILL_HINT_EMAIL_ADDRESS) ||
                hints.contains("username") || 
                hints.contains("email") -> {
                    // Only assign if visible (skip hidden username fields in split login)
                    if (usernameId == null && id != null && isVisible) {
                        usernameId = id
                        usernameHint = hint
                        android.util.Log.d("CiphioAutofill", "Username field detected via hints: $hints")
                    }
                }
                hints.contains(android.view.View.AUTOFILL_HINT_PASSWORD) ||
                hints.contains("password") -> {
                    if (passwordId == null && id != null) {
                        passwordId = id
                        passwordHint = hint
                        android.util.Log.d("CiphioAutofill", "Password field detected via hints: $hints")
                    }
                }
            }
            
            // Check HTML attributes (for web views)
            htmlInfo?.let { html ->
                val htmlTag = html.tag
                val htmlAttrs = html.attributes
                val inputType = htmlAttrs?.find { it.first.equals("type", ignoreCase = true) }?.second
                
                when {
                    inputType?.equals("email", ignoreCase = true) == true -> {
                        // Only assign if visible (skip hidden username fields in split login)
                        if (usernameId == null && id != null && isVisible) {
                            usernameId = id
                            usernameHint = hint ?: "email"
                            android.util.Log.d("CiphioAutofill", "Username field detected via HTML: tag=$htmlTag, type=$inputType")
                        }
                    }
                    inputType?.equals("password", ignoreCase = true) == true -> {
                        if (passwordId == null && id != null) {
                            passwordId = id
                            passwordHint = hint ?: "password"
                            android.util.Log.d("CiphioAutofill", "Password field detected via HTML: tag=$htmlTag, type=$inputType")
                        }
                    }
                    inputType?.equals("text", ignoreCase = true) == true && 
                    (idEntry?.contains("user", ignoreCase = true) == true ||
                     idEntry?.contains("email", ignoreCase = true) == true ||
                     idEntry?.contains("login", ignoreCase = true) == true) -> {
                        // Only assign if visible (skip hidden username fields in split login)
                        if (usernameId == null && id != null && isVisible) {
                            usernameId = id
                            usernameHint = hint ?: idEntry
                            android.util.Log.d("CiphioAutofill", "Username field detected via HTML text input: tag=$htmlTag, idEntry=$idEntry")
                        }
                    }
                }
            }
            
            // Fallback: check hint text and idEntry
            when {
                (usernameId == null) && id != null && isVisible && (
                    hint?.contains("username", ignoreCase = true) == true ||
                    hint?.contains("email", ignoreCase = true) == true ||
                    hint?.contains("login", ignoreCase = true) == true ||
                    idEntry?.contains("username", ignoreCase = true) == true ||
                    idEntry?.contains("email", ignoreCase = true) == true ||
                    idEntry?.contains("login", ignoreCase = true) == true ||
                    idEntry?.contains("user", ignoreCase = true) == true
                ) -> {
                    usernameId = id
                    usernameHint = hint
                    android.util.Log.d("CiphioAutofill", "Username field detected via hint/idEntry: hint=$hint, idEntry=$idEntry")
                }
                (passwordId == null) && id != null && (
                    hint?.contains("password", ignoreCase = true) == true ||
                    idEntry?.contains("password", ignoreCase = true) == true ||
                    idEntry?.contains("pass", ignoreCase = true) == true
                ) -> {
                    passwordId = id
                    passwordHint = hint
                    android.util.Log.d("CiphioAutofill", "Password field detected via hint/idEntry: hint=$hint, idEntry=$idEntry")
                }
            }

            // Traverse children
            for (i in 0 until node.childCount) {
                traverseView(node.getChildAt(i), depth + 1)
            }
        }

        for (i in 0 until structure.windowNodeCount) {
            structure.getWindowNodeAt(i).rootViewNode?.let { root ->
                traverseView(root)
            }
        }

        android.util.Log.d("CiphioAutofill", "Final fields - usernameId: $usernameId, passwordId: $passwordId")
        return AutofillFields(usernameId, passwordId, usernameHint, passwordHint)
    }

    /**
     * Extract domain from package name or assist structure.
     */
    private fun extractDomainFromPackage(packageName: String, structure: AssistStructure): String {
        // 1. Try to get webDomain (most reliable for Chrome/Browsers)
        // 1. Try to get webDomain (most reliable for Chrome/Browsers)
        val webDomain = extractWebDomain(structure)
        if (webDomain != null) {
            android.util.Log.d("CiphioAutofill", "Extracted webDomain: $webDomain")
            return webDomain
        }

        // 2. Try to get URL from web view if available (Legacy/Firefox)
        for (i in 0 until structure.windowNodeCount) {
            val window = structure.getWindowNodeAt(i)
            val root = window.rootViewNode
            if (root != null) {
                val url = extractUrlFromView(root)
                if (url != null && url.isNotBlank()) {
                    val domain = extractDomainFromUrl(url)
                    android.util.Log.d("CiphioAutofill", "Extracted domain from URL: $url -> $domain")
                    if (domain.isNotBlank() && domain != "null") {
                        return domain
                    }
                }
            }
        }
        
        // Try to extract from web view title or text content
        for (i in 0 until structure.windowNodeCount) {
            val window = structure.getWindowNodeAt(i)
            val title = window.title?.toString()
            if (title != null && title.contains(".")) {
                // Try to extract domain from title (e.g., "YouTube - Google")
                val domain = extractDomainFromText(title)
                if (domain.isNotBlank()) {
                    android.util.Log.d("CiphioAutofill", "Extracted domain from title: $title -> $domain")
                    return domain
                }
            }
        }

        // Fallback: use package name mapping
        android.util.Log.w("CiphioAutofill", "Could not extract domain from web view, using package name: $packageName")
        return when {
            // packageName.contains("chrome", ignoreCase = true) -> "google.com" // Removed: Chrome now uses webDomain
            packageName.contains("instagram", ignoreCase = true) -> "instagram.com"
            packageName.contains("facebook", ignoreCase = true) -> "facebook.com"
            packageName.contains("twitter", ignoreCase = true) -> "twitter.com"
            packageName.contains("github", ignoreCase = true) -> "github.com"
            else -> packageName
        }
    }
    
    /**
     * Extract domain from text (e.g., window title).
     */
    private fun extractDomainFromText(text: String): String {
        // Try to find common domain patterns
        val patterns = listOf(
            Pattern.compile("(?:https?://)?([a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})"),
            Pattern.compile("([a-zA-Z0-9-]+\\.(?:com|org|net|edu|gov|io|co|uk|de|fr|jp|cn))")
        )
        
        for (pattern in patterns) {
            val matcher = pattern.matcher(text)
            if (matcher.find()) {
                val domain = matcher.group(1)
                if (domain != null && !domain.startsWith("www.")) {
                    return domain.lowercase()
                }
            }
        }
        
        return ""
    }

    /**
     * Extract URL from web view nodes.
     */
    private fun extractUrlFromView(node: AssistStructure.ViewNode): String? {
        // Check if this is a web view
        if (node.className?.contains("WebView") == true) {
            // Try to get URL from node text or content description
            return node.text?.toString() ?: node.contentDescription?.toString()
        }

        // Traverse children
        for (i in 0 until node.childCount) {
            extractUrlFromView(node.getChildAt(i))?.let { return it }
        }

        return null
    }

    /**
     * Extract domain from URL.
     */
    private fun extractDomainFromUrl(url: String): String {
        return try {
            val uri = URI(url)
            uri.host ?: url
        } catch (e: Exception) {
            // Try regex extraction
            val pattern = Pattern.compile("https?://([^/]+)")
            val matcher = pattern.matcher(url)
            if (matcher.find()) {
                matcher.group(1) ?: url
            } else {
                url
            }
        }
    }

    /**
     * Find matching password entries based on domain.
     */
    private fun findMatchingEntries(
        entries: List<PasswordEntry>,
        domain: String,
        packageName: String
    ): List<PasswordEntry> {
        val domainLower = domain.lowercase()
        val packageLower = packageName.lowercase()

        return entries.filter { entry ->
            val serviceLower = entry.service.lowercase()
            serviceLower.contains(domainLower) || 
            domainLower.contains(serviceLower) ||
            packageLower.contains(serviceLower) ||
            serviceLower.contains(packageLower.split(".").lastOrNull() ?: "")
        }
    }

    /**
     * Get master password (try biometric first).
     */
    private suspend fun getMasterPassword(): String? {
        // Try biometric first if enabled
        if (vaultRepository.isBiometricEnabled()) {
            // Note: Biometric auth requires UI, so we'll handle it in the UI flow
            return null
        }
        
        // For now, return null to trigger authentication UI
        // In a real implementation, you might cache the master password temporarily
        return null
    }

    /**
     * Fill credentials directly (used after credential selection).
     * This fills immediately without requiring authentication again.
     */
    private fun fillCredentialsDirectly(
        callback: FillCallback,
        fields: AutofillFields,
        username: String,
        password: String
    ) {
        val responseBuilder = FillResponse.Builder()
        val datasetBuilder = android.service.autofill.Dataset.Builder()
        
        val servicePackageName = this@CiphioAutofillService.packageName
        
        // Create presentation for the dataset
        val presentation = RemoteViews(servicePackageName, com.ciphio.vault.R.layout.autofill_list_item).apply {
            setTextViewText(com.ciphio.vault.R.id.text1, "Ciphio Vault")
        }
        
        var hasFields = false
        
        // Read which field was originally tapped
        val sharedPrefs = getSharedPreferences("autofill_selected", MODE_PRIVATE)
        val tappedFieldType = sharedPrefs.getString("tapped_field_type", "both") ?: "both"
        android.util.Log.d("CiphioAutofill", "Filling based on tapped field type: $tappedFieldType")
        
        // Fill username field only if it was tapped or both fields are visible
        if (tappedFieldType == "username" || tappedFieldType == "both") {
            fields.usernameId?.let { id ->
                datasetBuilder.setValue(id, AutofillValue.forText(username), presentation)
                hasFields = true
                android.util.Log.d("CiphioAutofill", "Filled username field")
            }
        }
        
        // Fill password field only if it was tapped or both fields are visible
        if (tappedFieldType == "password" || tappedFieldType == "both") {
            fields.passwordId?.let { id ->
                datasetBuilder.setValue(id, AutofillValue.forText(password), presentation)
                hasFields = true
                android.util.Log.d("CiphioAutofill", "Filled password field")
            }
        }



        if (hasFields) {
            val dataset = datasetBuilder.build()
            responseBuilder.addDataset(dataset)
            
            // Add SaveInfo to enable password saving
            // This is critical for the save prompt to appear
            val saveIds = mutableListOf<AutofillId>()
            fields.usernameId?.let { saveIds.add(it) }
            fields.passwordId?.let { saveIds.add(it) }
            
            if (saveIds.isNotEmpty()) {
                val saveInfo = SaveInfo.Builder(
                    SaveInfo.SAVE_DATA_TYPE_PASSWORD or SaveInfo.SAVE_DATA_TYPE_USERNAME,
                    saveIds.toTypedArray()
                ).build()
                responseBuilder.setSaveInfo(saveInfo)
                android.util.Log.d("CiphioAutofill", "Added SaveInfo to Dataset response")
            }
            
            val response = responseBuilder.build()
            
            // Don't clear credentials here - let them persist for the 5-minute timeout
            // This allows Chrome to request them multiple times as user taps different fields
            
            android.util.Log.d("CiphioAutofill", "Returning Dataset with credentials - username: $username")
            callback.onSuccess(response)
        } else {
            android.util.Log.w("CiphioAutofill", "No fields to fill")
            callback.onFailure("No autofill fields found")
        }
    }
    
    /**
     * Fill credentials into the requesting app.
     */
    private fun fillCredentials(
        callback: FillCallback,
        fields: AutofillFields,
        entry: PasswordEntry
    ) {
        val responseBuilder = FillResponse.Builder()
        val datasetBuilder = android.service.autofill.Dataset.Builder()
        
        // IMPORTANT: RemoteViews must use the autofill service's package name
        val servicePackageName = this@CiphioAutofillService.packageName
        val presentation = RemoteViews(servicePackageName, com.ciphio.vault.R.layout.autofill_list_item).apply {
            setTextViewText(com.ciphio.vault.R.id.text1, "${entry.service} - ${entry.username}")
        }
        
        var hasFields = false
        
        // Set username field with presentation
        fields.usernameId?.let { id ->
            datasetBuilder.setValue(id, AutofillValue.forText(entry.username), presentation)
            hasFields = true
        }
        
        // Set password field with presentation
        fields.passwordId?.let { id ->
            datasetBuilder.setValue(id, AutofillValue.forText(entry.password), presentation)
            hasFields = true
        }

        if (hasFields) {
            responseBuilder.addDataset(datasetBuilder.build())
            callback.onSuccess(responseBuilder.build())
        } else {
            callback.onFailure("No autofill fields found")
        }
    }

    /**
     * Show authentication UI before autofill.
     */
    private fun showAuthenticationUI(
        request: FillRequest,
        callback: FillCallback,
        fields: AutofillFields,
        domain: String
    ) {
        // Launch authentication activity
        val intent = Intent(this, AutofillAuthActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
            putExtra("fill_request_id", request.id)
            putExtra("domain", domain)
        }
        
        startActivity(intent)
        // Note: The activity will handle the actual fill after authentication
        callback.onFailure("Authentication required")
    }

    /**
     * Show credential selection UI when multiple matches found.
     */
    private fun showCredentialSelectionUI(
        request: FillRequest,
        callback: FillCallback,
        fields: AutofillFields,
        entries: List<PasswordEntry>
    ) {
        // Launch selection activity
        val intent = Intent(this, AutofillSelectionActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
            putExtra("fill_request_id", request.id)
            putStringArrayListExtra("entry_ids", ArrayList(entries.map { it.id }))
        }
        
        startActivity(intent)
        callback.onFailure("Multiple credentials found - selection required")
    }

    /**
     * Data class to hold autofill field information.
     */
    internal data class AutofillFields(
        val usernameId: AutofillId?,
        val passwordId: AutofillId?,
        val usernameHint: String?,
        val passwordHint: String?
    )

    /**
     * Extract web domain from AssistStructure (API 26+).
     */
    private fun extractWebDomain(structure: AssistStructure): String? {
        for (i in 0 until structure.windowNodeCount) {
            val window = structure.getWindowNodeAt(i)
            val root = window.rootViewNode ?: continue
            
            var foundDomain: String? = null
            
            fun traverse(node: AssistStructure.ViewNode) {
                if (foundDomain != null) return
                
                // Check webDomain property (API 26+)
                node.webDomain?.let { domain ->
                    if (domain.isNotBlank()) {
                        foundDomain = domain
                        return
                    }
                }
                
                for (j in 0 until node.childCount) {
                    traverse(node.getChildAt(j))
                }
            }
            
            traverse(root)
            if (foundDomain != null) return foundDomain
        }
        return null
    }
}

