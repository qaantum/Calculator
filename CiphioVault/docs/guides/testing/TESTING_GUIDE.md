# Testing Guide for Password Manager

This document describes all the tests available for the Password Manager feature and how to run them.

## Test Coverage

### Android Tests

#### Unit Tests

**Location:** `android/app/src/test/java/com/ciphio/passwordmanager/`

1. **PasswordVaultRepositoryTest.kt**
   - Tests CRUD operations (Create, Read, Update, Delete)
   - Tests encryption/decryption
   - Tests export/import functionality
   - Tests CSV import parsing
   - Tests master password management
   - **15+ test cases**

2. **CsvImportTest.kt**
   - Tests CSV parsing with various formats
   - Tests quoted fields handling
   - Tests different column orders
   - Tests missing optional fields
   - Tests URL to domain extraction
   - **8+ test cases**

3. **PasswordVaultSecurityTest.kt**
   - Tests master password security (not stored in plaintext)
   - Tests encryption before storage
   - Tests wrong password decryption prevention
   - Tests master password verification
   - Tests password re-encryption on change
   - Tests exported data encryption
   - Tests data integrity
   - Tests multiple entries encryption
   - Tests deterministic password hashing
   - **10+ security test cases**

#### UI Tests

**Location:** `android/app/src/androidTest/java/com/ciphio/passwordmanager/`

1. **PasswordManagerUITest.kt**
   - Test structure for UI flows:
     - Master password setup
     - Add password entry
     - Edit password entry
     - Delete password entry (including swipe)
     - Search functionality
     - Category filter
     - Copy password
     - Password visibility toggle

### iOS Tests

#### Unit Tests

**Location:** `ios/Ciphio/CiphioTests/`

1. **PasswordVaultStoreTests.swift**
   - Tests CRUD operations
   - Tests encryption/decryption
   - Tests export/import functionality
   - Tests CSV import parsing
   - Tests master password management
   - **13+ test cases**

2. **PasswordVaultSecurityTests.swift**
   - Tests master password security
   - Tests encryption before storage
   - Tests wrong password decryption prevention
   - Tests master password verification
   - Tests exported data encryption
   - Tests data integrity
   - Tests multiple entries encryption
   - Tests deterministic password hashing
   - **9+ security test cases**

#### UI Tests

**Location:** `ios/Ciphio/CiphioUITests/`

1. **CiphioUITests.swift**
   - Test structure for UI flows:
     - App launch
     - Password manager tab navigation
     - Master password setup
     - Add/edit/delete flows
     - Search and filter
     - Copy password
     - Password visibility toggle
     - Swipe to delete

## Running Tests

### Android

#### Run All Unit Tests
```bash
cd android
./gradlew test
```

#### Run Specific Test Class
```bash
./gradlew test --tests "com.ciphio.passwordmanager.PasswordVaultRepositoryTest"
./gradlew test --tests "com.ciphio.passwordmanager.CsvImportTest"
./gradlew test --tests "com.ciphio.passwordmanager.PasswordVaultSecurityTest"
```

#### Run UI Tests (requires emulator/device)
```bash
./gradlew connectedAndroidTest
```

#### Run Tests with Coverage
```bash
./gradlew testDebugUnitTest --continue
./gradlew jacocoTestReport
```

### iOS

#### Run All Tests in Xcode
1. Open the project in Xcode
2. Press `⌘ + U` or go to **Product** → **Test**
3. Or use the Test Navigator (⌘ + 6) to run individual tests

#### Run Tests from Command Line
```bash
cd ios
xcodebuild test -scheme Ciphio -destination 'platform=iOS Simulator,name=iPhone 15'
```

#### Run Specific Test Suite
In Xcode:
1. Open Test Navigator (⌘ + 6)
2. Right-click on the test suite you want to run
3. Select "Run 'TestSuiteName'"

## Test Results

### Expected Test Counts

**Android:**
- Unit Tests: ~33 test cases
- UI Tests: 8 test templates (ready for implementation)
- Security Tests: 10 test cases

**iOS:**
- Unit Tests: ~22 test cases
- UI Tests: 9 test templates (ready for implementation)
- Security Tests: 9 test cases

## Test Implementation Status

### ✅ Completed
- [x] Unit tests for CRUD operations
- [x] Unit tests for encryption/decryption
- [x] Unit tests for export/import
- [x] Unit tests for CSV parsing
- [x] Security tests for password storage
- [x] Security tests for encryption
- [x] Security tests for data integrity
- [x] UI test structure and templates

### 🔄 Ready for Enhancement
- [ ] UI tests can be expanded with actual UI interactions
- [ ] Integration tests for end-to-end flows
- [ ] Performance tests for large datasets
- [ ] Biometric authentication tests

## Notes

- All unit tests use in-memory DataStore/UserDefaults for isolation
- Security tests verify encryption strength and password handling
- UI tests are structured but may need app-specific selectors
- Tests are designed to be independent and can run in any order

## Troubleshooting

### Android Tests
- If tests fail with "No such file or directory", ensure Gradle is properly configured
- For UI tests, ensure an emulator or device is connected
- Check that all test dependencies are in `build.gradle.kts`

### iOS Tests
- Ensure the project is properly configured in Xcode
- For UI tests, ensure a simulator is available
- Check that test targets are properly set up

