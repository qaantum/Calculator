# iOS Test Plan - Beta Release

**Date:** December 2024  
**Target:** TestFlight Beta  
**Platform:** iOS 15.0+

---

## Test Environment

### Required
- **Real iOS Device** (iPhone or iPad)
  - Face ID device (iPhone X or later) OR
  - Touch ID device (iPhone 8 or earlier, iPad with Touch ID)
- **iOS 15.0 or later**
- **TestFlight app installed**

### Optional
- iOS Simulator (for basic UI testing only)
- Multiple devices (for cross-device testing)

---

## Test Categories

### 1. Core Functionality Tests

#### 1.1 App Launch
- [ ] **Test:** App launches without crashes
- [ ] **Test:** App shows correct initial screen
- [ ] **Test:** App remembers theme preference
- [ ] **Expected:** App launches in < 2 seconds

#### 1.2 Master Password Setup
- [ ] **Test:** First launch shows master password setup
- [ ] **Test:** Can set master password (6+ characters)
- [ ] **Test:** Password confirmation must match
- [ ] **Test:** Error shown if passwords don't match
- [ ] **Test:** Error shown if password too short
- [ ] **Test:** After setup, vault is unlocked
- [ ] **Expected:** Smooth setup flow, clear error messages

#### 1.3 Master Password Unlock
- [ ] **Test:** Can unlock with correct password
- [ ] **Test:** Error shown with incorrect password
- [ ] **Test:** Can toggle password visibility
- [ ] **Test:** After unlock, password list is shown
- [ ] **Expected:** Fast unlock, secure password entry

#### 1.4 Biometric Unlock (Real Device Only)
- [ ] **Test:** Biometric option appears (if device supports)
- [ ] **Test:** Face ID/Touch ID prompt appears
- [ ] **Test:** Can unlock with biometric
- [ ] **Test:** Falls back to password if biometric fails
- [ ] **Test:** Can disable biometric in settings
- [ ] **Expected:** Smooth biometric flow, secure fallback

---

### 2. Password Manager Tests

#### 2.1 Add Password Entry
- [ ] **Test:** Can add new password entry
- [ ] **Test:** All fields save correctly (service, username, password, notes)
- [ ] **Test:** Can add multiple categories
- [ ] **Test:** Entry appears in list immediately
- [ ] **Test:** Entry is sorted by most recent
- [ ] **Test:** Free tier limit (20 passwords) is enforced
- [ ] **Test:** Premium users can add unlimited passwords
- [ ] **Expected:** Fast save, immediate UI update

#### 2.2 View Password Entry
- [ ] **Test:** Can view password entry details
- [ ] **Test:** Password is hidden by default
- [ ] **Test:** Can toggle password visibility
- [ ] **Test:** Can copy password to clipboard
- [ ] **Test:** Can copy username to clipboard
- [ ] **Test:** All fields display correctly
- [ ] **Expected:** Secure display, easy copying

#### 2.3 Edit Password Entry
- [ ] **Test:** Can edit existing entry
- [ ] **Test:** All fields can be modified
- [ ] **Test:** Changes save correctly
- [ ] **Test:** Updated timestamp changes
- [ ] **Test:** Entry moves to top of list after edit
- [ ] **Expected:** Smooth editing, immediate save

#### 2.4 Delete Password Entry
- [ ] **Test:** Can delete password entry
- [ ] **Test:** Confirmation dialog appears
- [ ] **Test:** Can cancel deletion
- [ ] **Test:** Entry is removed after confirmation
- [ ] **Test:** List updates immediately
- [ ] **Expected:** Safe deletion with confirmation

#### 2.5 Search Passwords
- [ ] **Test:** Can search by service name
- [ ] **Test:** Can search by username
- [ ] **Test:** Can search by notes
- [ ] **Test:** Can search by category
- [ ] **Test:** Search is case-insensitive
- [ ] **Test:** Search results update as you type (debounced)
- [ ] **Test:** Clear search shows all entries
- [ ] **Expected:** Fast, accurate search

#### 2.6 Category Filtering
- [ ] **Test:** Can filter by category
- [ ] **Test:** "All" shows all entries
- [ ] **Test:** Multiple categories work correctly
- [ ] **Test:** Filter works with search
- [ ] **Expected:** Smooth filtering, accurate results

---

### 3. AutoFill Tests (Real Device Only)

