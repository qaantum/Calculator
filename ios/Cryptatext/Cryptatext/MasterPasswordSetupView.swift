import SwiftUI

struct MasterPasswordSetupView: View {
    @ObservedObject var vaultStore: PasswordVaultStore
    let onSetupComplete: () -> Void
    
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var passwordVisible = false
    @State private var confirmPasswordVisible = false
    @State private var errorMessage: String?
    @Environment(\.cryptatextPalette) private var palette
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer()
                    .frame(height: 40)
                
                Image(systemName: "lock.shield")
                    .font(.system(size: 64))
                    .foregroundColor(palette.primary)
                
                Text("Set Master Password")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(palette.foreground)
                
                Text("Create a master password to secure your password vault. This password will be required to access your stored passwords.")
                    .font(.body)
                    .foregroundColor(palette.mutedForeground)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: 16) {
                    // Password field
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
                    
                    // Confirm password field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirm Password")
                            .font(.subheadline)
                            .foregroundColor(palette.foreground)
                        
                        HStack {
                            if confirmPasswordVisible {
                                TextField("Re-enter password", text: $confirmPassword)
                                    .textFieldStyle(.plain)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                            } else {
                                SecureField("Re-enter password", text: $confirmPassword)
                                    .textFieldStyle(.plain)
                            }
                            
                            Button(action: { confirmPasswordVisible.toggle() }) {
                                Image(systemName: confirmPasswordVisible ? "eye.slash" : "eye")
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
                }
                .padding(.horizontal)
                
                if let error = errorMessage {
                    Text(error)
                        .font(.body)
                        .foregroundColor(palette.destructive)
                        .padding(.horizontal)
                }
                
                Button(action: setupPassword) {
                    Text("Set Master Password")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(palette.onPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(palette.primary, in: RoundedRectangle(cornerRadius: 12))
                }
                .disabled(password.isEmpty || confirmPassword.isEmpty)
                .opacity(password.isEmpty || confirmPassword.isEmpty ? 0.5 : 1.0)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .background(palette.background)
    }
    
    private func setupPassword() {
        errorMessage = nil
        
        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return
        }
        
        do {
            try vaultStore.setMasterPassword(password)
            onSetupComplete()
        } catch {
            errorMessage = "Failed to set master password: \(error.localizedDescription)"
        }
    }
}

