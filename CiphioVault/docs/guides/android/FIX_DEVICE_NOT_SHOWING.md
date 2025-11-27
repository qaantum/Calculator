# Fix: Phone Not Showing in Android Studio Device List

## ✅ Your Phone IS Connected!

ADB shows your device is connected via wireless debugging:
```
adb-23f8eb5f-dSW8ta._adb-tls-connect._tcp    device
```

## Quick Fixes

### Method 1: Refresh Device List in Android Studio

1. **Open Device Manager:**
   - **View** → **Tool Windows** → **Device Manager**
   - Or click the device dropdown → **Device Manager**

2. **Click the refresh button** (circular arrow icon 🔄)

3. **Check the device dropdown** (top toolbar, next to Run button)
   - Your phone should appear there now

### Method 2: Invalidate Caches

1. **File** → **Invalidate Caches...**
2. Check **"Invalidate and Restart"**
3. After restart, check device dropdown again

### Method 3: Restart ADB Connection

**In Terminal:**
```bash
cd ~/Library/Android/sdk/platform-tools
./adb kill-server
./adb start-server
./adb devices
```

Then refresh in Android Studio.

### Method 4: Use Device Manager

1. **View** → **Tool Windows** → **Device Manager**
2. Your device should be listed there
3. If it shows but is grayed out, click it to select
4. Then it should appear in the run configuration dropdown

### Method 5: Manual Device Selection

1. **Run** → **Edit Configurations...**
2. Under **"Target device"**, select **"USB Device"** or **"Open Select Device Dialog"**
3. Your device should appear in the list
4. Select it and click **OK**

## Verify Connection

**In Terminal:**
```bash
cd ~/Library/Android/sdk/platform-tools
./adb devices
```

Should show:
```
List of devices attached
adb-23f8eb5f-dSW8ta._adb-tls-connect._tcp    device
```

If it shows "device" (not "unauthorized" or "offline"), your phone is ready!

## Still Not Showing?

### Try This:

1. **Close Android Studio completely**
2. **Restart ADB:**
   ```bash
   cd ~/Library/Android/sdk/platform-tools
   ./adb kill-server
   ./adb start-server
   ```
3. **Reopen Android Studio**
4. **Sync Gradle:** File → Sync Project with Gradle Files
5. **Check device dropdown again**

### Alternative: Run via Terminal

If Android Studio still doesn't show it, you can install directly:

```bash
cd /Users/qaantum/Desktop/Project/android
./gradlew installDebug
```

This will install the app on your connected phone!

## Pro Tip

If wireless debugging is working but Android Studio doesn't recognize it:
- The device IS connected (ADB confirms it)
- Android Studio just needs to refresh its device list
- Try Method 1 (refresh) or Method 2 (invalidate caches) first

