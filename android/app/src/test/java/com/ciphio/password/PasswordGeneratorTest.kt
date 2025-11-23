package com.ciphio.password

import com.google.common.truth.Truth.assertThat
import org.junit.Test

class PasswordGeneratorTest {

    private val generator = PasswordGenerator()

    @Test
    fun `generated password has requested length`() {
        val config = PasswordConfig(
            length = 32,
            includeUppercase = true,
            includeLowercase = true,
            includeDigits = true,
            includeSymbols = true
        )

        val password = generator.generate(config)

        assertThat(password).hasLength(32)
    }

    @Test
    fun `generated password characters stay within selected pool`() {
        val config = PasswordConfig(
            length = 40,
            includeUppercase = true,
            includeLowercase = false,
            includeDigits = true,
            includeSymbols = false
        )

        val password = generator.generate(config)

        val allowed = buildSet {
            addAll('A'..'Z')
            addAll('0'..'9')
        }

        assertThat(password).isNotEmpty()
        password.forEach { char ->
            assertThat(allowed).contains(char)
        }
    }

    @Test
    fun `entropy calculation respects pool size`() {
        val config = PasswordConfig(
            length = 12,
            includeUppercase = true,
            includeLowercase = true,
            includeDigits = false,
            includeSymbols = false
        )

        val strength = generator.calculateStrength(config)

        assertThat(strength.entropyBits).isGreaterThan(0.0)
        assertThat(strength.label).isNotEmpty()
    }
}

