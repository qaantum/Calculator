package com.ciphio.vault.passwordmanager

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import androidx.biometric.BiometricPrompt
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.IvParameterSpec

/**
 * Helper class for securely storing and retrieving the master password
 * using Android Keystore with biometric authentication.
 * 
 * This allows biometric unlock to work by storing the master password
 * encrypted in Android Keystore, which can only be decrypted with
 * biometric authentication.
 * 
 * Uses CBC mode instead of GCM because CBC can be initialized for decryption
 * without IV upfront, which is required for BiometricPrompt.
 */
class KeystoreHelper(private val context: Context) {
    
    companion object {
        private const val KEYSTORE_PROVIDER = "AndroidKeyStore"
        const val KEY_ALIAS = "ciphio_master_password_key"
        private const val OLD_KEY_ALIAS = "cryptatext_master_password_key" // For migration
        private const val TRANSFORMATION = "AES/CBC/PKCS7Padding"
        private const val IV_LENGTH = 16 // AES block size
    }
    
    val keyStore: KeyStore = KeyStore.getInstance(KEYSTORE_PROVIDER).apply {
        load(null)
        migrateFromOldKeyAlias()
    }
    
    /**
     * Migrate from old key alias to new one.
     * If old key exists and new key doesn't, we'll use the old key temporarily.
     * User will need to re-enable biometric unlock to create the new key.
     */
    private fun migrateFromOldKeyAlias() {
        val hasNewKey = try {
            keyStore.containsAlias(KEY_ALIAS)
        } catch (e: Exception) {
            false
        }
        
        val hasOldKey = try {
            keyStore.containsAlias(OLD_KEY_ALIAS)
        } catch (e: Exception) {
            false
        }
        
        if (hasOldKey && !hasNewKey) {
            android.util.Log.d("KeystoreHelper", "Migration: Old key alias found, new key doesn't exist")
            android.util.Log.d("KeystoreHelper", "Migration: User will need to re-enable biometric unlock to create new key")
            // Note: We can't directly copy Keystore keys, so the old key will remain
            // The user will need to re-enable biometric unlock, which will create the new key
            // The old key is harmless and can be left in place
        }
    }
    
    // Store encrypted data temporarily for retrieval
    private var storedEncryptedData: ByteArray? = null
    
    /**
     * Check if a key exists in the keystore.
     */
    fun hasKey(): Boolean {
        return try {
            keyStore.containsAlias(KEY_ALIAS)
        } catch (e: Exception) {
            false
        }
    }
    
    /**
     * Generate a new key for encrypting the master password.
     * This key requires user authentication (biometric) to use.
     */
    fun generateKey() {
        if (keyStore.containsAlias(KEY_ALIAS)) {
            // Key already exists, delete it first
            keyStore.deleteEntry(KEY_ALIAS)
        }
        
        val keyGenerator = KeyGenerator.getInstance(
            KeyProperties.KEY_ALGORITHM_AES,
            KEYSTORE_PROVIDER
        )
        
        // Note: setUserAuthenticationValidityDurationSeconds is deprecated in favor of
        // setUserAuthenticationParameters (API 30+), but we support API 24+, so we use the deprecated method
        @Suppress("DEPRECATION")
        val keyGenParameterSpec = KeyGenParameterSpec.Builder(
            KEY_ALIAS,
            KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
        )
            .setBlockModes(KeyProperties.BLOCK_MODE_CBC)
            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_PKCS7)
            .setUserAuthenticationRequired(true)
            .setUserAuthenticationValidityDurationSeconds(5) // Allow 5 seconds after biometric auth to access key
            .build()
        
