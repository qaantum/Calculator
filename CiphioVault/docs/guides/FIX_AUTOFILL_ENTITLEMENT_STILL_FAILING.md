# Fix AutoFill Entitlement Error (Still Failing)

**Error persists even after enabling capability in main App ID**

---

## Critical: Check Extension App ID

**The extension has its own App ID that ALSO needs the capability enabled!**

### Step 1: Enable in Extension App ID

1. **Go to:** https://developer.apple.com/account/resources/identifiers/list
2. **Click "App IDs"** in left sidebar
3. **Find:** `com.ciphio.vault.AutoFillExtension` (NOT the main app!)
4. **Click on it** to edit
5. **Scroll to "Capabilities"**
6. **Check:** "Authentication Services - AutoFill Credential Provider"
7. **Click "Save"**

**This is the most common issue!** The extension App ID is separate and needs the capability too.

---

## Step 2: Add Capability in Xcode UI

Even if the entitlements file is correct, Xcode needs to see the capability in the UI:

### For AutoFillExtension Target:

1. **Open Xcode**
2. **Select your project** in navigator
3. **Select "AutoFillExtension" target**
4. **Go to "Signing & Capabilities" tab**
5. **Check if "AutoFill Credential Provider" is listed:**
   - ✅ If YES: It's there, continue to next step
   - ❌ If NO: Add it (see below)

### If Capability is Missing in Xcode:

1. **Click "+ Capability"** button (top left of Signing & Capabilities tab)
2. **Search for:** "AutoFill"
3. **Select:** "AutoFill Credential Provider"
4. **Xcode will add it automatically**

**Important:** Xcode needs to see the capability in the UI, not just in the entitlements file!

---

## Step 3: Verify Both App IDs

**You need the capability enabled in BOTH App IDs:**

1. ✅ **`com.ciphio.vault`** (main app) - You already did this
2. ✅ **`com.ciphio.vault.AutoFillExtension`** (extension) - **DO THIS NOW!**

---

## Step 4: Delete Old Provisioning Profiles

After enabling capabilities, old profiles might be cached:

### Method 1: Delete in Xcode

1. **Xcode → Preferences** (`⌘ + ,`)
2. **Accounts tab**
3. **Select your Apple ID**
4. **Click your team**
5. **Click "Download Manual Profiles"** (this downloads fresh ones)
6. **Or:** Click "Manage Certificates" and refresh

### Method 2: Delete Manually

1. **Close Xcode**
2. **Open Finder**
3. **Press `⌘ + Shift + G`**
4. **Type:** `~/Library/MobileDevice/Provisioning Profiles`
5. **Delete all files** in that folder (or just the ones for your app)
6. **Reopen Xcode**
7. **Download profiles again**

---

## Step 5: Clean Everything

### Clean Build Folder:

1. **Product → Clean Build Folder** (`⌘ + Shift + K`)
2. **Wait for completion**

### Clean Derived Data:

1. **Xcode → Settings** (`⌘ + ,`)
2. **Locations tab**
3. **Click arrow** next to Derived Data path
4. **Delete the folder** for your project
5. **Or:** Delete entire DerivedData folder

### Clean Archive:

1. **Window → Organizer** (`⌘ + Shift + 2`)
2. **Select your archive**
3. **Right-click → Delete**
4. **Create a fresh archive**

---

## Step 6: Verify Entitlements File

**Check the entitlements file is correct:**

1. **In Xcode navigator**, find:
   - `AutoFillExtension/AutoFillExtension.entitlements`
2. **Open it** and verify it contains:
   ```xml
   <key>com.apple.developer.authentication-services.autofill-credential-provider</key>
   <true/>
   ```
3. **If missing:** Add it manually

---

## Step 7: Re-Archive

1. **Select "Any iOS Device"** (not simulator)
2. **Product → Clean Build Folder** (`⌘ + Shift + K`)
3. **Product → Archive**
4. **Wait for completion**
5. **Try uploading again**

---

## Step 8: If Still Failing - Check Provisioning Profile

### Verify Profile Includes Capability:

1. **In Xcode**, select "AutoFillExtension" target
2. **Signing & Capabilities tab**
3. **Look at "Provisioning Profile"** section
4. **Click the "i" icon** or profile name
5. **Check if it shows the AutoFill capability**

### Force Profile Refresh:

1. **In Signing & Capabilities tab**
2. **Uncheck "Automatically manage signing"**
3. **Check it again** (forces Xcode to regenerate)
4. **Or:** Select a different profile, then select automatic again

---

## Alternative: Remove and Re-Add Capability

If nothing works, try removing and re-adding:

### Step 1: Remove in Xcode

1. **Select "AutoFillExtension" target**
2. **Signing & Capabilities tab**
3. **Find "AutoFill Credential Provider"**
4. **Click the "X"** to remove it
5. **Confirm removal**

### Step 2: Remove from Entitlements File

1. **Open** `AutoFillExtension/AutoFillExtension.entitlements`
2. **Remove** the AutoFill entitlement key
3. **Save**

### Step 3: Re-Add Everything

1. **In Xcode**, add capability again via "+ Capability"
2. **Verify** it appears in entitlements file
3. **Enable** in both App IDs in Developer portal
4. **Download profiles**
5. **Clean and archive**

---

## Quick Checklist

- [ ] ✅ Enable capability in `com.ciphio.vault` App ID (you did this)
- [ ] ✅ **Enable capability in `com.ciphio.vault.AutoFillExtension` App ID** (DO THIS!)
- [ ] ✅ Add capability in Xcode UI for AutoFillExtension target
- [ ] ✅ Verify entitlements file has the key
- [ ] ✅ Delete old provisioning profiles
- [ ] ✅ Download fresh profiles in Xcode
- [ ] ✅ Clean build folder
- [ ] ✅ Clean derived data
- [ ] ✅ Delete old archive
- [ ] ✅ Create fresh archive
- [ ] ✅ Try uploading again

---

## Most Likely Issue

**The extension App ID (`com.ciphio.vault.AutoFillExtension`) doesn't have the capability enabled!**

**Fix:**
1. Go to Apple Developer portal
2. Edit `com.ciphio.vault.AutoFillExtension` App ID
3. Enable "Authentication Services - AutoFill Credential Provider"
4. Save
5. Download profiles in Xcode
6. Clean and archive again

---

## Still Not Working?

### Check Xcode Version

- Make sure you're using a recent Xcode version
- Update Xcode if needed

### Check Team Selection

- Verify the correct team is selected for both targets
- Both targets should use the same team

### Contact Apple Support

If nothing works:
- Contact Apple Developer Support
- Provide the error message
- Explain you've enabled the capability in both App IDs

---

**Last Updated:** November 2025

