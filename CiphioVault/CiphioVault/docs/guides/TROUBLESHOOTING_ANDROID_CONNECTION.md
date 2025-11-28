# Troubleshooting Android Phone Connection on M1 Mac

Common issues and solutions for connecting Android phones to M1 Macs in Android Studio.

---

## 🔍 Quick Checklist

- [ ] USB debugging enabled on phone
- [ ] Developer options enabled on phone
- [ ] USB cable supports data transfer (not just charging)
- [ ] Phone unlocked and "Allow USB debugging" prompt accepted
- [ ] Android File Transfer not running (can interfere)
- [ ] ADB recognizes device

---

## Step-by-Step Fix

### Step 1: Enable Developer Options on Phone

1. Go to **Settings** → **About phone**
2. Find **Build number** (or **Build version**)
3. Tap **Build number** 7 times
4. You'll see "You are now a developer!"

### Step 2: Enable USB Debugging

1. Go to **Settings** → **Developer options** (or **System** → **Developer options**)
2. Enable **USB debugging**
3. Enable **Stay awake** (optional, keeps screen on while charging)

### Step 3: Connect Phone to Mac

1. **Use a data cable** (not just charging cable)
   - Try a different USB cable if current one doesn't work
   - Some cables only charge, not transfer data

2. **Connect phone to Mac** via USB

3. **Unlock your phone**

4. **Look for prompt on phone:**
   - "Allow USB debugging?"
   - Check **"Always allow from this computer"**
   - Tap **"Allow"**

### Step 4: Check Android Studio

1. Open Android Studio
2. Look at bottom status bar for device connection
3. Or go to **View** → **Tool Windows** → **Device Manager**
4. Your phone should appear

---

## 🐛 Common Issues & Solutions

### Issue 1: Phone Not Appearing in Android Studio

**Solution A: Check ADB**
```bash
# Open Terminal on Mac
cd ~/Library/Android/sdk/platform-tools
./adb devices
```

**What you should see:**
```
List of devices attached
XXXXXXXX    device
```

**If you see "unauthorized":**
- Unplug phone
- Revoke USB debugging authorizations on phone:
  - Settings → Developer options → Revoke USB debugging authorizations
- Plug phone back in
- Accept the prompt on phone

**If you see "offline":**
- Unplug and replug phone
- Restart ADB:
  ```bash
  ./adb kill-server
  ./adb start-server
  ./adb devices
  ```

**If nothing appears:**
- Try different USB cable
- Try different USB port on Mac
- Restart phone
- Restart Mac

---

### Issue 2: M1 Mac Specific - Android File Transfer Interference

**Problem:** Android File Transfer app can interfere with ADB on M1 Macs.

**Solution:**
1. **Quit Android File Transfer** if it's running
   - Check Activity Monitor if needed
2. **Restart ADB:**
   ```bash
   cd ~/Library/Android/sdk/platform-tools
   ./adb kill-server
   ./adb start-server
   ```
3. **Try connecting again**

---

### Issue 3: USB Drivers Not Working

**For most phones:** No drivers needed (works out of the box)

**For some manufacturers (Samsung, OnePlus, etc.):**
1. Install manufacturer USB drivers
2. Or use **Wireless debugging** (Android 11+)

---

### Issue 4: Phone Shows "Charging Only" or "File Transfer Not Available"

**Solution:**
1. **Pull down notification shade** on phone
2. **Tap USB notification**
3. **Select "File Transfer"** or **"MTP"** mode
4. Phone should now appear in Android Studio

---

### Issue 5: ADB Not Found

**Solution:**
1. **Install Android SDK Platform Tools:**
   - Android Studio → SDK Manager
   - SDK Tools tab
   - Check "Android SDK Platform-Tools"
   - Apply

2. **Add to PATH** (optional):
   ```bash
   # Add to ~/.zshrc or ~/.bash_profile
   export PATH=$PATH:~/Library/Android/sdk/platform-tools
   ```

---

## 🔄 Alternative: Wireless Debugging (Android 11+)

If USB connection keeps failing, use wireless debugging:

### Step 1: Enable Wireless Debugging

1. **Settings** → **Developer options**
2. Enable **Wireless debugging**
3. Tap **Wireless debugging** to open settings
4. Tap **Pair device with pairing code**

### Step 2: Connect from Mac

1. Note the **IP address and port** (e.g., 192.168.1.100:12345)
2. Note the **pairing code**

3. In Terminal:
   ```bash
   cd ~/Library/Android/sdk/platform-tools
   ./adb pair 192.168.1.100:12345
   # Enter pairing code when prompted
   ```

4. After pairing, note the **port** shown (e.g., 12345)

5. Connect:
   ```bash
   ./adb connect 192.168.1.100:12345
   ```

6. Check:
   ```bash
   ./adb devices
   ```

**Note:** Phone and Mac must be on same Wi-Fi network.

---

## ✅ Verification Steps

1. **Check ADB:**
   ```bash
   cd ~/Library/Android/sdk/platform-tools
   ./adb devices
   ```
   Should show your device with "device" status

2. **Check Android Studio:**
   - Device should appear in Device Manager
   - Device should appear in run configuration dropdown

3. **Test Run:**
   - Select your phone from device dropdown
   - Click Run
   - App should install and launch on phone

---

## 🆘 Still Not Working?

### Try These:

1. **Restart everything:**
   - Restart phone
   - Restart Mac
   - Restart Android Studio

2. **Check USB port:**
   - Try different USB port on Mac
   - Some ports may not work (especially hubs)

3. **Check cable:**
   - Try different USB cable
   - Make sure it's a data cable, not just charging

4. **Check phone settings:**
   - Make sure USB debugging is still enabled
   - Revoke and re-authorize USB debugging

5. **Check Android Studio:**
   - File → Invalidate Caches → Invalidate and Restart
   - Update Android Studio to latest version

6. **Check macOS:**
   - Make sure macOS is updated
   - Some older macOS versions have USB issues

---

## 📱 Phone-Specific Tips

### Samsung
- May need Samsung USB drivers
- Or use Wireless debugging

### OnePlus
- May need OnePlus USB drivers
- Or use Wireless debugging

### Google Pixel
- Usually works out of the box
- No drivers needed

### Xiaomi/Redmi
- May need to enable "USB debugging (Security settings)"
- In Developer options

---

## 🔗 Useful Commands

```bash
# Check connected devices
adb devices

# Restart ADB server
adb kill-server
adb start-server

# Check ADB version
adb version

# Install APK directly
adb install path/to/app.apk

# View device logs
adb logcat
```

---

## 💡 Pro Tips

1. **Keep phone unlocked** while connecting
2. **Don't use USB hubs** - connect directly to Mac
3. **Use original cable** if possible
4. **Wireless debugging** is more reliable on M1 Macs
5. **Revoke and re-authorize** if connection is flaky

---

**If nothing works, use wireless debugging - it's often more reliable on M1 Macs!**

