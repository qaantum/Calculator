# Quick Build Instructions - Android Studio

## 🚀 Build APK in Android Studio (Recommended)

### Step 1: Open Project
1. Open **Android Studio**
2. **File** → **Open**
3. Select the `android` folder: `/Users/qaantum/Desktop/Project/android`
4. Click **OK**

### Step 2: Wait for Sync
- Android Studio will sync Gradle files
- Wait for "Gradle sync finished" at the bottom
- If errors appear, they'll show in the "Build" tab

### Step 3: Build APK
1. **Build** → **Build Bundle(s) / APK(s)** → **Build APK(s)**
2. Wait for build to complete (1-2 minutes)
3. You'll see a notification: **"APK(s) generated successfully"**

### Step 4: Find Your APK
1. Click **"locate"** in the notification
2. Or navigate to: `android/app/build/outputs/apk/debug/app-debug.apk`
3. **File size:** ~15-25 MB

---

## 📤 Share the APK

### Option 1: Google Drive (Easiest)
1. Upload `app-debug.apk` to Google Drive
2. Right-click → **Get link** → **Anyone with the link**
3. Share the link with friends

### Option 2: Email
1. Attach `app-debug.apk` to an email
2. Send to friends

### Option 3: AirDrop (Mac)
1. Right-click `app-debug.apk`
2. **Share** → **AirDrop**
3. Select friend's device

---

## ⚠️ Tell Your Friends

Before installing, they need to:

1. **Enable "Install from Unknown Sources":**
   - **Settings** → **Security** → Enable **"Install unknown apps"**
   - Or: **Settings** → **Apps** → **Special access** → **Install unknown apps**
   - Select the app they'll use (Chrome, Files, etc.)

2. **Android Version:**
   - Requires **Android 7.0 or higher**
   - Most phones from 2016+ work

3. **Install:**
   - Download the APK
   - Open it
   - Tap **"Install"** (may need to tap "Install anyway" if warning appears)

---

## ✅ That's It!

Your friends can now test the app! 🎉

**APK Location:** `android/app/build/outputs/apk/debug/app-debug.apk`

---

## 🔧 If Build Fails

1. **Clean Project:**
   - **Build** → **Clean Project**
   - Wait for it to finish

2. **Rebuild:**
   - **Build** → **Rebuild Project**

3. **Check Errors:**
   - Look at the **Build** tab at the bottom
   - Fix any errors shown

4. **Sync Gradle:**
   - **File** → **Sync Project with Gradle Files**

---

**Ready to build!** Open Android Studio and follow the steps above. 🚀

