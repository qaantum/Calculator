# Get iPhone UDID Without Password

**Problem:** Need UDID but don't remember iPhone password

---

## Method 1: Connect to Computer (If Previously Trusted)

If the iPhone was previously connected and trusted to your Mac:

### Using Finder (macOS Catalina+):

1. **Connect iPhone 6 to Mac via USB**
2. **Open Finder**
3. **Click on your iPhone** in the sidebar
4. **If it shows device info:**
   - Click on the **serial number** (it will change to UDID)
   - Copy the UDID
5. **If it asks to "Trust This Computer":**
   - You'll need to enter the password on the iPhone
   - If you can't, try other methods below

### Using iTunes (Older macOS):

1. **Connect iPhone 6 to Mac via USB**
2. **Open iTunes**
3. **Click on your device** icon
4. **Click on the serial number** (it will change to UDID)
5. **Copy the UDID**

---

## Method 2: Check Xcode (If Previously Connected)

If the iPhone was previously connected to Xcode:

1. **Open Xcode**
2. **Window → Devices and Simulators** (`⌘ + Shift + 2`)
3. **Look in the left sidebar:**
   - If your iPhone 6 appears (even if disconnected), select it
   - UDID will be shown in the device info panel
4. **If it doesn't appear:**
   - Try connecting the device
   - Even if locked, Xcode might show it

---

## Method 3: Check Device Back (Physical)

Some older iPhones have the UDID printed on the device:

1. **Look on the back of iPhone 6:**
   - Near the bottom, below "iPhone"
   - Look for a long alphanumeric code
   - Format: `A1549` (model) or serial number
   - **Note:** This is usually the serial number, not UDID

2. **If you have the serial number:**
   - You can look it up, but UDID is different
   - Try other methods

---

## Method 4: Use Another Device (Easier!)

**Best option:** Use a different iPhone/iPad that you can unlock:

### If you have access to another iOS device:

1. **Settings → General → About**
2. **Scroll to find "UDID" or "Identifier"**
3. **Tap to copy**
4. **Register that device instead**

**Any iOS device works!** It doesn't have to be iPhone 6.

---

## Method 5: Ask Friend/Family

If you know someone with an iPhone/iPad:

1. **Ask them to get their UDID:**
   - Settings → General → About
   - Scroll to UDID
   - Tap to copy
2. **They send you the UDID**
3. **You register it in your Apple Developer account**
4. **They don't need to give you the device - just the UDID**

---

## Method 6: Check Previous Backups

If you have a backup of the iPhone:

1. **Check iTunes/Finder backups:**
   - Look in backup folders
   - UDID might be in backup folder name
   - Location: `~/Library/Application Support/MobileSync/Backup/`

2. **Check iCloud:**
   - If you have iCloud backup, UDID might be visible in account settings
   - But this is harder to access

---

## Method 7: Reset iPhone (Last Resort)

⚠️ **Warning:** This will erase all data!

If you don't need the data on iPhone 6:

1. **Put iPhone in Recovery Mode:**
   - Turn off iPhone
   - Hold Home button
   - Connect to Mac while holding Home
   - Keep holding until you see recovery screen

2. **Use Finder/iTunes to restore:**
   - You'll see the device
   - UDID might be visible before restore

3. **Or restore and set up as new:**
   - Then get UDID from Settings → General → About

---

## Recommended: Use Another Device

**Easiest solution:** Use any iPhone/iPad you can unlock:

1. **Any iOS device works** (iPhone, iPad, iPod touch)
2. **Get UDID:** Settings → General → About → UDID
3. **Register it** in Apple Developer
4. **Done!**

You don't need iPhone 6 specifically - any iOS device will fix the code signing issue.

---

## Quick Steps (Using Any Device)

1. **Get any iPhone/iPad you can unlock**
2. **Settings → General → About**
3. **Scroll to UDID → Tap to copy**
4. **Go to:** https://developer.apple.com/account/resources/devices/list
5. **Click "+" → Add Device**
6. **Paste UDID → Register**
7. **Back in Xcode:** Download profiles → Archive

---

## Alternative: Check if Device Already Registered

Before adding a new device, check if you already have devices registered:

1. **Go to:** https://developer.apple.com/account/resources/devices/list
2. **Check the list:**
   - If you see any devices already registered
   - You might not need to add a new one
   - Just download profiles in Xcode

---

**Remember:** Any iOS device works! You don't need iPhone 6 specifically - use any device you can unlock.

---

**Last Updated:** November 2025

