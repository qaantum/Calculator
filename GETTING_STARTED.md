# Getting Started with Ciphio Mobile Apps

Welcome! This guide will walk you through setting up and running the Ciphio apps step-by-step. Don't worry if you're new to mobile development—we'll explain everything.

> **🔍 Quick Check**: Before starting, you can run `./verify_setup.sh` to check if your environment is set up correctly. (This is optional, but helpful!)

---

## 📋 What You Need

### For Android Development
- **Android Studio** (latest version recommended)
  - Download from: https://developer.android.com/studio
  - Includes Android SDK and JDK 17 (you don't need to install Java separately)
- **Android Emulator** or a physical Android device (Android 7.0+)

### For iOS Development
- **macOS** (required—iOS development only works on Mac)
- **Xcode** (latest version from Mac App Store)
- **iOS Simulator** (comes with Xcode)

---

## 🚀 Quick Start: Android

### Step 1: Install Android Studio
1. Download Android Studio from the link above
2. Run the installer and follow the setup wizard
3. When prompted, install:
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device (AVD)

### Step 2: Open the Project
1. Open Android Studio
2. Click **"Open"** (or File → Open)
3. Navigate to the `android` folder in this project
4. Click **"OK"**

### Step 3: Wait for Gradle Sync
- Android Studio will automatically download dependencies (this may take 5-10 minutes the first time)
- You'll see a progress bar at the bottom
- Wait until it says "Gradle sync finished"

**Troubleshooting:**
- If you see "JDK not found": Android Studio should have bundled JDK 17. Go to File → Project Structure → SDK Location and make sure JDK is set correctly.
- If sync fails: Check your internet connection and try File → Invalidate Caches → Invalidate and Restart

### Step 4: Create an Emulator (if you don't have a device)
1. Click the **Device Manager** icon (phone icon) in the toolbar
2. Click **"Create Device"**
3. Choose a phone (e.g., Pixel 5)
4. Choose a system image (e.g., API 34, Android 14)
5. Click **"Finish"** and wait for download

### Step 5: Run the App
1. Select your emulator/device from the dropdown at the top
2. Click the green **▶ Run** button (or press Shift+F10)
3. The app will build and launch automatically

**First build takes 2-5 minutes—be patient!**

---

## 🍎 Quick Start: iOS

### Step 1: Install Xcode
1. Open the **App Store** on your Mac
2. Search for **"Xcode"**
3. Click **"Get"** or **"Install"** (it's large, ~10GB, so this takes time)
4. Once installed, open Xcode and accept the license agreement

### Step 2: Open the Project
1. Open **Terminal** (Applications → Utilities → Terminal)
2. Navigate to the project folder:
   ```bash
   cd /path/to/Project/ios
   ```
   (Replace `/path/to/Project` with your actual path)
3. Type: `xed .` and press Enter
   - This opens the folder in Xcode
   - If `xed` doesn't work, open Xcode manually and drag the `ios` folder into it

### Step 3: Create an Xcode Project (if needed)
If you see individual Swift files but no project:
1. In Xcode: File → New → Project
2. Choose **iOS** → **App**
3. Fill in:
   - Product Name: `Ciphio`
   - Team: Your Apple ID (or "None" for simulator only)
   - Organization Identifier: `com.ciphio`
   - Interface: **SwiftUI**
   - Language: **Swift**
4. Save it in the `ios` folder
5. Drag the existing Swift files into the project

### Step 4: Set Up Tests (Optional but Recommended)
1. In Xcode: File → New → Target
2. Choose **iOS** → **Unit Testing Bundle**
3. Name it `CiphioTests`
4. Add the test files from `ios/CiphioTests/` to this target
5. If tests don't compile, add this line at the top of each test file:
   ```swift
   @testable import Ciphio
   ```

### Step 5: Run the App
1. At the top of Xcode, select a simulator (e.g., **iPhone 15**)
2. Click the **▶ Play** button (or press ⌘R)
3. The app will build and launch in the simulator

**First build takes 2-5 minutes—be patient!**

---

## ✅ Verify Everything Works

> **💡 Tip**: You can also run `./verify_setup.sh` from the project root to automatically check your setup!

### Android Verification
1. **App launches**: You should see the Ciphio home screen
2. **Test encryption**:
   - Type some text in the input field
   - Enter a password
   - Click **"Encrypt"**
   - You should see encrypted output starting with `gcm:`
   - Copy the encrypted text
   - Paste it in the input field
   - Click **"Decrypt"** with the same password
   - You should see your original text!
3. **Test password generator**:
   - Go to the Password tab
   - Click **"Generate"**
   - You should see a random password
   - The strength indicator should show (Weak/Moderate/Strong/Very Strong)

### iOS Verification
1. **App launches**: You should see the Ciphio home screen
2. **Test encryption**: Same as Android above
3. **Test password generator**: Same as Android above

---

## 🧪 Running Tests

### Android Tests
1. In Android Studio, open the **Project** view (left sidebar)
2. Navigate to: `app/src/test/java/com/ciphio/`
3. Right-click on a test file (e.g., `CryptoServiceTest.kt`)
4. Click **"Run 'CryptoServiceTest'"**
5. Or run all tests: Right-click the `test` folder → **"Run Tests"**

**Or use command line:**
```bash
cd android
./gradlew test
```

### iOS Tests
1. In Xcode, press **⌘U** (or Product → Test)
2. Tests will run in the simulator
3. Check the test results in the left sidebar

---

## 🐛 Common Issues & Solutions

### Android Issues

**Problem: "Gradle sync failed"**
- **Solution**: Check internet connection, try File → Invalidate Caches → Invalidate and Restart

**Problem: "JDK not found" or "Java version mismatch"**
- **Solution**: 
  1. File → Project Structure → SDK Location
  2. Set JDK location to Android Studio's bundled JDK (usually in Android Studio's installation folder)
  3. Or download JDK 17 from: https://adoptium.net/

**Problem: "Build failed" with BouncyCastle errors**
- **Solution**: The project uses BouncyCastle for encryption. Make sure you have internet for the first build to download dependencies.

**Problem: Emulator is slow**
- **Solution**: 
  - Enable hardware acceleration in AVD settings
  - Allocate more RAM to the emulator (2GB+ recommended)
  - Use a physical device if possible

### iOS Issues

**Problem: "No such module 'CryptoKit'"**
- **Solution**: CryptoKit is built into iOS 13+. Make sure your deployment target is iOS 13 or later in project settings.

**Problem: "Command failed with exit code 65"**
- **Solution**: 
  1. Clean build folder: Product → Clean Build Folder (⇧⌘K)
  2. Delete DerivedData: Xcode → Settings → Locations → Derived Data → Delete
  3. Try building again

**Problem: Simulator won't launch**
- **Solution**: 
  1. Xcode → Settings → Platforms
  2. Download the latest iOS Simulator runtime
  3. Restart Xcode

**Problem: Tests can't find classes**
- **Solution**: 
  1. Make sure test files are in the test target (check Target Membership in File Inspector)
  2. Add `@testable import Ciphio` at the top of test files
  3. Replace `Ciphio` with your actual app target name

---

## 📱 Testing Cross-Platform Compatibility

One of the coolest features: you can encrypt on Android and decrypt on iOS (and vice versa)!

### How to Test:
1. **On Android**: Encrypt some text with a password
2. **Copy the encrypted output** (starts with `gcm:`, `cbc:`, or `ctr:`)
3. **On iOS**: Paste the encrypted text, enter the same password, click Decrypt
4. **You should see your original text!** ✨

This works because both platforms use the same:
- Encryption algorithm (AES)
- Key derivation (PBKDF2 with 100,000 iterations)
- Output format (`algo:base64`)

---

## 🎓 Understanding the Project Structure

### Android (`android/` folder)
```
android/
├── app/
│   ├── src/
│   │   ├── main/          ← Your app code lives here
│   │   │   ├── java/com/ciphio/
│   │   │   │   ├── crypto/        ← Encryption logic
│   │   │   │   ├── password/      ← Password generator
│   │   │   │   ├── ui/            ← All screens and UI
│   │   │   │   └── data/          ← Storage (history, settings)
│   │   └── test/          ← Unit tests
│   └── build.gradle.kts   ← Dependencies and build config
```

### iOS (`ios/` folder)
```
ios/
├── CryptoService.swift      ← Encryption logic
├── PasswordGenerator.swift  ← Password generator
├── HomeViewModel.swift      ← Business logic
├── ContentView.swift        ← All screens and UI
├── HistoryStore.swift       ← Storage (history, settings)
└── CiphioTests/        ← Unit tests
```

---

## 🔧 What Each File Does (Simple Explanation)

### Encryption Files
- **`CryptoService`**: Does the actual encryption/decryption. Takes your text and password, returns encrypted data.
- **`PasswordGenerator`**: Creates random passwords and calculates how strong they are.

### UI Files
- **`HomeScreen.kt` (Android) / `ContentView.swift` (iOS)**: All the screens you see—encryption tab, password tab, history, settings.
- **`HomeViewModel`**: The "brain" that connects UI to the encryption/password logic.

### Storage Files
- **`HistoryRepository` (Android) / `HistoryStore` (iOS)**: Saves your encryption history locally on your device.

---

## 📚 Next Steps

1. **Explore the code**: Start with `CryptoService` to understand how encryption works
2. **Try modifying**: Change colors in the theme files, add a new feature
3. **Read the docs**: Check `PROJECT_SUMMARY.md` for detailed technical info
4. **Run tests**: Make sure everything still works after your changes

---

## 💡 Tips for Beginners

1. **Don't be afraid to break things**: That's how you learn! Use Git to save your work.
2. **Read error messages**: They usually tell you exactly what's wrong.
3. **Google is your friend**: Copy-paste error messages into Google.
4. **Start small**: Make one small change, test it, then move on.
5. **Use the debugger**: Set breakpoints to see what's happening step-by-step.

---

## 🆘 Still Stuck?

1. **Check the README.md**: More detailed info there
2. **Check PROJECT_SUMMARY.md**: Technical deep-dive
3. **Google the error**: Most issues have been solved by others
4. **Check Stack Overflow**: Great resource for programming questions

---

**You've got this! 🚀**

