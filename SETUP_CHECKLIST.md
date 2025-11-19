# Setup Verification Checklist

Use this checklist to verify your setup is correct before running the apps.

---

## ✅ Android Setup Checklist

### Prerequisites
- [ ] Android Studio installed (latest version)
- [ ] Android SDK installed (comes with Android Studio)
- [ ] JDK 17 available (usually bundled with Android Studio)

### Project Setup
- [ ] Opened `android` folder in Android Studio
- [ ] Gradle sync completed successfully (no red errors)
- [ ] All dependencies downloaded (check bottom status bar)

### Emulator/Device
- [ ] Created an Android Virtual Device (AVD) OR
- [ ] Connected a physical Android device via USB with USB debugging enabled

### Verification Steps
1. [ ] Project opens without errors
2. [ ] Can see the project structure in the left sidebar
3. [ ] No red error indicators in the code
4. [ ] Can select an emulator/device from the dropdown at the top
5. [ ] Click Run (▶) button - app builds and launches

### Common Issues to Check
- [ ] Internet connection (needed for first build)
- [ ] JDK 17 is set correctly (File → Project Structure → SDK Location)
- [ ] Android SDK Platform 34 is installed (Tools → SDK Manager)
- [ ] Emulator has enough RAM allocated (2GB+ recommended)

---

## ✅ iOS Setup Checklist

### Prerequisites
- [ ] macOS computer (required for iOS development)
- [ ] Xcode installed from Mac App Store
- [ ] Xcode license accepted (run `sudo xcodebuild -license accept` in Terminal)

### Project Setup
- [ ] Xcode project created OR existing project opens
- [ ] All Swift files are added to the project
- [ ] Project builds without errors (Product → Build or ⌘B)

### Simulator
- [ ] iOS Simulator runtime downloaded (Xcode → Settings → Platforms)
- [ ] Can select a simulator from the device dropdown (e.g., iPhone 15)

### Verification Steps
1. [ ] Project opens in Xcode without errors
2. [ ] Can see all Swift files in the project navigator (left sidebar)
3. [ ] No red error indicators in the code
4. [ ] Can select a simulator from the dropdown
5. [ ] Click Run (▶) button - app builds and launches

### Common Issues to Check
- [ ] Deployment target is iOS 13+ (Project Settings → General → Deployment Info)
- [ ] All Swift files are in the correct target (check Target Membership)
- [ ] No missing dependencies (CryptoKit is built-in, no external dependencies needed)

---

## ✅ Testing Setup Checklist

### Android Tests
- [ ] Test files exist in `app/src/test/java/com/cryptatext/`
- [ ] Test dependencies added to `build.gradle.kts` (JUnit, Truth)
- [ ] Can run tests: Right-click test file → Run
- [ ] All tests pass (green checkmarks)

### iOS Tests
- [ ] Test target created in Xcode (CryptatextTests)
- [ ] Test files added to test target
- [ ] `@testable import Cryptatext` added if needed (replace Cryptatext with your target name)
- [ ] Can run tests: Product → Test or ⌘U
- [ ] All tests pass (green checkmarks)

---

## ✅ Cross-Platform Verification

### Encryption Compatibility Test
1. [ ] **On Android**: Encrypt text "Hello World" with password "test123"
2. [ ] Copy the encrypted output (starts with `gcm:`, `cbc:`, or `ctr:`)
3. [ ] **On iOS**: Paste encrypted text, enter password "test123", click Decrypt
4. [ ] **Result**: Should see "Hello World" ✨

If this works, your cross-platform encryption is working correctly!

---

## 🎯 Quick Health Check

Run these commands to verify everything is set up:

### Android
```bash
cd android
./gradlew tasks          # Should list available tasks
./gradlew assembleDebug  # Should build successfully
./gradlew test           # Should run tests
```

### iOS
```bash
cd ios
xcodebuild -list         # Should show available schemes
xcodebuild -scheme CryptatextApp -destination 'platform=iOS Simulator,name=iPhone 15' build  # Should build
```

---

## 🆘 If Something Fails

1. **Check the error message** - it usually tells you what's wrong
2. **See [GETTING_STARTED.md](GETTING_STARTED.md)** - detailed troubleshooting there
3. **See [README.md](README.md)** - troubleshooting section
4. **Google the error** - most issues have been solved by others

---

## ✅ Final Checklist

Before you start developing:
- [ ] Android app runs and shows the home screen
- [ ] iOS app runs and shows the home screen
- [ ] Can encrypt/decrypt text on both platforms
- [ ] Can generate passwords on both platforms
- [ ] Cross-platform encryption test passes
- [ ] Tests run and pass on both platforms

**If all checked, you're ready to go! 🚀**

