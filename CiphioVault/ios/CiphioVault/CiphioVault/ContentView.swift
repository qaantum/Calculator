import SwiftUI
import UIKit

private enum Route: Hashable, Codable {
    case history
    case settings
    case algorithms
    case terms
    case privacy
}

private enum HomeTab: String, CaseIterable, Identifiable {
    case encrypt
    case password

    var id: String { rawValue }

    var title: String {
        switch self {
        case .encrypt: return "Text Encryption"
        case .password: return "Password Generator"
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var selectedTab: HomeTab = .encrypt
    @State private var showHistory = false
    @State private var showSettings = false
    @State private var showAlgorithms = false
    @State private var showTerms = false
    @State private var showPrivacy = false
    @Environment(\.colorScheme) private var systemColorScheme

    private var resolvedScheme: ColorScheme {
        viewModel.themeOption.colorScheme ?? systemColorScheme
    }
    
    private var palette: CiphioPalette {
        CiphioPalette.palette(for: resolvedScheme)
    }

    var body: some View {
        NavigationView {
            HomeMainView(
                viewModel: viewModel,
                selectedTab: $selectedTab,
                onOpenHistory: { 
                    showHistory = true
                },
                onOpenSettings: { 
                    showSettings = true
                }
            )
            .navigationTitle("Ciphio Vault")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { 
                        showHistory = true
                    }) {
                        Label("History", systemImage: "clock.arrow.circlepath")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { 
                        showSettings = true
                    }) {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
            }
            .background(
                Group {
                    NavigationLink(
                        destination: HistoryView(
                            entries: viewModel.historyEntries,
                            onUse: { entry in
                                viewModel.useHistoryEntry(entry)
                                showHistory = false
                            },
                            onDelete: { entry in
                                viewModel.deleteHistoryEntry(id: entry.id)
                            },
                            onClear: {
                                viewModel.clearHistory()
                            }
                        ),
                        isActive: $showHistory
                    ) {
                        EmptyView()
                    }
                    
                    NavigationLink(
                        destination: SettingsView(
                            viewModel: viewModel,
                            onOpenAlgorithms: { 
                                showAlgorithms = true
                            },
                            onOpenTerms: { 
                                showTerms = true
                            },
                            onOpenPrivacy: {
                                showPrivacy = true
                            }
                        )
                        .background(
                            Group {
                                NavigationLink(
                                    destination: InfoView(title: "Encryption Algorithms", paragraphs: AlgorithmsInfo),
                                    isActive: $showAlgorithms
                                ) {
                                    EmptyView()
                                }
                                
                                NavigationLink(
                                    destination: InfoView(title: "Terms of Service", paragraphs: TermsContent),
                                    isActive: $showTerms
                                ) {
                                    EmptyView()
                                }
                                
                                NavigationLink(
                                    destination: InfoView(title: "Privacy Policy", paragraphs: PrivacyContent),
                                    isActive: $showPrivacy
                                ) {
                                    EmptyView()
                                }
                            }
                        ),
                        isActive: $showSettings
                    ) {
                        EmptyView()
                    }
                }
            )
        }
        .environment(\.ciphioPalette, palette)
        .preferredColorScheme(viewModel.themeOption.colorScheme)
        .tint(palette.primary)
        .background(palette.background.ignoresSafeArea())
        .overlay(alignment: .bottom) {
            if let message = viewModel.toastMessage {
                ToastView(message: message)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 32)
            }
        }
        .animation(.easeInOut, value: viewModel.toastMessage)
    }
}

