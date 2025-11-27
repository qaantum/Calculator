# Quick Guide: Connect Your Phone to Android Studio

## 🚀 Quick Steps

### Step 1: Enable Developer Options on Your Phone

1. **Open Settings** on your phone
2. Go to **About phone** (or **About device**)
3. Find **Build number** (scroll down)
4. **Tap "Build number" 7 times**
5. You'll see: "You are now a developer!" ✅

### Step 2: Enable USB Debugging

1. Go back to **Settings**
2. Find **Developer options** (usually under System or Advanced)
3. **Enable "USB debugging"**
4. (Optional) Enable **"Stay awake"** (keeps screen on while charging)

### Step 3: Connect Phone to Mac

1. **Connect phone to Mac** with USB cable
2. **Unlock your phone**
3. **Look for prompt on phone:**
   - "Allow USB debugging?"
   - ✅ Check **"Always allow from this computer"**
   - Tap **"Allow"**

### Step 4: Check Connection

**In Terminal (on Mac):**
```bash
cd ~/Library/Android/sdk/platform-tools
./adb devices
```

**You should see:**
```
List of devices attached
XXXXXXXX    device
```

If you see "unauthorized" or nothing, see troubleshooting below.

### Step 5: Check Android Studio

1. **Open Android Studio**
2. Look at the **device dropdown** (top toolbar, next to Run button)
3. Your phone should appear there! 📱

---

## 🐛 Troubleshooting

### Phone Not Showing Up?

#### Check 1: USB Cable
- ✅ Use a **data cable** (not just charging cable)
- Try a **different USB cable**
- Try a **different USB port** on your Mac

#### Check 2: USB Mode on Phone
1. **Pull down notification shade** on phone
2. **Tap "USB" notification**
3. Select **"File Transfer"** or **"MTP"** (not "Charging only")

#### Check 3: Revoke and Re-authorize
1. **Unplug phone**
2. On phone: **Settings** → **Developer options** → **Revoke USB debugging authorizations**
3. **Plug phone back in**
4. **Accept the prompt** on phone

#### Check 4: Restart ADB
```bash
cd ~/Library/Android/sdk/platform-tools
./adb kill-server
./adb start-server
./adb devices
```

#### Check 5: Close Android File Transfer
- **Quit Android File Transfer** app if it's running
- It can interfere with ADB on Mac

---

## 📱 Alternative: Wireless Debugging (Android 11+)

If USB keeps failing, use wireless:

### On Phone:
1. **Settings** → **Developer options**
2. Enable **"Wireless debugging"**
3. Tap **"Wireless debugging"** → **"Pair device with pairing code"**
4. Note the **IP address, port, and pairing code**

### On Mac:
```bash
cd ~/Library/Android/sdk/platform-tools

# Pair (use IP:port and code from phone)
./adb pair 192.168.1.100:12345
# Enter pairing code when prompted

# Connect (use the port shown after pairing)
./adb connect 192.168.1.100:12345

# Verify
./adb devices
```

**Note:** Phone and Mac must be on **same Wi-Fi network**.

---

## ✅ Quick Test

Once connected, in Android Studio:
1. Select your phone from device dropdown
2. Click **Run** (green play button)
3. App should install and launch on your phone! 🎉

---

## 🆘 Still Not Working?

1. **Restart everything:**
   - Restart phone
   - Restart Mac
   - Restart Android Studio

2. **Check phone manufacturer:**
   - Some phones (Samsung, OnePlus) may need USB drivers
   - Or just use **Wireless debugging** instead

3. **Try wireless debugging** - it's often more reliable!

