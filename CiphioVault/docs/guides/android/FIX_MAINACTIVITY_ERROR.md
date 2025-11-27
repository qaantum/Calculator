# Fix: Activity class does not exist error

## Error
```
Activity class {com.ciphio/com.ciphio.vault.MainActivity} does not exist
```

## Solution Steps

### 1. Clean Build (Already Done)
```bash
cd android
./gradlew clean
```

### 2. Invalidate Android Studio Caches

**In Android Studio:**
1. **File** → **Invalidate Caches...**
2. Check **"Invalidate and Restart"**
3. Wait for Android Studio to restart

### 3. Sync Gradle

**In Android Studio:**
1. **File** → **Sync Project with Gradle Files**
2. Wait for sync to complete (check bottom status bar)

### 4. Delete Run Configuration

**In Android Studio:**
1. **Run** → **Edit Configurations...**
2. Delete any existing "app" run configuration
3. Click **OK**

### 5. Recreate Run Configuration

**In Android Studio:**
1. Right-click on `MainActivity.kt` in the project tree
2. Select **Run 'MainActivity'**
3. This will create a new run configuration with the correct package

### 6. Alternative: Uninstall Old App

If the app was previously installed with the old package name:

**On Device/Emulator:**
1. Uninstall any existing "Ciphio" or "Cryptatext" app
2. Then run the app again from Android Studio

**Or via ADB:**
```bash
adb uninstall com.ciphio.vault
adb uninstall com.cryptatext  # Old package name
```

### 7. Rebuild and Run

**In Android Studio:**
1. **Build** → **Rebuild Project**
2. Wait for build to complete
3. Click **Run** button (green play icon)

## Verification

After following these steps, the app should:
- ✅ Build successfully
- ✅ Install on device/emulator
- ✅ Launch with MainActivity

## If Still Not Working

1. **Check the manifest is correct:**
   - Open `android/app/src/main/AndroidManifest.xml`
   - Verify: `android:name="com.ciphio.vault.MainActivity"`

2. **Check the package declaration:**
   - Open `android/app/src/main/java/com/ciphio/vault/MainActivity.kt`
   - Verify: `package com.ciphio.vault`

3. **Check build.gradle.kts:**
   - Verify: `namespace = "com.ciphio.vault"`
   - Verify: `applicationId = "com.ciphio.vault"`

4. **Restart Android Studio completely:**
   - Quit Android Studio
   - Reopen the project
   - Sync Gradle
   - Rebuild

