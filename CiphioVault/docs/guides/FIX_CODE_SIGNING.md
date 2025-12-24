# Fix Code Signing Errors

**Problem:** Xcode can't find provisioning profiles for your app and extension

---

## Quick Fix

### For App Store Distribution (What You Need):

You don't need a physical device for archiving! The error is because Xcode is trying to create development profiles, but you need **App Store distribution profiles**.

---

## Solution 1: Enable Automatic Signing (Recommended)

### For Main App (CiphioVault):

1. **Open Xcode**
2. **Select your project** in the navigator (top left)
3. **Select "CiphioVault" target** (under TARGETS)
4. **Go to "Signing & Capabilities" tab**
5. **Check: "Automatically manage signing"** ✅
6. **Select your Team:**
   - Choose your Apple Developer account
   - If you see "Add Account", add your Apple ID
7. **Bundle Identifier:** Should be `com.ciphio.vault`

### For AutoFill Extension:

1. **Select "AutoFillExtension" target** (under TARGETS)
2. **Go to "Signing & Capabilities" tab**
3. **Check: "Automatically manage signing"** ✅
4. **Select your Team:** Same team as main app
5. **Bundle Identifier:** Should be `com.ciphio.vault.AutoFillExtension`

---

## Solution 2: Change Build Configuration

### For Archiving (App Store Upload):

1. **Select "Any iOS Device"** at the top (not a simulator)
2. **Product → Scheme → Edit Scheme**
3. **Select "Archive"** on the left
4. **Build Configuration:** Select **"Release"**
5. **Click "Close"**

---

## Solution 3: Fix Provisioning Profile Type

The error says "iOS App Development" but you need "App Store" profiles:

1. **Select "CiphioVault" target**
2. **Signing & Capabilities tab**
3. **If you see errors:**
   - Click "Try Again" or "Download Manual Profiles"
   - Xcode will create App Store profiles automatically

---

## Solution 4: Add Device (If Still Needed)

If automatic signing still fails, you may need to register a device:

### Option A: Connect Physical Device
1. **Connect your iPhone/iPad via USB**
2. **Trust the computer on device**
3. **Xcode will detect it automatically**
4. **Try archiving again**

### Option B: Add Device Manually
1. **Go to:** https://developer.apple.com/account/
2. **Certificates, Identifiers & Profiles**
3. **Devices → + (Add)**
4. **Get your device UDID:**
   - Settings → General → About → Scroll to find UDID
   - Or: Connect device, open Xcode → Window → Devices and Simulators
5. **Add device:**
   - Name: "My iPhone" (or any name)
   - UDID: Paste your device UDID
   - Click "Continue" → "Register"
6. **Back in Xcode:**
   - Product → Clean Build Folder
   - Try archiving again

---

## Step-by-Step Fix

### 1. Check Signing Settings:

**For CiphioVault target:**
- ✅ Automatically manage signing: **ON**
- ✅ Team: **Your Apple Developer team**
- ✅ Bundle ID: `com.ciphio.vault`
- ✅ Provisioning Profile: Should say "Xcode Managed Profile" or "App Store"

**For AutoFillExtension target:**
- ✅ Automatically manage signing: **ON**
- ✅ Team: **Same team as main app**
- ✅ Bundle ID: `com.ciphio.vault.AutoFillExtension`
- ✅ Provisioning Profile: Should say "Xcode Managed Profile" or "App Store"

### 2. Select Correct Device:

- ✅ Top left dropdown: **"Any iOS Device"**
- ❌ NOT a simulator
- ❌ NOT a specific device (unless you have one connected)

### 3. Clean and Try Again:

1. **Product → Clean Build Folder** (`⌘ + Shift + K`)
2. **Product → Archive**
3. **If errors persist:**
   - Xcode → Preferences → Accounts
   - Select your Apple ID
   - Click "Download Manual Profiles"
   - Try again

---

## Common Issues

### "No devices found"
- **For App Store upload:** You don't need a device!
- **Fix:** Make sure you're using "Any iOS Device" and "Release" configuration
- **Check:** Signing & Capabilities → Automatically manage signing is ON

### "Team has no devices"
- **For development:** You need a device
- **For App Store:** Not needed
- **Fix:** Change to "Release" configuration for Archive

### "Provisioning profile not found"
- **Fix:** Enable "Automatically manage signing"
- **Or:** Download profiles manually (Xcode → Preferences → Accounts → Download Manual Profiles)

### "Bundle ID mismatch"
- **Check:** Bundle IDs match exactly:
  - Main app: `com.ciphio.vault`
  - Extension: `com.ciphio.vault.AutoFillExtension`
- **Check:** They match in App Store Connect

---

## Verify Settings

### Before Archiving, Check:

1. **Target: CiphioVault**
   - ✅ Automatically manage signing: ON
   - ✅ Team: Selected
   - ✅ Bundle ID: `com.ciphio.vault`

2. **Target: AutoFillExtension**
   - ✅ Automatically manage signing: ON
   - ✅ Team: Same as main app
   - ✅ Bundle ID: `com.ciphio.vault.AutoFillExtension`

3. **Device Selector:**
   - ✅ "Any iOS Device" selected

4. **Scheme:**
   - ✅ Archive uses "Release" configuration

---

## Quick Checklist

- [ ] Automatically manage signing: ON (both targets)
- [ ] Team selected (both targets)
- [ ] Bundle IDs correct (both targets)
- [ ] "Any iOS Device" selected
- [ ] Archive scheme uses "Release"
- [ ] Cleaned build folder
- [ ] Try Product → Archive

---

## If Still Not Working

1. **Xcode → Preferences → Accounts**
2. **Select your Apple ID**
3. **Click "Download Manual Profiles"**
4. **Wait for download**
5. **Product → Clean Build Folder**
6. **Product → Archive**

---

**Last Updated:** November 2025

