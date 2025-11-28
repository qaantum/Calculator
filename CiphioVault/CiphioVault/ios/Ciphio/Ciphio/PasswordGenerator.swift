import Foundation

struct PasswordConfig {
    var length: Int = 16
    var includeUppercase: Bool = true
    var includeLowercase: Bool = true
    var includeDigits: Bool = true
    var includeSymbols: Bool = true
}

struct PasswordStrength {
    let entropyBits: Double
    let label: String
}

final class PasswordGenerator {
    private let uppercase = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    private let lowercase = Array("abcdefghijklmnopqrstuvwxyz")
    private let digits = Array("0123456789")
    private let symbols = Array("!@#$%^&*()-_=+[]{};:,.<>?/|")

    func generate(config: PasswordConfig) -> String {
        let pool = characterPool(config: config)
        guard !pool.isEmpty else { return "" }
        guard (6...64).contains(config.length) else { return "" }

        var password = String()
        while password.count < config.length {
            var random: UInt32 = 0
            let status = SecRandomCopyBytes(kSecRandomDefault, MemoryLayout<UInt32>.size, &random)
            if status != errSecSuccess { continue }
            let index = Int(random) % pool.count
            password.append(pool[index])
        }
        return password
    }

    func strength(for config: PasswordConfig) -> PasswordStrength {
        let poolSize = Double(characterPool(config: config).count)
        guard poolSize > 0 else { return PasswordStrength(entropyBits: 0, label: "Invalid") }
        let entropy = Double(config.length) * log2(poolSize)
        let label: String
        switch entropy {
        case ..<40: label = "Weak"
        case ..<60: label = "Moderate"
        case ..<100: label = "Strong"
        default: label = "Very Strong"
        }
        return PasswordStrength(entropyBits: entropy, label: label)
    }

    private func characterPool(config: PasswordConfig) -> [Character] {
        var pool = [Character]()
        if config.includeUppercase { pool += uppercase }
        if config.includeLowercase { pool += lowercase }
        if config.includeDigits { pool += digits }
        if config.includeSymbols { pool += symbols }
        return pool
    }
}