private struct HomeMainView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var selectedTab: HomeTab
    var onOpenHistory: () -> Void
    var onOpenSettings: () -> Void
    @State private var showPasswordManager = false
    @Environment(\.ciphioPalette) private var palette

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    // Password Manager Quick Access Card (matching Android)
                    Button(action: {
                        showPasswordManager = true
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: "lock.shield.fill")
                                .font(.system(size: 32))
                                .foregroundColor(palette.primary)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Password Manager")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(palette.foreground)
                                Text("Securely store your passwords")
                                    .font(.system(size: 12))
                                    .foregroundColor(palette.mutedForeground)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(palette.mutedForeground)
                        }
                        .padding(16)
                        .background(palette.card, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(palette.border, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $showPasswordManager) {
                        PasswordManagerView(
                            cryptoService: CryptoService()
                        )
                    }
                    
                    // Custom Tab Bar (similar to Android TabRow)
                    HStack(spacing: 0) {
                        ForEach(HomeTab.allCases) { tab in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedTab = tab
                                }
                            }) {
                                Text(tab.title)
                                    .font(.system(size: 14, weight: selectedTab == tab ? .medium : .regular))
                                    .foregroundColor(selectedTab == tab ? palette.foreground : palette.mutedForeground)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                                    .background(
                                        selectedTab == tab ? palette.card : Color.clear,
                                        in: RoundedRectangle(cornerRadius: 12)
                                    )
                            }
                        }
                    }
                    .padding(4)
                    .background(palette.muted, in: RoundedRectangle(cornerRadius: 12))

                    if selectedTab == .encrypt {
                        EncryptionSection(viewModel: viewModel, onOpenHistory: onOpenHistory, scrollProxy: proxy)
                            .id("encrypt")
                            .transition(.opacity)
                    } else if selectedTab == .password {
                        PasswordSection(viewModel: viewModel)
                            .id("password")
                            .transition(.opacity)
                    }
                }
                .padding(12)
                .padding(.bottom, 16)
            }
            .background(palette.background)
        }
    }
}

