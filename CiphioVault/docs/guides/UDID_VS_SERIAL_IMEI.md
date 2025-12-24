# UDID vs Serial Number vs IMEI

**Important:** UDID is different from Serial Number and IMEI!

---

## What You're Seeing

From your screenshot:
- ✅ **Serial Number:** `F6WP41NLG5MN`
- ✅ **IMEI:** `35 836806 901523 7`
- ❌ **UDID:** Not shown (this is what you need!)

---

## UDID is Different

- **Serial Number:** Used for warranty/service
- **IMEI:** Used for cellular network identification
- **UDID:** Unique Device Identifier - used for development/code signing

**You need the UDID, not the Serial Number or IMEI!**

---

## How to Get UDID

### Method 1: From iPhone Settings (Requires Password)

If you can unlock the iPhone 6:

1. **Settings → General → About**
2. **Scroll down to find "UDID" or "Identifier"**
3. **Tap on it** - it will show the full UDID
4. **Tap again to copy** (or write it down)
5. **Format:** `00008030-001A1D1234567890` (long alphanumeric with hyphens)

### Method 2: From Finder/iTunes (If Previously Trusted)

1. **Connect iPhone 6 to Mac via USB**
2. **Open Finder** (or iTunes on older macOS)
3. **Click on your iPhone** in sidebar
4. **Click on the Serial Number** - it will change to show UDID
5. **Copy the UDID**

### Method 3: From Xcode

1. **Connect iPhone 6 to Mac**
2. **Open Xcode**
3. **Window → Devices and Simulators** (`⌘ + Shift + 2`)
4. **Select iPhone 6** from the list
5. **UDID is shown** in the device info panel

---

## Alternative: Use IMEI to Find UDID (Advanced)

⚠️ **This is complicated and may not work:**

Some third-party tools can convert IMEI to UDID, but:
- Not officially supported by Apple
- May require additional information
- Not recommended

**Better to get UDID directly from device or use another device.**

---

## Easier Solution: Use Another Device

**Since you can't unlock iPhone 6, use any other iPhone/iPad:**

1. **Get any iPhone/iPad you can unlock**
2. **Settings → General → About**
3. **Scroll to UDID → Tap to copy**
4. **Register that device** in Apple Developer
5. **Done!**

Any iOS device works - you don't need iPhone 6 specifically!

---

## Check if Device Already Registered

Before adding a new device, check if you already have devices:

1. **Go to:** https://developer.apple.com/account/resources/devices/list
2. **Check the list:**
   - If you see devices already registered
   - You might not need to add iPhone 6
   - Just download profiles in Xcode

---

## Quick Steps

### If You Can Unlock iPhone 6:
1. Settings → General → About
2. Scroll to UDID → Copy
3. Register at: https://developer.apple.com/account/resources/devices/list

### If You Can't Unlock iPhone 6:
1. Use any other iPhone/iPad you can unlock
2. Get its UDID (Settings → General → About)
3. Register that device instead
4. Or check if you already have devices registered

---

**Remember:** You need UDID (not Serial Number or IMEI), and any iOS device works for registration!

---

**Last Updated:** November 2025

