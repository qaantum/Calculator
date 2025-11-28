# Play Store Release Guide

## What's Already Configured ✅
- Version: `1.0.0-beta.1`
- Beta flag enabled
- ProGuard minification enabled
- Signing config ready (uses environment variables)

## What YOU Need To Do

### 1. Generate Signing Key (one-time)
```bash
keytool -genkey -v -keystore ~/ciphio-release.keystore -alias ciphio -keyalg RSA -keysize 2048 -validity 10000
```
**⚠️ SAVE THIS KEYSTORE FILE AND PASSWORD FOREVER** - you can't update the app without it!

### 2. Set Environment Variables (before building)
```bash
export CIPHIO_KEYSTORE_PATH=~/ciphio-release.keystore
export CIPHIO_KEYSTORE_PASSWORD=your_password
export CIPHIO_KEY_ALIAS=ciphio
export CIPHIO_KEY_PASSWORD=your_key_password
```

Or add to `android/local.properties`:
```
CIPHIO_KEYSTORE_PATH=/path/to/ciphio-release.keystore
CIPHIO_KEYSTORE_PASSWORD=your_password
CIPHIO_KEY_ALIAS=ciphio
CIPHIO_KEY_PASSWORD=your_key_password
```

### 3. Build Release Bundle
```bash
cd android
./gradlew bundleRelease
```
Output: `android/app/build/outputs/bundle/release/app-release.aab`

### 4. Play Console Setup
1. Go to https://play.google.com/console
2. Create new app → "Ciphio Vault"
3. Upload AAB to **Internal Testing** track (fastest approval)
4. Fill required info:
   - Short description (80 chars): "Secure password manager with autofill & encryption"
   - Privacy policy URL (required)
   - Screenshots (2+ phone)
   - App icon 512x512

### 5. Content Rating
Answer the questionnaire - select "Utility" category, no violence/adult content.

### 6. Data Safety
Declare:
- Data encrypted in transit: Yes
- Data encrypted at rest: Yes  
- Data deletion: Yes (user can delete vault)
- No data shared with third parties

