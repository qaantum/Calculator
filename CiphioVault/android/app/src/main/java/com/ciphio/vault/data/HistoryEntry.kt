package com.ciphio.vault.data

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import java.util.UUID

@Serializable
data class HistoryEntry(
    @SerialName("id") val id: String = UUID.randomUUID().toString(),
    @SerialName("action") val action: OperationType,
    @SerialName("algorithm") val algorithm: String,
    @SerialName("input") val input: String,
    @SerialName("output") val output: String,
    @SerialName("timestamp") val timestamp: Long,
    @SerialName("keyHint") val keyHint: String
)

@Serializable
enum class OperationType {
    ENCRYPT,
    DECRYPT
}

