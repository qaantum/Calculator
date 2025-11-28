package com.ciphio.vault.password

import java.security.SecureRandom
import kotlin.math.log2

data class PasswordConfig(
    val length: Int,
    val includeUppercase: Boolean,
    val includeLowercase: Boolean,
    val includeDigits: Boolean,
    val includeSymbols: Boolean
)

data class PasswordStrength(
    val entropyBits: Double,
    val label: String
)

class PasswordGenerator(private val secureRandom: SecureRandom = SecureRandom()) {

    private val uppercase = ('A'..'Z').joinToString("")
    private val lowercase = ('a'..'z').joinToString("")
    private val digits = ('0'..'9').joinToString("")
    private val symbols = "!@#\$%^&*()-_=+[]{};:,.<>?/|"

    fun generate(config: PasswordConfig): String {
        val pool = buildPool(config)
        require(pool.isNotEmpty()) { "At least one character set must be selected" }
        require(config.length in 6..64) { "Length must be between 6 and 64" }

        return buildString {
            repeat(config.length) {
                append(pool[secureRandom.nextInt(pool.length)])
            }
        }
    }

    fun calculateStrength(config: PasswordConfig): PasswordStrength {
        val poolSize = buildPool(config).length
        if (poolSize == 0 || config.length <= 0) {
            return PasswordStrength(0.0, "Invalid")
        }
        val entropy = config.length * log2(poolSize.toDouble())
        val label = when {
            entropy < 40 -> "Weak"
            entropy < 60 -> "Moderate"
            entropy < 100 -> "Strong"
            else -> "Very Strong"
        }
        return PasswordStrength(entropy, label)
    }

    private fun buildPool(config: PasswordConfig): String {
        val pools = buildList {
            if (config.includeUppercase) add(uppercase)
            if (config.includeLowercase) add(lowercase)
            if (config.includeDigits) add(digits)
            if (config.includeSymbols) add(symbols)
        }
        return pools.joinToString(separator = "")
    }
}

