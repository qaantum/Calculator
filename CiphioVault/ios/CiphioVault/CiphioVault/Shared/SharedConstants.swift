//
//  SharedConstants.swift
//  Shared between main app and AutoFill extension
//

import Foundation

struct SharedConstants {
    // App Group for sharing data between main app and extension
    static let appGroupIdentifier = "group.com.ciphio.vault"
    
    // Keychain access group for sharing biometric keys
    static let keychainAccessGroup = "$(AppIdentifierPrefix)com.ciphio.vault"
    
    // UserDefaults keys for shared data
    static let vaultDataKey = "encrypted_vault_data"
    static let masterPasswordHashKey = "master_password_hash"
    static let biometricEnabledKey = "biometric_enabled"
    static let lastSyncTimestampKey = "last_sync_timestamp"
    
    // Keychain keys
    static let biometricKeyTag = "com.ciphio.vault.biometric.key"
    static let encryptedMasterPasswordKey = "com.ciphio.vault.encrypted.master.password"
}
