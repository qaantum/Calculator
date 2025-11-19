# Devices & Versions to Test

## 🎯 Priority Testing Devices

### Must Test (Critical)

#### Android
1. **Android 7.0 (API 24)** - Minimum supported
   - Test on: Emulator or physical device
   - Why: This is your minimum SDK - must work!

2. **Android 14 (API 34)** - Latest
   - Test on: Emulator or physical device
   - Why: Latest version - should work perfectly

#### iOS
1. **iOS 13.0** - Minimum supported (after fixing deployment target)
   - Test on: Simulator (iPhone 8, iPhone XR)
   - Why: This is your minimum - must work!

2. **iOS 17.0+** - Latest
   - Test on: Simulator (iPhone 15, iPhone 16 Pro)
   - Why: Latest version - should work perfectly

---

## 📱 Recommended Testing Devices

### Android (Pick 2-3)

**Minimum Required:**
- ✅ **Android 7.0 (API 24)** - Must test
- ✅ **Android 14 (API 34)** - Must test

**Additional (if you have time):**
- Android 8.0 (API 26) - Common older device
- Android 10 (API 29) - Mid-range
- Android 12 (API 31) - Modern

### iOS (Pick 2-3)

**Minimum Required:**
- ✅ **iOS 13.0** - Must test (after fixing deployment target)
- ✅ **iOS 17.0+** - Must test

**Additional (if you have time):**
- iOS 14.0 - Common older device
- iOS 15.0 - Mid-range
- iOS 16.0 - Modern

---

## 🚀 Quick Test Plan

### Minimum Testing (Fast - ~30 minutes)

**Test on these 4 devices:**

1. **Android 7.0 (API 24)** - Emulator
   - Run critical tests (encryption, password generator, history)

2. **Android 14 (API 34)** - Emulator
   - Run critical tests (encryption, password generator, history)

3. **iOS 13.0** - Simulator (iPhone 8 or iPhone XR)
   - Run critical tests (encryption, password generator, history)

4. **iOS 17.0+** - Simulator (iPhone 15 or iPhone 16 Pro)
   - Run critical tests (encryption, password generator, history)

---

## 📋 Specific Simulator/Emulator Names

### Android Studio Emulators

**Create these AVDs (Android Virtual Devices):**

1. **Android 7.0 (API 24)**
   - Device: Pixel 2 or Pixel 3
   - System Image: Android 7.0 (Nougat) - API 24
   - Name: "Android_7.0_Pixel2"

2. **Android 14 (API 34)**
   - Device: Pixel 7 or Pixel 8
   - System Image: Android 14 (UpsideDownCake) - API 34
   - Name: "Android_14_Pixel7"

### Xcode Simulators

**Use these simulators:**

1. **iOS 13.0**
   - Device: iPhone 8 or iPhone XR
   - OS: iOS 13.0
   - Note: You may need to download iOS 13.0 runtime

2. **iOS 17.0+**
   - Device: iPhone 15 or iPhone 16 Pro
   - OS: iOS 17.0 or iOS 18.0
   - Note: This should already be available

---

## ⚠️ Important Notes

### iOS Deployment Target Fix

**Before testing iOS 13.0:**
1. Open Xcode
2. Project → Target → General → Deployment Info
3. Set **iOS** to **13.0** (currently set to 18.5 - incorrect!)
4. This is required for iOS 13.0 testing

### Android Setup

**Android 7.0 (API 24) Emulator:**
- May need to download system image
- Tools → SDK Manager → SDK Platforms → Android 7.0 (Nougat)

**Android 14 (API 34) Emulator:**
- Should already be available
- If not: Tools → SDK Manager → SDK Platforms → Android 14

---

## ✅ Test Checklist Per Device

For each device, test:

- [ ] **Encryption/Decryption**
  - Encrypt text → Copy → Decrypt → Verify original
  - Test all 3 algorithms (AES-GCM, AES-CBC, AES-CTR)

- [ ] **Password Generator**
  - Generate password → Verify length
  - Test character sets
  - Test copy functionality

- [ ] **History**
  - Enable history → Encrypt → View history
  - Use This Entry → Verify fields populate
  - Delete Entry → Verify entry removed

- [ ] **Keyboard Handling**
  - Open keyboard → Verify fields visible
  - Verify buttons accessible

- [ ] **Tab Switching**
  - Switch tabs → Verify screen changes

- [ ] **Theme Switching**
  - Change theme → Verify colors change

---

## 🎯 Recommended Testing Order

1. **iOS 17.0+** (iPhone 15/16 Pro) - Latest, should work perfectly
2. **Android 14** (Pixel 7/8) - Latest, should work perfectly
3. **iOS 13.0** (iPhone 8/XR) - Minimum, critical to test
4. **Android 7.0** (Pixel 2/3) - Minimum, critical to test

---

## 📊 Coverage

Testing these 4 devices covers:
- ✅ **~95% of active devices** (both platforms)
- ✅ **Minimum supported versions** (critical)
- ✅ **Latest versions** (should work perfectly)
- ✅ **Cross-platform compatibility** (encrypt on one, decrypt on other)

---

## 🚀 Quick Start

1. **Fix iOS deployment target** (13.0)
2. **Create Android 7.0 emulator** (if not exists)
3. **Test on iOS 17.0+** first (should work)
4. **Test on Android 14** (should work)
5. **Test on iOS 13.0** (critical - minimum)
6. **Test on Android 7.0** (critical - minimum)

---

## 💡 Pro Tips

- **Test on real devices** when possible (more accurate than emulators/simulators)
- **Test cross-platform** (encrypt on Android, decrypt on iOS)
- **Test on different screen sizes** (small phone, large phone)
- **Test in both portrait and landscape** (if supported)

