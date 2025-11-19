import SwiftUI

struct ViewPasswordEntryView: View {
    let entry: PasswordEntry
    @ObservedObject var vaultStore: PasswordVaultStore
    let onEdit: (PasswordEntry) -> Void
    
    @State private var passwordVisible = false
    @State private var showDeleteConfirmation = false
    @Environment(\.cryptatextPalette) private var palette
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section("Service") {
                Text(entry.service)
                    .font(.system(size: 17))
            }
            
            Section("Credentials") {
                    HStack {
                        Text("Username")
                        Spacer()
                        Text(entry.username)
                            .foregroundColor(palette.mutedForeground)
                    }
                    
                    HStack {
                        Text("Password")
                        Spacer()
                        if passwordVisible {
                            Text(entry.password)
                                .foregroundColor(palette.mutedForeground)
                        } else {
                            Text(String(repeating: "•", count: 12))
                                .foregroundColor(palette.mutedForeground)
                        }
                        Button(action: { passwordVisible.toggle() }) {
                            Image(systemName: passwordVisible ? "eye.slash" : "eye")
                                .foregroundColor(palette.primary)
                        }
                    }
                    
                Button(action: copyPassword) {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        Text("Copy Password")
                    }
                }
            }
            
            if !entry.getAllCategories().isEmpty {
                Section("Categories") {
                    ForEach(entry.getAllCategories(), id: \.self) { category in
                        Text(category)
                    }
                }
            }
            
            if !entry.notes.isEmpty {
                Section("Notes") {
                    Text(entry.notes)
                        .font(.system(size: 15))
                }
            }
            
            Section {
                Button(role: .destructive, action: {
                    showDeleteConfirmation = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete Password")
                    }
                }
            }
        }
        .navigationTitle("Password Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    onEdit(entry)
                }
            }
        }
        .alert("Delete Password", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                Task {
                    do {
                        try await vaultStore.deleteEntry(id: entry.id)
                        await MainActor.run {
                            dismiss()
                        }
                    } catch {
                        // Handle error
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete the password for \(entry.service)?")
        }
    }
    
    private func copyPassword() {
        UIPasteboard.general.string = entry.password
    }
}