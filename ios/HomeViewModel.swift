import Combine
import SwiftUI
import UIKit

@MainActor
final class HomeViewModel: ObservableObject {
    // Encryption
    @Published var inputText: String = ""
    @Published var secretKey: String = ""
    @Published var selectedMode: AesMode = .aesGcm
    @Published var outputText: String = ""
    @Published var isProcessing: Bool = false

    // History
    @Published var historyEnabled: Bool
    @Published private(set) var historyEntries: [HistoryEntry] = []

    // Password generator
    @Published var passwordLength: Double
    @Published var includeUppercase: Bool
    @Published var includeLowercase: Bool
    @Published var includeDigits: Bool
    @Published var includeSymbols: Bool
    @Published var generatedPassword: String = ""
    @Published var passwordEntropyBits: Double = 0
    @Published var passwordStrengthLabel: String = ""

    // Preferences
    @Published var themeOption: ThemeOption

    // UI feedback
    @Published var toastMessage: String?

    private let cryptoService: CryptoService
    private let passwordGenerator: PasswordGenerator
    private let historyStore: HistoryStore
    private var cancellables = Set<AnyCancellable>()
    private let defaults = UserDefaults.standard

    private enum Keys {
        static let passwordLength = "password_length"
        static let uppercase = "password_uppercase"
        static let lowercase = "password_lowercase"
        static let digits = "password_digits"
        static let symbols = "password_symbols"
        static let generatedPassword = "password_last"
        static let themeOption = "theme_option"
    }

    init(
        cryptoService: CryptoService,
        passwordGenerator: PasswordGenerator,
        historyStore: HistoryStore
    ) {
        self.cryptoService = cryptoService
        self.passwordGenerator = passwordGenerator
        self.historyStore = historyStore

        let storedLength = defaults.integer(forKey: Keys.passwordLength)
        let length = storedLength == 0 ? 16 : max(6, min(storedLength, 64))
        self.passwordLength = Double(length)
        self.includeUppercase = defaults.object(forKey: Keys.uppercase) as? Bool ?? true
        self.includeLowercase = defaults.object(forKey: Keys.lowercase) as? Bool ?? true
        self.includeDigits = defaults.object(forKey: Keys.digits) as? Bool ?? true
        self.includeSymbols = defaults.object(forKey: Keys.symbols) as? Bool ?? true
        self.generatedPassword = defaults.string(forKey: Keys.generatedPassword) ?? ""

        let storedTheme = defaults.string(forKey: Keys.themeOption)
        self.themeOption = ThemeOption(rawValue: storedTheme ?? ThemeOption.system.rawValue) ?? .system

        self.historyEnabled = historyStore.saveEnabled

        historyStore.$entries
            .receive(on: DispatchQueue.main)
            .assign(to: &$historyEntries)

        historyStore.$saveEnabled
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.historyEnabled = value
            }
            .store(in: &cancellables)

