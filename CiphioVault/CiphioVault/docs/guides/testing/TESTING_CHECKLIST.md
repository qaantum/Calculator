# Comprehensive Testing Checklist

## 📱 Platform Compatibility

### Current Deployment Targets
- **Android**: minSdk 24 (Android 7.0 Nougat) - supports ~95% of devices
- **iOS**: Should be iOS 13.0+ (CryptoKit requirement) - supports ~95% of devices

### Recommended Testing Versions

#### Android
- ✅ **Android 7.0** (API 24) - Minimum supported
- ✅ **Android 8.0** (API 26) - Common older device
- ✅ **Android 10** (API 29) - Mid-range
- ✅ **Android 12** (API 31) - Modern
- ✅ **Android 14** (API 34) - Latest

#### iOS
- ✅ **iOS 13.0** - Minimum (CryptoKit requirement)
- ✅ **iOS 14.0** - Common older device
- ✅ **iOS 15.0** - Mid-range
- ✅ **iOS 16.0** - Modern
- ✅ **iOS 17.0+** - Latest

---

## 🧪 Functional Testing

### 1. Text Encryption Tab

#### Basic Encryption
- [ ] **Input Text Field**
  - [ ] Type text - text persists (doesn't delete)
  - [ ] Paste text works
  - [ ] Long text scrolls properly
  - [ ] Keyboard appears correctly
  - [ ] Keyboard doesn't hide buttons

- [ ] **Secret Key Field**
  - [ ] Type password - text persists
  - [ ] Secure field hides password by default
  - [ ] Eye icon toggles visibility
  - [ ] Keyboard appears correctly
  - [ ] Can type special characters

- [ ] **Algorithm Selection**
  - [ ] Dropdown/menu opens
  - [ ] Can select AES-GCM
  - [ ] Can select AES-CBC
  - [ ] Can select AES-CTR
  - [ ] Selection persists

- [ ] **Encrypt Button**
  - [ ] Button is clickable
  - [ ] Works with empty input (should show error)
  - [ ] Works with empty key (should show error)
  - [ ] Encrypts text correctly
  - [ ] Shows encrypted output
  - [ ] Output format is correct (`gcm:`, `cbc:`, or `ctr:` prefix)
  - [ ] Button disabled during processing
  - [ ] Toast message appears ("Encrypted")

- [ ] **Decrypt Button**
  - [ ] Button is clickable
  - [ ] Works with empty input (should show error)
  - [ ] Works with empty key (should show error)
  - [ ] Decrypts text correctly
  - [ ] Shows original text in output
  - [ ] Works with encrypted text from same platform
  - [ ] Works with encrypted text from other platform (cross-platform test)
  - [ ] Button disabled during processing
  - [ ] Toast message appears ("Decrypted")

- [ ] **Output Field**
  - [ ] Appears after encryption/decryption
  - [ ] Text is selectable
  - [ ] Can copy text
  - [ ] Long output scrolls properly
  - [ ] Copy button works
  - [ ] Toast message appears ("Copied to clipboard")

#### Error Handling
- [ ] **Invalid encrypted text**
  - [ ] Wrong format (no prefix)
  - [ ] Corrupted data
  - [ ] Wrong password
  - [ ] Shows appropriate error message

- [ ] **Empty fields**
  - [ ] Empty input + empty key → error
  - [ ] Empty input + valid key → error
  - [ ] Valid input + empty key → error

#### Keyboard Handling
- [ ] **When keyboard opens**
  - [ ] Input field scrolls into view
  - [ ] Secret key field scrolls into view
  - [ ] Output field scrolls into view (when appears)
  - [ ] Buttons remain accessible
  - [ ] Can dismiss keyboard by scrolling
  - [ ] Can dismiss keyboard by tapping outside

---

### 2. Password Generator Tab

#### Tab Switching
- [ ] **Switch to Password Generator**
  - [ ] Tab button works
  - [ ] Screen changes correctly
  - [ ] Previous tab state preserved

- [ ] **Switch back to Encryption**
  - [ ] Tab button works
  - [ ] Screen changes correctly
  - [ ] Previous tab state preserved

#### Password Generation
- [ ] **Length Slider**
  - [ ] Slider moves smoothly
  - [ ] Value updates in real-time
  - [ ] Range: 6-64
  - [ ] Default: 16
  - [ ] Value persists

- [ ] **Character Set Toggles**
  - [ ] **Uppercase (A-Z)**
    - [ ] Toggle works
    - [ ] State persists
    - [ ] Can't disable all (enforces at least one)
  
  - [ ] **Lowercase (a-z)**
    - [ ] Toggle works
    - [ ] State persists
    - [ ] Can't disable all (enforces at least one)
  
  - [ ] **Numbers (0-9)**
    - [ ] Toggle works
    - [ ] State persists
    - [ ] Can't disable all (enforces at least one)
  
  - [ ] **Symbols (!@#$...)**
    - [ ] Toggle works
    - [ ] State persists
    - [ ] Can't disable all (enforces at least one)

- [ ] **Generate Button**
  - [ ] Button is clickable
  - [ ] Generates password
  - [ ] Password appears in field
  - [ ] Password length matches slider
  - [ ] Password contains selected character sets
  - [ ] Password doesn't contain disabled character sets
  - [ ] Toast message appears ("Password generated")

- [ ] **Password Display**
  - [ ] Password is visible
  - [ ] Password is selectable
  - [ ] Can copy password
  - [ ] Copy button works
  - [ ] Toast message appears ("Copied to clipboard")

- [ ] **Strength Indicator**
  - [ ] Shows entropy bits
  - [ ] Shows strength label (Weak/Moderate/Strong/Very Strong)
  - [ ] Updates when length changes
  - [ ] Updates when character sets change
  - [ ] Calculation is correct

#### Edge Cases
- [ ] **All toggles disabled**
  - [ ] Should re-enable at least one
  - [ ] Shows toast message
  - [ ] Can't generate password

- [ ] **Minimum length (6)**
  - [ ] Generates 6-character password
  - [ ] Strength calculation correct

- [ ] **Maximum length (64)**
  - [ ] Generates 64-character password
  - [ ] Strength calculation correct

---

### 3. History Feature

#### Enable History
- [ ] **Save History Toggle**
  - [ ] Toggle works
  - [ ] State persists
  - [ ] When enabled, operations are saved
  - [ ] When disabled, operations are not saved

#### View History
- [ ] **History Button/Icon**
  - [ ] Button is visible
  - [ ] Button is clickable
  - [ ] Opens history screen
  - [ ] Navigation works

- [ ] **History Screen**
  - [ ] Shows saved entries
  - [ ] Shows "No history yet" when empty
  - [ ] Entries display correctly:
    - [ ] Operation type (Encrypt/Decrypt)
    - [ ] Algorithm (AES-GCM/CBC/CTR)
    - [ ] Input text (truncated)
    - [ ] Output text (truncated)
    - [ ] Key hint
    - [ ] Timestamp
  - [ ] Entries are sorted (newest first)
  - [ ] Maximum 100 entries (oldest removed)

#### Use Entry
- [ ] **Use This Entry Button**
  - [ ] Button is visible
  - [ ] Button is clickable
  - [ ] Loads entry into form:
    - [ ] Input text populated
    - [ ] Output text populated
    - [ ] Algorithm selected
  - [ ] Navigates back to main screen
  - [ ] Toast message appears ("History entry loaded")

#### Delete Entry
- [ ] **Delete Button**
  - [ ] Button is visible
  - [ ] Button is clickable
  - [ ] Deletes entry
  - [ ] Entry removed from list
  - [ ] Toast message appears ("Entry deleted")

#### Clear All
- [ ] **Clear All Button**
  - [ ] Button is visible (when entries exist)
  - [ ] Button is clickable
  - [ ] Clears all entries
  - [ ] Shows "No history yet" message
  - [ ] Toast message appears ("History cleared")

---

### 4. Settings

#### Navigation
- [ ] **Settings Button/Icon**
  - [ ] Button is visible
  - [ ] Button is clickable
  - [ ] Opens settings screen
  - [ ] Navigation works

#### Theme Selection
- [ ] **Light Theme**
  - [ ] Can select Light
  - [ ] Theme changes immediately
  - [ ] Colors are correct
  - [ ] State persists

- [ ] **Dark Theme**
  - [ ] Can select Dark
  - [ ] Theme changes immediately
  - [ ] Colors are correct
  - [ ] State persists

- [ ] **System Theme**
  - [ ] Can select System
  - [ ] Follows device theme
  - [ ] Changes when device theme changes
  - [ ] State persists

#### Information Screens
- [ ] **Encryption Algorithms**
  - [ ] Button opens screen
  - [ ] Content displays correctly
  - [ ] Can scroll content
  - [ ] Back button works

- [ ] **Terms of Service**
  - [ ] Button opens screen
  - [ ] Content displays correctly
  - [ ] Can scroll content
  - [ ] Back button works

---

### 5. Cross-Platform Compatibility

#### Encrypt on Android, Decrypt on iOS
- [ ] Encrypt text on Android
- [ ] Copy encrypted output
- [ ] Paste on iOS
- [ ] Enter same password
- [ ] Decrypt successfully
- [ ] Original text appears

#### Encrypt on iOS, Decrypt on Android
- [ ] Encrypt text on iOS
- [ ] Copy encrypted output
- [ ] Paste on Android
- [ ] Enter same password
- [ ] Decrypt successfully
- [ ] Original text appears

#### All Algorithms
- [ ] **AES-GCM**: Works cross-platform
- [ ] **AES-CBC**: Works cross-platform
- [ ] **AES-CTR**: Works cross-platform

---

### 6. UI/UX Testing

#### Layout
- [ ] **Default View**
  - [ ] All content fits on screen
  - [ ] No scrolling needed by default
  - [ ] Elements are properly spaced
  - [ ] Text is readable

- [ ] **Keyboard Open**
  - [ ] Content scrolls automatically
  - [ ] Focused field is visible
  - [ ] Buttons remain accessible
  - [ ] No content hidden behind keyboard

#### Responsiveness
- [ ] **Portrait Mode**
  - [ ] Layout works correctly
  - [ ] All elements visible
  - [ ] Buttons are tappable

- [ ] **Landscape Mode** (if supported)
  - [ ] Layout adapts
  - [ ] All elements visible
  - [ ] Buttons are tappable

#### Visual Feedback
- [ ] **Toast Messages**
  - [ ] Appear at bottom
  - [ ] Auto-dismiss after 2 seconds
  - [ ] Don't overlap content
  - [ ] Text is readable

- [ ] **Button States**
  - [ ] Disabled state visible during processing
  - [ ] Enabled state visible when ready
  - [ ] Hover/press states (Android)

---

### 7. Performance Testing

#### Speed
- [ ] **Encryption**
  - [ ] Short text (< 100 chars) - < 1 second
  - [ ] Medium text (100-1000 chars) - < 2 seconds
  - [ ] Long text (1000+ chars) - < 5 seconds

- [ ] **Decryption**
  - [ ] Short text (< 100 chars) - < 1 second
  - [ ] Medium text (100-1000 chars) - < 2 seconds
  - [ ] Long text (1000+ chars) - < 5 seconds

- [ ] **Password Generation**
  - [ ] Generates instantly (< 0.5 seconds)

#### Memory
- [ ] **No Memory Leaks**
  - [ ] App doesn't slow down over time
  - [ ] History doesn't cause memory issues
  - [ ] Large text doesn't crash app

---

### 8. Edge Cases & Error Handling

#### Input Validation
- [ ] **Very Long Text**
  - [ ] 10,000+ characters
  - [ ] App handles gracefully
  - [ ] No crashes

- [ ] **Special Characters**
  - [ ] Unicode characters
  - [ ] Emojis
  - [ ] Newlines
  - [ ] Tabs

- [ ] **Empty Strings**
  - [ ] Empty input
  - [ ] Empty key
  - [ ] Appropriate error messages

#### Network (if applicable)
- [ ] **Offline Mode**
  - [ ] App works without internet
  - [ ] No network errors

---

## 🔧 Platform-Specific Testing

### Android Specific

#### Permissions
- [ ] **Clipboard Access**
  - [ ] Copy to clipboard works
  - [ ] No permission errors

#### Back Button
- [ ] **Navigation**
  - [ ] Back button works
  - [ ] Returns to previous screen
  - [ ] Exits app from home screen

#### Notifications (if applicable)
- [ ] **Toast Messages**
  - [ ] Display correctly
  - [ ] Don't interfere with UI

### iOS Specific

#### Navigation
- [ ] **Back Button**
  - [ ] Navigation bar back button works
  - [ ] Swipe gesture works (if enabled)

#### Haptic Feedback (if applicable)
- [ ] **Button Presses**
  - [ ] Haptic feedback works
  - [ ] Not too aggressive

#### Safe Area
- [ ] **Notch/Dynamic Island**
  - [ ] Content doesn't overlap
  - [ ] Buttons are accessible

---

## 📊 Test Results Template

```
Date: ___________
Tester: ___________
Platform: Android / iOS
Version: ___________
Device: ___________
OS Version: ___________

### Passed Tests: ___ / ___
### Failed Tests: ___ / ___
### Notes:
_______________________________________
_______________________________________
_______________________________________
```

---

## 🚀 Quick Smoke Test (5 minutes)

If you're short on time, test these critical paths:

1. ✅ Encrypt text → Copy → Decrypt → Verify original text
2. ✅ Generate password → Copy → Verify length and character sets
3. ✅ Enable history → Encrypt → View history → Use entry → Verify fields populated
4. ✅ Change theme → Verify theme changes
5. ✅ Test keyboard handling → Verify fields visible when keyboard opens

---

## 📝 Notes

- Test on **real devices** when possible (simulators/emulators may behave differently)
- Test on **different screen sizes** (small phones, large phones, tablets if supported)
- Test with **different languages** if app supports localization
- Test with **accessibility features** enabled (if applicable)

