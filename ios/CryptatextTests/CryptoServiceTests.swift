import XCTest
// Note: If tests are in a separate test target in Xcode, add: @testable import Cryptatext
// (Replace "Cryptatext" with your actual app target name)

/**
 * CryptoServiceTests
 * 
 * These tests verify that encryption and decryption work correctly.
 * 
 * What we're testing:
 * 1. Can encrypt text with a password
 * 2. Can decrypt the encrypted text back to original
 * 3. Works for all three encryption modes (GCM, CBC, CTR)
 * 
 * This is called a "round-trip" test: encrypt → decrypt → should get original text back.
 */
final class CryptoServiceTests: XCTestCase {
    
    // These are test data - we'll use the same text and password for all tests
    private var service: CryptoService!  // The encryption service we're testing
    private let sampleText = "Confidential message"  // Text to encrypt
    private let password = "SuperSecret#123"  // Password to use
    
    // setUp() runs before each test - we create a fresh CryptoService instance
    override func setUp() {
        super.setUp()
        service = CryptoService()  // Create a new service for each test
    }
    
    // tearDown() runs after each test - we clean up
    override func tearDown() {
        service = nil  // Release the service
        super.tearDown()
    }
    
    // Test AES-GCM encryption (default mode)
    func testEncryptThenDecryptRoundTripForAESGCM() throws {
        try assertRoundTrip(mode: .aesGcm)
    }
    
    // Test AES-CBC encryption
    func testEncryptThenDecryptRoundTripForAESCBC() throws {
        try assertRoundTrip(mode: .aesCbc)
    }
    
    // Test AES-CTR encryption
    func testEncryptThenDecryptRoundTripForAESCTR() throws {
        try assertRoundTrip(mode: .aesCtr)
    }
    
    /**
     * Helper function that tests encryption/decryption for a given mode.
     * 
     * Steps:
     * 1. Encrypt the sample text with the password
     * 2. Check that the output starts with the correct algorithm tag (gcm:, cbc:, or ctr:)
     * 3. Decrypt the encrypted text
     * 4. Verify we get the original text back
     */
    private func assertRoundTrip(mode: AesMode) throws {
        // Step 1: Encrypt
        let encrypted = try service.encrypt(plaintext: sampleText, password: password, mode: mode)
        
        // Step 2: Verify output format (should start with "gcm:", "cbc:", or "ctr:")
        XCTAssertTrue(encrypted.encoded.starts(with: "\(mode.tag):"), 
                    "Encrypted output should start with algorithm tag")
        
        // Step 3: Decrypt
        let (resolvedMode, decrypted) = try service.decrypt(encoded: encrypted.encoded, password: password)
        
        // Step 4: Verify we got the original text back
        XCTAssertEqual(resolvedMode, mode, "Decryption should detect the correct algorithm")
        XCTAssertEqual(decrypted, sampleText, "Decrypted text should match original")
    }
}

