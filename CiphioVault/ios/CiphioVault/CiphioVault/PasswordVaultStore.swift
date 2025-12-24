import Foundation
import CryptoKit
import LocalAuthentication
import AuthenticationServices

/// Repository for managing password entries with encryption.
///
/// Features:
/// - Encrypted storage using master password
/// - CRUD operations
/// - Search/filter functionality
///
/// This is a separate, modular feature that can be easily removed.
@MainActor
final class PasswordVaultStore: ObservableObject {
    @Published private(set) var entries: [PasswordEntry] = []
    @Published private(set) var isUnlocked: Bool = false
    @Published private(set) var biometricEnabled: Bool = false
    @Published private(set) var hasMasterPassword: Bool = false
    
    private let passwordsKey = "ciphio.passwords"
    private let masterPasswordHashKey = "ciphio.master_password_hash"
    private let biometricEnabledKey = "ciphio.biometric_enabled"
    private let dataVersionKey = "ciphio.data_version"
    private let defaults = UserDefaults.standard
    
    // Data version for migration - increment when data format changes
    private let currentDataVersion = 1
    private let cryptoService: CryptoService
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let keychainHelper = KeychainHelper()
    private let vaultDataManager = VaultDataManager.shared
    
    // In-memory cache for performance
    private var cachedEntries: [PasswordEntry]?
    private var cachePassword: String?
    
    var currentMasterPassword: String?
    
    init(cryptoService: CryptoService) {
        self.cryptoService = cryptoService
        encoder.outputFormatting = .prettyPrinted
        loadBiometricStatus()
        hasMasterPassword = defaults.string(forKey: masterPasswordHashKey) != nil
        
        // Migrate data if needed
        migrateDataIfNeeded()
    }
    
    /// Migrate data format if version has changed
    /// This ensures passwords don't break after app updates
    /// 
    /// Handles skipped versions: If user has version 1 and app updates to version 5,
    /// all migrations (1→2, 2→3, 3→4, 4→5) will run sequentially.
    private func migrateDataIfNeeded() {
        let storedVersion = defaults.integer(forKey: dataVersionKey)
        
        // If no version stored, this is old data - set version to current
        if storedVersion == 0 {
            defaults.set(currentDataVersion, forKey: dataVersionKey)
            return
        }
        
        // If version matches, no migration needed
        if storedVersion == currentDataVersion {
            return
        }
        
        // Run all migrations sequentially from stored version to current version
        // This handles cases where user skips updates (e.g., version 1 → version 5)
        // Each migration transforms data from version N-1 to version N
        _ = storedVersion
        
        // Future: Add migration logic here when data format changes
        // IMPORTANT: Each migration function should transform data from previous version to next version
        // They will run sequentially if user has skipped versions
        // Example:
        // while currentVersion < currentDataVersion {
        //     if currentVersion == 1 {
        //         migrateFromV1ToV2()
        //         currentVersion = 2
        //     } else if currentVersion == 2 {
        //         migrateFromV2ToV3()
        //         currentVersion = 3
        //     } else if currentVersion == 3 {
        //         migrateFromV3ToV4()
        //         currentVersion = 4
        //     } else if currentVersion == 4 {
        //         migrateFromV4ToV5()
        //         currentVersion = 5
        //     }
        //     // Update stored version after each migration step
        //     defaults.set(currentVersion, forKey: dataVersionKey)
        // }
        
        // Alternative pattern (simpler but requires all migrations to run):
        // if storedVersion < 2 {
        //     migrateFromV1ToV2()
        // }
        // if storedVersion < 3 {
        //     migrateFromV2ToV3()  // This assumes data is now in v2 format
        // }
        // if storedVersion < 4 {
        //     migrateFromV3ToV4()  // This assumes data is now in v3 format
        // }
        // if storedVersion < 5 {
        //     migrateFromV4ToV5()  // This assumes data is now in v4 format
        // }
        // NOTE: With this pattern, each migration function must handle data in the
        // format of the PREVIOUS version, not the stored version.
        
        // Update to current version after all migrations complete
        defaults.set(currentDataVersion, forKey: dataVersionKey)
    }
    
