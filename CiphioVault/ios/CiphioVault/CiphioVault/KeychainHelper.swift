import Foundation
import Security
import LocalAuthentication

/// Helper class for securely storing and retrieving the master password
/// using iOS Keychain with biometric authentication.
///
/// This allows biometric unlock to work by storing the master password
/// encrypted in iOS Keychain, which can only be decrypted with
/// biometric authentication.
final class KeychainHelper {
    
    private let service = "com.ciphio.passwordmanager"
    private let account = "master_password"
    
    init() {
        // No migration needed - fresh start
    }
    
    /// Check if master password is stored in Keychain.
    func hasStoredPassword() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: false
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// Store the master password in Keychain with biometric protection.
    /// This requires biometric authentication to access.
    func storeMasterPassword(_ password: String) throws {
        // Delete existing entry if it exists
        deleteMasterPassword()
        
        guard let passwordData = password.data(using: .utf8) else {
            throw KeychainError.invalidInput
        }
        
        // Create access control that requires biometric authentication
        var error: Unmanaged<CFError>?
        guard let accessControl = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            [.biometryAny],
            &error
        ) else {
            throw KeychainError.accessControlCreationFailed
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: passwordData,
            kSecAttrAccessControl as String: accessControl
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.storeFailed(status: status)
        }
    }
    
    /// Retrieve the master password from Keychain using biometric authentication.
    /// This will trigger a biometric prompt automatically via the access control.
    /// The context parameter is used to customize the biometric prompt.
    /// Note: This must be called from the main thread as Keychain operations with biometric
    /// require UI interaction and will block until the user completes authentication.
    func retrieveMasterPassword(context: LAContext) throws -> String {
        // Set up the context for the biometric prompt
        context.localizedFallbackTitle = "Use Password"
        
        // The biometric prompt is triggered automatically when accessing
        // a Keychain item with kSecAttrAccessControl that requires biometric.
        // The context properties are used by the system to customize the prompt.
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            // Check for user cancellation (errSecUserCancel = -128)
            if status == -128 {
                throw KeychainError.userCancelled
            } else if status == errSecAuthFailed {
                throw KeychainError.authenticationFailed
            } else {
                throw KeychainError.retrieveFailed(status: status)
            }
        }
        
        guard let data = result as? Data,
              let password = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidData
        }
        
        return password
    }
    
    /// Delete the master password from Keychain.
    func deleteMasterPassword() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

enum KeychainError: LocalizedError {
    case invalidInput
    case accessControlCreationFailed
    case storeFailed(status: OSStatus)
    case retrieveFailed(status: OSStatus)
    case authenticationFailed
    case userCancelled
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Invalid password input"
        case .accessControlCreationFailed:
            return "Failed to create access control"
        case .storeFailed(let status):
            return "Failed to store password in Keychain (status: \(status))"
        case .retrieveFailed(let status):
            return "Failed to retrieve password from Keychain (status: \(status))"
        case .authenticationFailed:
            return "Biometric authentication failed"
        case .userCancelled:
            return "Biometric authentication was cancelled"
        case .invalidData:
            return "Invalid data retrieved from Keychain"
        }
    }
}

