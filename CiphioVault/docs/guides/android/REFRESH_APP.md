# How to Refresh/Rebuild the App in Android Studio

## 🔄 Quick Steps to Refresh

### Method 1: Clean and Rebuild (Recommended)

1. **Stop the app** if it's running:
   - Click the **Stop** button (red square) in the toolbar
   - Or press `Shift + F10` (Windows/Linux) or `Control + F2` (Mac)

2. **Clean the project:**
   - **Build** → **Clean Project**
   - Wait for it to finish (check bottom status bar)

3. **Rebuild the project:**
   - **Build** → **Rebuild Project**
   - Wait for build to complete

4. **Run the app again:**
   - Click the **Run** button (green play icon)
   - Or press `Shift + F10` (Windows/Linux) or `Control + R` (Mac)

### Method 2: Uninstall and Reinstall

1. **Uninstall the app from device/emulator:**
   - On your device/emulator: Long-press the app icon → **Uninstall**
   - Or in Android Studio: **Run** → **Edit Configurations** → Check "Uninstall APK before installing"

2. **Run the app again:**
   - Click **Run** button
   - This will install a fresh version

### Method 3: Invalidate Caches (If above doesn't work)

1. **File** → **Invalidate Caches...**
2. Check **"Invalidate and Restart"**
3. Wait for Android Studio to restart
4. **Rebuild** → **Rebuild Project**
5. **Run** the app

---

## 🐛 Troubleshooting

### If changes still don't appear:

1. **Check if you're running the right variant:**
   - Make sure you're running **Debug** variant (not Release)
   - Check the build variant selector in Android Studio

2. **Check for build errors:**
   - Look at the **Build** tab at the bottom
   - Fix any errors shown

3. **Sync Gradle:**
   - **File** → **Sync Project with Gradle Files**
   - Wait for sync to complete

4. **Check the device/emulator:**
   - Make sure you're running on the correct device
   - Try a different device/emulator

5. **Restart Android Studio:**
   - Close Android Studio completely
   - Reopen the project
   - Rebuild and run

---

## ✅ Verify Changes Are Applied

After rebuilding, test:
1. **Default state:** Encrypt button should be green, Decrypt should be gray
2. **Press Encrypt:** Encrypt stays green, Decrypt stays gray
3. **Press Decrypt:** Decrypt turns green, Encrypt turns gray

---

## 🚀 Quick Command (Terminal)

If you prefer terminal:

```bash
cd /Users/qaantum/Desktop/Project/android
./gradlew clean
./gradlew assembleDebug
```

Then install the APK manually or run from Android Studio.

---

**Most common issue:** The app needs to be **uninstalled and reinstalled** to see changes, especially if it was already installed before the changes.

