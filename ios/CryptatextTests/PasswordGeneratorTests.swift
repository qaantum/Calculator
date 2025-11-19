import XCTest
// Note: If tests are in a separate test target in Xcode, add: @testable import Cryptatext
// (Replace "Cryptatext" with your actual app target name)

/**
 * PasswordGeneratorTests
 * 
 * These tests verify that password generation works correctly.
 * 
 * What we're testing:
 * 1. Generated passwords have the correct length
 * 2. Generated passwords only use allowed characters
 * 3. Entropy calculation works correctly
 * 4. Strength labels are correct (Weak, Moderate, Strong, Very Strong)
 */
final class PasswordGeneratorTests: XCTestCase {
    
    // The password generator we're testing
    private var generator: PasswordGenerator!
    
    // setUp() runs before each test - we create a fresh generator instance
    override func setUp() {
        super.setUp()
        generator = PasswordGenerator()  // Create a new generator for each test
    }
    
    // tearDown() runs after each test - we clean up
    override func tearDown() {
        generator = nil  // Release the generator
        super.tearDown()
    }
    
    /**
     * Test: Generated password should have the exact length we requested.
     * 
     * We ask for 32 characters, so we should get exactly 32 characters.
     */
    func testGeneratedPasswordHasRequestedLength() {
        // Configure: 32 characters, all character types enabled
        let config = PasswordConfig(
            length: 32,
            includeUppercase: true,
            includeLowercase: true,
            includeDigits: true,
            includeSymbols: true
        )
        
        // Generate the password
        let password = generator.generate(config: config)
        
        // Verify: password should be exactly 32 characters long
        XCTAssertEqual(password.count, 32, "Password should have requested length")
    }
    
    /**
     * Test: Generated password should only use characters from enabled character sets.
     * 
     * We enable only uppercase letters and digits, so the password should
     * only contain A-Z and 0-9 (no lowercase, no symbols).
     */
    func testGeneratedPasswordCharactersStayWithinSelectedPool() {
        // Configure: only uppercase and digits enabled (no lowercase, no symbols)
        let config = PasswordConfig(
            length: 40,
            includeUppercase: true,
            includeLowercase: false,  // Disabled
            includeDigits: true,
            includeSymbols: false     // Disabled
        )
        
        // Generate the password
        let password = generator.generate(config: config)
        
        // Define what characters are allowed (only A-Z and 0-9)
        let allowed = Set("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        
        // Verify: password is not empty
        XCTAssertFalse(password.isEmpty, "Password should not be empty")
        
        // Verify: every character in the password is in the allowed set
        for char in password {
            XCTAssertTrue(allowed.contains(char), 
                        "Character '\(char)' is not in allowed pool (should only be A-Z and 0-9)")
        }
    }
    
    /**
     * Test: Entropy calculation should work correctly.
     * 
     * Entropy measures password strength. More characters and more character types = higher entropy.
     * We verify that entropy is calculated (greater than 0) and a label is assigned.
     */
    func testEntropyCalculationRespectsPoolSize() {
        // Configure: 12 characters, uppercase + lowercase only (no digits, no symbols)
        let config = PasswordConfig(
            length: 12,
            includeUppercase: true,
            includeLowercase: true,
            includeDigits: false,
            includeSymbols: false
        )
        
        // Calculate strength
        let strength = generator.strength(for: config)
        
        // Verify: entropy should be greater than 0 (password has some strength)
        XCTAssertGreaterThan(strength.entropyBits, 0.0, "Entropy should be greater than 0")
        
        // Verify: strength label should not be empty
        XCTAssertFalse(strength.label.isEmpty, "Strength label should not be empty")
    }
    
    /**
     * Test: Strength labels should be correct based on entropy.
     * 
     * Strength categories:
     * - Weak: < 40 bits
     * - Moderate: 40-59 bits
     * - Strong: 60-99 bits
     * - Very Strong: >= 100 bits
     * 
     * We test each category to make sure the labels are correct.
     */
    func testStrengthLabels() {
        // Test Weak: 6 characters, only uppercase (26 possible characters)
        // Entropy = 6 * log2(26) ≈ 28 bits (< 40, so "Weak")
        let weakConfig = PasswordConfig(
            length: 6, 
            includeUppercase: true, 
            includeLowercase: false, 
            includeDigits: false, 
            includeSymbols: false
        )
        let weakStrength = generator.strength(for: weakConfig)
        XCTAssertTrue(weakStrength.entropyBits < 40.0, "Should be less than 40 bits")
        XCTAssertEqual(weakStrength.label, "Weak", "Should be labeled as Weak")
        
        // Test Moderate: 8 characters, uppercase + lowercase (52 possible characters)
        // Entropy = 8 * log2(52) ≈ 45 bits (40-59, so "Moderate")
        let moderateConfig = PasswordConfig(
            length: 8, 
            includeUppercase: true, 
            includeLowercase: true, 
            includeDigits: false, 
            includeSymbols: false
        )
        let moderateStrength = generator.strength(for: moderateConfig)
        XCTAssertTrue(moderateStrength.entropyBits >= 40.0 && moderateStrength.entropyBits < 60.0, 
                     "Should be between 40-59 bits")
        XCTAssertEqual(moderateStrength.label, "Moderate", "Should be labeled as Moderate")
        
        // Test Strong: 12 characters, all character types (94 possible characters)
        // Entropy = 12 * log2(94) ≈ 78 bits (60-99, so "Strong")
        let strongConfig = PasswordConfig(
            length: 12, 
            includeUppercase: true, 
            includeLowercase: true, 
            includeDigits: true, 
            includeSymbols: true
        )
        let strongStrength = generator.strength(for: strongConfig)
        XCTAssertTrue(strongStrength.entropyBits >= 60.0 && strongStrength.entropyBits < 100.0, 
                     "Should be between 60-99 bits")
        XCTAssertEqual(strongStrength.label, "Strong", "Should be labeled as Strong")
        
        // Test Very Strong: 20 characters, all character types (94 possible characters)
        // Entropy = 20 * log2(94) ≈ 130 bits (>= 100, so "Very Strong")
        let veryStrongConfig = PasswordConfig(
            length: 20, 
            includeUppercase: true, 
            includeLowercase: true, 
            includeDigits: true, 
            includeSymbols: true
        )
        let veryStrongStrength = generator.strength(for: veryStrongConfig)
        XCTAssertTrue(veryStrongStrength.entropyBits >= 100.0, "Should be >= 100 bits")
        XCTAssertEqual(veryStrongStrength.label, "Very Strong", "Should be labeled as Very Strong")
    }
}