    private func loadBiometricStatus() {
        biometricEnabled = defaults.bool(forKey: biometricEnabledKey)
    }
    
    // MARK: - Master Password Management
    
    /// Set master password (stores hash for verification).
    /// Uses SHA-256 for deterministic password hashing.
    /// If biometric is enabled, also stores in Keychain.
    /// Automatically unlocks the vault after setting the password.
    func setMasterPassword(_ password: String, enableBiometric: Bool = false) throws {
        // Use SHA-256 for deterministic password hashing
        let passwordData = password.data(using: .utf8) ?? Data()
        let hash = SHA256.hash(data: passwordData)
        let hashString = Data(hash).base64EncodedString()
        defaults.set(hashString, forKey: masterPasswordHashKey)
        
        // Sync master password hash to shared storage for AutoFill extension
        vaultDataManager.saveMasterPasswordHash(hashString)
        
        currentMasterPassword = password
        
        // Update published property to trigger view refresh
        hasMasterPassword = true
        
        // Store in Keychain if biometric is enabled
        if enableBiometric {
            try keychainHelper.storeMasterPassword(password)
            biometricEnabled = true
            defaults.set(true, forKey: biometricEnabledKey)
            vaultDataManager.setBiometricEnabled(true)
        }
        
        // Automatically unlock the vault after setting the password
        isUnlocked = true
    }
    
    /// Enable or disable biometric unlock.
    func setBiometricEnabled(_ enabled: Bool) {
        biometricEnabled = enabled
        defaults.set(enabled, forKey: biometricEnabledKey)
        
        if !enabled {
            // Remove from Keychain when disabling
            keychainHelper.deleteMasterPassword()
        }
    }
    
    /// Check if biometric unlock is enabled.
    func isBiometricEnabled() -> Bool {
        return biometricEnabled
    }
    
    /// Retrieve master password from Keychain using biometric authentication.
    func retrieveMasterPasswordFromKeychain(context: LAContext) throws -> String {
        return try keychainHelper.retrieveMasterPassword(context: context)
    }
    
    /// Verify master password.
    /// Tries to decrypt existing data or verify against stored hash.
    func verifyMasterPassword(_ password: String) -> Bool {
        // If no data exists, any password is valid for first setup
        guard defaults.string(forKey: passwordsKey) != nil || defaults.string(forKey: masterPasswordHashKey) != nil else {
            return true
        }
        
        // If we have encrypted data, try to decrypt it first (most reliable method)
        if let encryptedData = defaults.string(forKey: passwordsKey) {
            do {
                _ = try cryptoService.decrypt(encoded: encryptedData, password: password)
                // Decryption succeeded, password is valid
                currentMasterPassword = password
                return true
            } catch {
                // Decryption failed, try hash verification
            }
        }
        
        // Verify against stored hash
        guard let storedHash = defaults.string(forKey: masterPasswordHashKey) else {
            return false
        }
        
        let passwordData = password.data(using: .utf8) ?? Data()
        let hash = SHA256.hash(data: passwordData)
        let hashString = Data(hash).base64EncodedString()
        
        if hashString == storedHash {
            currentMasterPassword = password
            return true
        }
        
        return false
    }
    
