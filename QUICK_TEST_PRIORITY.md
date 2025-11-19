# Quick Test Priority - Focused Checklist

## 🎯 Critical Tests (Do These First - ~15 minutes)

### 1. Encryption/Decryption Core Functionality ⭐⭐⭐

**Test on BOTH iOS and Android:**

- [ ] **Basic Encrypt/Decrypt**
  1. Type "Hello World" in Input Text
  2. Enter password "test123"
  3. Click "Encrypt"
  4. Copy the encrypted output (starts with `gcm:`, `cbc:`, or `ctr:`)
  5. Paste it back into Input Text
  6. Click "Decrypt"
  7. ✅ **Expected**: Should show "Hello World" in output

- [ ] **Test All 3 Algorithms**
  - Repeat above test for:
    - [ ] AES-GCM (default)
    - [ ] AES-CBC
    - [ ] AES-CTR
  - ✅ **Expected**: All should encrypt/decrypt correctly

- [ ] **Cross-Platform Test** ⭐
  1. Encrypt on Android → Copy output
  2. Paste on iOS → Enter same password → Decrypt
  3. ✅ **Expected**: Should show original text
  4. Repeat: Encrypt on iOS → Decrypt on Android
  5. ✅ **Expected**: Should show original text

---

### 2. Password Generator ⭐⭐⭐

**Test on BOTH iOS and Android:**

- [ ] **Basic Generation**
  1. Click "Generate New Password" button
  2. ✅ **Expected**: Password appears immediately
  3. ✅ **Expected**: Password length matches slider value

- [ ] **Length Slider**
  1. Set slider to minimum (6)
  2. Generate password
  3. ✅ **Expected**: Password is exactly 6 characters
  4. Set slider to maximum (64)
  5. Generate password
  6. ✅ **Expected**: Password is exactly 64 characters

- [ ] **Character Sets**
  1. Enable only "Uppercase" → Generate
  2. ✅ **Expected**: Password contains only A-Z
  3. Enable only "Numbers" → Generate
  4. ✅ **Expected**: Password contains only 0-9
  5. Enable all toggles → Generate
  6. ✅ **Expected**: Password contains mixed characters

- [ ] **Copy Functionality**
  1. Generate password
  2. Click "Copy" button
  3. Paste into Input Text field
  4. ✅ **Expected**: Password pastes correctly

---

### 3. History Feature ⭐⭐

**Test on BOTH iOS and Android:**

- [ ] **Save History**
  1. Enable "Save history" toggle
  2. Encrypt some text
  3. ✅ **Expected**: Entry should be saved

- [ ] **View History**
  1. Click History button/icon (top-left)
  2. ✅ **Expected**: History screen opens
  3. ✅ **Expected**: Shows saved entries

- [ ] **Use This Entry** ⭐ (We just fixed this!)
  1. Click "Use This Entry" button
  2. ✅ **Expected**: Returns to main screen
  3. ✅ **Expected**: Input Text is populated
  4. ✅ **Expected**: Output Text is populated
  5. ✅ **Expected**: Algorithm is selected correctly
  6. ✅ **Expected**: Does NOT delete the entry

- [ ] **Delete Entry** ⭐ (We just fixed this!)
  1. Click "Delete" button on an entry
  2. ✅ **Expected**: Entry is removed from list
  3. ✅ **Expected**: Does NOT load the entry

---

### 4. Keyboard Handling ⭐⭐ (We just fixed this!)

**Test on BOTH iOS and Android:**

