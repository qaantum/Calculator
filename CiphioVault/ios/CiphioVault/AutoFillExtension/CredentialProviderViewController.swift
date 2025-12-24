//
//  CredentialProviderViewController.swift
//  AutoFillExtension
//
//  Created by Kaan Gul on 29.11.2025.
//

import AuthenticationServices
import LocalAuthentication
import Foundation

class CredentialProviderViewController: ASCredentialProviderViewController {
    
    private var allEntries: [PasswordEntry] = []
    private var masterPassword: String?
    
    // MARK: - Credential List
    
    override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
        // Load credentials from vault
        loadCredentials { [weak self] success in
            guard let self = self else { return }
            
            if success {
                // Filter credentials matching the requested services
                _ = self.filterEntries(for: serviceIdentifiers)
                
                // Present credentials to user
                // Note: This would typically show a UI with matching credentials
                // For now, we'll handle it in provideCredentialWithoutUserInteraction
            } else {
                // Show error or authentication UI
                self.showError("Failed to load credentials. Please unlock the vault in the main app first.")
            }
        }
    }
    
    // MARK: - QuickType Bar Support
    
    override func provideCredentialWithoutUserInteraction(for credentialIdentity: ASPasswordCredentialIdentity) {
        // Load credentials and find matching entry
        loadCredentials { [weak self] success in
            guard let self = self, success else {
                self?.extensionContext.cancelRequest(withError: NSError(
                    domain: ASExtensionErrorDomain,
                    code: ASExtensionError.userInteractionRequired.rawValue
                ))
                return
            }
            
            // Find matching entry
            guard let entry = self.findEntry(for: credentialIdentity) else {
                self.extensionContext.cancelRequest(withError: NSError(
                    domain: ASExtensionErrorDomain,
                    code: ASExtensionError.credentialIdentityNotFound.rawValue
                ))
                return
            }
            
            // Provide credential
            let passwordCredential = ASPasswordCredential(user: entry.username, password: entry.password)
            self.extensionContext.completeRequest(withSelectedCredential: passwordCredential, completionHandler: nil)
        }
    }
    
    // MARK: - User Interaction Required
    
    override func prepareInterfaceToProvideCredential(for credentialIdentity: ASPasswordCredentialIdentity) {
        // This is called when user interaction is required (e.g., biometric auth)
        // Load credentials with authentication
        authenticateAndLoadCredentials { [weak self] success in
            guard let self = self, success else {
                self?.extensionContext.cancelRequest(withError: NSError(
                    domain: ASExtensionErrorDomain,
                    code: ASExtensionError.userCanceled.rawValue
                ))
                return
            }
            
            // Find matching entry
            guard let entry = self.findEntry(for: credentialIdentity) else {
                self.extensionContext.cancelRequest(withError: NSError(
                    domain: ASExtensionErrorDomain,
                    code: ASExtensionError.credentialIdentityNotFound.rawValue
                ))
                return
            }
            
            // Provide credential
            let passwordCredential = ASPasswordCredential(user: entry.username, password: entry.password)
            self.extensionContext.completeRequest(withSelectedCredential: passwordCredential, completionHandler: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: AnyObject?) {
        extensionContext.cancelRequest(withError: NSError(
            domain: ASExtensionErrorDomain,
            code: ASExtensionError.userCanceled.rawValue
        ))
    }
    
    @IBAction func passwordSelected(_ sender: AnyObject?) {
        // This would be called from UI if we had a credential selection interface
        // For now, credentials are provided via QuickType bar
    }
    
    // MARK: - Helper Methods
    
    private func loadCredentials(completion: @escaping (Bool) -> Void) {
        // Try to get master password from keychain (biometric)
        let context = LAContext()
        let keychainHelper = KeychainHelper()
        
        do {
            let password = try keychainHelper.retrieveMasterPassword(context: context)
            self.masterPassword = password
            loadAndDecryptVault(password: password, completion: completion)
        } catch {
            // Biometric failed or not available - require user interaction
            completion(false)
        }
    }
    
    private func authenticateAndLoadCredentials(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        let keychainHelper = KeychainHelper()
        
        do {
            let password = try keychainHelper.retrieveMasterPassword(context: context)
            self.masterPassword = password
            loadAndDecryptVault(password: password, completion: completion)
        } catch {
            showError("Authentication required. Please unlock the vault in the main app first.")
            completion(false)
        }
    }
    
    private func loadAndDecryptVault(password: String, completion: @escaping (Bool) -> Void) {
        guard let encryptedData = VaultDataManager.shared.loadEncryptedVault() else {
            completion(false)
            return
        }
        
        do {
            let entries = try VaultDataManager.shared.decryptVault(encryptedData: encryptedData, masterPassword: password)
            self.allEntries = entries
            completion(true)
        } catch {
            print("CredentialProvider: Failed to decrypt vault: \(error)")
            completion(false)
        }
    }
    
    private func filterEntries(for serviceIdentifiers: [ASCredentialServiceIdentifier]) -> [PasswordEntry] {
        guard !serviceIdentifiers.isEmpty else {
            return allEntries
        }
        
        // Extract domains from service identifiers
        let domains = serviceIdentifiers.compactMap { identifier -> String? in
            guard let url = URL(string: identifier.identifier) else { return nil }
            return url.host ?? identifier.identifier
        }
        
        // Filter entries that match any of the domains
        return allEntries.filter { entry in
            let entryService = entry.service.lowercased()
            return domains.contains { domain in
                entryService.contains(domain.lowercased())
            }
        }
    }
    
    private func findEntry(for credentialIdentity: ASPasswordCredentialIdentity) -> PasswordEntry? {
        // Find entry by record identifier (entry ID)
        if let recordId = credentialIdentity.recordIdentifier {
            return allEntries.first { $0.id == recordId }
        }
        
        // Fallback: find by service and username
        let service = credentialIdentity.serviceIdentifier.identifier.lowercased()
        let username = credentialIdentity.user
        
        return allEntries.first { entry in
            entry.service.lowercased() == service && entry.username == username
        }
    }
    
    private func showError(_ message: String) {
        // In a real implementation, you'd show this in the UI
        print("CredentialProvider Error: \(message)")
    }
}
