# Testing iOS App - Quick Guide

## Option 1: Create Xcode Project (Recommended)

### Step 1: Open Xcode
1. Open **Xcode** (from Applications or Spotlight)
2. If you don't have Xcode: Download from Mac App Store (it's free but large ~10GB)

### Step 2: Create New Project
1. In Xcode: **File** → **New** → **Project**
2. Choose **iOS** → **App** (or **Multiplatform** → **App** if you want iOS + macOS)
3. Fill in:
   - **Product Name**: `Ciphio`
   - **Team**: Your Apple ID (or "None" for simulator only)
   - **Organization Identifier**: `com.ciphio`
   - **Interface**: **SwiftUI**
   - **Language**: **Swift**
   - **Storage**: **None** (we're using UserDefaults)
4. Click **Next**
5. **Save location**: Choose the `ios` folder (or parent folder)
6. Click **Create**

**Note about Multiplatform:**
- **iOS-only** (recommended for now): Simpler, focused on mobile testing
- **Multiplatform**: Creates app for iOS, iPadOS, macOS, watchOS, tvOS
  - Good if you want to support multiple platforms
  - Adds complexity (need to handle different screen sizes, input methods)
  - For this app, iOS-only is recommended since it's designed for mobile

### Step 3: Add Existing Swift Files
1. In Xcode, right-click on the project name in the left sidebar
2. Select **Add Files to "Ciphio"...**
3. Navigate to the `ios` folder
4. Select all Swift files:
   - `CiphioApp.swift`
   - `ContentView.swift`
   - `CryptoService.swift`
   - `PasswordGenerator.swift`
   - `HistoryStore.swift`
   - `HomeViewModel.swift`
   - `ThemeOption.swift`
5. Make sure **"Copy items if needed"** is **unchecked**
6. Make sure **"Add to targets: Ciphio"** is **checked**
7. Click **Add**

### Step 4: Replace Default App File
1. Delete the default `ContentView.swift` that Xcode created (if it exists)
2. Make sure `CiphioApp.swift` is set as the entry point:
   - Check that `CiphioApp.swift` has `@main` attribute
   - If not, add it: `@main` before `struct CiphioApp: App`

### Step 5: Set Deployment Target
1. Click on the project name in left sidebar
2. Select the **Ciphio** target
3. Go to **General** tab
4. Under **Deployment Info**:
   - **iOS**: Set to **13.0** or higher (required for CryptoKit)
   - **Devices**: iPhone (or Universal)

### Step 6: Run on Simulator
1. At the top of Xcode, select a simulator (e.g., **iPhone 15**)
2. Click the **▶ Play** button (or press **⌘R**)
3. Wait for build to complete (first build takes 2-5 minutes)
4. App will launch in simulator

---

## Option 2: Use Terminal to Open in Xcode

If you prefer command line:

```bash
cd /Users/qaantum/Desktop/Project/ios
xed .
```

This opens the folder in Xcode. Then follow **Option 1** to create the project.

---

## Quick Test Checklist

Once the app is running:

- [ ] **App launches** - You should see the Ciphio home screen
- [ ] **Text Encryption tab**:
  - [ ] Type text in "Input Text" field
  - [ ] Enter a password in "Secret Key"
  - [ ] Click "Encrypt" - should see encrypted output
  - [ ] Copy encrypted text, paste in input, click "Decrypt" - should see original text
  - [ ] Test keyboard handling - buttons should be accessible when keyboard is open
- [ ] **Password Generator tab**:
  - [ ] Adjust length slider
  - [ ] Toggle character sets
  - [ ] Click "Generate New Password" - should see password
  - [ ] Copy button works
- [ ] **History**:
  - [ ] Enable "Save history" toggle
  - [ ] Perform encryption/decryption
  - [ ] Open History (top-left icon)
  - [ ] Should see entries
  - [ ] Test "Use This Entry" - should populate fields
  - [ ] Test delete
- [ ] **Settings**:
  - [ ] Open Settings (top-right icon)
  - [ ] Change theme (Light/Dark/System)
  - [ ] Navigate to "Encryption Algorithms" and "Terms of Service"
  - [ ] Go back

---

## Common Issues

### "No such module 'CryptoKit'"
- **Fix**: Set deployment target to iOS 13.0+ (CryptoKit requires iOS 13+)
- Project → Target → General → Deployment Info → iOS 13.0

### "Cannot find 'CiphioPalette' in scope"
- **Fix**: Make sure `ThemeOption.swift` is added to the target
- Check Target Membership in File Inspector

### Build errors about missing files
- **Fix**: Make sure all Swift files are added to the target
- Select file → File Inspector → Target Membership → Check "Ciphio"

### Simulator won't launch
- **Fix**: Xcode → Settings → Platforms → Download iOS Simulator runtime
- Or select a different simulator from the device dropdown

---

## Testing on Real Device (Optional)

1. Connect iPhone via USB
2. In Xcode, select your device from the device dropdown
3. You may need to:
   - Sign in with Apple ID in Xcode → Settings → Accounts
   - Trust the computer on your iPhone
   - Enable Developer Mode on iPhone (Settings → Privacy & Security → Developer Mode)

---

## Running Tests

1. In Xcode: **Product** → **Test** (or press **⌘U**)
2. Tests will run in simulator
3. Check test results in left sidebar

---

**That's it! You're ready to test the iOS app.** 🚀

