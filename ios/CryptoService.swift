import Foundation
import CommonCrypto
import CryptoKit

enum AesMode: String, CaseIterable, Identifiable {
    case aesGcm = "AES-GCM"
    case aesCbc = "AES-CBC"
    case aesCtr = "AES-CTR"

    var id: String { rawValue }

    var ivLength: Int {
        switch self {
        case .aesGcm: return 12
        case .aesCbc, .aesCtr: return 16
        }
    }

    var tag: String {
        switch self {
        case .aesGcm: return "gcm"
        case .aesCbc: return "cbc"
        case .aesCtr: return "ctr"
        }
    }

    static func from(tag: String?) -> AesMode {
        guard let lower = tag?.lowercased() else { return .aesGcm }
        switch lower {
        case "cbc": return .aesCbc
        case "ctr": return .aesCtr
        default: return .aesGcm
        }
    }
}

struct CryptoPayload {
    let mode: AesMode
    let raw: Data
    let encoded: String
}

enum CryptoError: Error {
    case invalidInput
    case derivationFailed
    case encryptionFailed
    case decryptionFailed
}

final class CryptoService {
    private let saltLength = 16
    private let iterations = 100_000
    private let keyLength = 32

    func encrypt(plaintext: String, password: String, mode: AesMode) throws -> CryptoPayload {
        guard !password.isEmpty else { throw CryptoError.invalidInput }
        guard let inputData = plaintext.data(using: .utf8) else { throw CryptoError.invalidInput }

        let salt = randomBytes(count: saltLength)
        let key = try deriveKey(password: password, salt: salt)
        let iv = randomBytes(count: mode.ivLength)

        let cipherData: Data
        switch mode {
        case .aesGcm:
            let nonce = try AES.GCM.Nonce(data: iv)
            let symmetricKey = SymmetricKey(data: key)
            let sealed = try AES.GCM.seal(inputData, using: symmetricKey, nonce: nonce)
            cipherData = sealed.ciphertext + sealed.tag
        case .aesCbc:
            cipherData = try commonCryptoCrypt(input: inputData, key: key, iv: iv, operation: CCOperation(kCCEncrypt), options: CCOptions(kCCOptionPKCS7Padding))
        case .aesCtr:
            cipherData = try ctrCrypt(input: inputData, key: key, iv: iv, operation: CCOperation(kCCEncrypt))
        }

        let payload = salt + iv + cipherData
        let encoded = "\(mode.tag):\(payload.base64EncodedString())"
        return CryptoPayload(mode: mode, raw: payload, encoded: encoded)
    }

    func decrypt(encoded: String, password: String) throws -> (AesMode, String) {
        guard !password.isEmpty else { throw CryptoError.invalidInput }
        let (mode, base64) = parse(encoded: encoded)
        guard let payload = Data(base64Encoded: base64) else { throw CryptoError.invalidInput }
        guard payload.count > saltLength + mode.ivLength else { throw CryptoError.invalidInput }

        let salt = payload[0..<saltLength]
        let iv = payload[saltLength..<(saltLength + mode.ivLength)]
        let cipherText = payload[(saltLength + mode.ivLength)...]

        let key = try deriveKey(password: password, salt: Data(salt))
        let plainData: Data

        switch mode {
        case .aesGcm:
            guard cipherText.count >= 16 else { throw CryptoError.decryptionFailed }
            let cipher = Data(cipherText.prefix(cipherText.count - 16))
            let tag = Data(cipherText.suffix(16))
            let symmetricKey = SymmetricKey(data: key)
            let nonce = try AES.GCM.Nonce(data: iv)
            let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: cipher, tag: tag)
            plainData = try AES.GCM.open(sealedBox, using: symmetricKey)
        case .aesCbc:
            plainData = try commonCryptoCrypt(input: Data(cipherText), key: key, iv: Data(iv), operation: CCOperation(kCCDecrypt), options: CCOptions(kCCOptionPKCS7Padding))
        case .aesCtr:
            plainData = try ctrCrypt(input: Data(cipherText), key: key, iv: Data(iv), operation: CCOperation(kCCDecrypt))
        }

