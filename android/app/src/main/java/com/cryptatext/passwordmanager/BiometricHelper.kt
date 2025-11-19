package com.cryptatext.passwordmanager

import android.content.Context
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/**
 * Helper class for biometric authentication.
 * 
 * This is a premium feature that allows users to unlock the password vault
 * using fingerprint, face recognition, or other biometric methods.
 */
class BiometricHelper(
    private val context: Context,
    private val keystoreHelper: KeystoreHelper? = null
) {
    
    /**
     * Check if biometric authentication is available on the device.
     */
    fun isBiometricAvailable(): Boolean {
        val biometricManager = BiometricManager.from(context)
        return when (biometricManager.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_STRONG)) {
            BiometricManager.BIOMETRIC_SUCCESS -> true
            else -> false
        }
    }
    
    /**
     * Get the biometric status message.
     */
    fun getBiometricStatus(): String {
        val biometricManager = BiometricManager.from(context)
        return when (biometricManager.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_STRONG)) {
            BiometricManager.BIOMETRIC_SUCCESS -> "Biometric authentication available"
            BiometricManager.BIOMETRIC_ERROR_NO_HARDWARE -> "No biometric hardware available"
            BiometricManager.BIOMETRIC_ERROR_HW_UNAVAILABLE -> "Biometric hardware unavailable"
            BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED -> "No biometric enrolled. Please set up fingerprint or face unlock in device settings."
            else -> "Biometric authentication unavailable"
        }
    }
    
    /**
     * Show biometric prompt for authentication.
     * 
     * @param activity The FragmentActivity to show the prompt
     * @param forUnlock If true, use existing key (for unlocking). If false, regenerate key (for enabling).
     * @param onSuccess Callback when authentication succeeds, provides CryptoObject
     * @param onError Callback when authentication fails or is cancelled
     */
    fun authenticate(
        activity: FragmentActivity,
        forUnlock: Boolean = false,
        onSuccess: (BiometricPrompt.CryptoObject) -> Unit,
        onError: (String) -> Unit
    ) {
        val executor = ContextCompat.getMainExecutor(context)
        
        // Create cipher for biometric authentication if keystore is available
        if (keystoreHelper == null) {
            android.util.Log.w("BiometricHelper", "Keystore not available")
            onError("Keystore not available")
            return
        }
        
        // First, show BiometricPrompt without CryptoObject to authenticate
        // After authentication, we'll have a 5-second window to initialize the cipher
        val biometricPrompt = BiometricPrompt(
            activity,
            executor,
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
                    super.onAuthenticationSucceeded(result)
                    // After authentication, we have 5 seconds to initialize the cipher
                    // Do this on a background thread to avoid blocking
                    CoroutineScope(Dispatchers.IO).launch {
                        try {
                            android.util.Log.d("BiometricHelper", "Authentication succeeded, initializing cipher... (forUnlock=$forUnlock)")
                            
                            if (!forUnlock) {
                                // When enabling biometric unlock, delete old key and generate new one
                                // Always delete old key first (might be from GCM mode or incompatible mode)
                                if (keystoreHelper.hasKey()) {
                                    android.util.Log.d("BiometricHelper", "Deleting old key (might be incompatible mode)...")
                                    keystoreHelper.deleteKey()
                                }
                                
                                // Generate new key with CBC mode (this doesn't require auth)
                                android.util.Log.d("BiometricHelper", "Generating new key with CBC mode...")
                                keystoreHelper.generateKey()
                            } else {
                                // When unlocking, use existing key - don't delete it!
                                if (!keystoreHelper.hasKey()) {
                                    android.util.Log.e("BiometricHelper", "No key found in keystore for unlock")
                                    withContext(Dispatchers.Main) {
                                        onError("No biometric key found. Please disable and re-enable biometric unlock.")
                                    }
                                    return@launch
                                }
                                android.util.Log.d("BiometricHelper", "Using existing key for unlock")
                            }
                            
                            // Create cipher instance
                            val cipher = javax.crypto.Cipher.getInstance("AES/CBC/PKCS7Padding")
                            
                            // Get the key and initialize the cipher - this should work now
                            // because we're within the 5-second validity window
                            android.util.Log.d("BiometricHelper", "Getting key and initializing cipher...")
                            val secretKey = keystoreHelper.keyStore.getKey(KeystoreHelper.KEY_ALIAS, null) as javax.crypto.SecretKey
                            cipher.init(javax.crypto.Cipher.ENCRYPT_MODE, secretKey)
                            android.util.Log.d("BiometricHelper", "Cipher initialized successfully")
                            
                            // Switch back to main thread to call success callback
                            withContext(Dispatchers.Main) {
                                // Create CryptoObject with initialized cipher
                                val cryptoObject = BiometricPrompt.CryptoObject(cipher)
                                android.util.Log.d("BiometricHelper", "Biometric authentication succeeded, cipher is ready")
                                onSuccess(cryptoObject)
                            }
                        } catch (e: android.security.keystore.UserNotAuthenticatedException) {
                            // This shouldn't happen because we just authenticated
                            android.util.Log.e("BiometricHelper", "User not authenticated after successful auth: ${e.message}", e)
                            withContext(Dispatchers.Main) {
                                onError("Failed to initialize cipher after authentication")
                            }
                        } catch (e: Exception) {
                            android.util.Log.e("BiometricHelper", "Failed to create cipher: ${e.message}", e)
                            e.printStackTrace()
                            withContext(Dispatchers.Main) {
                                onError("Failed to initialize biometric authentication: ${e.message}")
                            }
                        }
                    }
                }
                
                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                    super.onAuthenticationError(errorCode, errString)
                    when (errorCode) {
                        BiometricPrompt.ERROR_USER_CANCELED,
                        BiometricPrompt.ERROR_NEGATIVE_BUTTON -> {
                            onError("Authentication cancelled")
                        }
                        else -> {
                            onError("Biometric authentication failed: $errString")
                        }
                    }
                }
                
                override fun onAuthenticationFailed() {
                    super.onAuthenticationFailed()
                    onError("Biometric authentication failed. Please try again.")
                }
            }
        )
        
        val promptInfo = BiometricPrompt.PromptInfo.Builder()
            .setTitle(if (forUnlock) "Unlock with Biometric" else "Enable Biometric Unlock")
            .setSubtitle("Use your fingerprint or face to ${if (forUnlock) "unlock" else "enable unlock"}")
            .setNegativeButtonText("Cancel")
            .build()
        
        // Show BiometricPrompt without CryptoObject first to authenticate
        // After authentication, we'll initialize the cipher within the validity window
        biometricPrompt.authenticate(promptInfo)
    }
}