        keyGenerator.init(keyGenParameterSpec)
        keyGenerator.generateKey()
    }
    
    /**
     * Store the master password encrypted in Android Keystore.
     * 
     * Note: This requires biometric authentication first. The key requires
     * user authentication, so we need to trigger biometric auth before encrypting.
     * 
     * @param masterPassword The master password to store
     * @return true if successful, false otherwise
     */
    fun storeMasterPassword(masterPassword: String): Boolean {
        return try {
            // Generate key if it doesn't exist
            if (!hasKey()) {
                generateKey()
            }
            
            // Get the secret key - this will trigger biometric authentication
            // because the key requires user authentication
            android.util.Log.d("KeystoreHelper", "storeMasterPassword: getting key (will trigger biometric)...")
            val secretKey = keyStore.getKey(KEY_ALIAS, null) as SecretKey
            android.util.Log.d("KeystoreHelper", "storeMasterPassword: key retrieved successfully")
            
            // Create cipher for encryption
            val cipher = Cipher.getInstance(TRANSFORMATION)
            android.util.Log.d("KeystoreHelper", "storeMasterPassword: initializing cipher for encryption...")
            cipher.init(Cipher.ENCRYPT_MODE, secretKey)
            android.util.Log.d("KeystoreHelper", "storeMasterPassword: cipher initialized successfully")
            
            // Encrypt the master password
            android.util.Log.d("KeystoreHelper", "storeMasterPassword: encrypting...")
            val encryptedBytes = cipher.doFinal(masterPassword.toByteArray(Charsets.UTF_8))
            val iv = cipher.iv
            
            // Store encrypted password and IV
            // Note: The encrypted data is stored in DataStore, but the key is in Android Keystore
            // This means the encrypted data can only be decrypted with biometric authentication
            val encryptedData = encryptedBytes + iv
            storedEncryptedData = encryptedData
            android.util.Log.d("KeystoreHelper", "Master password stored successfully, encryptedData size=${encryptedData.size}")
            
            true
        } catch (e: Exception) {
            android.util.Log.e("KeystoreHelper", "Failed to store master password: ${e.message}", e)
            e.printStackTrace()
            false
        }
    }
    
    /**
     * Get the encrypted master password data.
     * This should be called after storeMasterPassword() to get the encrypted data
     * to store in DataStore.
     */
    fun getEncryptedMasterPasswordData(): ByteArray? {
        return storedEncryptedData
    }
    
    /**
     * Create a cipher for biometric authentication.
     * This will trigger biometric authentication when the cipher is used.
     * 
     * Note: We use ENCRYPT_MODE because it doesn't require an IV upfront.
     * The BiometricPrompt just needs a cipher to authenticate with - the mode doesn't matter.
     * After authentication succeeds, we'll use the authenticated key to create a decrypt cipher with the IV.
     * 
     * Important: We don't access the key here - we just create the cipher.
     * The key access (and biometric prompt) will happen when BiometricPrompt uses the cipher.
     * 
     * @return The cipher (not yet initialized), or null if failed
     */
    fun createDecryptCipher(): Cipher? {
        return try {
            // Generate key if it doesn't exist (this doesn't require auth)
            if (!hasKey()) {
                android.util.Log.d("KeystoreHelper", "createDecryptCipher: key doesn't exist, generating...")
                generateKey()
            }
            
            android.util.Log.d("KeystoreHelper", "createDecryptCipher: creating cipher instance...")
            val cipher = Cipher.getInstance(TRANSFORMATION)
            
            // Don't initialize the cipher here - let BiometricPrompt do it
            // This way, the biometric prompt will be triggered when the cipher is actually used
            android.util.Log.d("KeystoreHelper", "createDecryptCipher: cipher created successfully (not initialized yet)")
            
            cipher
        } catch (e: Exception) {
            android.util.Log.e("KeystoreHelper", "Failed to create cipher for biometric auth: ${e.message}", e)
            e.printStackTrace()
            null
        }
    }
    
    /**
     * Retrieve the master password from Android Keystore.
     * This requires biometric authentication.
     * 
     * @param encryptedData The encrypted master password data (encrypted bytes + IV)
     * @param cryptoObject The BiometricPrompt.CryptoObject from successful biometric auth
     * @return The decrypted master password, or null if failed
     */
    fun retrieveMasterPassword(
        encryptedData: ByteArray,
        cryptoObject: BiometricPrompt.CryptoObject?
    ): String? {
        return try {
            android.util.Log.d("KeystoreHelper", "retrieveMasterPassword: starting, encryptedData size=${encryptedData.size}, cryptoObject=${cryptoObject != null}")
            
            if (!hasKey()) {
                android.util.Log.e("KeystoreHelper", "No key found in keystore")
                return null
            }
            
            // Split encrypted data and IV
            if (encryptedData.size < IV_LENGTH) {
                android.util.Log.e("KeystoreHelper", "Invalid encrypted data format: size=${encryptedData.size}, need at least $IV_LENGTH")
                return null
            }
            
            val encryptedBytes = encryptedData.sliceArray(0 until encryptedData.size - IV_LENGTH)
            val iv = encryptedData.sliceArray(encryptedData.size - IV_LENGTH until encryptedData.size)
            android.util.Log.d("KeystoreHelper", "retrieveMasterPassword: split data - encryptedBytes size=${encryptedBytes.size}, iv size=${iv.size}")
            
            // After biometric authentication succeeds, we can access the key from keystore
            // (within the 5-second window) to create a new cipher with the IV for CBC mode
            android.util.Log.d("KeystoreHelper", "retrieveMasterPassword: getting key from keystore (within 5-second window)...")
            val secretKey = keyStore.getKey(KEY_ALIAS, null) as SecretKey
            android.util.Log.d("KeystoreHelper", "retrieveMasterPassword: key retrieved successfully")
            
            val cipher = Cipher.getInstance(TRANSFORMATION)
            val parameterSpec = IvParameterSpec(iv)
            android.util.Log.d("KeystoreHelper", "retrieveMasterPassword: initializing cipher with IV...")
            cipher.init(Cipher.DECRYPT_MODE, secretKey, parameterSpec)
            android.util.Log.d("KeystoreHelper", "retrieveMasterPassword: cipher initialized successfully")
            
            // Decrypt the master password
            android.util.Log.d("KeystoreHelper", "retrieveMasterPassword: decrypting...")
            val decryptedBytes = cipher.doFinal(encryptedBytes)
            val masterPassword = String(decryptedBytes, Charsets.UTF_8)
            
            android.util.Log.d("KeystoreHelper", "Master password retrieved successfully, length=${masterPassword.length}")
            masterPassword
        } catch (e: Exception) {
            android.util.Log.e("KeystoreHelper", "Failed to retrieve master password: ${e.message}", e)
            e.printStackTrace()
            null
        }
    }
    
    /**
     * Delete the stored master password key.
     */
    fun deleteKey() {
        try {
            if (keyStore.containsAlias(KEY_ALIAS)) {
                android.util.Log.d("KeystoreHelper", "Deleting key with alias: $KEY_ALIAS")
                keyStore.deleteEntry(KEY_ALIAS)
                android.util.Log.d("KeystoreHelper", "Key deleted successfully")
                // Verify deletion
                if (keyStore.containsAlias(KEY_ALIAS)) {
                    android.util.Log.w("KeystoreHelper", "Key still exists after deletion!")
                } else {
                    android.util.Log.d("KeystoreHelper", "Key deletion confirmed")
                }
            } else {
                android.util.Log.d("KeystoreHelper", "No key to delete")
            }
        } catch (e: Exception) {
            android.util.Log.e("KeystoreHelper", "Failed to delete key: ${e.message}", e)
            e.printStackTrace()
        }
    }
}

