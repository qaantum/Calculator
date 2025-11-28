# iOS App Store Release Guide

## Beta Testing - App Store vs Play Store

**No mandatory beta required!** Unlike Google Play (which requires closed testing before production), Apple App Store allows direct submission to App Store Review.

However, **TestFlight is highly recommended**:
- ✅ Free with Apple Developer account
- ✅ Test on real devices before review
- ✅ Catch bugs before public release
- ✅ Up to 10,000 external testers
- ⏱️ Faster than full App Store review

**Recommendation**: Use TestFlight for beta, then submit to App Store when ready.

---

## Pre-Release Checklist

### 1. Version Numbers (Update in Xcode)
- **Marketing Version**: `1.0.0` (or `1.0.0-beta.6` to match Android)
- **Build Number**: Increment for each upload (start at `1`)

### 2. Deployment Target
- **Current**: iOS 18.0 (❌ WRONG - iOS 18 doesn't exist)
- **Should be**: iOS 15.0 or 16.0 (check what you actually need)
- **Fix in Xcode**: Project → Target → General → Deployment Info → iOS

### 3. App Icon
- ✅ 1024x1024 PNG (required for App Store)
- ✅ No transparency
- ✅ Already set: "Ciphio Vault"

### 4. Bundle Identifier
- ✅ Already correct: `com.ciphio.vault`

### 5. In-App Purchase Product ID
- ✅ Updated: `com.ciphio.vault.premium`
- ⚠️ **Must create in App Store Connect** before submission

### 6. Privacy & Permissions
- ✅ No data collection declared
- ✅ Privacy policy URL: https://www.ciphio.com/privacy.html
- ✅ No special permissions needed (no camera, location, etc.)

### 7. Screenshots Required
- **iPhone 6.7"**: At least 1 (iPhone 14 Pro Max, 15 Pro Max)
- **iPhone 6.5"**: At least 1 (iPhone 11 Pro Max, XS Max)
- **iPad Pro 12.9"**: At least 1 (if supporting iPad)
- **iPad Pro 11"**: At least 1 (if supporting iPad)

### 8. App Store Listing
- **Name**: Ciphio Vault (30 chars max)
- **Subtitle**: Secure Password Manager (30 chars max)
- **Description**: Full description (4000 chars max)
- **Keywords**: password, manager, vault, security, encryption (100 chars max)
- **Category**: Productivity or Utilities
- **Age Rating**: 4+ (no objectionable content)

---

## Release Steps

### Option A: TestFlight Beta (Recommended)

1. **Archive in Xcode**:
   - Product → Archive
   - Wait for build to complete

2. **Upload to App Store Connect**:
   - Window → Organizer
   - Select archive → Distribute App
   - Choose "App Store Connect"
   - Follow prompts

3. **Set up TestFlight**:
   - Go to App Store Connect → TestFlight
   - Add internal testers (up to 100)
   - Add external testers (up to 10,000)
   - Testers get email invite

4. **After testing, submit for review**:
   - App Store Connect → App Store → Version
   - Click "Submit for Review"

### Option B: Direct to App Store

1. **Archive in Xcode** (same as above)
2. **Upload to App Store Connect** (same as above)
3. **Submit for Review** immediately

---

## Common Issues

### "Invalid Bundle"
- Check bundle identifier matches App Store Connect
- Ensure signing certificate is valid

### "Missing Compliance"
- Export compliance: Select "No" (no encryption export restrictions)
- Or provide compliance document if using encryption

### "Missing Screenshots"
- Must provide at least one screenshot per device size
- Can use same screenshot for all sizes if needed

---

## Version Numbering

- **Marketing Version**: User-facing (e.g., "1.0.0")
- **Build Number**: Internal, increments each upload (1, 2, 3...)

For beta: Use `1.0.0-beta.6` in Marketing Version
For release: Use `1.0.0` in Marketing Version

---

## Next Steps

1. ✅ Fix deployment target (iOS 18.0 → 15.0 or 16.0)
2. ✅ Update version numbers
3. ✅ Create in-app purchase in App Store Connect
4. ✅ Prepare screenshots
5. ✅ Archive and upload

