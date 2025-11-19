import SwiftUI

struct ChangeMasterPasswordView: View {
    @ObservedObject var vaultStore: PasswordVaultStore
    let onComplete: () -> Void
    
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var currentPasswordVisible = false
    @State private var newPasswordVisible = false
    @State private var confirmPasswordVisible = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @Environment(\.cryptatextPalette) private var palette
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Spacer()
                        .frame(height: 20)
                    
                    Image(systemName: "key.fill")
                        .font(.system(size: 64))
                        .foregroundColor(palette.primary)
                    
                    Text("Change Master Password")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(palette.foreground)
                    
                    Text("Enter your current password and choose a new one. All your passwords will be re-encrypted.")
                        .font(.body)
                        .foregroundColor(palette.mutedForeground)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        // Current password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Current Password")
                                .font(.subheadline)
                                .foregroundColor(palette.foreground)
                            
                            HStack {
                                if currentPasswordVisible {
                                    TextField("Enter current password", text: $currentPassword)
                                        .textFieldStyle(.plain)
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled()
                                } else {
                                    SecureField("Enter current password", text: $currentPassword)
                                        .textFieldStyle(.plain)
                                }
                                
                                Button(action: { currentPasswordVisible.toggle() }) {
                                    Image(systemName: currentPasswordVisible ? "eye.slash" : "eye")
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
                        
                        // New password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("New Password")
                                .font(.subheadline)
                                .foregroundColor(palette.foreground)
                            
                            HStack {
                                if newPasswordVisible {
                                    TextField("Enter new password", text: $newPassword)
                                        .textFieldStyle(.plain)
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled()
                                } else {
                                    SecureField("Enter new password", text: $newPassword)
                                        .textFieldStyle(.plain)
                                }
                                
                                Button(action: { newPasswordVisible.toggle() }) {
                                    Image(systemName: newPasswordVisible ? "eye.slash" : "eye")
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
                        
                        // Confirm new password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm New Password")
                                .font(.subheadline)
                                .foregroundColor(palette.foreground)
                            
                            HStack {
                                if confirmPasswordVisible {
                                    TextField("Re-enter new password", text: $confirmPassword)
                                        .textFieldStyle(.plain)
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled()
                                } else {
                                    SecureField("Re-enter new password", text: $confirmPassword)
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
                    
                    if let success = successMessage {
                        Text(success)
                            .font(.body)
                            .foregroundColor(palette.success)
                            .padding(.horizontal)
                    }
                    
                    Button(action: changePassword) {
                        Text("Change Password")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(palette.onPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(palette.primary, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty)
                    .opacity(currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty ? 0.5 : 1.0)
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .background(palette.background)
            .navigationTitle("Change Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(palette.foreground)
                }
            }
        }
    }
    
    private func changePassword() {
        errorMessage = nil
        successMessage = nil
        
        guard !currentPassword.isEmpty else {
            errorMessage = "Current password cannot be empty"
            return
        }
        
        guard !newPassword.isEmpty else {
            errorMessage = "New password cannot be empty"
            return
        }
        
        guard newPassword == confirmPassword else {
            errorMessage = "New passwords do not match"
            return
        }
        
        guard newPassword.count >= 6 else {
            errorMessage = "New password must be at least 6 characters"
            return
        }
        
        guard newPassword != currentPassword else {
            errorMessage = "New password must be different from current password"
            return
        }
        
        do {
            try vaultStore.changeMasterPassword(oldPassword: currentPassword, newPassword: newPassword)
            successMessage = "Password changed successfully!"
            
            // Clear fields
            currentPassword = ""
            newPassword = ""
            confirmPassword = ""
            
            // Go back after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onComplete()
            }
        } catch {
            errorMessage = "Failed to change password: \(error.localizedDescription)"
            currentPassword = ""
        }
    }
}