private struct EncryptionSection: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var keyVisible = false
    var onOpenHistory: () -> Void
    var scrollProxy: ScrollViewProxy?
    @Environment(\.ciphioPalette) private var palette
    @FocusState private var focusedField: Field?

    enum Field {
        case input, secretKey
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle("Save history", isOn: $viewModel.historyEnabled)
                .toggleStyle(SwitchToggleStyle(tint: palette.primary))
                .foregroundColor(palette.foreground)
                .font(.subheadline)

            VStack(alignment: .leading, spacing: 6) {
                Text("Input Text")
                    .font(.caption)
                    .foregroundColor(palette.mutedForeground)
                TextEditor(text: $viewModel.inputText)
                    .frame(minHeight: 80, maxHeight: 100)
                    .padding(8)
                    .background(palette.input, in: RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(palette.border, lineWidth: 1))
                    .foregroundColor(palette.foreground)
                    .focused($focusedField, equals: .input)
                    .id("inputTextEditor")
                    .onChange(of: focusedField) { newValue in
                        if newValue == .input {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                scrollProxy?.scrollTo("inputTextEditor", anchor: .center)
                            }
                        }
                    }
                HStack {
                    Spacer()
                    Button(action: viewModel.pasteInput) {
                        Label("Paste", systemImage: "doc.on.clipboard")
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 14)
                            .background(palette.secondary, in: Capsule())
                            .foregroundColor(palette.onSecondary)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Secret Key")
                    .font(.caption)
                    .foregroundColor(palette.mutedForeground)
                HStack {
                    Group {
                        if keyVisible {
                            TextField("Secret key", text: $viewModel.secretKey)
                                .focused($focusedField, equals: .secretKey)
                        } else {
                            SecureField("Secret key", text: $viewModel.secretKey)
                                .focused($focusedField, equals: .secretKey)
                        }
                    }
                    .foregroundColor(palette.foreground)

                    Button(action: { keyVisible.toggle() }) {
                        Image(systemName: keyVisible ? "eye.slash" : "eye")
                            .foregroundColor(palette.mutedForeground)
                    }
                }
                .padding(10)
                .background(palette.input, in: RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(palette.border, lineWidth: 1))
                .onChange(of: focusedField) { newValue in
                    if newValue == .secretKey {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            scrollProxy?.scrollTo("secretKeyField", anchor: .center)
                        }
                    }
                }
            }
            .id("secretKeyField")

            Menu {
                ForEach(AesMode.allCases) { mode in
                    Button(mode.rawValue) { viewModel.selectedMode = mode }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedMode.rawValue)
                        .foregroundColor(palette.foreground)
                        .font(.subheadline)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(palette.mutedForeground)
                        .font(.caption)
                }
                .padding(10)
                .background(palette.input, in: RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(palette.border, lineWidth: 1))
            }

            HStack(spacing: 10) {
                // Each button shows its own state: green if it was last pressed, gray otherwise
                let isEncryptActive = viewModel.lastOperation == .encrypt || viewModel.lastOperation == nil
                let isDecryptActive = viewModel.lastOperation == .decrypt
                
                let encryptColor = isEncryptActive ? palette.primary : palette.secondary
                let encryptContentColor = isEncryptActive ? palette.onPrimary : palette.onSecondary
                let decryptColor = isDecryptActive ? palette.primary : palette.secondary
                let decryptContentColor = isDecryptActive ? palette.onPrimary : palette.onSecondary
                
                Button(action: viewModel.encrypt) {
                    Text("Encrypt")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
                .background(encryptColor, in: RoundedRectangle(cornerRadius: 12))
                .foregroundColor(encryptContentColor)
                .opacity(viewModel.isProcessing ? 0.5 : 1)
                .disabled(viewModel.isProcessing)

                Button(action: viewModel.decrypt) {
                    Text("Decrypt")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
                .background(decryptColor, in: RoundedRectangle(cornerRadius: 12))
                .foregroundColor(decryptContentColor)
                .opacity(viewModel.isProcessing ? 0.5 : 1)
                .disabled(viewModel.isProcessing)
            }

            if !viewModel.outputText.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Output")
                        .font(.caption)
                        .foregroundColor(palette.mutedForeground)
                    TextEditor(text: .constant(viewModel.outputText))
                        .frame(minHeight: 80, maxHeight: 100)
                        .padding(8)
                        .background(palette.input, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(palette.border, lineWidth: 1))
                        .foregroundColor(palette.foreground)
                        .disabled(true)
                        .textSelection(.enabled)
                        .id("outputTextEditor")
                    HStack(spacing: 10) {
                        Spacer()
                        Button(action: { viewModel.copy(text: viewModel.outputText) }) {
                            Label("Copy", systemImage: "doc.on.doc")
                                .font(.system(size: 12, weight: .semibold))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 14)
                                .background(palette.secondary, in: Capsule())
                                .foregroundColor(palette.onSecondary)
                        }
                        Button(action: { shareText(viewModel.outputText) }) {
                            Label("Share", systemImage: "square.and.arrow.up")
                                .font(.system(size: 12, weight: .semibold))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 14)
                                .background(palette.secondary, in: Capsule())
                                .foregroundColor(palette.onSecondary)
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        scrollProxy?.scrollTo("outputTextEditor", anchor: .center)
                    }
                }
            }

            Button(action: onOpenHistory) {
                Label("View History", systemImage: "clock.arrow.circlepath")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.plain)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(palette.border, lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 16).fill(palette.card))
            )
            .foregroundColor(palette.foreground)
        }
        .padding(22)
        .background(palette.card, in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(viewModel.themeOption == .dark ? 0.25 : 0.08), radius: 18, x: 0, y: 10)
    }
}

