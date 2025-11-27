# Implementation Tasks: Password Manager Pivot

## 🎯 Strategic Goal

**Pivot from "Text Encryption Tool" to "Local-Only Password Manager that also encrypts text"**

---

## 📋 Task Breakdown by Phase

### Phase 1: Core Password Manager (MVP)

#### 1.1 Data Models & Storage

- [ ] **Create PasswordEntry data model**
  - Fields: `id`, `service/website`, `username`, `password`, `notes`, `category/tags`, `createdAt`, `updatedAt`
  - Android: `data class PasswordEntry`
  - iOS: `struct PasswordEntry: Codable`

- [ ] **Create PasswordVault repository**
  - Encrypted storage for password entries
  - CRUD operations (Create, Read, Update, Delete)
  - Search/filter functionality
  - Android: `PasswordVaultRepository` using encrypted DataStore
  - iOS: `PasswordVaultStore` using encrypted UserDefaults or SQLite

- [ ] **Implement master password/key derivation**
  - Master password setup flow
  - Key derivation (PBKDF2, same as current encryption)
  - Master key storage in platform KeyStore/Keychain
  - Master password change flow

- [ ] **Implement encryption for password entries**
  - Encrypt each password entry individually
  - Use existing AES-GCM encryption
  - Encrypt entire entry (username + password + notes)
  - Decrypt on-demand (not store plaintext)

#### 1.2 UI Components

- [ ] **Password Manager Screen**
  - List view of password entries
  - Search bar
  - Filter by category
  - Empty state
  - Android: New screen in navigation
  - iOS: New tab or section

- [ ] **Password Entry List Item**
  - Display: Service name, username (masked), last updated
  - Tap to view/edit
  - Swipe to delete
  - Copy password button
  - Android: `PasswordEntryListItem` composable
  - iOS: `PasswordEntryRow` view

- [ ] **Add/Edit Password Entry Screen**
  - Form fields: Service, Username, Password, Notes, Category
  - Password visibility toggle
  - Generate password button (integrate existing generator)
  - Save/Cancel buttons
  - Validation
  - Android: `AddEditPasswordScreen` composable
  - iOS: `AddEditPasswordView` view

- [ ] **View Password Entry Screen**
  - Display all fields
  - Copy buttons (username, password)
  - Edit button
  - Delete button
  - Show/hide password toggle
  - Android: `ViewPasswordScreen` composable
  - iOS: `ViewPasswordView` view

- [ ] **Master Password Setup Screen**
  - First-time setup flow
  - Password input (with strength indicator)
  - Confirm password
  - Biometric setup option (premium)
  - Android: `MasterPasswordSetupScreen` composable
  - iOS: `MasterPasswordSetupView` view

- [ ] **Master Password Unlock Screen**
  - Password input
  - Biometric unlock option (premium)
  - Forgot password? (show warning)
  - Android: `MasterPasswordUnlockScreen` composable
  - iOS: `MasterPasswordUnlockView` view

#### 1.3 Free Tier Limitation

- [ ] **Implement 10-item limit**
  - Check count before adding new entry
  - Show upgrade prompt at limit
  - Display "X of 10 passwords" in UI
  - Block adding new entries at limit
  - Android: Check in `PasswordVaultRepository`
  - iOS: Check in `PasswordVaultStore`

- [ ] **Upgrade prompt UI**
  - Modal/dialog when limit reached
  - "Upgrade to Premium" button
  - Show premium features
  - Link to premium purchase
  - Android: `UpgradePromptDialog` composable
  - iOS: `UpgradePromptView` view

#### 1.4 Integration with Existing Features

- [ ] **Integrate password generator**
  - "Generate Password" button in Add/Edit screen
  - Pre-fill password field
  - Use existing `PasswordGenerator` class
  - Same UI/UX as current generator

- [ ] **Integrate text encryption**
  - Keep existing text encryption feature
  - Add to navigation/tabs
  - Position as "bonus feature"
  - No changes to existing functionality

- [ ] **Update app navigation**
  - Add Password Manager to main navigation
  - Reorganize tabs/sections
  - Update app structure
  - Android: Update `AppDestination` navigation
  - iOS: Update `ContentView` tabs

#### 1.5 Testing

- [ ] **Unit tests for PasswordVault**
  - Test encryption/decryption
  - Test CRUD operations
  - Test search/filter
  - Test 10-item limit
  - Android: `PasswordVaultRepositoryTest`
  - iOS: `PasswordVaultStoreTests`

- [ ] **UI tests**
  - Test add/edit/delete flows
  - Test search/filter
  - Test 10-item limit
  - Test master password setup
  - Android: UI tests
  - iOS: UI tests

- [ ] **Security tests**
  - Test master password derivation
  - Test encryption strength
  - Test key storage security
  - Test data persistence

---

### Phase 2: Premium Features

#### 2.1 Premium Unlock System

- [ ] **Implement in-app purchase system**
  - Android: Google Play Billing Library
  - iOS: StoreKit
  - One-time purchase: $9.99
  - Subscription: $1.99/month (optional)
  - Purchase verification
  - Restore purchases

- [ ] **Premium state management**
  - Check premium status
  - Store premium status locally
  - Verify with store on app launch
  - Handle purchase events
  - Android: `PremiumManager` class
  - iOS: `PremiumManager` class

- [ ] **Premium UI indicators**
  - Premium badge/icon
  - "Premium" label in settings
  - Upgrade button in free tier
  - Premium features locked/unlocked states

#### 2.2 Unlimited Password Manager

