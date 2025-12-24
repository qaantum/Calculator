# Fix "No Devices" Signing Error

**Problem:** Xcode shows "Your team has no devices" error when trying to archive

**Solution:** For App Store distribution, you don't need a device! Change Archive to use "Release" configuration.

---

## Quick Fix

### Step 1: Change Archive Scheme to Release

1. **Product → Scheme → Edit Scheme**
   - Or: Click the scheme dropdown (next to "Any iOS Device") → Edit Scheme

2. **Select "Archive"** on the left sidebar

3. **Build Configuration:** Change from "Debug" to **"Release"**

4. **Click "Close"**

### Step 2: Try Again

1. **Product → Clean Build Folder** (`⌘ + Shift + K`)
2. **Product → Archive**

The error should be gone because "Release" configuration uses App Store distribution profiles, which don't require devices.

---

## Alternative: Add a Device (If You Have One)

If you have an iPhone/iPad, you can add it to fix the error:

### Option A: Connect Device

1. **Connect your iPhone/iPad via USB**
2. **Trust the computer** on your device
3. **Xcode will detect it automatically**
4. **Try archiving again**

### Option B: Add Device Manually

1. **Get your device UDID:**
   - Settings → General → About → Scroll to find UDID
   - Or: Connect device, open Xcode → Window → Devices and Simulators

2. **Go to:** https://developer.apple.com/account/resources/devices/list

3. **Click "+" (Add Device)**

4. **Fill in:**
   - Name: "My iPhone" (or any name)
   - UDID: Paste your device UDID
   - Click "Continue" → "Register"

5. **Back in Xcode:**
   - Click "Try Again" in the signing error
   - Or: Product → Clean Build Folder → Archive

---

## Why This Happens

- **Debug configuration** = Development profiles = Requires device
- **Release configuration** = App Store profiles = No device needed ✅

For App Store uploads, you should always use **Release** configuration.

---

## Verify Settings

### Check Archive Scheme:

1. **Product → Scheme → Edit Scheme**
2. **Archive → Build Configuration**
3. **Should be:** "Release" ✅
4. **NOT:** "Debug" ❌

### Check Signing:

1. **Signing & Capabilities tab**
2. **Automatically manage signing:** ✅ Checked
3. **Team:** Selected
4. **Bundle Identifier:** `com.ciphio.vault`

---

## Step-by-Step Fix

1. ✅ **Product → Scheme → Edit Scheme**
2. ✅ **Select "Archive"**
3. ✅ **Change "Build Configuration" to "Release"**
4. ✅ **Click "Close"**
5. ✅ **Product → Clean Build Folder**
6. ✅ **Product → Archive**

---

## If Still Not Working

1. **Xcode → Preferences → Accounts**
2. **Select your Apple ID (Kaan Gul)**
3. **Click "Download Manual Profiles"**
4. **Wait for download**
5. **Product → Clean Build Folder**
6. **Product → Archive**

---

**Remember:** For App Store uploads, use **Release** configuration - no device needed!

---

**Last Updated:** November 2025