    /// Change master password (re-encrypts all entries).
    /// Preserves biometric enabled state and updates Keychain if needed.
    func changeMasterPassword(oldPassword: String, newPassword: String) throws {
        guard verifyMasterPassword(oldPassword) else {
            throw PasswordVaultError.invalidPassword
        }
        
        guard let masterPassword = currentMasterPassword else {
            throw PasswordVaultError.notUnlocked
        }
        
        // Preserve biometric enabled state
        let wasBiometricEnabled = biometricEnabled
        
        // Get all entries
        let allEntries = try getAllEntries(masterPassword: masterPassword)
        
        // Set new master password (don't enable biometric here - will be handled after)
        try setMasterPassword(newPassword, enableBiometric: false)
        
        // Re-encrypt all entries with new password
        if !allEntries.isEmpty {
            let jsonData = try encoder.encode(allEntries)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            let encrypted = try cryptoService.encrypt(plaintext: jsonString, password: newPassword, mode: .aesGcm)
            defaults.set(encrypted.encoded, forKey: passwordsKey)
        }
        
        currentMasterPassword = newPassword
        
        // Update cache with new password
        cachedEntries = allEntries
        cachePassword = newPassword
        
        // If biometric was enabled, update Keychain with new password
        if wasBiometricEnabled {
            do {
                try keychainHelper.storeMasterPassword(newPassword)
                biometricEnabled = true
                defaults.set(true, forKey: biometricEnabledKey)
            } catch {
                // If Keychain update fails, disable biometric
                biometricEnabled = false
                defaults.set(false, forKey: biometricEnabledKey)
                // Don't throw - password change succeeded, just biometric update failed
            }
        }
    }
    
    // MARK: - Entry Management
    
    /// Unlock vault with master password.
    func unlock(masterPassword: String) throws {
        guard verifyMasterPassword(masterPassword) else {
            throw PasswordVaultError.invalidPassword
        }
        
        currentMasterPassword = masterPassword
        entries = try getAllEntries(masterPassword: masterPassword)
        isUnlocked = true
        
        // Register all credentials with iOS Autofill system after unlock
        registerAllCredentialsWithAutofill()
    }
    
    /// Lock vault.
    func lock() {
        currentMasterPassword = nil
        entries = []
        isUnlocked = false
    }
    
    /// Get all password entries (decrypted).
    /// Uses in-memory cache for performance.
    private func getAllEntries(masterPassword: String) throws -> [PasswordEntry] {
        // Return cached entries if password matches
        if cachePassword == masterPassword, let cached = cachedEntries {
            return cached
        }
        
        guard let encryptedData = defaults.string(forKey: passwordsKey) else {
            cachedEntries = []
            cachePassword = masterPassword
            return []
        }
        
        let (_, decryptedJson) = try cryptoService.decrypt(encoded: encryptedData, password: masterPassword)
        guard let jsonData = decryptedJson.data(using: .utf8) else {
            return []
        }
        
        let entries = try decoder.decode([PasswordEntry].self, from: jsonData)
        
        // Cache the result
        cachedEntries = entries
        cachePassword = masterPassword
        
        return entries
    }
    
    /// Add a new password entry.
    /// Optimized: crypto operations run on background thread.
    func addEntry(_ entry: PasswordEntry) async throws {
        guard let masterPassword = currentMasterPassword else {
            throw PasswordVaultError.notUnlocked
        }
        
        // Get current entries
        let currentEntries = try getAllEntries(masterPassword: masterPassword)
        
        // Perform crypto operations off main thread
        let (encryptedData, updatedEntries) = try await Task.detached(priority: .userInitiated) { [encoder, cryptoService] in
            // Deduplicate and update
            var entriesDict = Dictionary(uniqueKeysWithValues: currentEntries.map { ($0.id, $0) })
            entriesDict[entry.id] = entry
            let updated = Array(entriesDict.values).sorted { $0.updatedAt > $1.updatedAt }
            
            // Encrypt
            let jsonData = try encoder.encode(updated)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            let encrypted = try cryptoService.encrypt(plaintext: jsonString, password: masterPassword, mode: .aesGcm)
            
            return (encrypted.encoded, updated)
        }.value
        
        // Quick write and cache update on main thread
        defaults.set(encryptedData, forKey: passwordsKey)
        defaults.set(currentDataVersion, forKey: dataVersionKey) // Store data version
        
        // Sync to shared storage for AutoFill extension
        syncVaultDataToSharedStorage(encryptedData: encryptedData)
        
        cachedEntries = updatedEntries
        cachePassword = masterPassword
        entries = updatedEntries
        
        // Register with iOS Autofill system
        registerCredentialWithAutofill(entry)
    }
    
