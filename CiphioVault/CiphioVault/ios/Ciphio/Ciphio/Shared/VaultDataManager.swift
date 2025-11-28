//
//  VaultDataManager.swift
//  Shared vault data management for main app and AutoFill extension
//

import Foundation
import CryptoKit

class VaultDataManager {
    static let shared = VaultDataManager()
    
    private let sharedDefaults: UserDefaults?
    
    private init() {
        sharedDefaults = UserDefaults(suiteName: SharedConstants.appGroupIdentifier)
    }
    
    // MARK: - Vault Data
    
    /// Save encrypted vault data to shared storage
    func saveEncryptedVault(_ data: Data) {
        sharedDefaults?.set(data, forKey: SharedConstants.vaultDataKey)
        sharedDefaults?.set(Date().timeIntervalSince1970, forKey: SharedConstants.lastSyncTimestampKey)
        sharedDefaults?.synchronize()
    }
    
    /// Load encrypted vault data from shared storage
    func loadEncryptedVault() -> Data? {
        return sharedDefaults?.data(forKey: SharedConstants.vaultDataKey)
    }
    
    /// Save master password hash
    func saveMasterPasswordHash(_ hash: String) {
        sharedDefaults?.set(hash, forKey: SharedConstants.masterPasswordHashKey)
        sharedDefaults?.synchronize()
    }
    
    /// Load master password hash
    func loadMasterPasswordHash() -> String? {
        return sharedDefaults?.string(forKey: SharedConstants.masterPasswordHashKey)
    }
    
    /// Check if biometric is enabled
    func isBiometricEnabled() -> Bool {
        return sharedDefaults?.bool(forKey: SharedConstants.biometricEnabledKey) ?? false
    }
    
    /// Set biometric enabled status
    func setBiometricEnabled(_ enabled: Bool) {
        sharedDefaults?.set(enabled, forKey: SharedConstants.biometricEnabledKey)
        sharedDefaults?.synchronize()
    }
    
    // MARK: - Decryption
    
    /// Decrypt vault data with master password
    func decryptVault(encryptedData: Data, masterPassword: String) throws -> [PasswordEntry] {
        // Derive key from master password
        let salt = Data("ciphio_vault_salt".utf8) // Use same salt as main app
        let key = try deriveKey(from: masterPassword, salt: salt)
        
        // Decrypt data
        let decryptedData = try decrypt(data: encryptedData, key: key)
        
        // Decode JSON
        let decoder = JSONDecoder()
        let entries = try decoder.decode([PasswordEntry].self, from: decryptedData)
        
        return entries
    }
    
    // MARK: - Encryption Helpers
    
    private func deriveKey(from password: String, salt: Data) throws -> SymmetricKey {
        guard let passwordData = password.data(using: .utf8) else {
            throw VaultError.invalidPassword
        }
        
        // Use PBKDF2 with SHA-256 (same as main app)
        let rounds = 100_000
        let derivedKey = try PBKDF2.deriveKey(
            password: passwordData,
            salt: salt,
            rounds: rounds,
            keyLength: 32
        )
        
        return SymmetricKey(data: derivedKey)
    }
    
    private func decrypt(data: Data, key: SymmetricKey) throws -> Data {
        // Extract nonce and ciphertext
        let nonceSize = 12
        guard data.count > nonceSize else {
            throw VaultError.invalidData
        }
        
        let nonce = data.prefix(nonceSize)
        let ciphertext = data.suffix(from: nonceSize)
        
        // Decrypt using AES-GCM
        let sealedBox = try AES.GCM.SealedBox(nonce: AES.GCM.Nonce(data: nonce), ciphertext: ciphertext)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        
        return decryptedData
    }
}

// MARK: - PBKDF2 Helper

struct PBKDF2 {
    static func deriveKey(password: Data, salt: Data, rounds: Int, keyLength: Int) throws -> Data {
        var derivedKeyData = Data(count: keyLength)
        
        let result = derivedKeyData.withUnsafeMutableBytes { derivedKeyBytes in
            salt.withUnsafeBytes { saltBytes in
                password.withUnsafeBytes { passwordBytes in
                    CCKeyDerivationPBKDF(
                        CCPBKDFAlgorithm(kCCPBKDF2),
                        passwordBytes.baseAddress?.assumingMemoryBound(to: Int8.self),
                        password.count,
                        saltBytes.baseAddress?.assumingMemoryBound(to: UInt8.self),
                        salt.count,
                        CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                        UInt32(rounds),
                        derivedKeyBytes.baseAddress?.assumingMemoryBound(to: UInt8.self),
                        keyLength
                    )
                }
            }
        }
        
        guard result == kCCSuccess else {
            throw VaultError.keyDerivationFailed
        }
        
        return derivedKeyData
    }
}

// MARK: - Errors

enum VaultError: Error {
    case invalidPassword
    case invalidData
    case keyDerivationFailed
    case decryptionFailed
}

import CommonCrypto
