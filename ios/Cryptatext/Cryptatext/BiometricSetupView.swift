import SwiftUI
import LocalAuthentication

struct BiometricSetupView: View {
    @ObservedObject var vaultStore: PasswordVaultStore
    let onDismiss: () -> Void
    
    @State private var isAuthenticating = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @Environment(\.cryptatextPalette) private var palette
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "faceid")
                    .font(.system(size: 64))
                    .foregroundColor(palette.primary)
                
                Text("Enable Biometric Unlock")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(palette.foreground)
                
                Text("Store your master password securely in Keychain. You'll be able to unlock your vault using Face ID or Touch ID.")
                    .font(.body)
                    .foregroundColor(palette.mutedForeground)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                if let error = errorMessage {
                    Text(error)
                        .font(.body)
                        .foregroundColor(palette.destructive)
                        .padding(.horizontal)
                }
                
                if let success = successMessage {
                    Text(success)
                        .font(.body)
                        .foregroundColor(palette.success)
                        .padding(.horizontal)
                }
                
                Button(action: enableBiometric) {
                    if isAuthenticating {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(palette.onPrimary)
                    } else {
                        Text("Enable Biometric Unlock")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(palette.onPrimary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(palette.primary, in: RoundedRectangle(cornerRadius: 12))
                .disabled(isAuthenticating)
                .padding(.horizontal)
                
                Button(action: onDismiss) {
                    Text("Cancel")
                        .font(.system(size: 17))
                        .foregroundColor(palette.mutedForeground)
                }
            }
            .padding(.vertical, 40)
            .navigationTitle("Biometric Setup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: onDismiss)
                }
            }
        }
    }
    
    private func enableBiometric() {
        guard let masterPassword = vaultStore.currentMasterPassword else {
            errorMessage = "Vault must be unlocked to enable biometric unlock"
            return
        }
        
        isAuthenticating = true
        errorMessage = nil
        successMessage = nil
        
        let context = LAContext()
        context.localizedFallbackTitle = "Use Password"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Enable biometric unlock for your password vault") { success, error in
            DispatchQueue.main.async {
                isAuthenticating = false
                
                if success {
                    do {
                        // Store master password in Keychain
                        try vaultStore.setMasterPassword(masterPassword, enableBiometric: true)
                        successMessage = "Biometric unlock enabled successfully!"
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            onDismiss()
                        }
                    } catch {
                        errorMessage = "Failed to enable biometric unlock: \(error.localizedDescription)"
                    }
                } else {
                    if let error = error {
                        if let laError = error as? LAError, laError.code == .userCancel {
                            // User cancelled - don't show error
                            return
                        }
                        errorMessage = "Biometric authentication failed: \(error.localizedDescription)"
                    } else {
                        errorMessage = "Biometric authentication failed"
                    }
                }
            }
        }
    }
}


