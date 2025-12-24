# iOS Beta Release Checklist

**Date:** December 2024  
**Status:** Pre-Beta Release  
**Target:** TestFlight Beta

---

## ✅ Pre-Release Configuration

### 1. Xcode Project Setup

#### AutoFill Extension Target
- [ ] Verify AutoFill Extension target exists in Xcode project
- [ ] Extension target has correct bundle identifier: `com.ciphio.vault.AutoFillExtension`
- [ ] Extension Info.plist is properly configured
- [ ] Extension principal class is set: `CredentialProviderViewController`

#### App Groups Capability
- [ ] Add App Groups capability to main app target
- [ ] Add App Groups capability to AutoFill Extension target
- [ ] Configure App Group identifier: `group.com.ciphio.vault`
- [ ] Verify both targets use the same App Group

#### Keychain Sharing Capability
- [ ] Add Keychain Sharing capability to main app target
- [ ] Add Keychain Sharing capability to AutoFill Extension target
- [ ] Configure Keychain Access Group: `$(AppIdentifierPrefix)com.ciphio.vault`
- [ ] Verify both targets use the same Keychain Access Group

#### Build Settings
- [ ] Verify deployment target: iOS 15.0+
- [ ] Verify code signing is configured
- [ ] Verify provisioning profiles are set up
- [ ] Check that all targets build without errors

---

## ✅ Code Verification

### 2. Core Features
- [ ] Text encryption (AES-GCM, CBC, CTR) works
- [ ] Password generator works
- [ ] Password manager CRUD operations work
- [ ] Master password setup/change/unlock works
- [ ] Biometric authentication works (on real device)
- [ ] Import/Export works
- [ ] Search and filtering work
- [ ] Categories work
- [ ] History works
- [ ] Theme switching works

### 3. AutoFill Integration
- [ ] Credentials register with iOS when added
- [ ] Credentials register with iOS when updated
- [ ] Credentials removed when deleted
- [ ] AutoFill extension can access shared data
- [ ] AutoFill extension can authenticate
- [ ] AutoFill prompt appears in Settings

### 4. Premium Features
- [ ] Premium purchase flow works
- [ ] Premium status is saved
- [ ] Free tier limit (20 passwords) is enforced
- [ ] Premium upgrade prompts appear correctly

---

## ✅ Testing Checklist

### 5. Device Testing (Real Device Required)

#### Basic Functionality
- [ ] App launches without crashes
- [ ] Master password setup works
- [ ] Master password unlock works
- [ ] Biometric unlock works (Face ID/Touch ID)
- [ ] Add password entry works
- [ ] Edit password entry works
- [ ] Delete password entry works
- [ ] Search passwords works
- [ ] Filter by category works

#### AutoFill Testing
- [ ] AutoFill extension appears in Settings → Passwords → Password Options
- [ ] Can enable AutoFill in Settings
- [ ] AutoFill appears when tapping login fields in Safari
- [ ] AutoFill appears when tapping login fields in other apps
- [ ] Can select credential from AutoFill
- [ ] Authentication works in AutoFill (Face ID/Touch ID)
- [ ] Credentials are filled correctly
- [ ] Save password prompt appears after login

#### Edge Cases
- [ ] App handles no passwords gracefully
- [ ] App handles corrupted data gracefully
- [ ] App handles network errors (if applicable)
- [ ] App handles low memory situations
- [ ] App handles background/foreground transitions

### 6. Performance Testing
- [ ] App launches quickly (< 2 seconds)
- [ ] Password list scrolls smoothly (100+ entries)
- [ ] Search is responsive (debounced)
- [ ] Encryption/decryption is fast
- [ ] No memory leaks (check with Instruments)

### 7. Security Testing
- [ ] Master password is hashed (not stored plaintext)
- [ ] Passwords are encrypted at rest
- [ ] Keychain items are properly secured
- [ ] Biometric data is stored securely
- [ ] No sensitive data in logs

---

## ✅ App Store Connect Setup

### 8. App Information
- [ ] App name: "Ciphio Vault"
- [ ] Bundle ID: `com.ciphio.vault`
- [ ] Version number: Set appropriately (e.g., 1.0.0)
- [ ] Build number: Increment for each build

### 9. App Store Listing (For Beta)
- [ ] App description (can be brief for beta)
- [ ] Keywords (optional for beta)
- [ ] Privacy policy URL (required)
- [ ] Support URL (optional)

### 10. TestFlight Configuration
- [ ] Create TestFlight group
- [ ] Add beta testers
- [ ] Configure beta testing information
- [ ] Set up external testing (if needed)

---

## ✅ Build & Archive

### 11. Build Configuration
- [ ] Select "Any iOS Device" or specific device
- [ ] Set build configuration to "Release"
- [ ] Clean build folder (Product → Clean Build Folder)
- [ ] Build project (⌘B)
- [ ] Verify no build errors or warnings

### 12. Archive
- [ ] Product → Archive
- [ ] Wait for archive to complete
- [ ] Verify archive appears in Organizer
- [ ] Check archive size (should be reasonable)

### 13. Upload to App Store Connect
- [ ] Click "Distribute App"
- [ ] Select "App Store Connect"
- [ ] Select "Upload"
- [ ] Choose distribution options
- [ ] Upload archive
- [ ] Wait for processing to complete

---

## ✅ Post-Upload Verification

### 14. App Store Connect
- [ ] Verify build appears in TestFlight
- [ ] Check processing status
- [ ] Verify no compliance issues
- [ ] Check for any warnings or errors

### 15. TestFlight Testing
- [ ] Install app via TestFlight
- [ ] Test all core features
- [ ] Test AutoFill functionality
- [ ] Report any issues found

---

## ✅ Documentation

### 16. Beta Release Notes
- [ ] Create release notes for beta testers
- [ ] List known issues (if any)
- [ ] Provide setup instructions
- [ ] Include feedback mechanism

### 17. Known Issues
- [ ] Document any known bugs
- [ ] Document any limitations
- [ ] Document workarounds (if any)

---

## ✅ Final Checks

### 18. Pre-Beta Checklist
- [ ] All critical features work
- [ ] No blocking bugs
- [ ] App is stable
- [ ] Performance is acceptable
- [ ] Security is verified
- [ ] Privacy policy is accessible
- [ ] TestFlight is configured
- [ ] Beta testers are added

---

## 📋 Quick Reference

### Bundle Identifiers
- Main App: `com.ciphio.vault`
- AutoFill Extension: `com.ciphio.vault.AutoFillExtension`
- Test Targets: `com.ciphio.vault.CiphioVaultTests`, `com.ciphio.vault.CiphioVaultUITests`

### App Group
- Identifier: `group.com.ciphio.vault`

### Keychain Access Group
- Identifier: `$(AppIdentifierPrefix)com.ciphio.vault`

### Minimum iOS Version
- iOS 15.0+

---

## 🚨 Critical Issues to Fix Before Beta

If any of these are broken, **DO NOT** release beta:

1. ❌ App crashes on launch
2. ❌ Master password setup doesn't work
3. ❌ Cannot unlock vault
4. ❌ Cannot add/view passwords
5. ❌ Data loss occurs
6. ❌ Security vulnerabilities

---

## 📝 Notes

- **Real Device Required:** Many features (biometrics, AutoFill) only work on real devices
- **TestFlight:** Beta testing requires TestFlight setup in App Store Connect
- **Privacy Policy:** Must be hosted publicly before submission
- **Code Signing:** Ensure certificates and provisioning profiles are valid

---

**Last Updated:** December 2024