private struct PasswordSection: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.ciphioPalette) private var palette

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Length")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(palette.foreground)
                    Spacer()
                    Text("\(viewModel.passwordLengthInt)")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(palette.primary)
                }
                Slider(value: $viewModel.passwordLength, in: 6...64, step: 1)
                    .onChange(of: viewModel.passwordLength) { newValue in
                        viewModel.updatePasswordLength(newValue)
                    }
                    .tint(palette.primary)
            }

            Group {
                Toggle("Include Uppercase (A-Z)", isOn: Binding(get: { viewModel.includeUppercase }, set: { viewModel.toggleUppercase($0) }))
                Toggle("Include Lowercase (a-z)", isOn: Binding(get: { viewModel.includeLowercase }, set: { viewModel.toggleLowercase($0) }))
                Toggle("Include Numbers (0-9)", isOn: Binding(get: { viewModel.includeDigits }, set: { viewModel.toggleDigits($0) }))
                Toggle("Include Symbols (!@#$…)", isOn: Binding(get: { viewModel.includeSymbols }, set: { viewModel.toggleSymbols($0) }))
            }
            .toggleStyle(SwitchToggleStyle(tint: palette.primary))
            .foregroundColor(palette.foreground)

            HStack {
                Text("Strength")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(palette.foreground)
                Spacer()
                Text("\(viewModel.passwordStrengthLabel) (\(Int(viewModel.passwordEntropyBits)) bits)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(strengthColor(for: viewModel.passwordStrengthLabel))
            }

            Button(action: viewModel.generatePassword) {
                Label("Generate New Password", systemImage: "arrow.clockwise")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.plain)
            .background(palette.primary, in: RoundedRectangle(cornerRadius: 16))
            .foregroundColor(palette.onPrimary)

            if !viewModel.generatedPassword.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Generated Password")
                        .font(.subheadline)
                        .foregroundColor(palette.mutedForeground)
                    Text(viewModel.generatedPassword)
                        .font(.body.monospaced())
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(palette.input, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(palette.border, lineWidth: 1))
                        .textSelection(.enabled)
                    HStack {
                        Spacer()
                        Button(action: { viewModel.copy(text: viewModel.generatedPassword) }) {
                            Label("Copy", systemImage: "doc.on.doc")
                                .font(.system(size: 15, weight: .semibold))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 18)
                                .background(palette.secondary, in: Capsule())
                                .foregroundColor(palette.onSecondary)
                        }
                    }
                }
            }
        }
        .padding(22)
        .background(palette.card, in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(viewModel.themeOption == .dark ? 0.25 : 0.08), radius: 18, x: 0, y: 10)
    }

    private func strengthColor(for label: String) -> Color {
        switch label.lowercased() {
        case "weak": return palette.destructive
        case "moderate": return palette.warning
        case "strong": return palette.info
        case "very strong": return palette.success
        default: return palette.mutedForeground
        }
    }
}

private struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    let entries: [HistoryEntry]
    let onUse: (HistoryEntry) -> Void
    let onDelete: (HistoryEntry) -> Void
    let onClear: () -> Void
    @Environment(\.ciphioPalette) private var palette

    var body: some View {
        List {
            if entries.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("No history yet")
                        .font(.headline)
                        .foregroundColor(palette.foreground)
                    Text("Enable the save toggle on the encryption screen to store your operations.")
                        .font(.subheadline)
                        .foregroundColor(palette.mutedForeground)
                }
                .padding(.vertical, 12)
                .listRowBackground(palette.card)
            } else {
                Section {
                    ForEach(entries) { entry in
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(entry.action.displayName) • \(entry.algorithm)")
                                .font(.headline)
                                .foregroundColor(palette.foreground)
                            Text("Input: \(entry.input.truncated())")
                                .font(.subheadline)
                                .foregroundColor(palette.mutedForeground)
                            Text("Output: \(entry.output.truncated())")
                                .font(.subheadline)
                                .foregroundColor(palette.mutedForeground)
                            Text("Key hint: \(entry.keyHint)")
                                .font(.footnote)
                                .foregroundColor(palette.mutedForeground)
                            Text(entry.timestamp.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(palette.mutedForeground)
                            HStack(spacing: 12) {
                                Button(action: {
                                    onUse(entry)
                                    dismiss()
                                }) {
                                    Text("Use This Entry")
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(palette.primary, in: RoundedRectangle(cornerRadius: 10))
                                        .foregroundColor(palette.onPrimary)
                                }
                                .buttonStyle(.plain)
                                
                                Button(role: .destructive, action: {
                                    onDelete(entry)
                                }) {
                                    Label("Delete", systemImage: "trash")
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(palette.destructive.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
                                        .foregroundColor(palette.destructive)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(palette.card)
                    }
                }
            }
        }
        .background(palette.background)
        .listStyle(.plain)
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !entries.isEmpty {
                    Button("Clear All", role: .destructive) {
                        onClear()
                    }
                }
            }
        }
    }
}

private struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: HomeViewModel
    let onOpenAlgorithms: () -> Void
    let onOpenTerms: () -> Void
    let onOpenPrivacy: () -> Void
    @Environment(\.ciphioPalette) private var palette

    var body: some View {
        List {
            Section("Appearance") {
                Picker("Theme", selection: Binding(get: { viewModel.themeOption }, set: { viewModel.setTheme($0) })) {
                    ForEach(ThemeOption.allCases) { option in
                        VStack(alignment: .leading) {
                            Text(option.title)
                                .foregroundColor(palette.foreground)
                            Text(option.description)
                                .font(.caption)
                                .foregroundColor(palette.mutedForeground)
                        }
                        .tag(option)
                    }
                }
            }

            Section("About") {
                Button {
                    onOpenAlgorithms()
                } label: {
                    Label("Encryption Algorithms", systemImage: "lock.shield")
                        .foregroundColor(palette.foreground)
                }
                Button {
                    onOpenTerms()
                } label: {
                    Label("Terms of Service", systemImage: "doc.plaintext")
                        .foregroundColor(palette.foreground)
                }
                Button {
                    onOpenPrivacy()
                } label: {
                    Label("Privacy Policy", systemImage: "hand.raised.fill")
                        .foregroundColor(palette.foreground)
                }
            }
        }
        .background(palette.background)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") { dismiss() }
            }
        }
    }
}

