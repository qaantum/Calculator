//
//  CredentialProviderViewController.swift
//  AutoFillExtension
//
//  AutoFill Credential Provider for Ciphio Vault
//

import AuthenticationServices
import LocalAuthentication
import SwiftUI

class CredentialProviderViewController: ASCredentialProviderViewController {
    
    private var entries: [PasswordEntry] = []
    private var requestedDomain: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // We'll use SwiftUI for the UI
        let hostingController = UIHostingController(rootView: CredentialListView(
            entries: entries,
            domain: requestedDomain ?? "",
            onSelect: { [weak self] entry in
                self?.provideCredential(entry)
            },
            onCancel: { [weak self] in
                self?.extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.userCanceled.rawValue))
            }
        ))
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.didMove(toParent: self)
    }
    
    // MARK: - Prepare Credential List
    
    override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
        // Extract domain from service identifiers
        requestedDomain = serviceIdentifiers.first?.identifier
        
        // Authenticate and load credentials
        authenticateAndLoadCredentials { [weak self] success in
            if !success {
                self?.extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.userCanceled.rawValue))
            }
        }
    }
    
    // MARK: - Provide Credential Without User Interaction
    
    override func provideCredentialWithoutUserInteraction(for credentialIdentity: ASPasswordCredentialIdentity) {
        // Try to provide credential quickly if recently authenticated
        // For security, we'll always require authentication
        extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.userInteractionRequired.rawValue))
    }
    
    // MARK: - Provide Credential With User Interaction
    
    override func prepareInterfaceToProvideCredential(for credentialIdentity: ASPasswordCredentialIdentity) {
        requestedDomain = credentialIdentity.serviceIdentifier.identifier
        
        // Authenticate and load credentials
        authenticateAndLoadCredentials { [weak self] success in
            if !success {
                self?.extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.userCanceled.rawValue))
            } else {
                // Find the specific credential
                if let entry = self?.entries.first(where: { $0.id.uuidString == credentialIdentity.recordIdentifier }) {
                    self?.provideCredential(entry)
                }
            }
        }
    }
    
    // MARK: - Extension Configuration
    
    override func prepareInterfaceForExtensionConfiguration() {
        // Show configuration UI (optional)
        let message = "Please open the Ciphio Vault app to configure your password vault."
        let alert = UIAlertController(title: "Configuration Required", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.extensionContext.completeExtensionConfigurationRequest()
        })
        present(alert, animated: true)
    }
    
    // MARK: - Authentication
    
    private func authenticateAndLoadCredentials(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometric is available
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // Fallback to password authentication
            promptForMasterPassword(completion: completion)
            return
        }
        
        // Check if biometric is enabled
        guard VaultDataManager.shared.isBiometricEnabled() else {
            promptForMasterPassword(completion: completion)
            return
        }
        
        // Authenticate with biometric
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock Ciphio Vault to autofill password") { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.loadCredentials(completion: completion)
                } else {
                    // Biometric failed, try password
                    self?.promptForMasterPassword(completion: completion)
                }
            }
        }
    }
    
    private func promptForMasterPassword(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Enter Master Password", message: "Unlock your vault to access passwords", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Master Password"
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        })
        
        alert.addAction(UIAlertAction(title: "Unlock", style: .default) { [weak self, weak alert] _ in
            guard let password = alert?.textFields?.first?.text, !password.isEmpty else {
                completion(false)
                return
            }
            
            self?.loadCredentials(withPassword: password, completion: completion)
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - Load Credentials
    
    private func loadCredentials(withPassword password: String? = nil, completion: @escaping (Bool) -> Void) {
        // Load encrypted vault from shared storage
        guard let encryptedData = VaultDataManager.shared.loadEncryptedVault() else {
            showError("No vault data found. Please unlock the vault in the main app first.")
            completion(false)
            return
        }
        
        // Get master password
        let masterPassword: String
        if let providedPassword = password {
            // Verify password
            guard verifyMasterPassword(providedPassword) else {
                showError("Incorrect master password")
                completion(false)
                return
            }
            masterPassword = providedPassword
        } else {
            // Try to get from biometric keychain
            guard let storedPassword = retrieveMasterPasswordFromKeychain() else {
                promptForMasterPassword(completion: completion)
                return
            }
            masterPassword = storedPassword
        }
        
        // Decrypt vault
        do {
            let allEntries = try VaultDataManager.shared.decryptVault(encryptedData: encryptedData, masterPassword: masterPassword)
            
            // Filter by domain if requested
            if let domain = requestedDomain {
                entries = allEntries.filter { entry in
                    entry.service?.lowercased().contains(domain.lowercased()) ?? false
                }
            } else {
                entries = allEntries
            }
            
            completion(true)
        } catch {
            showError("Failed to decrypt vault: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    // MARK: - Provide Credential
    
    private func provideCredential(_ entry: PasswordEntry) {
        let credential = ASPasswordCredential(user: entry.username, password: entry.password)
        extensionContext.completeRequest(withSelectedCredential: credential, completionHandler: nil)
    }
    
    // MARK: - Helpers
    
    private func verifyMasterPassword(_ password: String) -> Bool {
        guard let storedHash = VaultDataManager.shared.loadMasterPasswordHash() else {
            return false
        }
        
        // Hash the provided password and compare
        let passwordHash = password.sha256Hash()
        return passwordHash == storedHash
    }
    
    private func retrieveMasterPasswordFromKeychain() -> String? {
        // Retrieve encrypted master password from shared keychain
        // This would use KeychainHelper with the shared access group
        // For now, return nil to force password entry
        return nil
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - SwiftUI Views

struct CredentialListView: View {
    let entries: [PasswordEntry]
    let domain: String
    let onSelect: (PasswordEntry) -> Void
    let onCancel: () -> Void
    
    @State private var searchText = ""
    
    var filteredEntries: [PasswordEntry] {
        if searchText.isEmpty {
            return entries
        }
        return entries.filter { entry in
            entry.username.lowercased().contains(searchText.lowercased()) ||
            (entry.service?.lowercased().contains(searchText.lowercased()) ?? false)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if entries.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "key.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No credentials found")
                            .font(.headline)
                        Text("for \(domain)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                } else {
                    List(filteredEntries) { entry in
                        Button(action: {
                            onSelect(entry)
                        }) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.username)
                                    .font(.headline)
                                if let service = entry.service {
                                    Text(service)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .searchable(text: $searchText, prompt: "Search credentials")
                }
            }
            .navigationTitle("Ciphio Vault")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
            }
        }
    }
}

// MARK: - String Extension for Hashing

extension String {
    func sha256Hash() -> String {
        guard let data = self.data(using: .utf8) else { return "" }
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

import CryptoKit