#### 3.1 AutoFill Setup
- [ ] **Test:** AutoFill appears in Settings → Passwords → Password Options
- [ ] **Test:** Can enable "Ciphio Vault" in AutoFill settings
- [ ] **Test:** AutoFill stays enabled after app restart
- [ ] **Expected:** Easy setup, persistent settings

#### 3.2 AutoFill Fill Credentials
- [ ] **Test:** Open Safari, navigate to website with login
- [ ] **Test:** Tap username or password field
- [ ] **Test:** AutoFill suggestion appears (key icon or "Passwords")
- [ ] **Test:** Can select "Ciphio Vault" from list
- [ ] **Test:** Face ID/Touch ID prompt appears
- [ ] **Test:** After authentication, credentials are filled
- [ ] **Test:** Works in other apps (not just Safari)
- [ ] **Expected:** Smooth AutoFill, secure authentication

#### 3.3 AutoFill Save Credentials
- [ ] **Test:** Log in to website with new credentials
- [ ] **Test:** iOS shows "Save Password" prompt
- [ ] **Test:** Can save password to Ciphio Vault
- [ ] **Test:** Saved credential appears in app
- [ ] **Test:** Saved credential is available for AutoFill
- [ ] **Expected:** Easy saving, automatic registration

#### 3.4 AutoFill Multiple Credentials
- [ ] **Test:** Have multiple credentials for same website
- [ ] **Test:** AutoFill shows list of credentials
- [ ] **Test:** Can select which credential to use
- [ ] **Expected:** Clear selection, correct filling

---

### 4. Text Encryption Tests

#### 4.1 Encrypt Text
- [ ] **Test:** Can encrypt text with password
- [ ] **Test:** All three modes work (GCM, CBC, CTR)
- [ ] **Test:** Encrypted output is different each time (nonce)
- [ ] **Test:** Can copy encrypted output
- [ ] **Test:** Can share encrypted output
- [ ] **Expected:** Fast encryption, secure output

#### 4.2 Decrypt Text
- [ ] **Test:** Can decrypt encrypted text
- [ ] **Test:** Decryption requires correct password
- [ ] **Test:** Error shown with incorrect password
- [ ] **Test:** All three modes decrypt correctly
- [ ] **Test:** Can paste encrypted text
- [ ] **Expected:** Accurate decryption, clear errors

#### 4.3 History
- [ ] **Test:** Encrypted/decrypted entries appear in history
- [ ] **Test:** Can use history entry to restore text
- [ ] **Test:** Can delete history entry
- [ ] **Test:** Can clear all history
- [ ] **Test:** History shows algorithm used
- [ ] **Expected:** Useful history, easy access

---

### 5. Password Generator Tests

#### 5.1 Generate Password
- [ ] **Test:** Can generate password
- [ ] **Test:** Can adjust length (4-32 characters)
- [ ] **Test:** Can toggle character types (uppercase, lowercase, numbers, symbols)
- [ ] **Test:** Generated password matches settings
- [ ] **Test:** Can copy generated password
- [ ] **Test:** Strength indicator shows correctly
- [ ] **Expected:** Fast generation, secure passwords

---

### 6. Import/Export Tests

#### 6.1 Export Passwords
- [ ] **Test:** Can export passwords to JSON
- [ ] **Test:** Export file contains all entries
- [ ] **Test:** Can share export file
- [ ] **Test:** Export is encrypted/secure
- [ ] **Expected:** Complete export, secure format

#### 6.2 Import Passwords
- [ ] **Test:** Can import passwords from JSON
- [ ] **Test:** Can paste JSON directly
- [ ] **Test:** Import merges with existing entries
- [ ] **Test:** Duplicate entries are handled correctly
- [ ] **Test:** Error shown for invalid JSON
- [ ] **Expected:** Smooth import, data integrity

---

### 7. Premium Features Tests

#### 7.1 Free Tier Limits
- [ ] **Test:** Free users limited to 20 passwords
- [ ] **Test:** Error shown when limit reached
- [ ] **Test:** Upgrade prompt appears
- [ ] **Expected:** Clear limits, upgrade path

#### 7.2 Premium Purchase
- [ ] **Test:** Can initiate premium purchase
- [ ] **Test:** Purchase flow works (if configured)
- [ ] **Test:** Premium status is saved
- [ ] **Test:** Premium badge appears
- [ ] **Test:** Can add unlimited passwords after purchase
- [ ] **Expected:** Smooth purchase, immediate unlock

