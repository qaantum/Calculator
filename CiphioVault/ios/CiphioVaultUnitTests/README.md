# iOS Unit Tests

This directory contains unit tests for the Ciphio Vault iOS app.

## Setup in Xcode

1. Open your Xcode project (or create one if needed)
2. Add a new **Unit Testing Bundle** target:
   - File → New → Target → iOS Unit Testing Bundle
   - Name it `CiphioVaultTests`
3. Add these test files to the test target:
   - `CryptoServiceTests.swift`
   - `PasswordGeneratorTests.swift`
4. If the test target is separate from the main app target, add this import at the top of each test file:
   ```swift
   @testable import CiphioVault
   ```
   (Replace `CiphioVault` with your actual app target name if different)

## Running Tests

- In Xcode: Product → Test (⌘U)
- Command line: `xcodebuild test -scheme CiphioVault -destination 'platform=iOS Simulator,name=iPhone 15'`

## Test Coverage

- **CryptoServiceTests**: Tests encryption/decryption round-trips for all three AES modes (GCM, CBC, CTR)
- **PasswordGeneratorTests**: Tests password generation, character pool validation, entropy calculation, and strength labels

