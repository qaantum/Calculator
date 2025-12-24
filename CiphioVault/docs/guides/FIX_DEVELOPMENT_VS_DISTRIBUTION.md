# Fix: Archive Using Development Instead of Distribution

**Problem:** Archive is signed with Development certificate/profile, but App Store needs Distribution

**From logs:** Archive shows `get-task-allow = 1` (Development profile) and `Apple Development` certificate

---

## The Issue

Your archive was created with **Debug** configuration, which uses:
- ❌ Development certificate (`Apple Development`)
- ❌ Development provisioning profile (`get-task-allow = 1`)

But App Store distribution needs:
- ✅ Distribution certificate (`Apple Distribution`)
- ✅ App Store provisioning profile (no `get-task-allow`)

---

## Solution: Archive with Release Configuration

### Step 1: Check Archive Scheme

1. **In Xcode**, click the scheme selector (next to Play/Stop buttons)
2. **Click "Edit Scheme..."**
3. **Select "Archive"** in left sidebar
4. **Check "Build Configuration":**
   - ✅ Should be: **"Release"**
   - ❌ If it's "Debug": Change it to "Release"

### Step 2: Verify Release Configuration

1. **Select your project** in navigator
2. **Select "CiphioVault" target**
3. **Build Settings tab**
4. **Search for:** "Code Signing"
5. **Verify "Release" configuration:**
   - Code Signing Style: Automatic
   - Development Team: Your team
   - Provisioning Profile: Should be automatic

6. **Select "AutoFillExtension" target**
7. **Same checks** for Release configuration

### Step 3: Clean Everything

1. **Product → Clean Build Folder** (`⌘ + Shift + K`)
2. **Delete old archive** in Organizer
3. **Close Xcode** (optional, but helps)

### Step 4: Archive with Release

1. **Select "Any iOS Device"** (not simulator)
2. **Make sure scheme is set to "Release"** (check scheme selector)
3. **Product → Archive**
4. **Wait for completion**

### Step 5: Verify Archive Uses Distribution

After archiving, check:

1. **Window → Organizer** (`⌘ + Shift + 2`)
2. **Select your archive**
3. **Right-click → Show in Finder**
4. **Right-click archive → Show Package Contents**
5. **Navigate to:** `Products/Applications/CiphioVault.app/embedded.mobileprovision`
6. **Open it** (it's a text file)
7. **Check for:**
   - ✅ Should NOT have `get-task-allow`
   - ✅ Should have `ProvisionedDevices` empty or not present
   - ✅ Should say "App Store" or "Distribution" in profile name

**Or check in Xcode:**
- The archive should show "Distribution" not "Development"

---

## Alternative: Force Distribution Signing

If automatic signing keeps using Development:

### Step 1: Check Certificates

1. **Xcode → Preferences** (`⌘ + ,`)
2. **Accounts tab**
3. **Select your Apple ID**
4. **Click your team**
5. **Check "Signing Certificates":**
   - ✅ Should see: **"Apple Distribution"** certificate
   - ❌ If missing: You need to create it (see below)

### Step 2: Create Distribution Certificate (If Missing)

1. **Go to:** https://developer.apple.com/account/resources/certificates/list
2. **Click "+"** to create new certificate
3. **Select:** "Apple Distribution"
4. **Follow instructions** to create it
5. **Xcode will download it automatically** (or download manually)

### Step 3: Force Distribution Profile

1. **Select "CiphioVault" target**
2. **Signing & Capabilities tab**
3. **Uncheck "Automatically manage signing"**
4. **Select "App Store"** provisioning profile manually
5. **Check "Automatically manage signing" again**
6. **Do same for "AutoFillExtension" target**

---

## Quick Fix Checklist

- [ ] ✅ Set Archive scheme to "Release" configuration
- [ ] ✅ Verify Release configuration in Build Settings
- [ ] ✅ Clean build folder
- [ ] ✅ Delete old archive
- [ ] ✅ Archive again (should use Release now)
- [ ] ✅ Verify archive uses Distribution certificate
- [ ] ✅ Try uploading again

---

## Verify Archive is Correct

After archiving, the archive should show:
- ✅ **Certificate:** "Apple Distribution" (not "Apple Development")
- ✅ **Profile:** "App Store" or "Distribution" (not "Development")
- ✅ **No `get-task-allow`** in entitlements

If you still see Development, the Archive scheme is still set to Debug.

---

## Most Common Issue

**Archive scheme is set to "Debug" instead of "Release"**

**Fix:**
1. Edit Scheme → Archive → Build Configuration → **Release**
2. Clean and archive again

---

**Last Updated:** November 2025

