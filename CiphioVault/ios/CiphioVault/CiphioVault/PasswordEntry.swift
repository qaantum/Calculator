import Foundation

/// Data model for a password entry in the password manager.
///
/// This is a separate, modular feature that can be easily removed
/// without affecting text encryption or password generation features.
struct PasswordEntry: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let service: String
    let username: String
    let password: String // Will be encrypted in storage
    let notes: String
    let category: String // Deprecated: kept for backward compatibility
    let categories: [String] // New: multiple categories
    let createdAt: Int64 // Unix timestamp in milliseconds
    let updatedAt: Int64 // Unix timestamp in milliseconds
    
    init(
        id: String = UUID().uuidString,
        service: String,
        username: String,
        password: String,
        notes: String = "",
        category: String = "",
        categories: [String] = [],
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        updatedAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) {
        self.id = id
        self.service = service
        self.username = username
        self.password = password
        self.notes = notes
        self.category = category
        self.categories = categories
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    /// Get all categories (supports both old single category and new multiple categories).
    /// Migrates old single category to new format.
    func getAllCategories() -> [String] {
        var allCategories: [String] = []
        // Add old single category if exists
        if !category.isEmpty {
            allCategories.append(category)
        }
        // Add new multiple categories
        allCategories.append(contentsOf: categories)
        // Remove duplicates and blanks
        return Array(Set(allCategories.filter { !$0.isEmpty }))
    }
}