        guard let plaintext = String(data: plainData, encoding: .utf8) else { throw CryptoError.decryptionFailed }
        return (mode, plaintext)
    }

    private func deriveKey(password: String, salt: Data) throws -> Data {
        let passwordData = password.data(using: .utf8) ?? Data()
        var derived = Data(count: keyLength)
        let result = derived.withUnsafeMutableBytes { derivedBytes in
            salt.withUnsafeBytes { saltBytes in
                CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    password, passwordData.count,
                    saltBytes.bindMemory(to: UInt8.self).baseAddress,
                    salt.count,
                    CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                    UInt32(iterations),
                    derivedBytes.bindMemory(to: UInt8.self).baseAddress,
                    keyLength
                )
            }
        }
        guard result == kCCSuccess else { throw CryptoError.derivationFailed }
        return derived
    }

    private func commonCryptoCrypt(input: Data, key: Data, iv: Data, operation: CCOperation, options: CCOptions) throws -> Data {
        var outLength: size_t = 0
        var output = Data(count: input.count + kCCBlockSizeAES128)

        let status = output.withUnsafeMutableBytes { outputBytes in
            input.withUnsafeBytes { inputBytes in
                key.withUnsafeBytes { keyBytes in
                    iv.withUnsafeBytes { ivBytes in
                        CCCrypt(
                            operation,
                            CCAlgorithm(kCCAlgorithmAES128),
                            options,
                            keyBytes.baseAddress, keyLength,
                            ivBytes.baseAddress,
                            inputBytes.baseAddress, input.count,
                            outputBytes.baseAddress, output.count,
                            &outLength
                        )
                    }
                }
            }
        }

        guard status == kCCSuccess else { throw CryptoError.encryptionFailed }
        return output.prefix(outLength)
    }

    private func ctrCrypt(input: Data, key: Data, iv: Data, operation: CCOperation) throws -> Data {
        var cryptor: CCCryptorRef?
        let status = key.withUnsafeBytes { keyBytes -> CCCryptorStatus in
            guard let keyBase = keyBytes.baseAddress else { return CCCryptorStatus(kCCMemoryFailure) }
            return iv.withUnsafeBytes { ivBytes -> CCCryptorStatus in
                guard let ivBase = ivBytes.baseAddress else { return CCCryptorStatus(kCCMemoryFailure) }
                return CCCryptorCreateWithMode(
                    operation,
                    CCMode(kCCModeCTR),
                    CCAlgorithm(kCCAlgorithmAES128),
                    CCPadding(ccNoPadding),
                    ivBase,
                    keyBase,
                    keyLength,
                    nil,
                    0,
                    0,
                    CCModeOptions(kCCModeOptionCTR_BE),
                    &cryptor
                )
            }
        }
        guard status == kCCSuccess, let cryptor else { throw CryptoError.encryptionFailed }
        defer { CCCryptorRelease(cryptor) }

        var output = Data(count: input.count + kCCBlockSizeAES128)
        var outLength: size_t = 0
        var total: size_t = 0

        let updateStatus = input.withUnsafeBytes { inputBytes -> CCCryptorStatus in
            guard let inputBase = inputBytes.baseAddress else { return CCCryptorStatus(kCCMemoryFailure) }
            return output.withUnsafeMutableBytes { outputBytes -> CCCryptorStatus in
                guard let outputBase = outputBytes.baseAddress else { return CCCryptorStatus(kCCMemoryFailure) }
                return CCCryptorUpdate(
                    cryptor,
                    inputBase,
                    input.count,
                    outputBase,
                    output.count,
                    &outLength
                )
            }
        }
        guard updateStatus == kCCSuccess else { throw CryptoError.encryptionFailed }
        total += outLength

        let finalStatus = output.withUnsafeMutableBytes { outputBytes -> CCCryptorStatus in
            guard let outputBase = outputBytes.baseAddress else { return CCCryptorStatus(kCCMemoryFailure) }
            return CCCryptorFinal(
                cryptor,
                outputBase.advanced(by: Int(total)),
                size_t(output.count - Int(total)),
                &outLength
            )
        }
        guard finalStatus == kCCSuccess else { throw CryptoError.encryptionFailed }
        total += outLength
        return output.prefix(total)
    }

    private func randomBytes(count: Int) -> Data {
        var data = Data(count: count)
        _ = data.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, count, $0.baseAddress!) }
        return data
    }

    private func parse(encoded: String) -> (AesMode, String) {
        let parts = encoded.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
        if parts.count == 2 {
            let mode = AesMode.from(tag: String(parts[0]))
            return (mode, String(parts[1]))
        }
        return (.aesGcm, encoded)
    }
}

private func +(lhs: Data, rhs: Data) -> Data {
    var data = Data(lhs)
    data.append(rhs)
    return data
}