- [ ] **Remove 10-item limit for premium**
  - Check premium status
  - Allow unlimited entries
  - Update UI to show "Unlimited" or count
  - Remove upgrade prompts

#### 2.3 Biometric Unlock

- [ ] **Implement biometric authentication**
  - Android: BiometricPrompt API
  - iOS: LocalAuthentication framework
  - Face ID / Touch ID / Fingerprint
  - Setup flow in settings
  - Unlock flow on app launch
  - Fallback to master password

- [ ] **Biometric UI**
  - Setup screen
  - Unlock prompt
  - Settings toggle
  - Error handling (biometric unavailable)

#### 2.4 Optional Cloud Sync (Premium) - FUTURE PHASE

**⚠️ IMPORTANT: This maintains "local-only" promise by using USER'S cloud (iCloud/Google Drive), not our servers**

- [ ] **Implement cloud sync via user's cloud**
  - Android: Google Drive API
  - iOS: iCloud Drive API
  - Optional: Dropbox, WebDAV
  - Encrypted sync (encrypt before upload)
  - Sync on user's cloud, not your servers
  - Maintains "no vendor servers" promise
  - **Note:** This is Phase 3 or later - not breaking local promise

- [ ] **Sync UI**
  - Sync settings screen
  - Enable/disable sync
  - Choose cloud provider
  - Sync status indicator
  - Manual sync button
  - Conflict resolution

- [ ] **Sync logic**
  - Encrypt data before upload
  - Download and decrypt on other devices
  - Merge conflicts
  - Last-write-wins or manual resolution
  - Sync frequency (manual or periodic)

#### 2.5 Export/Import (Premium)

- [ ] **Implement encrypted export**
  - Export all passwords to encrypted file
  - Use existing encryption (AES-GCM)
  - JSON format
  - Include metadata (version, timestamp)
  - Android: File export via system share
  - iOS: File export via system share

- [ ] **Implement encrypted import**
  - Import from encrypted file
  - Validate file format
  - Decrypt and parse
  - Merge or replace
  - Conflict handling
  - Android: File picker
  - iOS: File picker

- [ ] **Export/Import UI**
  - Export button in settings
  - Import button in settings
  - File picker
  - Progress indicator
  - Success/error messages
  - Confirmation dialogs

---

### Phase 3: Polish & Launch (FUTURE)

**Note:** These are future tasks, not part of MVP. Focus on Phase 1 & 2 first.

#### 3.1 UI/UX Improvements (FUTURE)
- [ ] Update app branding
- [ ] Improve password manager UI
- [ ] Onboarding flow
- [ ] Settings screen updates

#### 3.2 App Store Preparation (FUTURE)
- [ ] Update app description
- [ ] Update privacy policy
- [ ] Prepare marketing materials

#### 3.3 Testing & QA (FUTURE)
- [ ] Comprehensive testing
- [ ] Cross-platform testing
- [ ] Security audit
- [ ] Performance testing

#### 3.4 Beta Testing (FUTURE)
- [ ] Prepare beta release
- [ ] Gather feedback
- [ ] Iterate based on feedback

#### 3.5 Production Launch (FUTURE)
- [ ] Final release preparation
- [ ] Submit to stores

---

## 🎯 Priority Order

### Must Have (MVP - Phase 1):
1. Password Manager core (data models, storage, CRUD)
2. Master password setup/unlock
3. Add/Edit/View password screens
4. 10-item limit for free tier
5. Integration with existing features
6. Basic testing

### Should Have (Premium - Phase 2):
7. Premium unlock system
8. Unlimited passwords
9. Biometric unlock
10. Export/Import

### Future Features (Phase 3+):
11. Cloud sync (user's cloud - maintains local promise)
12. Advanced features (categories, tags, notes)
13. Multiple vaults
14. Secure notes
15. File encryption

---

## 🚀 Quick Start Checklist

Before starting implementation:

- [ ] Review and approve this task list
- [ ] Decide on data model structure
- [ ] Decide on encryption approach (reuse existing or new?)
- [ ] Decide on storage approach (DataStore vs SQLite)
- [ ] Set up premium purchase system (Google Play / App Store)
- [ ] Create design mockups for password manager UI
- [ ] Set up project structure for new features

---

## 📝 Notes

- **Reuse existing code:** Password generator, encryption service, theme system
- **Maintain privacy promise:** All data local-only, no network calls
  - **Cloud sync (future):** Only via user's cloud (iCloud/Google Drive), not our servers - maintains local promise
- **Keep text encryption:** Don't remove, just reposition as secondary feature
- **Test thoroughly:** Security is critical for password manager
- **Focus on MVP:** Phase 1 & 2 only - other features are future
- **10-item limit:** Free tier limited to 10 passwords

---

**Last Updated:** December 2024  
**Status:** ✅ **COMPLETE** - All Phase 1 & 2 features implemented  
**Focus:** Phase 1 & 2 complete - Phase 3 features are future enhancements

---

## ✅ Implementation Complete!

All MVP (Phase 1) and Premium (Phase 2) features have been successfully implemented:

- ✅ Core Password Manager (data models, storage, CRUD)
- ✅ Master password setup/unlock/change
- ✅ Add/Edit/View password screens
- ✅ Biometric unlock (Face ID/Touch ID/Fingerprint)
- ✅ Export/Import (encrypted JSON + CSV)
- ✅ Search and filter functionality
- ✅ Categories support
- ✅ Swipe to delete gesture
- ✅ Comprehensive test coverage (72+ test cases)
- ✅ Security tests (19 test cases)

**Note:** The 10-item limit was removed - all features are now free for all users.

See `IMPLEMENTATION_STATUS.md` for complete details.