private struct InfoView: View {
    let title: String
    let paragraphs: [String]
    @Environment(\.ciphioPalette) private var palette

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(paragraphs, id: \.self) { paragraph in
                    Text(paragraph)
                        .foregroundColor(palette.foreground)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(20)
        }
        .background(palette.background)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ToastView: View {
    let message: String
    @Environment(\.ciphioPalette) private var palette

    var body: some View {
        Text(message)
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(palette.card.opacity(0.9), in: Capsule())
            .overlay(Capsule().stroke(palette.border, lineWidth: 1))
            .shadow(color: Color.black.opacity(0.15), radius: 8)
            .padding(.horizontal)
    }
}

private extension String {
    func truncated(_ limit: Int = 64) -> String {
        if count <= limit { return self }
        let endIndex = index(startIndex, offsetBy: limit)
        return String(self[..<endIndex]) + "…"
    }
}

private extension HistoryEntry.Action {
    var displayName: String {
        switch self {
        case .encrypt: return "Encrypt"
        case .decrypt: return "Decrypt"
        }
    }
}

private let AlgorithmsInfo: [String] = [
                "Ciphio Vault supports three AES block cipher modes to balance usability and security across different workflows.",
    "AES-GCM (Galois/Counter Mode) is the default choice because it offers authenticated encryption. It protects confidentiality and verifies message integrity using a 12-byte nonce and 16-byte tag.",
    "AES-CBC (Cipher Block Chaining) is provided for compatibility with older systems. It applies PKCS#7 padding and generates a fresh 16-byte IV for every operation. Pair it with an HMAC if you need tamper detection.",
    "AES-CTR (Counter Mode) converts AES into a stream cipher using a 16-byte nonce. It is fast and avoids padding, but it does not provide built-in integrity—combine it with a signature or MAC when possible.",
                "Regardless of the mode, Ciphio Vault derives a unique 256-bit key for each encryption by running PBKDF2-HMAC-SHA256 with 100,000 iterations and a random 16-byte salt."
]

private let TermsContent: [String] = [
    "Welcome to Ciphio. By accessing or using our applications, website, or related services, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use Ciphio.",
    "Ciphio is designed as a privacy first, security focused application for managing and protecting sensitive credentials and encrypted content.",
    "You are responsible for maintaining the confidentiality of your device access and any authentication methods used to protect your Ciphio vault. You agree to use the service only for lawful purposes and in a manner that does not infringe upon the rights of others.",
    "You agree NOT to: Use the service for illegal, harmful, or fraudulent activities; Attempt to reverse engineer, decompile, or bypass security mechanisms; Interfere with or disrupt the integrity or performance of the service; Attempt unauthorized access to systems or data.",
    "You remain solely responsible for the security of your master password and device protections.",
    "Ciphio is provided on an \"as available\" basis. While we strive for reliability, we do not guarantee uninterrupted service or permanent accessibility to features. We reserve the right to modify, suspend, or discontinue any part of the service at any time without prior notice.",
    "Ciphio is provided \"as is\" and \"as available\" without warranties of any kind, either express or implied. Ciphio shall not be liable for any damages arising from the use or inability to use the service, including: Data loss; Security breaches resulting from user negligence; Device failure or unauthorized access; Indirect or consequential damages.",
    "We may update these Terms at any time. Any changes will be reflected on this page and the \"Last updated\" date will be revised accordingly. Continued use of the service after changes constitutes acceptance of the new terms.",
    "Last updated: November 24, 2025"
]

private let PrivacyContent: [String] = [
    "Ciphio is built on a zero access design philosophy. All sensitive data including passwords, encrypted text, and vault contents are encrypted and stored locally on your device. Ciphio does not have access to your vault contents and cannot decrypt them.",
    "We do not collect, view, sell, or share user vault data.",
    "Ciphio does NOT collect: Stored passwords; Vault contents; Encrypted text data; Notes or private content; Biometric data; Personal identity profiles. All such data remains encrypted and fully under user control on the device.",
    "Ciphio may process limited technical metrics for application improvement and stability purposes. These metrics are anonymous and cannot be used to identify you. This may include: App performance statistics; Feature usage trends; Crash diagnostics; Session duration patterns; Basic device and operating system version.",
    "These metrics: Do NOT include personal data; Are NOT linked to individual users; Are NOT used for profiling or advertising. Ciphio does not monitor or track user behavior for marketing or behavioral analysis.",
    "We employ industry standard encryption and secure coding practices to protect all sensitive data: AES GCM encryption; Secure key derivation; Local only storage architecture; Platform level security features (Android Keystore and Apple Keychain). Your master password and vault data are never transmitted to Ciphio servers.",
    "In limited cases, essential third party services may be used for operational functionality such as crash reporting or application performance. These services are configured to respect anonymization standards and do not receive vault data or personal identity information.",
    "You maintain full control over your data on your device. Since vault data is not stored on Ciphio servers, requests for deletion or access apply only to locally stored content, which you can manage directly within the app.",
    "We may update this Privacy Policy periodically. Any changes will be published on this page with a revised date.",
    "Last updated: November 24, 2025"
]

private func shareText(_ text: String) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootViewController = windowScene.windows.first?.rootViewController else {
        return
    }
    
    let activityViewController = UIActivityViewController(
        activityItems: [text],
        applicationActivities: nil
    )
    
    // For iPad
    if let popover = activityViewController.popoverPresentationController {
        popover.sourceView = windowScene.windows.first
        popover.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
        popover.permittedArrowDirections = []
    }
    
    rootViewController.present(activityViewController, animated: true)
}
