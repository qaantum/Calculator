# App Icon Update Guide

This guide explains how to update the app icon for both Android and iOS platforms.

---

## 📱 Current Icon Setup

### Android
- **Location:** Uses adaptive icons (Android 8.0+)
- **Files:**
  - `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml` - Adaptive icon config
  - `android/app/src/main/res/drawable/ic_launcher_background.xml` - Background layer
  - `android/app/src/main/res/drawable/ic_launcher_foreground.xml` - Foreground layer
- **Current:** Default Android icon (green background, white circle)

### iOS
- **Location:** `ios/Ciphio/Ciphio/Assets.xcassets/AppIcon.appiconset/`
- **Current:** No icon files present (just configuration)

---

## 🎨 Option 1: Using Your Own Icon Image

If you have an icon image ready (PNG format):

### Android

1. **Create icon sizes** (or use a tool):
   - **mdpi**: 48x48 px
   - **hdpi**: 72x72 px
   - **xhdpi**: 96x96 px
   - **xxhdpi**: 144x144 px
   - **xxxhdpi**: 192x192 px
   - **Play Store**: 512x512 px (high-res)

2. **For Adaptive Icons (Recommended for Android 8.0+)**:
   - **Foreground**: 432x432 px (safe area: 288x288 px)
   - **Background**: 432x432 px (full area)
   - Both should be PNG with transparency

3. **Place files:**
   ```
   android/app/src/main/res/
   ├── mipmap-mdpi/ic_launcher.png (48x48)
   ├── mipmap-hdpi/ic_launcher.png (72x72)
   ├── mipmap-xhdpi/ic_launcher.png (96x96)
   ├── mipmap-xxhdpi/ic_launcher.png (144x144)
   ├── mipmap-xxxhdpi/ic_launcher.png (192x192)
   └── mipmap-anydpi-v26/
       └── ic_launcher.xml (adaptive icon config)
   ```

4. **Update adaptive icon XML** (if using adaptive icons):
   - Edit `ic_launcher.xml` to reference your new foreground/background drawables
   - Or replace the XML drawables in `drawable/` folder

### iOS

1. **Create icon:**
   - **Size**: 1024x1024 px (single size, iOS generates all sizes automatically)
   - **Format**: PNG (no transparency for App Store)
   - **Name**: `AppIcon.png` or `AppIcon-1024.png`

2. **Place file:**
   ```
   ios/Ciphio/Ciphio/Assets.xcassets/AppIcon.appiconset/
   └── AppIcon.png (1024x1024)
   ```

3. **Update Contents.json** (if needed):
   - The file should reference `AppIcon.png` for the 1024x1024 size
   - Xcode will handle this automatically if you add via Xcode

---

## 🛠️ Option 2: Using Icon Generation Tools

### Recommended Tools:

1. **Android Asset Studio** (Online)
   - URL: https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html
   - Upload your 1024x1024 icon
   - Generates all Android sizes automatically
   - Download and extract to `android/app/src/main/res/`

2. **AppIcon.co** (Online)
   - URL: https://www.appicon.co/
   - Upload one icon, generates all sizes for both platforms
   - Free and easy to use

3. **IconKitchen** (Google)
   - URL: https://icon.kitchen/
   - Specifically for adaptive icons
   - Generates foreground/background layers

---

## 📝 Step-by-Step: Manual Update

### Android - Using Vector Drawables (Current Method)

If you want to keep using XML vector drawables (scalable, no pixelation):

1. **Update background** (`ic_launcher_background.xml`):
   ```xml
   <vector xmlns:android="http://schemas.android.com/apk/res/android"
       android:width="108dp"
       android:height="108dp"
       android:viewportWidth="108"
       android:viewportHeight="108">
       <path
           android:fillColor="#YOUR_COLOR"
           android:pathData="M0,0h108v108h-108z" />
   </vector>
   ```

2. **Update foreground** (`ic_launcher_foreground.xml`):
   - Replace the path data with your icon design
   - Keep safe area in mind (72dp safe zone)

### Android - Using PNG Images

1. Create PNG images for each density
2. Place in respective `mipmap-*` folders
3. Update `ic_launcher.xml` if needed:
   ```xml
   <adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
       <background android:drawable="@drawable/ic_launcher_background" />
       <foreground android:drawable="@drawable/ic_launcher_foreground" />
   </adaptive-icon>
   ```

### iOS - Using Xcode (Easiest)

1. Open `ios/Ciphio/Ciphio.xcodeproj` in Xcode
2. Navigate to `Assets.xcassets` → `AppIcon`
3. Drag and drop your 1024x1024 PNG into the AppIcon set
4. Xcode will automatically configure everything

### iOS - Manual

1. Place `AppIcon.png` (1024x1024) in:
   ```
   ios/Ciphio/Ciphio/Assets.xcassets/AppIcon.appiconset/
   ```

2. Update `Contents.json`:
   ```json
   {
     "images" : [
       {
         "filename" : "AppIcon.png",
         "idiom" : "universal",
         "platform" : "ios",
         "size" : "1024x1024"
       },
       ...
     ]
   }
   ```

---

## 🎨 Design Guidelines

### Android Adaptive Icons
- **Safe Zone**: Keep important content within 72dp (66% of 108dp)
- **Background**: Can extend to edges
- **Foreground**: Should stay in safe zone
- **Shape**: System will apply mask (circle, square, rounded square)

### iOS Icons
- **No Transparency**: App Store requires opaque icons
- **No Rounded Corners**: iOS applies automatically
- **1024x1024**: Single size, system generates all others
- **Simple Design**: Icons are displayed small, keep it simple

### General Tips
- ✅ Use high contrast colors
- ✅ Keep design simple and recognizable
- ✅ Test on both light and dark backgrounds
- ✅ Avoid text (hard to read at small sizes)
- ✅ Use brand colors consistently

---

## 🔍 Testing Your Icon

### Android
1. Build and install the app
2. Check home screen icon
3. Check app drawer icon
4. Check recent apps switcher
5. Test on different Android versions (adaptive vs legacy)

### iOS
1. Build and run on device/simulator
2. Check home screen icon
3. Check App Switcher
4. Test on different iOS versions

---

## 📦 Quick Start (If You Have Icon Ready)

**If you have a 1024x1024 PNG icon ready:**

1. **Android:**
   - Use Android Asset Studio to generate all sizes
   - Extract to `android/app/src/main/res/`
   - Or manually place in `mipmap-*` folders

2. **iOS:**
   - Place `AppIcon.png` in `ios/Ciphio/Ciphio/Assets.xcassets/AppIcon.appiconset/`
   - Or add via Xcode

3. **Rebuild both apps**

---

## ❓ Need Help?

If you need assistance:
1. Share your icon file and I can help set it up
2. Tell me what design you want and I can create vector drawables
3. Specify colors/branding and I can update the current icons

---

## 📚 Additional Resources

- [Android Adaptive Icons Guide](https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive)
- [iOS App Icon Guidelines](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html)
- [AppIcon.co](https://www.appicon.co/)