- [ ] **Input Text Field**
  1. Tap on "Input Text" field
  2. ✅ **Expected**: Keyboard appears
  3. ✅ **Expected**: Input field is visible (not hidden behind keyboard)
  4. ✅ **Expected**: Can type text (text doesn't delete immediately)
  5. ✅ **Expected**: Encrypt/Decrypt buttons are accessible

- [ ] **Secret Key Field**
  1. Tap on "Secret Key" field
  2. ✅ **Expected**: Keyboard appears
  3. ✅ **Expected**: Secret key field is visible
  4. ✅ **Expected**: Can type password
  5. ✅ **Expected**: Eye icon works (toggle visibility)

- [ ] **Keyboard Dismissal**
  1. Open keyboard
  2. Scroll down
  3. ✅ **Expected**: Keyboard dismisses (iOS: interactive scroll, Android: adjustResize)
  4. Tap outside fields
  5. ✅ **Expected**: Keyboard dismisses

---

### 5. Tab Switching ⭐ (We just fixed this!)

**Test on BOTH iOS and Android:**

- [ ] **Switch to Password Generator**
  1. Click "Password Generator" tab
  2. ✅ **Expected**: Screen changes immediately
  3. ✅ **Expected**: Shows password generator UI
  4. ✅ **Expected**: Previous tab state is preserved

- [ ] **Switch Back to Encryption**
  1. Click "Text Encryption" tab
  2. ✅ **Expected**: Screen changes immediately
  3. ✅ **Expected**: Shows encryption UI
  4. ✅ **Expected**: Previous tab state is preserved

---

### 6. Theme Switching ⭐

**Test on BOTH iOS and Android:**

- [ ] **Change Theme**
  1. Open Settings (top-right icon)
  2. Select "Light" theme
  3. ✅ **Expected**: App changes to light colors immediately
  4. Select "Dark" theme
  5. ✅ **Expected**: App changes to dark colors immediately
  6. Select "System" theme
  7. ✅ **Expected**: App follows device theme

- [ ] **Theme Persistence**
  1. Change theme
  2. Close app completely
  3. Reopen app
  4. ✅ **Expected**: Theme preference is saved

---

### 7. Navigation ⭐

**Test on BOTH iOS and Android:**

- [ ] **Settings Navigation**
  1. Click Settings icon (top-right)
  2. ✅ **Expected**: Settings screen opens
  3. Click "Encryption Algorithms"
  4. ✅ **Expected**: Info screen opens
  5. Go back
  6. ✅ **Expected**: Returns to Settings
  6. Click "Terms of Service"
  7. ✅ **Expected**: Terms screen opens
  8. Go back
  9. ✅ **Expected**: Returns to Settings
  10. Go back to main screen
  11. ✅ **Expected**: Returns to home

---

## 🚨 Critical Issues to Verify (We Just Fixed)

### ✅ Text Input Doesn't Delete
- [ ] Type in Input Text field
- [ ] ✅ **Expected**: Text persists (doesn't delete immediately)

### ✅ Tab Switching Works
- [ ] Click Password Generator tab
- [ ] ✅ **Expected**: Screen changes (not just button click)

### ✅ Use This Entry Works Correctly
- [ ] Click "Use This Entry" in History
- [ ] ✅ **Expected**: Loads entry (does NOT delete it)

### ✅ Delete Button Works Correctly
- [ ] Click "Delete" in History
- [ ] ✅ **Expected**: Deletes entry (does NOT load it)

---

## ⏱️ Time Estimates

- **Critical Tests (1-3)**: ~15 minutes
- **Keyboard & UI Tests (4-5)**: ~5 minutes
- **Settings & Navigation (6-7)**: ~5 minutes
- **Total**: ~25 minutes

---

## 📝 Test Results Template

```
Date: ___________
Platform: iOS / Android
Device: ___________
OS Version: ___________

### Critical Tests
- [ ] Encryption/Decryption: ✅ / ❌
- [ ] Password Generator: ✅ / ❌
- [ ] History: ✅ / ❌
- [ ] Keyboard Handling: ✅ / ❌
- [ ] Tab Switching: ✅ / ❌
- [ ] Theme Switching: ✅ / ❌
- [ ] Navigation: ✅ / ❌

### Issues Found:
_______________________________________
_______________________________________
```

---

## 🎯 Priority Order

1. **Encryption/Decryption** (most critical - core feature)
2. **Password Generator** (second core feature)
3. **History Use/Delete** (we just fixed these!)
4. **Keyboard Handling** (we just fixed this!)
5. **Tab Switching** (we just fixed this!)
6. **Theme Switching** (nice to have)
7. **Navigation** (nice to have)

---

## ✅ Success Criteria

All tests should pass on:
- ✅ **iOS** (minimum iOS 13.0+)
- ✅ **Android** (minimum Android 7.0+)
- ✅ **Cross-platform compatibility** (encrypt on one, decrypt on other)

---

## 🐛 If Tests Fail

1. **Note which test failed**
2. **Note which platform** (iOS/Android)
3. **Note the exact behavior** (what happened vs what should happen)
4. **Take a screenshot** if possible
5. **Report the issue** with details

