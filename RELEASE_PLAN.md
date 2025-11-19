# Release Plan for Cryptatext

This document outlines the steps required to prepare and release Cryptatext for Android and iOS.

## 1. Pre-Release Checklist

### General
- [ ] Verify all critical features are working (Encryption, Decryption, Password Generation, History).
- [ ] Verify "Offline-First" functionality (no network dependencies).
- [ ] Verify "Freemium" logic (History limit for free users, Premium upgrade mock).
- [ ] Update version numbers in `build.gradle.kts` (Android) and Xcode project (iOS).

### Android
- [ ] **Signing**: Generate a release keystore and configure `signingConfigs` in `android/app/build.gradle.kts`.
    ```bash
    keytool -genkey -v -keystore release.keystore -alias release -keyalg RSA -keysize 2048 -validity 10000
    ```
- [ ] **ProGuard**: Verify `proguard-rules.pro` if `isMinifyEnabled` is set to `true` (currently `false`).
- [ ] **Play Store**: Create a Google Play Developer account and set up the app listing.

### iOS
- [ ] **App Store ID**: Replace placeholder `YOUR_APP_STORE_ID` in `CryptatextApp.swift` (if used for "Rate Us") or `Info.plist`.
- [ ] **Signing**: Configure "Signing & Capabilities" in Xcode with a valid Apple Developer Team.
- [ ] **Icons**: Ensure all App Icon sizes are populated in `Assets.xcassets`.

## 2. Build Instructions

### Android (APK/AAB)
Run the following command to build the release bundle:
```bash
cd android
./gradlew bundleRelease
```
Output: `android/app/build/outputs/bundle/release/app-release.aab`

### iOS (IPA)
1. Open `ios/Cryptatext/Cryptatext.xcodeproj` in Xcode.
2. Select "Any iOS Device (arm64)".
3. Go to **Product > Archive**.
4. Once archived, use the **Distribute App** flow to upload to App Store Connect or export an IPA.

## 3. Monetization Setup (Implemented)
The app now uses **Real In-App Purchases**:
1. **Android**: Google Play Billing Library is integrated (`RealPremiumManager.kt`).
   - **Action**: Ensure Product ID `com.cryptatext.premium` is created in Google Play Console.
   - **Action**: Add license testers in Play Console to test without being charged.
2. **iOS**: StoreKit 2 is integrated (`PremiumManager.swift`).
   - **Action**: Ensure Product ID `com.cryptatext.premium` is created in App Store Connect.
   - **Action**: Use a StoreKit Configuration File for local testing or TestFlight for beta testing.

## 4. Post-Release
- Monitor crash reports (Crashlytics/Xcode Organizer).
- Gather user feedback for feature improvements.