    /// Update an existing password entry.
    /// Optimized: crypto operations run on background thread.
    func updateEntry(_ entry: PasswordEntry) async throws {
        guard let masterPassword = currentMasterPassword else {
            throw PasswordVaultError.notUnlocked
        }
        
        // Get current entries on main thread first
        var currentEntries = try getAllEntries(masterPassword: masterPassword)
        
        // Perform crypto operations off main thread
        let (encryptedData, updatedEntries) = try await Task.detached(priority: .userInitiated) { [encoder, cryptoService] in
            // Update entry
            if let index = currentEntries.firstIndex(where: { $0.id == entry.id }) {
                // Preserve the original createdAt from the existing entry
                let existingEntry = currentEntries[index]
                let updatedEntry = PasswordEntry(
                    id: entry.id,
                    service: entry.service,
                    username: entry.username,
                    password: entry.password,
                    notes: entry.notes,
                    category: entry.category,
                    categories: entry.categories,
                    createdAt: existingEntry.createdAt, // Preserve original creation date
                    updatedAt: Int64(Date().timeIntervalSince1970 * 1000)
                )
                currentEntries[index] = updatedEntry
            } else {
                throw PasswordVaultError.entryNotFound
            }
            
            // Sort by updatedAt descending
            currentEntries.sort { $0.updatedAt > $1.updatedAt }
            
            // Encrypt
            let jsonData = try encoder.encode(currentEntries)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            let encrypted = try cryptoService.encrypt(plaintext: jsonString, password: masterPassword, mode: .aesGcm)
            
            return (encrypted.encoded, currentEntries)
        }.value
        
        // Quick write and cache update on main thread
        defaults.set(encryptedData, forKey: passwordsKey)
        defaults.set(currentDataVersion, forKey: dataVersionKey) // Store data version
        
        // Sync to shared storage for AutoFill extension
        syncVaultDataToSharedStorage(encryptedData: encryptedData)
        
        cachedEntries = updatedEntries
        cachePassword = masterPassword
        entries = updatedEntries
        
        // Register with iOS Autofill system
        if let updatedEntry = updatedEntries.first(where: { $0.id == entry.id }) {
            registerCredentialWithAutofill(updatedEntry)
        }
    }
    
    /// Delete a password entry.
    /// Optimized: crypto operations run on background thread.
    func deleteEntry(id: String) async throws {
        guard let masterPassword = currentMasterPassword else {
            throw PasswordVaultError.notUnlocked
        }
        
        // Get current entries on main thread first
        var currentEntries = try getAllEntries(masterPassword: masterPassword)
        
        // Perform crypto operations off main thread
        let (encryptedData, updatedEntries) = try await Task.detached(priority: .userInitiated) { [encoder, cryptoService] in
            currentEntries.removeAll { $0.id == id }
            
            if currentEntries.isEmpty {
                return (Optional<String>.none, currentEntries)
            } else {
                // Encrypt and save
                let jsonData = try encoder.encode(currentEntries)
                let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
                let encrypted = try cryptoService.encrypt(plaintext: jsonString, password: masterPassword, mode: .aesGcm)
                return (Optional<String>.some(encrypted.encoded), currentEntries)
            }
        }.value
        
        // Quick write and cache update on main thread
        if let encryptedData = encryptedData {
            defaults.set(encryptedData, forKey: passwordsKey)
        } else {
            defaults.removeObject(forKey: passwordsKey)
        }
        cachedEntries = updatedEntries
        cachePassword = masterPassword
        entries = updatedEntries
    }
    
    /// Reload entries from storage.
    func reloadEntries() throws {
        guard let masterPassword = currentMasterPassword else {
            throw PasswordVaultError.notUnlocked
        }
        
        entries = try getAllEntries(masterPassword: masterPassword)
    }
    
    /// Reload entries asynchronously.
    func reloadEntriesAsync() async throws {
        guard let masterPassword = currentMasterPassword else {
            throw PasswordVaultError.notUnlocked
        }
        
        entries = try getAllEntries(masterPassword: masterPassword)
    }
    
