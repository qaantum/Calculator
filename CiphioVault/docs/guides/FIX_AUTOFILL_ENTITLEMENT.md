# Fix AutoFill Entitlement Error

**Error:** "Missing Entitlement. The extension bundle 'CiphioVault.app' is missing entitlement 'com.apple.developer.authentication-services.autofill-credential-provider'."

---

## Problem

The AutoFill extension entitlement exists in your code, but it's not enabled in your Apple Developer account or the provisioning profile doesn't include it.

---

## Solution: Enable AutoFill Capability in Apple Developer

### Step 1: Go to Apple Developer Portal

1. **Go to:** https://developer.apple.com/account/resources/identifiers/list
2. **Sign in** with your Apple Developer account

### Step 2: Find Your App ID

1. **Click on "App IDs"** in the left sidebar
2. **Find:** `com.ciphio.vault`
3. **Click on it** to edit

### Step 3: Enable AutoFill Capability

1. **Scroll down** to "Capabilities" section
2. **Look for:** "Authentication Services - AutoFill Credential Provider"
3. **Check the box** to enable it
4. **Click "Save"** (top right)

### Step 4: Find Your Extension App ID

1. **Still in App IDs list**
2. **Find:** `com.ciphio.vault.AutoFillExtension`
3. **Click on it** to edit
4. **Verify** "Authentication Services - AutoFill Credential Provider" is enabled
5. **If not enabled:** Check the box and click "Save"

---

## Solution: Enable in Xcode Signing & Capabilities

### Step 1: Check Main App Target

1. **Open Xcode**
2. **Select your project** in navigator
3. **Select "CiphioVault" target**
4. **Go to "Signing & Capabilities" tab**
5. **Check if "AutoFill Credential Provider" is listed:**
   - ✅ If YES: It's already enabled
   - ❌ If NO: Continue to next step

### Step 2: Add Capability to Main App (If Needed)

**Note:** The main app usually doesn't need this capability, but let's verify:

1. **In "Signing & Capabilities" tab**
2. **Click "+ Capability"** button (top left)
3. **Search for:** "AutoFill Credential Provider"
4. **If it appears:** Add it
5. **If it doesn't appear:** That's fine - it's only needed for the extension

### Step 3: Check Extension Target

1. **Select "AutoFillExtension" target**
2. **Go to "Signing & Capabilities" tab**
3. **Look for:** "AutoFill Credential Provider" capability
4. **If it's NOT there:**
   - Click "+ Capability"
   - Search for "AutoFill Credential Provider"
   - Add it

### Step 4: Verify Entitlements File

1. **In Xcode navigator**, find:
   - `AutoFillExtension/AutoFillExtension.entitlements`
2. **Open it** and verify it contains:
   ```xml
   <key>com.apple.developer.authentication-services.autofill-credential-provider</key>
   <true/>
   ```
3. **If missing:** Add it (but it should already be there)

---

## Solution: Download New Provisioning Profiles

After enabling the capability in Apple Developer portal:

### Step 1: Download Profiles in Xcode

1. **Xcode → Preferences** (`⌘ + ,`)
2. **Accounts tab**
3. **Select your Apple ID**
4. **Click "Download Manual Profiles"**
5. **Wait for completion**

### Step 2: Clean and Rebuild

1. **Product → Clean Build Folder** (`⌘ + Shift + K`)
2. **Product → Archive** again
3. **Try uploading** again

---

## Solution: Check Bundle Identifier

### Verify Extension Bundle ID

1. **Select "AutoFillExtension" target**
2. **General tab**
3. **Verify "Bundle Identifier":**
   - Should be: `com.ciphio.vault.AutoFillExtension`
4. **If different:** Change it to match

---

## Solution: Verify Capability in Xcode

### Step 1: Check Capabilities Tab

1. **Select "AutoFillExtension" target**
2. **Signing & Capabilities tab**
3. **You should see:**
   - ✅ App Groups
   - ✅ Keychain Sharing
   - ✅ **AutoFill Credential Provider** ← This must be present!

### Step 2: If Missing, Add It

1. **Click "+ Capability"** button
2. **Type:** "AutoFill"
3. **Select:** "AutoFill Credential Provider"
4. **Xcode will add it automatically**

---

## Quick Fix Checklist

- [ ] ✅ Enable "AutoFill Credential Provider" in Apple Developer portal for both App IDs:
  - `com.ciphio.vault`
  - `com.ciphio.vault.AutoFillExtension`
- [ ] ✅ Verify capability is in Xcode for "AutoFillExtension" target
- [ ] ✅ Download new provisioning profiles in Xcode
- [ ] ✅ Clean build folder
- [ ] ✅ Archive again
- [ ] ✅ Try uploading again

---

## Most Likely Fix

**The capability is probably not enabled in Apple Developer portal:**

1. **Go to:** https://developer.apple.com/account/resources/identifiers/list
2. **Edit App ID:** `com.ciphio.vault.AutoFillExtension`
3. **Enable:** "Authentication Services - AutoFill Credential Provider"
4. **Save**
5. **Download profiles in Xcode**
6. **Archive again**

---

## If Still Not Working

### Check Provisioning Profile

1. **In Xcode**, select "AutoFillExtension" target
2. **Signing & Capabilities tab**
3. **Look at "Provisioning Profile"** section
4. **Click "Download"** if there's a download button
5. **Or:** Select "Automatically manage signing" and let Xcode fix it

### Verify Entitlements Are Included

The entitlements file should have:
```xml
<key>com.apple.developer.authentication-services.autofill-credential-provider</key>
<true/>
```

If it's there, the issue is in Apple Developer portal or provisioning profile.

---

**Last Updated:** November 2025

