import SwiftUI
import LocalAuthentication

struct PasswordManagerListView: View {
    @ObservedObject var vaultStore: PasswordVaultStore
    let onAddEntry: () -> Void
    let onViewEntry: (PasswordEntry) -> Void
    let onEditEntry: (PasswordEntry) -> Void
    let onChangePassword: () -> Void
    let onLock: () -> Void
    let isPremium: Bool
    let onPremiumPurchase: () -> Void
    
    @State private var searchQuery = ""
    @State private var debouncedSearchQuery = "" // Debounced version for filtering
    @State private var selectedCategory: String? = nil
    @State private var showExportSheet = false
    @State private var showImportSheet = false
    @State private var importText = ""
    @State private var showDeleteConfirmation: PasswordEntry? = nil
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @State private var biometricAvailable = false
    @State private var showBiometricSetup = false
    @Environment(\.ciphioPalette) private var palette
    
    // Cache for entry categories (computed once per entry)
    @State private var categoryCache: [String: [String]] = [:]
    
    // Memoized filtered entries with debouncing
    private var filteredEntries: [PasswordEntry] {
        let entries = vaultStore.entries
        
        // Early return if no filtering needed - return pre-sorted list
        let queryLower = debouncedSearchQuery.lowercased()
        let hasQuery = !queryLower.isEmpty
        let hasCategory = selectedCategory != nil
        
        guard hasQuery || hasCategory else {
            // No filtering - just return sorted entries
            return entries.sorted(by: { $0.updatedAt > $1.updatedAt })
        }
        
        // Update category cache for new entries
        for entry in entries where categoryCache[entry.id] == nil {
            categoryCache[entry.id] = entry.getAllCategories()
        }
        
        // Apply filters in single pass with cached categories
        let filtered = entries.filter { entry in
            let categories = categoryCache[entry.id] ?? []
            
            // Apply search filter (pre-lowercased query)
            let matchesSearch = !hasQuery || (
                entry.service.lowercased().contains(queryLower) ||
                entry.username.lowercased().contains(queryLower) ||
                entry.notes.lowercased().contains(queryLower) ||
                categories.contains { $0.lowercased().contains(queryLower) }
            )
            
            // Apply category filter with cached categories
            let matchesCategory = !hasCategory || categories.contains(selectedCategory!)
            
            return matchesSearch && matchesCategory
        }
        
        // Sort only the filtered subset
        return filtered.sorted(by: { $0.updatedAt > $1.updatedAt })
    }
    
