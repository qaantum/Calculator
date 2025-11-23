package com.ciphio.vault.passwordmanager

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import java.util.UUID

/**
 * Data model for a password entry in the password manager.
 * 
 * This is a separate, modular feature that can be easily removed
 * without affecting text encryption or password generation features.
 */
@Serializable
data class PasswordEntry(
    @SerialName("id") val id: String = UUID.randomUUID().toString(),
    @SerialName("service") val service: String,
    @SerialName("username") val username: String,
    @SerialName("password") val password: String, // Will be encrypted in storage
    @SerialName("notes") val notes: String = "",
    @SerialName("category") val category: String = "", // Deprecated: kept for backward compatibility
    @SerialName("categories") val categories: List<String> = emptyList(), // New: multiple categories
    @SerialName("createdAt") val createdAt: Long = System.currentTimeMillis(),
    @SerialName("updatedAt") val updatedAt: Long = System.currentTimeMillis()
) {
    /**
     * Get all categories (supports both old single category and new multiple categories).
     * Migrates old single category to new format.
     */
    fun getAllCategories(): List<String> {
        val allCategories = mutableListOf<String>()
        // Add old single category if exists
        if (category.isNotBlank()) {
            allCategories.add(category)
        }
        // Add new multiple categories
        allCategories.addAll(categories)
        // Remove duplicates and blanks
        return allCategories.filter { it.isNotBlank() }.distinct()
    }
}

