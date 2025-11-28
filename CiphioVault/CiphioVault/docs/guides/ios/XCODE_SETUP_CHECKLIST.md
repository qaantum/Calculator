# Xcode Setup Checklist - Step by Step

Follow these steps in order:

## ✅ Step 1: Delete Default ContentView.swift

1. In Xcode left sidebar, find `ContentView.swift` (under Ciphio folder)
2. Right-click on it
3. Select **"Delete"**
4. Choose **"Move to Trash"**

## ✅ Step 2: Add Your Swift Files

1. In Xcode left sidebar, right-click on **"Ciphio"** folder (blue icon)
2. Select **"Add Files to 'Ciphio'..."**
3. Navigate to: `/Users/qaantum/Desktop/Project/ios`
4. Select ALL these files (⌘A or click each while holding ⌘):
   - ✅ `CiphioApp.swift`
   - ✅ `ContentView.swift`
   - ✅ `CryptoService.swift`
   - ✅ `PasswordGenerator.swift`
   - ✅ `HistoryStore.swift`
   - ✅ `HomeViewModel.swift`
   - ✅ `ThemeOption.swift`
5. **IMPORTANT**: Uncheck **"Copy items if needed"** (we want to reference, not copy)
6. **IMPORTANT**: Check **"Add to targets: Ciphio"**
7. Click **"Add"**

## ✅ Step 3: Set Deployment Target

1. Click on **"Ciphio"** project name (blue icon at top of left sidebar)
2. Select **"Ciphio"** target (under TARGETS section)
3. Click **"General"** tab
4. Scroll to **"Deployment Info"** section
5. Set **iOS** to **13.0** (or higher - required for CryptoKit)
6. Make sure **Devices** is set to **iPhone** (or Universal)

## ✅ Step 4: Verify Entry Point

1. Open `CiphioApp.swift` in Xcode
2. Make sure it has `@main` at the top (it should)
3. If not, add `@main` before `struct CiphioApp: App`

## ✅ Step 5: Build and Run

1. At the top of Xcode, select a simulator (e.g., **"iPhone 16 Pro"**)
2. Click the **▶ Play** button (or press **⌘R**)
3. Wait for build to complete (first build: 2-5 minutes)
4. App should launch in simulator!

---

## 🐛 If You See Errors

### "Cannot find 'CiphioPalette' in scope"
- **Fix**: Make sure `ThemeOption.swift` is added to target
- Select `ThemeOption.swift` → File Inspector → Target Membership → Check "Ciphio"

### "No such module 'CryptoKit'"
- **Fix**: Set deployment target to iOS 13.0+ (Step 3 above)

### "Cannot find type 'HistoryEntry' in scope"
- **Fix**: Make sure `HistoryStore.swift` is added to target
- Check Target Membership for all files

### Build errors about missing files
- **Fix**: Make sure all 7 Swift files are added to target
- Select each file → File Inspector → Target Membership → Check "Ciphio"

---

## ✅ Verification

After adding files, you should see in Xcode:
- ✅ `CiphioApp.swift` (with @main)
- ✅ `ContentView.swift`
- ✅ `CryptoService.swift`
- ✅ `PasswordGenerator.swift`
- ✅ `HistoryStore.swift`
- ✅ `HomeViewModel.swift`
- ✅ `ThemeOption.swift`

All files should have a checkmark next to them in Target Membership.

---

**Once you complete these steps, the app should build and run!** 🚀