---

### 8. UI/UX Tests

#### 8.1 Theme Switching
- [ ] **Test:** Can switch between Light/Dark/System themes
- [ ] **Test:** Theme persists across app restarts
- [ ] **Test:** All screens respect theme
- [ ] **Expected:** Smooth theme switching, consistent appearance

#### 8.2 Navigation
- [ ] **Test:** Can navigate between tabs
- [ ] **Test:** Back button/gesture works
- [ ] **Test:** Deep navigation works
- [ ] **Test:** Navigation is smooth
- [ ] **Expected:** Intuitive navigation, no crashes

#### 8.3 Performance
- [ ] **Test:** App launches quickly (< 2 seconds)
- [ ] **Test:** Password list scrolls smoothly (100+ entries)
- [ ] **Test:** Search is responsive
- [ ] **Test:** No lag when typing
- [ ] **Test:** No memory leaks (use Instruments)
- [ ] **Expected:** Fast, smooth performance

---

### 9. Security Tests

#### 9.1 Data Security
- [ ] **Test:** Master password is hashed (not plaintext)
- [ ] **Test:** Passwords are encrypted at rest
- [ ] **Test:** Keychain items are secure
- [ ] **Test:** No sensitive data in logs
- [ ] **Test:** App locks after backgrounding (if implemented)
- [ ] **Expected:** Strong security, no data leaks

#### 9.2 Authentication Security
- [ ] **Test:** Cannot bypass master password
- [ ] **Test:** Biometric requires device authentication
- [ ] **Test:** Failed authentication shows error
- [ ] **Test:** No password hints or recovery (by design)
- [ ] **Expected:** Secure authentication, no bypasses

---

### 10. Edge Cases & Error Handling

#### 10.1 Empty States
- [ ] **Test:** App handles no passwords gracefully
- [ ] **Test:** Empty search shows appropriate message
- [ ] **Test:** Empty categories handled correctly
- [ ] **Expected:** Clear empty states, helpful messages

#### 10.2 Error Scenarios
- [ ] **Test:** App handles corrupted data gracefully
- [ ] **Test:** App handles invalid JSON import
- [ ] **Test:** App handles network errors (if applicable)
- [ ] **Test:** Error messages are clear and helpful
- [ ] **Expected:** Graceful error handling, user-friendly messages

#### 10.3 Background/Foreground
- [ ] **Test:** App handles backgrounding correctly
- [ ] **Test:** App handles foregrounding correctly
- [ ] **Test:** Data persists across app restarts
- [ ] **Test:** Vault locks after backgrounding (if implemented)
- [ ] **Expected:** Smooth transitions, data persistence

---

## Test Execution

### Phase 1: Core Functionality (Priority 1)
- Execute tests 1.1 - 1.4, 2.1 - 2.6
- **Time:** ~2 hours
- **Status:** Must pass before beta

### Phase 2: AutoFill (Priority 1)
- Execute tests 3.1 - 3.4
- **Time:** ~1 hour
- **Status:** Must pass before beta

### Phase 3: Additional Features (Priority 2)
- Execute tests 4.1 - 4.3, 5.1, 6.1 - 6.2
- **Time:** ~1 hour
- **Status:** Should pass before beta

### Phase 4: Premium & Polish (Priority 3)
- Execute tests 7.1 - 7.2, 8.1 - 8.3
- **Time:** ~30 minutes
- **Status:** Nice to have

### Phase 5: Security & Edge Cases (Priority 2)
- Execute tests 9.1 - 9.2, 10.1 - 10.3
- **Time:** ~1 hour
- **Status:** Should pass before beta

---

## Test Results Template

### Test Case: [Name]
- **Status:** ✅ Pass / ❌ Fail / ⚠️ Partial
- **Device:** iPhone [model] / iPad [model]
- **iOS Version:** [version]
- **Notes:** [any observations]
- **Screenshots:** [if applicable]

---

## Known Limitations

1. **Simulator Limitations:**
   - Biometric authentication doesn't work
   - AutoFill extension doesn't work
   - Keychain may behave differently

2. **TestFlight Limitations:**
   - Some features may need App Store review
   - Premium purchases may not work in beta

---

## Reporting Issues

When reporting issues, include:
- Device model and iOS version
- Steps to reproduce
- Expected vs actual behavior
- Screenshots or videos
- Logs (if available)

---

**Last Updated:** December 2024

