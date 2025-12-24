# Get UDID Directly on iPhone

**How to find UDID on iPhone 6 (even if locked)**

---

## Method 1: Settings App (If iPhone is Unlocked)

### Step 1: Open Settings
1. **Unlock iPhone 6** (if you can)
2. **Open Settings app**

### Step 2: Find UDID
1. **Settings → General → About**
2. **Scroll down** to find device information
3. **Look for:**
   - **"UDID"** (might be labeled as "Identifier")
   - Or tap on **"Serial Number"** multiple times (it cycles through Serial → UDID → ECID)

### Step 3: Copy UDID
- **Tap on UDID** to copy it
- Or **long press** and select "Copy"
- Or **write it down**

**UDID Format:** `00008030-001A1D1234567890` (long alphanumeric string with hyphens)

---

## Method 2: If iPhone is Locked

### ⚠️ Problem: Can't Access Settings

**If iPhone 6 is locked and you don't know the password:**

**You CANNOT get UDID from the iPhone itself** - you need to:
- Connect to a computer (Mac/PC)
- Or use one of the other methods (backup folders, Xcode, etc.)

---

## Method 3: Using a Computer (If iPhone is Locked)

### If iPhone was Previously Trusted:

1. **Connect iPhone 6 to Mac** via USB
2. **Open Finder** (macOS Catalina+) or **iTunes** (older macOS)
3. **Click on iPhone** in sidebar
4. **Click on Serial Number** - it will change to UDID
5. **Copy the UDID**

### If iPhone Shows "Trust This Computer":

- You'll need the password to trust the computer
- Once trusted, you can see UDID in Finder/iTunes

---

## Method 4: Check if iPhone is in Recovery Mode

### If iPhone is in Recovery Mode:

1. **Connect iPhone to Mac**
2. **Open Finder/iTunes**
3. **You'll see the device in recovery mode**
4. **UDID might be visible** in the device info
5. **Or use Terminal command:**
   ```bash
   system_profiler SPUSBDataType | grep -A 11 iPhone
   ```

---

## Method 5: Using 3uTools or iMazing (Third-Party Tools)

### If You Can't Use Official Methods:

**3uTools (Windows/Mac):**
1. Download 3uTools
2. Connect iPhone 6
3. It will show UDID even if locked

**iMazing (Mac/Windows):**
1. Download iMazing
2. Connect iPhone 6
3. It shows device info including UDID

**Note:** These tools can sometimes read device info even if locked

---

## Method 6: Check iPhone Box or Receipt

### If You Have the Original Box:

- **Check the iPhone box** - UDID might be printed on it
- **Check the receipt** - Apple receipts sometimes include UDID
- **Check Apple Store purchase email** - might have device info

---

## Quick Answer: If iPhone is Unlocked

**If you CAN unlock iPhone 6:**

1. **Settings → General → About**
2. **Scroll down**
3. **Tap on "Serial Number"** multiple times
4. **It cycles:** Serial Number → UDID → ECID
5. **Copy the UDID when it shows**

**Or:**
1. **Settings → General → About**
2. **Look for "Identifier" or "UDID"**
3. **Tap to copy**

---

## Quick Answer: If iPhone is Locked

**If you CANNOT unlock iPhone 6:**

1. **Try connecting to Mac** (if it was previously trusted)
2. **Check Finder/iTunes** for device info
3. **Check backup folders** on Mac
4. **Check Xcode** (if it was previously connected)
5. **Use third-party tools** (3uTools, iMazing)

---

## Most Common Method (If Unlocked)

**Settings → General → About → Tap Serial Number → Shows UDID**

That's the easiest way if the iPhone is unlocked!

---

**Last Updated:** November 2025