    // MARK: - Export/Import
    
    /// Export all entries as encrypted JSON string.
    func exportEntries() throws -> String {
        guard let masterPassword = currentMasterPassword else {
            throw PasswordVaultError.notUnlocked
        }
        
        let allEntries = try getAllEntries(masterPassword: masterPassword)
        let jsonData = try encoder.encode(allEntries)
        let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
        let encrypted = try cryptoService.encrypt(plaintext: jsonString, password: masterPassword, mode: .aesGcm)
        return encrypted.encoded
    }
    
    /// Import entries from encrypted JSON string or CSV format.
    func importEntries(encryptedData: String, merge: Bool = true) throws -> ImportResult {
        guard let masterPassword = currentMasterPassword else {
            throw PasswordVaultError.notUnlocked
        }
        
        let importedEntries: [PasswordEntry]
        
        // Try to detect format: encrypted (starts with "gcm:" or "cbc:" or "ctr:") or CSV
        let trimmed = encryptedData.trimmingCharacters(in: .whitespacesAndNewlines)
        let isEncrypted = trimmed.hasPrefix("gcm:") || trimmed.hasPrefix("cbc:") || trimmed.hasPrefix("ctr:")
        
        if isEncrypted {
            // Decrypt the imported data (our own format)
            let (_, decryptedJson) = try cryptoService.decrypt(encoded: encryptedData, password: masterPassword)
            guard let jsonData = decryptedJson.data(using: .utf8) else {
                throw PasswordVaultError.invalidFormat
            }
            importedEntries = try decoder.decode([PasswordEntry].self, from: jsonData)
        } else {
            // Try to parse as CSV (common password manager export format)
            importedEntries = try parseCsvImport(csvData: encryptedData)
        }
        
        if merge {
            // Merge with existing entries
            var existing = try getAllEntries(masterPassword: masterPassword)
            let existingIds = Set(existing.map { $0.id })
            let newEntries = importedEntries.filter { !existingIds.contains($0.id) }
            
            existing.append(contentsOf: newEntries)
            existing.sort { $0.updatedAt > $1.updatedAt }
            
            // Encrypt and save
            let jsonData = try encoder.encode(existing)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            let encrypted = try cryptoService.encrypt(plaintext: jsonString, password: masterPassword, mode: .aesGcm)
            defaults.set(encrypted.encoded, forKey: passwordsKey)
            
            entries = existing
            
            return ImportResult(
                newEntriesCount: newEntries.count,
                existingEntriesCount: importedEntries.count - newEntries.count,
                totalEntriesCount: existing.count,
                isError: false
            )
        } else {
            // Replace all entries
            let sortedEntries = importedEntries.sorted { $0.updatedAt > $1.updatedAt }
            
            // Encrypt and save
            let jsonData = try encoder.encode(sortedEntries)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            let encrypted = try cryptoService.encrypt(plaintext: jsonString, password: masterPassword, mode: .aesGcm)
            defaults.set(encrypted.encoded, forKey: passwordsKey)
            
            entries = sortedEntries
            
            return ImportResult(
                newEntriesCount: sortedEntries.count,
                existingEntriesCount: 0,
                totalEntriesCount: sortedEntries.count,
                isError: false
            )
        }
    }
}

// MARK: - Supporting Types

enum PasswordVaultError: LocalizedError {
    case invalidPassword
    case notUnlocked
    case entryNotFound
    case invalidFormat
    
    var errorDescription: String? {
        switch self {
        case .invalidPassword:
            return "Invalid master password"
        case .notUnlocked:
            return "Vault is not unlocked"
        case .entryNotFound:
            return "Entry not found"
        case .invalidFormat:
            return "Invalid data format"
        }
    }
}

struct ImportResult {
    let newEntriesCount: Int
    let existingEntriesCount: Int
    let totalEntriesCount: Int
    let isError: Bool
    
    static func error() -> ImportResult {
        return ImportResult(
            newEntriesCount: 0,
            existingEntriesCount: 0,
            totalEntriesCount: 0,
            isError: true
        )
    }
}

