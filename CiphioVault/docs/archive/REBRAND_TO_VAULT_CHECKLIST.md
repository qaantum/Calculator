# Rebrand to Ciphio Vault - Implementation Checklist

**Date:** November 2025  
**Status:** ✅ **IN PROGRESS**

---

## ✅ Completed Changes

### Android
- [x] Updated `app_name` in `strings.xml` → "Ciphio Vault"
- [x] Updated `AndroidManifest.xml` to use `@string/app_name`
- [x] Updated `applicationId` in `build.gradle.kts` → `com.ciphio.vault`

### iOS
- [x] Added `INFOPLIST_KEY_CFBundleDisplayName = "Ciphio Vault"` in project settings
- [x] Updated `PRODUCT_BUNDLE_IDENTIFIER` → `com.ciphio.vault` (both Debug and Release)
- [ ] Verify `CFBundleName` also set to "Ciphio Vault" (system fallback)

### URL Schemes (Deep Links)
- [x] Updated Android URL scheme: `ciphio://` → `ciphiovault://`
- [x] Updated iOS URL scheme: `ciphio://` → `ciphiovault://`
- [x] Updated code references to new scheme

---

## 📋 Remaining Tasks

### Code Updates

#### 1. Update Internal References
- [ ] Search codebase for hardcoded "Ciphio" strings that should be "Ciphio Vault"
- [ ] Update app descriptions in code
- [ ] Update any user-facing text that says just "Ciphio"

**Files to check:**
- `ios/Ciphio/Ciphio/ContentView.swift`
- `android/app/src/main/java/com/ciphio/ui/InfoContent.kt`
- Any welcome screens or about pages

#### 2. Update App Icons
- [ ] Design new app icon with "Vault" branding
- [ ] Update iOS app icon (1024x1024 in Assets.xcassets)
- [ ] Update Android app icons (all mipmap sizes)
- [ ] Consider vault/lock imagery

#### 3. Update Documentation
- [ ] Update README.md
- [ ] Update all markdown files mentioning "Ciphio" app
- [ ] Update release preparation docs
- [ ] Update testing guides

### App Store Preparation

#### 4. App Store Listing (iOS)
- [ ] App Name: **"Ciphio Vault – Password Manager"** (ASO optimized, 30 char limit ✅)
- [ ] Subtitle: **"Secure Vault & Encryption Tools"**
- [ ] Description: Update to emphasize vault/security
- [ ] Keywords: vault, password manager, encryption, secure, privacy
- [ ] Screenshots: Update if they show old branding
- [ ] App Icon: 1024x1024 with new branding

#### 5. Play Store Listing (Android)
- [ ] App Name: **"Ciphio Vault - Password Manager"** (ASO optimized)
- [ ] Short Description: "Secure password vault with encryption tools"
- [ ] Full Description: Update branding and messaging
- [ ] Feature Graphic: Update if needed
- [ ] Screenshots: Update if they show old branding
- [ ] App Icon: 512x512 with new branding

### Website

#### 6. Domain Setup
- [ ] Register/configure `ciphio.com` (if not done)
- [ ] Set up basic homepage
- [ ] Create `/vault` marketing page
- [ ] Create `/privacy` page (REQUIRED)
- [ ] Create `/terms` page (REQUIRED)
- [ ] Add App Store/Play Store download buttons
- [ ] **CRITICAL:** Ensure NO direct payment processing on website (tax compliance - GVK 20/B)
- [ ] All payments must route through App Store/Play Store only

### Testing

#### 7. Pre-Launch Testing
- [ ] Test app with new name on iOS device/simulator
- [ ] Test app with new name on Android device/emulator
- [ ] Verify app icon displays correctly
- [ ] Verify app name displays correctly in system
- [ ] Test all features still work
- [ ] Verify bundle ID changes don't break anything

### Legal/Compliance

#### 8. Privacy & Terms
- [ ] Update Privacy Policy with new app name
- [ ] Update Terms of Service with new app name
- [ ] Ensure compliance with App Store requirements
- [ ] Ensure compliance with Play Store requirements
- [ ] **Turkish Tax Compliance (GVK 20/B):** Verify all revenue comes through App Store/Play Store only
- [ ] No direct Stripe/PayPal payments on website (for now)

### Future App Preparation

#### 9. Reserve Future Bundle IDs
- [ ] Reserve `com.ciphio.spend` (for Ciphio Spend)
- [ ] Reserve `com.ciphio.calc` (for Ciphio Calc)
- [ ] Plan URL schemes: `ciphiospend://`, `ciphiocalc://`

---

## 🎯 Bundle ID Decision

**Current Status:**
- ✅ Updated to `com.ciphio.vault` (both platforms)

**Important Notes:**
- Changing bundle ID = **new app** in stores
- Since you're pre-launch, this is fine
- Old bundle IDs (`com.ciphio` / `com.ciphio.Ciphio`) won't be used

**Future Apps:**
- Ciphio Spend: `com.ciphio.spend`
- Ciphio Calc: `com.ciphio.calc`

---

## 📝 App Store Submission Notes

### iOS App Store
- **Bundle ID:** `com.ciphio.vault` (new)
- **Display Name:** Ciphio Vault
- **Category:** Utilities / Productivity
- **Age Rating:** 4+ (no objectionable content)

### Google Play Store
- **Package Name:** `com.ciphio.vault` (new)
- **App Name:** Ciphio Vault
- **Category:** Productivity
- **Content Rating:** Everyone

---

## 🚀 Next Steps

1. **Test the changes:**
   ```bash
   # Android
   cd android && ./gradlew assembleDebug
   
   # iOS
   # Open in Xcode and build
   ```

2. **Update any hardcoded strings in code**

3. **Design new app icons**

4. **Prepare App Store listings**

5. **Set up website**

6. **Submit to stores!**

---

## ⚠️ Important Reminders

- **Bundle ID change = new app** - you'll need to create new listings
- **Test thoroughly** - bundle ID changes can affect some features
- **Update all user-facing text** - consistency is key
- **Website must be ready** - stores require privacy policy URL

---

**Last Updated:** November 2025  
**Status:** Implementation in progress

