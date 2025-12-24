# Fix Distribution Signing Error

**Problem:** Even with Release configuration, Xcode still shows "Apple Development" certificate and device errors

**Solution:** Force Xcode to use App Store Distribution profiles

---

## Solution 1: Download Profiles Manually

1. **Xcode → Preferences** (`⌘ + ,`)
2. **Accounts tab**
3. **Select your Apple ID (Kaan Gul)**
4. **Click "Download Manual Profiles"**
5. **Wait for download to complete**
6. **Close Preferences**

7. **Back in project:**
   - **Product → Clean Build Folder** (`⌘ + Shift + K`)
   - **Product → Archive**

---

## Solution 2: Check Bundle IDs in App Store Connect

The bundle IDs need to be registered in App Store Connect:

1. **Go to:** https://appstoreconnect.apple.com
2. **Your App → App Information**
3. **Check Bundle ID:** Should be `com.ciphio.vault`
4. **If not registered:**
   - Go to: https://developer.apple.com/account/resources/identifiers/list
   - Click "+" to add new identifier
   - Select "App IDs"
   - Register: `com.ciphio.vault`
   - Register: `com.ciphio.vault.AutoFillExtension`

---

## Solution 3: Force Distribution Certificate

### For CiphioVault Target:

1. **Select "CiphioVault" target**
2. **Signing & Capabilities tab**
3. **Uncheck "Automatically manage signing"** (temporarily)
4. **Provisioning Profile dropdown:**
   - Look for profiles with "App Store" or "Distribution" in name
   - If none exist, go back to step 1 (download profiles)
5. **Check "Automatically manage signing" again**
6. **Xcode should now create App Store profiles**

### For AutoFillExtension Target:

1. **Select "AutoFillExtension" target**
2. **Signing & Capabilities tab**
3. **Same steps as above**

---

## Solution 4: Add Device (Quick Fix)

Even though you don't need it for distribution, adding a device can help Xcode create the profiles:

### If You Have an iPhone/iPad:

1. **Connect device via USB**
2. **Trust computer on device**
3. **Xcode will detect it**
4. **Click "Try Again" in signing error**
5. **Xcode will create profiles**

### If You Don't Have a Device:

1. **Get device UDID from a friend/family member:**
   - Settings → General → About → UDID

2. **Add device manually:**
   - Go to: https://developer.apple.com/account/resources/devices/list
   - Click "+"
   - Name: "Test Device"
   - UDID: Paste UDID
   - Click "Continue" → "Register"

3. **Back in Xcode:**
   - Click "Try Again"
   - Or: Product → Clean Build Folder → Archive

---

## Solution 5: Check Certificate Type

1. **Xcode → Preferences → Accounts**
2. **Select your Apple ID**
3. **Click "Manage Certificates"**
4. **Check if you have:**
   - ✅ "Apple Distribution" certificate
   - ❌ Only "Apple Development" certificate

5. **If missing Distribution certificate:**
   - Xcode will create it automatically when you archive
   - Or: Click "+" → "Apple Distribution"

---

## Step-by-Step Complete Fix

### 1. Register Bundle IDs (If Not Done):

1. Go to: https://developer.apple.com/account/resources/identifiers/list
2. Click "+" → "App IDs"
3. Register: `com.ciphio.vault`
4. Register: `com.ciphio.vault.AutoFillExtension`

### 2. Download Profiles:

1. Xcode → Preferences → Accounts
2. Select your Apple ID
3. Click "Download Manual Profiles"
4. Wait for completion

### 3. Add Device (Temporary):

1. Add at least one device to your account:
   - https://developer.apple.com/account/resources/devices/list
   - Or connect a physical device

### 4. Clean and Archive:

1. Product → Clean Build Folder
2. Product → Archive

---

## Alternative: Use Export Instead

If signing still fails, you can export and upload manually:

1. **Product → Archive**
2. **Organizer opens**
3. **Select archive → "Distribute App"**
4. **Choose: "App Store Connect"**
5. **Choose: "Upload"**
6. **Xcode will handle signing during upload**

---

## Verify Settings

### Before Archiving, Check:

1. **Archive Scheme:**
   - ✅ Build Configuration: "Release"

2. **CiphioVault Target:**
   - ✅ Automatically manage signing: ON
   - ✅ Team: Selected
   - ✅ Bundle ID: `com.ciphio.vault`

3. **AutoFillExtension Target:**
   - ✅ Automatically manage signing: ON
   - ✅ Team: Same as main app
   - ✅ Bundle ID: `com.ciphio.vault.AutoFillExtension`

4. **Certificates:**
   - ✅ Apple Distribution certificate exists
   - (Check: Xcode → Preferences → Accounts → Manage Certificates)

---

## Quick Checklist

- [ ] Bundle IDs registered in Apple Developer
- [ ] Downloaded profiles manually
- [ ] Added at least one device (temporary)
- [ ] Archive uses Release configuration
- [ ] Cleaned build folder
- [ ] Try Product → Archive

---

**Last Updated:** November 2025

