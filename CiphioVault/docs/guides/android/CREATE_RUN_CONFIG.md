# Create Run Configuration for Android App

## Quick Steps

### Method 1: Right-Click on MainActivity (Easiest)

1. **In Android Studio Project panel:**
   - Navigate to: `app` → `java` → `com.ciphio.vault` → `MainActivity.kt`
   - **Right-click** on `MainActivity.kt`
   - Select **"Run 'MainActivity'"**
   - This will automatically create a run configuration and run the app!

### Method 2: Create Run Configuration Manually

1. **Click "Add Configuration..."** (top toolbar, next to device dropdown)

2. **Click the "+" button** → Select **"Android App"**

3. **Configure:**
   - **Name:** `app` (or "Ciphio Vault")
   - **Module:** Select `android.app`
   - **Launch:** Select **"Default Activity"** or **"Specified Activity"**
     - If "Specified Activity": Enter `com.ciphio.vault.MainActivity`
   - **Target device:** Select **"USB Device"** or **"Open Select Device Dialog"**
     - Then select your OnePlus LE2127

4. **Click "OK"**

5. **Select your device:**
   - Click the device dropdown (currently shows "Select Device")
   - Select **"OnePlus LE2127"**

6. **Click Run** (green play button)!

### Method 3: Use the Run Button Directly

1. **Select your device:**
   - Click "Select Device" dropdown
   - Choose **"OnePlus LE2127"**

2. **Click the Run button** (green play icon)
   - Android Studio will prompt you to create a configuration
   - Click "OK" to create it automatically

## Verify Configuration

After creating, you should see:
- Device dropdown shows: **"OnePlus LE2127"**
- Run configuration shows: **"app"** (or your chosen name)
- Run button is enabled (green)

## If It Still Doesn't Work

1. **Check MainActivity:**
   - Make sure `MainActivity.kt` has `package com.ciphio.vault`
   - Make sure it extends `FragmentActivity` or `ComponentActivity`

2. **Sync Gradle:**
   - **File** → **Sync Project with Gradle Files**

3. **Rebuild:**
   - **Build** → **Rebuild Project**

4. **Try Method 1** (right-click on MainActivity) - it's the most reliable!

