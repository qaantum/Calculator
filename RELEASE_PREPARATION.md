# Release Preparation Guide

This guide helps you prepare the apps for release to the app stores.

---

## 📋 Pre-Release Checklist

### Before Building Release Versions

- [ ] **App Icons**: Create proper app icons for both platforms
- [ ] **Privacy Policy**: Create and host a privacy policy (required by both stores)
- [ ] **Testing**: Test all features on real devices
- [ ] **Version Numbers**: Set correct version numbers
- [ ] **Signing**: Configure app signing (Android keystore, iOS certificates)
- [ ] **Build Config**: Enable ProGuard/R8 for Android (smaller APK)
- [ ] **Screenshots**: Prepare screenshots for store listings
- [ ] **Descriptions**: Write app descriptions for stores

---

## 🎨 App Icons

### Android Icons

**Required Sizes:**
- `mipmap-mdpi`: 48x48 px
- `mipmap-hdpi`: 72x72 px
- `mipmap-xhdpi`: 96x96 px
- `mipmap-xxhdpi`: 144x144 px
- `mipmap-xxxhdpi`: 192x192 px
- **Play Store**: 512x512 px (high-res icon)

**Where to place:**
- Icons go in `android/app/src/main/res/mipmap-*/`
- Play Store icon: Upload separately in Play Console

**Tools to create icons:**
- Android Asset Studio: https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html
- Or use design tools (Figma, Photoshop, etc.)

### iOS Icons

**Required Sizes:**
- App Icon: 1024x1024 px (single size, iOS generates all sizes)
- **App Store**: 1024x1024 px

**Where to place:**
- In Xcode: Assets.xcassets → AppIcon
- Or add to project manually

**Tools:**
- Xcode Asset Catalog
- Or design tools

---

## 📄 Privacy Policy

**Required by both Google Play and Apple App Store.**

### What to Include

1. **Data Collection**: What data you collect (if any)
   - For Cryptatext: All data is stored locally, no data collection
2. **Data Storage**: Where data is stored
   - For Cryptatext: All data stored locally on device
3. **Data Sharing**: Who you share data with
   - For Cryptatext: No data sharing (everything is local)
4. **Encryption**: How you protect data
   - For Cryptatext: Client-side encryption using AES
5. **User Rights**: User's rights regarding their data
6. **Contact Information**: How to contact you

### Template

Create a file: `PRIVACY_POLICY.md` (see below for template)

### Hosting Options

1. **GitHub Pages** (free)
   - Create a `gh-pages` branch
   - Push the privacy policy HTML
   - URL: `https://yourusername.github.io/cryptatext/privacy-policy.html`

2. **Your Website**
   - Host on your own domain

3. **Google Sites** (free)
   - Create a simple site with the policy

---

## 🔐 Android Release Signing

### Step 1: Create Keystore

```bash
cd android/app
keytool -genkey -v -keystore cryptatext-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias cryptatext
```

**Important:**
- Store the keystore file securely (backup in multiple places!)
- Remember the passwords (store them securely)
- Never commit the keystore to Git

### Step 2: Add to .gitignore

Add to `android/.gitignore`:
```
*.jks
*.keystore
cryptatext-release.jks
```

### Step 3: Configure Signing

Create `android/keystore.properties` (add to .gitignore):
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=cryptatext
storeFile=cryptatext-release.jks
```

Update `android/app/build.gradle.kts`:
```kotlin
// Load keystore properties
val keystorePropertiesFile = rootProject.file("keystore.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
```

---

## 🍎 iOS Release Configuration

### Step 1: Set Up Signing in Xcode

1. Open project in Xcode
2. Select project → Signing & Capabilities
3. Select your Team (Apple Developer account)
4. Xcode will manage certificates automatically

### Step 2: Configure Build Settings

1. Select project → Build Settings
2. Set **Deployment Target**: iOS 13.0+ (for CryptoKit)
3. Set **Version**: 1.0
4. Set **Build**: 1

### Step 3: Create Archive

1. Product → Scheme → Edit Scheme
2. Set Build Configuration to **Release**
3. Product → Archive
4. Wait for archive to complete

---

## 🏗️ Building Release Versions

### Android

**Build AAB (recommended for Play Store):**
```bash
cd android
./gradlew bundleRelease
```
Output: `android/app/build/outputs/bundle/release/app-release.aab`

**Build APK (for direct distribution):**
```bash
cd android
./gradlew assembleRelease
```
Output: `android/app/build/outputs/apk/release/app-release.apk`

### iOS

1. Open project in Xcode
2. Product → Scheme → Edit Scheme → Release
3. Product → Archive
4. Window → Organizer → Distribute App

---

## 📸 Screenshots for Store Listings

### Android (Google Play)

**Required:**
- Phone: At least 2 screenshots (up to 8)
- Tablet: Optional (up to 8)
- Feature graphic: 1024x500 px

**Screenshot Sizes:**
- Phone: 1080x1920 px (portrait) or 1920x1080 px (landscape)
- Tablet: 1200x1920 px (portrait) or 1920x1200 px (landscape)

### iOS (App Store)

**Required for each device size:**
- iPhone 6.7" (iPhone 14 Pro Max): 1290x2796 px
- iPhone 6.5" (iPhone 11 Pro Max): 1242x2688 px
- iPhone 5.5" (iPhone 8 Plus): 1242x2208 px
- iPad Pro 12.9": 2048x2732 px

**Minimum:** At least one set of screenshots

**Tools:**
- Use iOS Simulator to take screenshots
- Or use real device screenshots

---

## 📝 Store Listing Content

### App Name
- **Android**: "Cryptatext" (max 50 chars)
- **iOS**: "Cryptatext" (max 30 chars)

### Short Description
- **Android**: 80 characters max
- Example: "Secure text encryption and password generator. All data stored locally."

### Full Description
- **Android**: 4000 characters max
- **iOS**: 4000 characters max
- Include:
  - What the app does
  - Key features
  - How it works
  - Privacy/security notes

### Keywords (iOS only)
- 100 characters max
- Example: "encryption,decrypt,password,generator,secure,privacy"

### Category
- **Android**: Tools / Utilities
- **iOS**: Utilities

---

## ✅ Final Pre-Release Checklist

### Code
- [ ] All features tested
- [ ] No debug code left
- [ ] Error handling in place
- [ ] Performance optimized

### Assets
- [ ] App icons created (all sizes)
- [ ] Screenshots prepared
- [ ] Privacy policy written and hosted

### Configuration
- [ ] Version numbers set correctly
- [ ] Signing configured (Android keystore, iOS certificates)
- [ ] Release builds tested

### Store Listing
- [ ] App name finalized
- [ ] Descriptions written
- [ ] Screenshots ready
- [ ] Privacy policy URL ready

---

## 🚀 Next Steps

Once all items above are complete:

1. **Build release versions** (see above)
2. **Test release builds** on real devices
3. **Prepare store listings** (see APP_STORE_GUIDE.md)
4. **Submit to stores** (see APP_STORE_GUIDE.md)

---

## 📚 Related Guides

- [APP_STORE_GUIDE.md](APP_STORE_GUIDE.md) - Step-by-step app store submission
- [GETTING_STARTED.md](GETTING_STARTED.md) - Development setup
- [README.md](README.md) - Project overview

