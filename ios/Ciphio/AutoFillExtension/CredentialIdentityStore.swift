//
//  CredentialIdentityStore.swift
//  AutoFillExtension
//
//  Credential Identity Store for iOS Autofill Save functionality
//  This class manages credential registration with iOS system
//

import AuthenticationServices
import Foundation

/// Manages credential identities for iOS Autofill
/// This allows iOS to save new credentials when users log in to websites/apps
class CredentialIdentityStore: NSObject {
    
    static let shared = CredentialIdentityStore()
    
    private let store = ASCredentialIdentityStore.shared
    
    private override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    
    /// Register all credentials from vault with iOS system
    /// This should be called when credentials are added/updated in the vault
    func registerCredentials(from entries: [PasswordEntry]) {
        let credentialIdentities = entries.map { entry -> ASPasswordCredentialIdentity in
            let serviceIdentifier = ASCredentialServiceIdentifier(
                identifier: entry.service,
                type: .URL
            )
            
            let credentialIdentity = ASPasswordCredentialIdentity(
                serviceIdentifier: serviceIdentifier,
                user: entry.username,
                recordIdentifier: entry.id
            )
            
            return credentialIdentity
        }
        
        store.replaceCredentialIdentities(with: credentialIdentities) { success, error in
            if let error = error {
                print("CredentialIdentityStore: Error registering credentials: \(error.localizedDescription)")
            } else {
                print("CredentialIdentityStore: Successfully registered \(credentialIdentities.count) credentials")
            }
        }
    }
    
    /// Register a single credential with iOS system
    func registerCredential(entry: PasswordEntry) {
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
                print("CredentialIdentityStore: Error registering credential: \(error.localizedDescription)")
            } else {
                print("CredentialIdentityStore: Successfully registered credential for \(entry.service)")
            }
        }
    }
    
    /// Remove a credential from iOS system
    func removeCredential(entry: PasswordEntry) {
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
                print("CredentialIdentityStore: Error removing credential: \(error.localizedDescription)")
            } else {
                print("CredentialIdentityStore: Successfully removed credential for \(entry.service)")
            }
        }
    }
    
    /// Remove all credentials from iOS system
    func removeAllCredentials() {
        store.removeAllCredentialIdentities { success, error in
            if let error = error {
                print("CredentialIdentityStore: Error removing all credentials: \(error.localizedDescription)")
            } else {
                print("CredentialIdentityStore: Successfully removed all credentials")
            }
        }
    }
    
    /// Get the state of the credential identity store
    func getStoreState(completion: @escaping (ASCredentialIdentityStoreState) -> Void) {
        store.credentialIdentityStoreState(completion: completion)
    }
}

