package com.ciphio.crypto

import com.google.common.truth.Truth.assertThat
import org.junit.Test

class CryptoServiceTest {

    private val service = CryptoService()
    private val sampleText = "Confidential message"
    private val password = "SuperSecret#123"

    @Test
    fun `encrypt then decrypt round trips for AES-GCM`() {
        assertRoundTrip(AesMode.AES_GCM)
    }

    @Test
    fun `encrypt then decrypt round trips for AES-CBC`() {
        assertRoundTrip(AesMode.AES_CBC)
    }

    @Test
    fun `encrypt then decrypt round trips for AES-CTR`() {
        assertRoundTrip(AesMode.AES_CTR)
    }

    private fun assertRoundTrip(mode: AesMode) {
        val encrypted = service.encrypt(sampleText, password, mode)

        assertThat(encrypted.encoded).startsWith("${mode.tag}:")

        val (resolvedMode, decrypted) = service.decrypt(encrypted.encoded, password)

        assertThat(resolvedMode).isEqualTo(mode)
        assertThat(decrypted).isEqualTo(sampleText)
    }
}

