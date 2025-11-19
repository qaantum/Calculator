package com.cryptatext.crypto

import android.os.Build
import java.security.GeneralSecurityException
import java.util.Base64
import java.security.SecureRandom
import javax.crypto.Cipher
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.PBEKeySpec
import javax.crypto.spec.SecretKeySpec
import org.bouncycastle.crypto.PBEParametersGenerator
import org.bouncycastle.crypto.digests.SHA256Digest
import org.bouncycastle.crypto.generators.PKCS5S2ParametersGenerator
import org.bouncycastle.crypto.params.KeyParameter

enum class AesMode(val displayName: String, val transformation: String, val ivLength: Int, val tag: String) {
    AES_GCM("AES-GCM", "AES/GCM/NoPadding", 12, "gcm"),
    AES_CBC("AES-CBC", "AES/CBC/PKCS5Padding", 16, "cbc"),
    AES_CTR("AES-CTR", "AES/CTR/NoPadding", 16, "ctr");

    companion object {
        fun fromDisplayName(name: String?): AesMode = values().firstOrNull { it.displayName == name } ?: AES_GCM
        fun fromTag(tag: String?): AesMode = values().firstOrNull { it.tag.equals(tag, ignoreCase = true) } ?: AES_GCM
    }
}

private const val PBKDF2_ITERATIONS = 100_000
private const val KEY_LENGTH_BITS = 256
private const val SALT_LENGTH_BYTES = 16

class CryptoService {
    private val secureRandom = SecureRandom()

    data class Result(val rawBytes: ByteArray, val encoded: String)

    fun encrypt(plainText: String, password: String, mode: AesMode): Result {
        require(password.isNotBlank()) { "Password must not be blank" }

        val salt = ByteArray(SALT_LENGTH_BYTES).also(secureRandom::nextBytes)
        val secretKey = deriveKey(password, salt)
        val iv = ByteArray(mode.ivLength).also(secureRandom::nextBytes)

        val cipher = Cipher.getInstance(mode.transformation)
        when (mode) {
            AesMode.AES_GCM -> cipher.init(Cipher.ENCRYPT_MODE, secretKey, GCMParameterSpec(128, iv))
            else -> cipher.init(Cipher.ENCRYPT_MODE, secretKey, IvParameterSpec(iv))
        }

        val cipherBytes = cipher.doFinal(plainText.toByteArray(Charsets.UTF_8))
        val payload = salt + iv + cipherBytes
        val encoded = "${mode.tag}:${Base64.getEncoder().encodeToString(payload)}"
        return Result(payload, encoded)
    }

    fun decrypt(encodedPayload: String, password: String): Pair<AesMode, String> {
        require(password.isNotBlank()) { "Password must not be blank" }

        val (resolvedMode, base64Part) = parsePayload(encodedPayload)
        val payload = try {
            Base64.getDecoder().decode(base64Part)
        } catch (ex: IllegalArgumentException) {
            throw GeneralSecurityException("Invalid Base64 payload", ex)
        }

        require(payload.size > SALT_LENGTH_BYTES + resolvedMode.ivLength) { "Ciphertext too short" }

        val salt = payload.copyOfRange(0, SALT_LENGTH_BYTES)
        val iv = payload.copyOfRange(SALT_LENGTH_BYTES, SALT_LENGTH_BYTES + resolvedMode.ivLength)
        val cipherBytes = payload.copyOfRange(SALT_LENGTH_BYTES + resolvedMode.ivLength, payload.size)

        val secretKey = deriveKey(password, salt)
        val cipher = Cipher.getInstance(resolvedMode.transformation)
        when (resolvedMode) {
            AesMode.AES_GCM -> cipher.init(Cipher.DECRYPT_MODE, secretKey, GCMParameterSpec(128, iv))
            else -> cipher.init(Cipher.DECRYPT_MODE, secretKey, IvParameterSpec(iv))
        }

        val plainBytes = cipher.doFinal(cipherBytes)
        return resolvedMode to plainBytes.toString(Charsets.UTF_8)
    }

    fun extractMode(encodedPayload: String): AesMode = parsePayload(encodedPayload).first

    private fun deriveKey(password: String, salt: ByteArray): SecretKeySpec {
        val keyBytes = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Use standard Java crypto for API 26+ (Android 8.0+)
            deriveKeyWithJavaCrypto(password, salt)
        } else {
            // Use BouncyCastle for API < 26 (Android 7.0 and below)
            deriveKeyWithBouncyCastle(password, salt)
        }
        return SecretKeySpec(keyBytes, "AES")
    }
    
    private fun deriveKeyWithJavaCrypto(password: String, salt: ByteArray): ByteArray {
        val keySpec = PBEKeySpec(password.toCharArray(), salt, PBKDF2_ITERATIONS, KEY_LENGTH_BITS)
        val factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
        return factory.generateSecret(keySpec).encoded
    }
    
    private fun deriveKeyWithBouncyCastle(password: String, salt: ByteArray): ByteArray {
        val generator = PKCS5S2ParametersGenerator(SHA256Digest())
        generator.init(
            PBEParametersGenerator.PKCS5PasswordToUTF8Bytes(password.toCharArray()),
            salt,
            PBKDF2_ITERATIONS
        )
        val keyParam = generator.generateDerivedMacParameters(KEY_LENGTH_BITS) as KeyParameter
        return keyParam.key
    }

    private fun parsePayload(payload: String): Pair<AesMode, String> {
        val parts = payload.split(":", limit = 2)
        return if (parts.size == 2 && parts[0].length in 2..4) {
            AesMode.fromTag(parts[0]) to parts[1]
        } else {
            AesMode.AES_GCM to payload
        }
    }
}