        $historyEnabled
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] newValue in
                self?.historyStore.setSaveEnabled(newValue)
            }
            .store(in: &cancellables)

        recalculateStrength()
    }

    var passwordLengthInt: Int { Int(passwordLength.rounded()) }

    func encrypt() {
        Task {
            guard !secretKey.isEmpty else {
                showToast("Secret key required")
                return
            }
            isProcessing = true
            defer { isProcessing = false }
            do {
                let payload = try cryptoService.encrypt(plaintext: inputText, password: secretKey, mode: selectedMode)
                outputText = payload.encoded
                showToast("Encrypted")
                appendHistory(action: .encrypt, input: inputText, output: payload.encoded, algorithm: selectedMode)
            } catch {
                showToast("Encryption failed")
            }
        }
    }

    func decrypt() {
        Task {
            guard !secretKey.isEmpty else {
                showToast("Secret key required")
                return
            }
            isProcessing = true
            defer { isProcessing = false }
            do {
                let (mode, plaintext) = try cryptoService.decrypt(encoded: inputText, password: secretKey)
                selectedMode = mode
                outputText = plaintext
                showToast("Decrypted")
                appendHistory(action: .decrypt, input: inputText, output: plaintext, algorithm: mode)
            } catch {
                showToast("Decryption failed")
            }
        }
    }

    func updatePasswordLength(_ value: Double) {
        passwordLength = value
        persistPasswordPreferences()
        recalculateStrength()
    }

    func toggleUppercase(_ enabled: Bool) {
        includeUppercase = enabled
        enforceCharacterSelection()
    }

    func toggleLowercase(_ enabled: Bool) {
        includeLowercase = enabled
        enforceCharacterSelection()
    }

    func toggleDigits(_ enabled: Bool) {
        includeDigits = enabled
        enforceCharacterSelection()
    }

    func toggleSymbols(_ enabled: Bool) {
        includeSymbols = enabled
        enforceCharacterSelection()
    }

    func generatePassword() {
        let config = PasswordConfig(
            length: passwordLengthInt,
            includeUppercase: includeUppercase,
            includeLowercase: includeLowercase,
            includeDigits: includeDigits,
            includeSymbols: includeSymbols
        )

        let password = passwordGenerator.generate(config: config)
        guard !password.isEmpty else {
            showToast("Select at least one character set")
            return
        }
        generatedPassword = password
        defaults.set(password, forKey: Keys.generatedPassword)
        recalculateStrength()
        showToast("Password generated")
    }

    private func appendHistory(action: HistoryEntry.Action, input: String, output: String, algorithm: AesMode) {
        guard historyEnabled else { return }
        let hint = buildKeyHint(from: secretKey)
        historyStore.append(
            action: action,
            algorithm: algorithm.rawValue,
            input: input,
            output: output,
            keyHint: hint
        )
    }

    func clearHistory() {
        historyStore.clear()
        showToast("History cleared")
    }

    func deleteHistoryEntry(id: UUID) {
        historyStore.clear(id: id)
        showToast("Entry deleted")
    }

    func useHistoryEntry(_ entry: HistoryEntry) {
        inputText = entry.input
        outputText = entry.output
        selectedMode = AesMode(rawValue: entry.algorithm) ?? .aesGcm
        showToast("History entry loaded")
    }

    func setTheme(_ option: ThemeOption) {
        themeOption = option
        defaults.set(option.rawValue, forKey: Keys.themeOption)
    }

    func copy(text: String) {
        UIPasteboard.general.string = text
        showToast("Copied to clipboard")
    }

    private func enforceCharacterSelection() {
        if !includeUppercase && !includeLowercase && !includeDigits && !includeSymbols {
            includeUppercase = true
            showToast("At least one character set required")
        }
        persistPasswordPreferences()
        recalculateStrength()
    }

    private func persistPasswordPreferences() {
        defaults.set(passwordLengthInt, forKey: Keys.passwordLength)
        defaults.set(includeUppercase, forKey: Keys.uppercase)
        defaults.set(includeLowercase, forKey: Keys.lowercase)
        defaults.set(includeDigits, forKey: Keys.digits)
        defaults.set(includeSymbols, forKey: Keys.symbols)
    }

    private func recalculateStrength() {
        let config = PasswordConfig(
            length: passwordLengthInt,
            includeUppercase: includeUppercase,
            includeLowercase: includeLowercase,
            includeDigits: includeDigits,
            includeSymbols: includeSymbols
        )
        let strength = passwordGenerator.strength(for: config)
        passwordEntropyBits = strength.entropyBits
        passwordStrengthLabel = strength.label
    }

    private func buildKeyHint(from secret: String) -> String {
        guard !secret.isEmpty else { return "" }
        let prefix = String(secret.prefix(4))
        let stars = String(repeating: "*", count: max(secret.count - 4, 0))
        return prefix + stars
    }

    private func showToast(_ message: String) {
        toastMessage = message
        Task { [weak self] in
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            if self?.toastMessage == message {
                self?.toastMessage = nil
            }
        }
    }
}

