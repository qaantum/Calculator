# Fix Build Errors - Quick Guide

## Common Issue: Files Not Added to Target

If you see 65 errors, the most common cause is that files aren't added to the target.

### Quick Fix:

1. **In Xcode, select each Swift file** in the left sidebar:
   - `ContentView.swift`
   - `CiphioVaultApp.swift`
   - `CryptoService.swift`
   - `PasswordGenerator.swift`
   - `HistoryStore.swift`
   - `HomeViewModel.swift`
   - `ThemeOption.swift`

2. **For each file:**
   - Click on the file
   - Open the **File Inspector** (right sidebar, or View → Inspectors → File Inspector)
   - Under **"Target Membership"**
   - **Check the box** next to **"Ciphio"** (the app target)
   - Make sure **"CiphioTests"** and **"CiphioUITests"** are **unchecked** (unless you want them in tests)

3. **Verify all files are checked:**
   - All 7 Swift files should have "Ciphio" checked in Target Membership

### Alternative: Add Files Again

If the above doesn't work:

1. **Select all Swift files** in Finder:
   - Navigate to `/Users/qaantum/Desktop/Project/ios/Ciphio/Ciphio/`
   - Select all 7 `.swift` files

2. **Drag and drop into Xcode:**
   - Drag files into the `Ciphio` folder in Xcode
   - In the dialog:
     - **Uncheck** "Copy items if needed"
     - **Check** "Add to targets: Ciphio"
     - **Uncheck** "CiphioTests" and "CiphioUITests"
   - Click **"Finish"**

### Set Deployment Target

1. Click **"Ciphio"** project (blue icon at top)
2. Select **"Ciphio"** target (under TARGETS)
3. Go to **"General"** tab
4. Under **"Deployment Info"**:
   - Set **iOS** to **13.0** or higher (required for CryptoKit)

### Clean Build

1. **Product** → **Clean Build Folder** (or press **⇧⌘K**)
2. Wait for clean to complete
3. **Product** → **Build** (or press **⌘B**)

### Check Errors

1. Click on the **red error icon** in the top bar
2. Or open **Issue Navigator** (left sidebar, exclamation mark icon)
3. Read the error messages - they'll tell you what's wrong

---

## Common Errors and Fixes

### "Cannot find 'CiphioPalette' in scope"
- **Fix**: Make sure `ThemeOption.swift` is added to target

### "Cannot find type 'HistoryEntry' in scope"
- **Fix**: Make sure `HistoryStore.swift` is added to target

### "Cannot find type 'AesMode' in scope"
- **Fix**: Make sure `CryptoService.swift` is added to target

### "No such module 'CryptoKit'"
- **Fix**: Set deployment target to iOS 13.0+ (see above)

### "Cannot find 'HomeViewModel' in scope"
- **Fix**: Make sure `HomeViewModel.swift` is added to target

---

**After fixing target membership, the build should succeed!** 🚀

