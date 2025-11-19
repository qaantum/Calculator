import SwiftUI
import UniformTypeIdentifiers

struct ExportPasswordsView: View {
    @ObservedObject var vaultStore: PasswordVaultStore
    @Environment(\.dismiss) private var dismiss
    @State private var exportData: String?
    @State private var errorMessage: String?
    @Environment(\.cryptatextPalette) private var palette
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if let data = exportData {
                    Text("Export Data")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(palette.foreground)
                    
                    ScrollView {
                        Text(data)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(palette.foreground)
                            .padding()
                            .background(palette.card, in: RoundedRectangle(cornerRadius: 8))
                    }
                    .frame(maxHeight: 300)
                    
                    Button(action: shareExport) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Export")
                        }
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(palette.onPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(palette.primary, in: RoundedRectangle(cornerRadius: 12))
                    }
                } else if let error = errorMessage {
                    Text(error)
                        .font(.body)
                        .foregroundColor(palette.destructive)
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            .padding()
            .navigationTitle("Export Passwords")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: { dismiss() })
                }
            }
            .onAppear {
                do {
                    exportData = try vaultStore.exportEntries()
                } catch {
                    errorMessage = "Failed to export: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func shareExport() {
        guard let data = exportData else { return }
        let activityVC = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}

struct ImportPasswordsView: View {
    @ObservedObject var vaultStore: PasswordVaultStore
    let onImportComplete: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var importText = ""
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @State private var showFilePicker = false
    @Environment(\.cryptatextPalette) private var palette
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(action: { showFilePicker = true }) {
                        HStack {
                            Image(systemName: "doc")
                            Text("Select File")
                        }
                    }
                }
                
                Section("Or Paste Export Data") {
                    TextEditor(text: $importText)
                        .frame(minHeight: 200)
                        .font(.system(size: 12, design: .monospaced))
                }
                
                if let error = errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(palette.destructive)
                    }
                }
                
                if let success = successMessage {
                    Section {
                        Text(success)
                            .foregroundColor(palette.success)
                    }
                }
                
                Section {
                    Button(action: importData) {
                        Text("Import")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(importText.isEmpty)
                }
            }
            .navigationTitle("Import Passwords")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel", action: { dismiss() })
                }
            }
            .fileImporter(
                isPresented: $showFilePicker,
                allowedContentTypes: [.text, .plainText],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    if let url = urls.first {
                        importFromFile(url: url)
                    }
                case .failure(let error):
                    errorMessage = "Failed to select file: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func importFromFile(url: URL) {
        do {
            let data = try String(contentsOf: url, encoding: .utf8)
            importText = data
        } catch {
            errorMessage = "Failed to read file: \(error.localizedDescription)"
        }
    }
    
    private func importData() {
        guard !importText.isEmpty else { return }
        
        do {
            let result = try vaultStore.importEntries(encryptedData: importText, merge: true)
            if result.isError {
                errorMessage = "Failed to import passwords"
            } else {
                successMessage = "Imported \(result.newEntriesCount) new passwords"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    onImportComplete()
                }
            }
        } catch {
            errorMessage = "Failed to import: \(error.localizedDescription)"
        }
    }
}

