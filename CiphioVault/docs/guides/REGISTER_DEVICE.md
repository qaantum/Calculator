# Register Device for Code Signing

**Purpose:** Register a device UDID to fix code signing errors (you don't need to test on it)

---

## iPhone 6 is Fine!

✅ **Yes, iPhone 6 works perfectly for registration!**

- You only need the device UDID
- The device doesn't need to run your app
- Once registered, you can archive without the device
- You can use any iOS device (iPhone, iPad, iPod touch)

---

## How to Get iPhone 6 UDID

### Method 1: From iPhone Settings

1. **On iPhone 6:**
   - Settings → General → About
   - Scroll down to find **"UDID"** or **"Identifier"**
   - Tap on it to copy (or write it down)
   - It looks like: `00008030-001A1D1234567890`

### Method 2: From iTunes (If Connected)

1. **Connect iPhone 6 to computer**
2. **Open iTunes** (or Finder on macOS Catalina+)
3. **Click on your device**
4. **Click on the serial number** (it will change to UDID)
5. **Copy the UDID**

### Method 3: From Xcode (If Connected)

1. **Connect iPhone 6 to Mac**
2. **Open Xcode**
3. **Window → Devices and Simulators** (`⌘ + Shift + 2`)
4. **Select your iPhone 6**
5. **UDID is shown in the device info**

---

## Register Device in Apple Developer

### Step 1: Get UDID

- Use one of the methods above to get the UDID

### Step 2: Register Device

1. **Go to:** https://developer.apple.com/account/resources/devices/list
   - Or: App Store Connect → Users and Access → Devices

2. **Click "+" (Add Device)** button

3. **Fill in the form:**
   - **Name:** "iPhone 6" (or any name you want)
   - **UDID:** Paste the UDID you copied
   - **Platform:** iOS (should be selected automatically)

4. **Click "Continue"**

5. **Review and click "Register"**

---

## After Registration

### Step 1: Download Profiles in Xcode

1. **Xcode → Preferences** (`⌘ + ,`)
2. **Accounts tab**
3. **Select your Apple ID**
4. **Click "Download Manual Profiles"**
5. **Wait for completion**

### Step 2: Fix Signing

1. **In your project:**
   - Select "CiphioVault" target
   - Signing & Capabilities tab
   - Click "Try Again" on the error
   - Or: Product → Clean Build Folder

2. **Select "AutoFillExtension" target:**
   - Signing & Capabilities tab
   - Click "Try Again"

### Step 3: Archive

1. **Product → Clean Build Folder** (`⌘ + Shift + K`)
2. **Product → Archive**

The errors should be gone! ✅

---

## Important Notes

### Device Requirements for Testing:

⚠️ **iPhone 6 won't be able to test your app:**
- iPhone 6 supports up to iOS 12.5.7
- Your app requires iOS 15.0+
- So iPhone 6 can't run the app

✅ **But that's fine!**
- You only need it registered for code signing
- Once registered, you can archive without it
- You can test on a newer device later (or use TestFlight)

### For Testing Later:

You'll need a device that supports iOS 15.0+:
- iPhone 6s or newer
- iPad (5th generation) or newer
- Or use TestFlight on any iOS 15+ device

---

## Quick Checklist

- [ ] Get iPhone 6 UDID
- [ ] Register device in Apple Developer portal
- [ ] Download profiles in Xcode
- [ ] Click "Try Again" in signing errors
- [ ] Clean build folder
- [ ] Archive successfully

---

## Troubleshooting

### "Device already registered"
- That's fine! The device is already in your account
- Just download profiles in Xcode

### "Invalid UDID"
- Double-check you copied the full UDID
- Make sure there are no spaces
- UDID format: `00008030-001A1D1234567890`

### "Still showing errors after registration"
- Download profiles: Xcode → Preferences → Accounts → Download Manual Profiles
- Clean build folder
- Try archiving again

---

**Remember:** iPhone 6 is perfect for registration! You don't need to test on it - just register it to fix code signing.

---

**Last Updated:** November 2025