// MARK: - CSV Import Support

extension PasswordVaultStore {
    /// Parse CSV data into PasswordEntry array.
    /// Supports common CSV formats from password managers like NordPass, LastPass, 1Password, etc.
    private func parseCsvImport(csvData: String) throws -> [PasswordEntry] {
        let lines = csvData.components(separatedBy: .newlines)
        guard !lines.isEmpty else { return [] }
        
        // Parse header to find column indices
        let headerLine = lines[0]
        let headers = parseCsvLine(headerLine)
        
        // Find column indices (case-insensitive)
        let urlIndex = headers.firstIndex { $0.lowercased().contains("url") || $0.lowercased().contains("website") || $0.lowercased().contains("site") } ?? -1
        let usernameIndex = headers.firstIndex { $0.lowercased().contains("username") || $0.lowercased().contains("login") || $0.lowercased().contains("email") } ?? -1
        let passwordIndex = headers.firstIndex { $0.lowercased().contains("password") } ?? -1
        let nameIndex = headers.firstIndex { $0.lowercased().contains("name") || $0.lowercased().contains("title") } ?? -1
        let notesIndex = headers.firstIndex { $0.lowercased().contains("note") || $0.lowercased().contains("comment") } ?? -1
        
        guard passwordIndex >= 0 else {
            throw PasswordVaultError.invalidFormat
        }
        
        // Parse data rows
        var entries: [PasswordEntry] = []
        for i in 1..<lines.count {
            let line = lines[i].trimmingCharacters(in: .whitespaces)
            guard !line.isEmpty else { continue }
            
            let values = parseCsvLine(line)
            guard values.count > max(urlIndex, usernameIndex, passwordIndex, nameIndex, notesIndex) else { continue }
            
            let serviceValue = nameIndex >= 0 && nameIndex < values.count ? values[nameIndex].trimmingCharacters(in: .whitespaces) :
                              (urlIndex >= 0 && urlIndex < values.count ? values[urlIndex].trimmingCharacters(in: .whitespaces) : "Unknown")
            let usernameValue = usernameIndex >= 0 && usernameIndex < values.count ? values[usernameIndex].trimmingCharacters(in: .whitespaces) : ""
            let passwordValue = passwordIndex >= 0 && passwordIndex < values.count ? values[passwordIndex].trimmingCharacters(in: .whitespaces) : ""
            let notesValue = notesIndex >= 0 && notesIndex < values.count ? values[notesIndex].trimmingCharacters(in: .whitespaces) : ""
            
            // Extract domain from URL if service is a URL
            let service: String
            if serviceValue.hasPrefix("http://") || serviceValue.hasPrefix("https://") {
                if let url = URL(string: serviceValue), let host = url.host {
                    service = host
                } else {
                    service = serviceValue
                }
            } else {
                service = serviceValue.isEmpty ? "Imported Entry" : serviceValue
            }
            
            guard !service.isEmpty && !passwordValue.isEmpty else { continue }
            
            let username = usernameValue
            let password = passwordValue
            let notes = notesValue
            
            let entry = PasswordEntry(
                service: service,
                username: username,
                password: password,
                notes: notes,
                category: "",
                categories: []
            )
            entries.append(entry)
        }
        
        return entries
    }
    
    /// Parse a CSV line, handling quoted fields and escaped quotes.
    private func parseCsvLine(_ line: String) -> [String] {
        var fields: [String] = []
        var currentField = ""
        var inQuotes = false
        var i = line.startIndex
        
        while i < line.endIndex {
            let char = line[i]
            let nextIndex = line.index(after: i)
            
            if char == "\"" {
                if inQuotes && nextIndex < line.endIndex && line[nextIndex] == "\"" {
                    // Escaped quote
                    currentField.append("\"")
                    i = line.index(after: nextIndex)
                } else {
                    // Toggle quote state
                    inQuotes.toggle()
                    i = nextIndex
                }
            } else if char == "," && !inQuotes {
                // Field separator
                fields.append(currentField.trimmingCharacters(in: .whitespaces))
                currentField = ""
                i = nextIndex
            } else {
                currentField.append(char)
                i = nextIndex
            }
        }
        
        // Add last field
        fields.append(currentField.trimmingCharacters(in: .whitespaces))
        
        return fields
    }
    
