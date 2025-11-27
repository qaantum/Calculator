import SwiftUI
import LocalAuthentication

struct MasterPasswordUnlockView: View {
    @ObservedObject var vaultStore: PasswordVaultStore
    let onUnlockComplete: () -> Void
    
    @State private var password = ""
    @State private var passwordVisible = false
    @State private var errorMessage: String?
    @State private var biometricAvailable = false
    @Environment(\.ciphioPalette) private var palette
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer()
                    .frame(height: 60)
                
                Image(systemName: "lock.fill")
                    .font(.system(size: 64))
                    .foregroundColor(palette.primary)
                
                Text("Unlock Vault")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(palette.foreground)
                
                Text("Enter your master password to access your password vault.")
                    .font(.body)
                    .foregroundColor(palette.mutedForeground)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Master Password")
                        .font(.subheadline)
                        .foregroundColor(palette.foreground)
                    
                    HStack {
                        if passwordVisible {
                            TextField("Enter password", text: $password)
                                .textFieldStyle(.plain)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                        } else {
                            SecureField("Enter password", text: $password)
                                .textFieldStyle(.plain)
                        }
                        
                        Button(action: { passwordVisible.toggle() }) {
                            Image(systemName: passwordVisible ? "eye.slash" : "eye")
                                .foregroundColor(palette.mutedForeground)
                        }
                    }
                    .padding()
                    .background(palette.input, in: RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(palette.border, lineWidth: 1)
                    )
                }
                .padding(.horizontal)
                
                if let error = errorMessage {
                    Text(error)
                        .font(.body)
                        .foregroundColor(palette.destructive)
                        .padding(.horizontal)
                }
                
                Button(action: unlockVault) {
                    Text("Unlock")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(palette.onPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(palette.primary, in: RoundedRectangle(cornerRadius: 12))
                }
                .disabled(password.isEmpty)
                .opacity(password.isEmpty ? 0.5 : 1.0)
                .padding(.horizontal)
                
                // Biometric unlock button if available
                if biometricAvailable && vaultStore.isBiometricEnabled() {
                    Button(action: unlockWithBiometric) {
                        HStack {
                            Image(systemName: biometricType == .faceID ? "faceid" : "touchid")
                            Text("Unlock with \(biometricType == .faceID ? "Face ID" : "Touch ID")")
                        }
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(palette.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(palette.card, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(palette.primary, lineWidth: 2)
                        )
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .background(palette.background)
        .onAppear {
            checkBiometricAvailability()
        }
    }
    
    private var biometricType: LABiometryType {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return context.biometryType
    }
    
    private func checkBiometricAvailability() {
        let context = LAContext()
        var error: NSError?
        biometricAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    private func unlockVault() {
        errorMessage = nil
        
        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty"
            return
        }
        
        do {
            try vaultStore.unlock(masterPassword: password)
            onUnlockComplete()
        } catch {
            errorMessage = "Incorrect password"
            password = ""
        }
    }
    
    private func unlockWithBiometric() {
        let context = LAContext()
        context.localizedFallbackTitle = "Use Password"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock your password vault") { success, error in
            DispatchQueue.main.async {
                if success {
                    do {
                        let retrievedPassword = try vaultStore.retrieveMasterPasswordFromKeychain(context: context)
                        try vaultStore.unlock(masterPassword: retrievedPassword)
                        onUnlockComplete()
                    } catch {
                        errorMessage = "Failed to unlock with biometric: \(error.localizedDescription)"
                    }
                } else {
                    if let error = error as? LAError {
                        switch error.code {
                        case .userCancel, .userFallback, .systemCancel:
                            break // User cancelled, do nothing
                        default:
                            errorMessage = "Biometric authentication failed"
                        }
                    }
                }
            }
        }
    }
}

