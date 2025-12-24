import SwiftUI

struct AddEditPasswordEntryView: View {
    let entry: PasswordEntry?
    @ObservedObject var vaultStore: PasswordVaultStore
    let onSave: () -> Void
    
    @State private var service = ""
    @State private var username = ""
    @State private var password = ""
    @State private var notes = ""
    @State private var categories: [String] = []
    @State private var newCategory = ""
    @State private var passwordVisible = false
    @State private var errorMessage: String?
    @State private var showPasswordGenerator = false
    
    private let passwordGenerator = PasswordGenerator()
    @Environment(\.ciphioPalette) private var palette
    @Environment(\.dismiss) private var dismiss
    
    private var isEditing: Bool {
        entry != nil
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                serviceSection
                credentialsSection
                categoriesSection
                notesSection
                errorSection
                Spacer()
                    .frame(height: 20)
            }
            .padding(.top, 8)
        }
        .background(palette.background)
        .navigationTitle(isEditing ? "Edit Password" : "Add Password")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(palette.foreground)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveEntry()
                }
                .disabled(service.isEmpty || username.isEmpty || password.isEmpty)
                .foregroundColor(service.isEmpty || username.isEmpty || password.isEmpty ? palette.mutedForeground : palette.primary)
            }
        }
        .onAppear {
            if let entry = entry {
                service = entry.service
                username = entry.username
                password = entry.password
                notes = entry.notes
                categories = entry.getAllCategories()
            }
        }
    }
    
    private var serviceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("SERVICE")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(palette.mutedForeground)
                .textCase(.uppercase)
            
            TextField("Service/Website", text: $service)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .autocorrectionDisabled()
        }
        .padding(.horizontal)
    }
    
    private var credentialsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("CREDENTIALS")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(palette.mutedForeground)
                .textCase(.uppercase)
            
            VStack(spacing: 12) {
                TextField("Username/Email", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                
                HStack {
                    if passwordVisible {
                        TextField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Button(action: { passwordVisible.toggle() }) {
                        Image(systemName: passwordVisible ? "eye.slash" : "eye")
                            .foregroundColor(palette.primary)
                            .frame(width: 44, height: 44)
                    }
                    
                    Button(action: generatePassword) {
                        Image(systemName: "key")
                            .foregroundColor(palette.primary)
                            .frame(width: 44, height: 44)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("CATEGORIES")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(palette.mutedForeground)
                .textCase(.uppercase)
            
            if !categories.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { category in
                            HStack(spacing: 4) {
                                Text(category)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(palette.onPrimary)
                                Button(action: {
                                    categories.removeAll { $0 == category }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(palette.onPrimary)
                                        .font(.system(size: 14))
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(palette.primary, in: Capsule())
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            
            HStack {
                TextField("Add category", text: $newCategory)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        addCategory()
                    }
                Button(action: addCategory) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(palette.primary)
                        .font(.system(size: 24))
                        .frame(width: 44, height: 44)
                }
                .disabled(newCategory.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .padding(.horizontal)
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("NOTES")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(palette.mutedForeground)
                .textCase(.uppercase)
            
            TextEditor(text: $notes)
                .frame(minHeight: 120)
                .padding(8)
                .background(Color(uiColor: .systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(palette.border, lineWidth: 1)
                )
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var errorSection: some View {
        if let error = errorMessage {
            Text(error)
                .font(.body)
                .foregroundColor(palette.destructive)
            .padding(.horizontal)
        }
    }
    
    private func addCategory() {
        let trimmed = newCategory.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty && !categories.contains(trimmed) {
            categories.append(trimmed)
            newCategory = ""
        }
    }
    
    private func generatePassword() {
        let config = PasswordConfig(
            length: 16,
            includeUppercase: true,
            includeLowercase: true,
            includeDigits: true,
            includeSymbols: true
        )
        password = passwordGenerator.generate(config: config)
    }
    
    private func saveEntry() {
        guard !service.isEmpty && !username.isEmpty && !password.isEmpty else {
            errorMessage = "Please fill in all required fields"
            return
        }
        
        let entryToSave: PasswordEntry
        if let existingEntry = entry {
            entryToSave = PasswordEntry(
                id: existingEntry.id,
                service: service,
                username: username,
                password: password,
                notes: notes,
                category: "",
                categories: categories,
                createdAt: existingEntry.createdAt,
                updatedAt: Int64(Date().timeIntervalSince1970 * 1000)
            )
        } else {
            entryToSave = PasswordEntry(
                service: service,
                username: username,
                password: password,
                notes: notes,
                category: "",
                categories: categories
            )
        }
        
        // Use Task for async operations
        Task {
            do {
                if isEditing {
                    // Try to update first, if entry not found, fall back to add
                    do {
                        try await vaultStore.updateEntry(entryToSave)
                    } catch PasswordVaultError.entryNotFound {
                        // Entry not found, try adding it instead
                        try await vaultStore.addEntry(entryToSave)
                    }
                } else {
                    try await vaultStore.addEntry(entryToSave)
                }
                await MainActor.run {
                    errorMessage = nil
                    onSave()
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to save entry: \(error.localizedDescription)"
                }
            }
        }
    }
}