    // MARK: - Shared Storage Sync
    
    /// Sync encrypted vault data to shared storage for AutoFill extension
    private func syncVaultDataToSharedStorage(encryptedData: String) {
        // The encrypted data format is "mode:base64..." (e.g., "gcm:base64string")
        // Extract the base64 part after the colon
        let parts = encryptedData.split(separator: ":", maxSplits: 1)
        guard parts.count == 2, let base64Data = Data(base64Encoded: String(parts[1])) else {
            // Fallback: store as UTF-8 if parsing fails
            if let data = encryptedData.data(using: .utf8) {
                vaultDataManager.saveEncryptedVault(data)
            }
            return
        }
        vaultDataManager.saveEncryptedVault(base64Data)
    }
    
    // MARK: - Autofill Integration
    
    /// Register a credential with iOS Autofill system
    private func registerCredentialWithAutofill(_ entry: PasswordEntry) {
        #if canImport(AuthenticationServices)
        let store = ASCredentialIdentityStore.shared
        let serviceIdentifier = ASCredentialServiceIdentifier(
            identifier: entry.service,
            type: .URL
        )
        
        let credentialIdentity = ASPasswordCredentialIdentity(
            serviceIdentifier: serviceIdentifier,
            user: entry.username,
            recordIdentifier: entry.id
        )
        
        store.saveCredentialIdentities([credentialIdentity]) { success, error in
            if let error = error {
                print("PasswordVaultStore: Error registering credential with Autofill: \(error.localizedDescription)")
            } else {
                print("PasswordVaultStore: Successfully registered credential for \(entry.service)")
            }
        }
        #endif
    }
    
    /// Remove a credential from iOS Autofill system
    private func removeCredentialFromAutofill(_ entry: PasswordEntry) {
        #if canImport(AuthenticationServices)
        let store = ASCredentialIdentityStore.shared
        let serviceIdentifier = ASCredentialServiceIdentifier(
            identifier: entry.service,
            type: .URL
        )
        
        let credentialIdentity = ASPasswordCredentialIdentity(
            serviceIdentifier: serviceIdentifier,
            user: entry.username,
            recordIdentifier: entry.id
        )
        
        store.removeCredentialIdentities([credentialIdentity]) { success, error in
            if let error = error {
                print("PasswordVaultStore: Error removing credential from Autofill: \(error.localizedDescription)")
            } else {
                print("PasswordVaultStore: Successfully removed credential for \(entry.service)")
            }
        }
        #endif
    }
    
    /// Register all credentials with iOS Autofill system
    func registerAllCredentialsWithAutofill() {
        guard let masterPassword = currentMasterPassword else {
            return
        }
        
        do {
            let allEntries = try getAllEntries(masterPassword: masterPassword)
            #if canImport(AuthenticationServices)
            let store = ASCredentialIdentityStore.shared
            let credentialIdentities = allEntries.map { entry -> ASPasswordCredentialIdentity in
                let serviceIdentifier = ASCredentialServiceIdentifier(
                    identifier: entry.service,
                    type: .URL
                )
                return ASPasswordCredentialIdentity(
                    serviceIdentifier: serviceIdentifier,
                    user: entry.username,
                    recordIdentifier: entry.id
                )
            }
            
            store.replaceCredentialIdentities(with: credentialIdentities) { success, error in
                if let error = error {
                    print("PasswordVaultStore: Error registering all credentials: \(error.localizedDescription)")
                } else {
                    print("PasswordVaultStore: Successfully registered \(credentialIdentities.count) credentials")
                }
            }
            #endif
        } catch {
            print("PasswordVaultStore: Error loading entries for Autofill registration: \(error.localizedDescription)")
        }
    }
}

