# Fix: Distribution Profile Missing AutoFill Entitlement

**Problem:** Archive is set to Release, but Distribution profile doesn't have AutoFill capability

**Issue:** Development profiles have the capability, but App Store Distribution profiles don't

---

## The Real Problem

Even though:
- ✅ Archive is set to Release
- ✅ Capability is enabled in App IDs
- ✅ Development profiles have the entitlement

The **App Store Distribution provisioning profile** might not have been regenerated with the capability.

---

## Solution: Force Xcode to Regenerate Distribution Profiles

### Step 1: Delete All Provisioning Profiles

1. **Close Xcode**
2. **Open Finder**
3. **Press `⌘ + Shift + G`**
4. **Type:** `~/Library/MobileDevice/Provisioning Profiles`
5. **Delete ALL files** in that folder
   - Or just delete ones for `com.ciphio.vault`
6. **Empty Trash** (optional)

### Step 2: Verify Capabilities in Developer Portal

1. **Go to:** https://developer.apple.com/account/resources/identifiers/list
2. **Click "App IDs"**
3. **Verify BOTH App IDs have capability enabled:**
   - ✅ `com.ciphio.vault` - AutoFill Credential Provider enabled
   - ✅ `com.ciphio.vault.AutoFillExtension` - AutoFill Credential Provider enabled
4. **If not enabled:** Enable them and save

### Step 3: Force Xcode to Download Fresh Profiles

1. **Open Xcode**
2. **Xcode → Preferences** (`⌘ + ,`)
3. **Accounts tab**
4. **Select your Apple ID**
5. **Click your team** (Kaan Gul - 45K7S9XMQ7)
6. **Click "Download Manual Profiles"**
7. **Wait for completion**

### Step 4: Toggle Automatic Signing

**For CiphioVault target:**
1. **Select "CiphioVault" target**
2. **Signing & Capabilities tab**
3. **Uncheck "Automatically manage signing"**
4. **Check it again** (forces regeneration)
5. **Wait for Xcode to finish**

**For AutoFillExtension target:**
1. **Select "AutoFillExtension" target**
2. **Signing & Capabilities tab**
3. **Uncheck "Automatically manage signing"**
4. **Check it again**
5. **Wait for Xcode to finish**

### Step 5: Verify Profiles Include Capability

**Check AutoFillExtension target:**
1. **Select "AutoFillExtension" target**
2. **Signing & Capabilities tab**
3. **Look at "Provisioning Profile" section**
4. **Click the profile name** or "i" icon
5. **Verify it shows:**
   - ✅ "App Store" or "Distribution" (not "Development")
   - ✅ Should include AutoFill capability

**If it still shows Development:**
- The Archive scheme might still be using Debug
- Or Xcode hasn't generated Distribution profiles yet

---

## Alternative: Create Distribution Profile Manually

If automatic signing isn't working:

### Step 1: Create App Store Profile

1. **Go to:** https://developer.apple.com/account/resources/profiles/list
2. **Click "+"** to create new profile
3. **Select:** "App Store" (under Distribution)
4. **Click "Continue"**
5. **Select App ID:** `com.ciphio.vault.AutoFillExtension`
6. **Click "Continue"**
7. **Select certificate:** "Apple Distribution" (or create one)
8. **Click "Continue"**
9. **Name it:** "Ciphio Vault AutoFill Extension App Store"
10. **Click "Generate"**
11. **Download the profile**

### Step 2: Install Profile in Xcode

1. **Double-click the downloaded .mobileprovision file**
2. **It will install in Xcode automatically**
3. **Or:** Drag it into Xcode

### Step 3: Use Manual Profile

1. **Select "AutoFillExtension" target**
2. **Signing & Capabilities tab**
3. **Uncheck "Automatically manage signing"**
4. **Select the profile** you just created
5. **Do same for "CiphioVault" target** (create App Store profile for main app too)

---

## Step 6: Clean and Re-Archive

1. **Product → Clean Build Folder** (`⌘ + Shift + K`)
2. **Delete old archive** in Organizer
3. **Verify Archive scheme is "Release"** (Edit Scheme → Archive)
4. **Select "Any iOS Device"**
5. **Product → Archive**
6. **Wait for completion**

### Step 7: Verify Archive Uses Distribution

After archiving:

1. **Window → Organizer** (`⌘ + Shift + 2`)
2. **Select your archive**
3. **Right-click → Show in Finder**
4. **Right-click archive → Show Package Contents**
5. **Navigate to:** `Products/Applications/CiphioVault.app/PlugIns/AutoFillExtension.appex/embedded.mobileprovision`
6. **Open it** (text file)
7. **Check:**
   - ✅ Should NOT have `get-task-allow`
   - ✅ Should have `ProvisionedDevices` empty or not present
   - ✅ Should say "App Store" in name
   - ✅ Should include: `com.apple.developer.authentication-services.autofill-credential-provider`

---

## Quick Checklist

- [ ] ✅ Delete all provisioning profiles from Mac
- [ ] ✅ Verify both App IDs have AutoFill capability enabled
- [ ] ✅ Download fresh profiles in Xcode
- [ ] ✅ Toggle automatic signing to force regeneration
- [ ] ✅ Verify profiles are "App Store" not "Development"
- [ ] ✅ Clean build folder
- [ ] ✅ Delete old archive
- [ ] ✅ Archive with Release configuration
- [ ] ✅ Verify archive uses Distribution profiles
- [ ] ✅ Try uploading again

---

## Most Likely Fix

**The Distribution/App Store provisioning profiles don't have the capability because they were created before you enabled it.**

**Solution:**
1. Delete old profiles
2. Force Xcode to regenerate them
3. Archive again

---

**Last Updated:** November 2025

