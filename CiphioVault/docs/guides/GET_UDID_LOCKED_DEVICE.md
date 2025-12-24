# Get UDID from Locked iPhone 6

**Problem:** Need UDID but iPhone 6 is locked and you don't have other devices

---

## Method 1: Connect to Mac (Even If Locked)

Even if the iPhone is locked, try connecting it:

### Step 1: Connect iPhone 6

1. **Connect iPhone 6 to Mac via USB**
2. **If iPhone shows "Trust This Computer":**
   - You'll need the password (can't bypass this)
   - Skip to Method 2

3. **If iPhone was previously trusted:**
   - It might connect without password
   - Continue to next step

### Step 2: Check Finder/iTunes

1. **Open Finder** (macOS Catalina+) or **iTunes** (older macOS)
2. **Look in sidebar for your iPhone**
3. **If it appears:**
   - Click on it
   - Click on the **Serial Number** (it changes to UDID)
   - Copy the UDID

### Step 3: Check Xcode

1. **Open Xcode**
2. **Window → Devices and Simulators** (`⌘ + Shift + 2`)
3. **Check if iPhone 6 appears** in the list (even if disconnected)
4. **If it appears:**
   - Select it
   - UDID is shown in the device info panel
   - Copy it

---

## Method 2: Check if Devices Already Registered

**Before trying to get UDID, check if you already have devices:**

1. **Go to:** https://developer.apple.com/account/resources/devices/list
2. **Check the list:**
   - Do you see any devices already registered?
   - If YES: You might not need to add iPhone 6!
   - Just download profiles in Xcode

3. **If you have devices registered:**
   - Xcode → Preferences → Accounts
   - Select your Apple ID
   - Click "Download Manual Profiles"
   - Try archiving again

---

## Method 3: Check Previous Xcode Connections

Xcode might have saved the UDID from previous connections:

1. **Open Xcode**
2. **Window → Devices and Simulators** (`⌘ + Shift + 2`)
3. **Look at the list:**
   - Even disconnected devices might appear
   - Check if iPhone 6 is listed
   - If yes, select it and copy UDID

---

## Method 4: Check Backup Folders

If you have backups of the iPhone 6:

1. **Check backup location:**
   - `~/Library/Application Support/MobileSync/Backup/`
   - Or: `~/Library/Application Support/iTunes/Mobile Applications/`

2. **Look for folders:**
   - Backup folders are named with UDID
   - Format: Long alphanumeric string
   - That's the UDID!

3. **If you find a backup folder:**
   - The folder name is the UDID
   - Copy it and register it

---

## Method 5: Reset iPhone 6 (Last Resort)

⚠️ **Warning:** This will ERASE ALL DATA on iPhone 6!

Only do this if:
- You don't need the data on iPhone 6
- You've tried all other methods
- You're okay with losing everything on the device

### Steps:

1. **Put iPhone in Recovery Mode:**
   - Turn off iPhone (if possible)
   - Hold **Home button**
   - Connect to Mac while holding Home
   - Keep holding until you see recovery screen

2. **Use Finder/iTunes:**
   - You'll see the device in recovery mode
   - UDID might be visible before restore
   - Or restore and set up as new
   - Then get UDID from Settings → General → About

---

## Method 6: Contact Apple Support

If nothing else works:

1. **Contact Apple Developer Support:**
   - https://developer.apple.com/contact/
   - Explain you need to register a device but can't unlock it
   - They might be able to help

2. **Or Apple Support:**
   - They might be able to help with device registration
   - But they usually can't provide UDID directly

---

## Recommended: Check Existing Devices First

**Before trying to get UDID, do this:**

1. **Go to:** https://developer.apple.com/account/resources/devices/list
2. **Check if you already have devices registered**
3. **If YES:**
   - You might not need iPhone 6 UDID!
   - Just download profiles in Xcode
   - Try archiving

4. **If NO devices registered:**
   - Then try the methods above to get iPhone 6 UDID

---

## Quick Checklist

- [ ] Check if devices already registered in Apple Developer
- [ ] Try connecting iPhone 6 to Mac (even if locked)
- [ ] Check Finder/iTunes for device
- [ ] Check Xcode → Devices and Simulators
- [ ] Check backup folders for UDID
- [ ] If all else fails, consider resetting iPhone 6 (erases data)

---

**Last Updated:** November 2025