    private var allCategories: [String] {
        // Memoize category computation
        let cached = categoryCache.values.flatMap { $0 }
        return Array(Set(cached)).sorted()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar with debouncing
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(palette.mutedForeground)
                TextField("Search passwords...", text: $searchQuery)
                    .textFieldStyle(.plain)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .onChange(of: searchQuery) { _, newValue in
                        // Debounce search input (300ms delay)
                        Task {
                            try? await Task.sleep(nanoseconds: 300_000_000)
                            if searchQuery == newValue {
                                debouncedSearchQuery = newValue
                            }
                        }
                    }
            }
            .padding()
            .background(palette.input, in: RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Category filters
            if !allCategories.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        CategoryChip(
                            title: "All",
                            isSelected: selectedCategory == nil,
                            palette: palette
                        ) {
                            selectedCategory = nil
                        }
                        
                        ForEach(allCategories, id: \.self) { category in
                            CategoryChip(
                                title: category,
                                isSelected: selectedCategory == category,
                                palette: palette
                            ) {
                                selectedCategory = selectedCategory == category ? nil : category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
            }
            
            // Password count card
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(isPremium ? "\(vaultStore.entries.count) passwords" : "\(vaultStore.entries.count) of 10 passwords")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(palette.foreground)
                    Spacer()
                    Button(action: onAddEntry) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(palette.primary)
                    }
                }
                Text(isPremium ? "Premium • Unlimited" : "Free")
                    .font(.system(size: 14))
                    .foregroundColor(isPremium ? palette.primary : palette.mutedForeground)
            }
            .padding()
            .background(palette.card, in: RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Messages
            if let error = errorMessage {
                Text(error)
                    .font(.body)
                    .foregroundColor(palette.destructive)
                    .padding(.horizontal)
                    .task(id: error) {
                        // Auto-clear error message after 5 seconds
                        try? await Task.sleep(nanoseconds: 5_000_000_000)
                        await MainActor.run {
                            errorMessage = nil
                        }
                    }
            }
            
            if let success = successMessage {
                Text(success)
                    .font(.body)
                    .foregroundColor(palette.success)
                    .padding(.horizontal)
                    .task(id: success) {
                        // Auto-clear success message after 3 seconds
                        try? await Task.sleep(nanoseconds: 3_000_000_000)
                        await MainActor.run {
                            successMessage = nil
                        }
                    }
            }
            
            // Entries list - takes remaining space
            if filteredEntries.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "lock.shield")
                        .font(.system(size: 48))
                        .foregroundColor(palette.mutedForeground)
                    Text(searchQuery.isEmpty ? "No passwords yet" : "No matching passwords")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(palette.mutedForeground)
                    if searchQuery.isEmpty {
                        Button(action: onAddEntry) {
                            Text("Add Your First Password")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(palette.onPrimary)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(palette.primary, in: RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(filteredEntries) { entry in
                        PasswordEntryRow(
                            entry: entry,
                            onTap: {
                                onViewEntry(entry)
                            },
                            onEdit: {
                                onEditEntry(entry)
                            },
                            onDelete: {
                                showDeleteConfirmation = entry
                            },
                            palette: palette
                        )
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Color.clear)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                showDeleteConfirmation = entry
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .id(entry.id) // Stable ID for better performance
                    }
                }
                .listStyle(.plain) // Better performance than default style
                .animation(.easeInOut(duration: 0.2), value: filteredEntries.count) // Smooth list updates
                .scrollContentBackground(.hidden)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(palette.background)
        .navigationTitle("Password Manager")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Lock", action: onLock)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showExportSheet = true }) {
                            Label("Export Passwords", systemImage: "square.and.arrow.up")
                        }
                        Button(action: { showImportSheet = true }) {
                            Label("Import Passwords", systemImage: "square.and.arrow.down")
                        }
                        Button(action: onChangePassword) {
                            Label("Change Master Password", systemImage: "key")
                        }
                        
                        if biometricAvailable {
                            Toggle(isOn: Binding(
                                get: { vaultStore.biometricEnabled },
                                set: { enabled in
                                    if enabled {
                                        showBiometricSetup = true
                                    } else {
                                        vaultStore.setBiometricEnabled(false)
                                    }
                                }
                            )) {
                                Label("Biometric Unlock", systemImage: "faceid")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showExportSheet) {
                ExportPasswordsView(vaultStore: vaultStore)
            }
            .sheet(isPresented: $showImportSheet) {
                ImportPasswordsView(vaultStore: vaultStore, onImportComplete: {
                    showImportSheet = false
                    successMessage = "Passwords imported successfully"
                    errorMessage = nil
                })
            }
            .alert("Delete Password", isPresented: Binding(
                get: { showDeleteConfirmation != nil },
                set: { if !$0 { showDeleteConfirmation = nil } }
            ), presenting: showDeleteConfirmation) { entry in
                Button("Delete", role: .destructive) {
                    Task {
                        do {
                            try await vaultStore.deleteEntry(id: entry.id)
                            await MainActor.run {
                                showDeleteConfirmation = nil
                            }
                        } catch {
                            await MainActor.run {
                                errorMessage = "Failed to delete entry: \(error.localizedDescription)"
                                showDeleteConfirmation = nil
                            }
                        }
                    }
                }
                Button("Cancel", role: .cancel) {
                    showDeleteConfirmation = nil
                }
            } message: { entry in
                Text("Are you sure you want to delete the password for \(entry.service)?")
            }
            .onAppear {
                do {
                    try vaultStore.reloadEntries()
                } catch {
                    errorMessage = "Failed to load entries: \(error.localizedDescription)"
                }
                
                // Check biometric availability
                let context = LAContext()
                var error: NSError?
                biometricAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            }
            .sheet(isPresented: $showBiometricSetup) {
                BiometricSetupView(vaultStore: vaultStore, onDismiss: {
                    showBiometricSetup = false
                })
            }
    }
    
    private func checkBiometricAvailability() {
        let context = LAContext()
        var error: NSError?
        biometricAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let palette: CiphioPalette
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? palette.onPrimary : palette.foreground)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? palette.primary : palette.card, in: Capsule())
        }
    }
}

struct PasswordEntryRow: View {
    let entry: PasswordEntry
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let palette: CiphioPalette
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.service)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(palette.foreground)
                    
                    Text(entry.username)
                        .font(.system(size: 15))
                        .foregroundColor(palette.mutedForeground)
                    
                    if !entry.getAllCategories().isEmpty {
                        HStack(spacing: 4) {
                            ForEach(entry.getAllCategories().prefix(3), id: \.self) { category in
                                Text(category)
                                    .font(.system(size: 12))
                                    .foregroundColor(palette.primary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(palette.primary.opacity(0.1), in: Capsule())
                            }
                        }
                        .padding(.top, 2)
                    }
                }
                
                Spacer()
                
                Menu {
                    Button(action: onEdit) {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button(role: .destructive, action: onDelete) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(palette.mutedForeground)
                }
            }
            .padding()
            .background(palette.card, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

