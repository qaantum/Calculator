# How to Run iOS Tests

## Method 1: Xcode GUI (Easiest)

1. **Open the project:**
   ```bash
   open ios/Cryptatext/Cryptatext.xcodeproj
   ```

2. **Select a simulator or device:**
   - In Xcode, click on the device selector at the top
   - Choose an iOS Simulator (e.g., iPhone 15)

3. **Run all tests:**
   - Press `⌘ + U` (Command + U)
   - Or go to **Product** → **Test**

4. **Run specific tests:**
   - Open Test Navigator: `⌘ + 6`
   - Click the play button next to individual tests or test suites

5. **View results:**
   - Test results appear in the Test Navigator
   - Green checkmarks = passed
   - Red X = failed (click to see error details)

## Method 2: Command Line (Requires Full Xcode)

If you have full Xcode installed (not just command line tools):

```bash
cd ios
xcodebuild test \
  -scheme Cryptatext \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:CryptatextTests
```

## Expected Test Results

### Test Suites:
- **PasswordVaultStoreTests**: ~13 tests
  - CRUD operations
  - Export/Import
  - CSV parsing
  - Master password management

- **PasswordVaultSecurityTests**: ~9 tests
  - Password hashing
  - Encryption verification
  - Data integrity
  - Wrong password rejection

- **CryptatextTests**: Basic app tests

**Total: ~22+ test methods**

## Troubleshooting

### If tests fail to compile:
1. Make sure the test target includes all necessary files
2. Check that `@testable import Cryptatext` works
3. Verify Swift Testing framework is available (iOS 18+ or Xcode 15+)

### If you see "No such module 'Testing'":
- Update to Xcode 15+ (Swift Testing is new)
- Or switch tests to use XCTest framework instead

### If tests can't find PasswordVaultStore:
- Check that `PasswordVaultStore.swift` is included in the main app target
- Verify `@testable import Cryptatext` is correct

## Test Coverage

The iOS tests mirror the Android tests:
- ✅ CRUD operations
- ✅ Encryption/Decryption
- ✅ Master password management
- ✅ Export/Import functionality
- ✅ CSV parsing
- ✅ Security tests

