# App Store Submission Guide

Complete guide for submitting Ciphio to Google Play Store and Apple App Store.

---

## 📱 Google Play Store Submission

### Prerequisites

1. **Google Play Developer Account** ($25 one-time fee)
   - Sign up: https://play.google.com/console
   - Complete account setup

2. **Release Build**
   - AAB file built and signed (see RELEASE_PREPARATION.md)

3. **Required Assets**
   - App icon (512x512 px)
   - Screenshots (at least 2)
   - Privacy policy URL
   - App description

### Step 1: Create App in Play Console

1. Go to https://play.google.com/console
2. Click **"Create app"**
3. Fill in:
   - **App name**: Ciphio
   - **Default language**: English
   - **App or game**: App
   - **Free or paid**: Free
4. Click **"Create app"**

### Step 2: Complete Store Listing

1. Go to **Store presence** → **Main store listing**

2. **App details:**
   - **App name**: Ciphio
   - **Short description** (80 chars): "Secure text encryption and password generator. All data stored locally."
   - **Full description** (4000 chars): [Write detailed description]
   - **App icon**: Upload 512x512 px icon
   - **Feature graphic**: 1024x500 px (optional but recommended)

3. **Graphics:**
   - Upload screenshots (at least 2, up to 8)
   - Phone screenshots: 1080x1920 px (portrait) or 1920x1080 px (landscape)
   - Tablet screenshots: Optional

4. **Categorization:**
   - **App category**: Tools
   - **Tags**: encryption, security, password

5. **Contact details:**
   - **Email**: Your contact email
   - **Phone**: Optional
   - **Website**: Your website (if any)

### Step 3: Set Up App Content

1. **Privacy Policy:**
   - Go to **Policy** → **App content**
   - **Privacy Policy**: Enter your privacy policy URL (required)

2. **Content Rating:**
   - Go to **Content rating**
   - Complete questionnaire (select "No" for all sensitive content)
   - Submit for rating (usually instant)

3. **Target Audience:**
   - Go to **Target audience**
   - Select appropriate age groups

### Step 4: Set Up Pricing

1. Go to **Monetization setup**
2. Select **Free**
3. Complete setup

### Step 5: Create Release

1. Go to **Production** → **Create new release**

2. **Release name:**
   - Version: 1.0
   - Release name: "Initial release"

3. **Upload AAB:**
   - Click **"Upload"**
   - Select your `app-release.aab` file
   - Wait for upload and processing

4. **Release notes:**
   - What's new in this version: "Initial release of Ciphio"

5. Click **"Review release"**

### Step 6: Review and Submit

1. Review all information
2. Check for any warnings or errors
3. Click **"Start rollout to Production"**
4. App will be submitted for review

**Review time:** Usually 1-3 days

---

## 🍎 Apple App Store Submission

### Prerequisites

1. **Apple Developer Account** ($99/year)
   - Sign up: https://developer.apple.com
   - Enroll in Apple Developer Program

2. **Release Build**
   - Archive created in Xcode (see RELEASE_PREPARATION.md)

3. **Required Assets**
   - App icon (1024x1024 px)
   - Screenshots (various device sizes)
   - Privacy policy URL
   - App description

### Step 1: Create App in App Store Connect

1. Go to https://appstoreconnect.apple.com
2. Click **"My Apps"** → **"+"** → **"New App"**

3. Fill in:
   - **Platform**: iOS
   - **Name**: Ciphio
   - **Primary Language**: English
   - **Bundle ID**: com.ciphio (must match your Xcode project)
   - **SKU**: ciphio-001 (unique identifier)
   - **User Access**: Full Access

4. Click **"Create"**

### Step 2: Complete App Information

1. Go to **App Information**

2. **General Information:**
   - **Category**: Utilities
   - **Subcategory**: Optional
   - **License Agreement**: Standard Apple EULA

3. **Privacy Policy URL:**
   - Enter your privacy policy URL (required)

### Step 3: Set Up Pricing and Availability

1. Go to **Pricing and Availability**

2. **Price:**
   - Select **"Free"**

3. **Availability:**
   - Select countries (or "All countries")
   - Select availability date

### Step 4: Prepare Version Information

1. Go to **App Store** → **1.0 Prepare for Submission**

2. **App Preview and Screenshots:**
   - Upload screenshots for each device size:
     - iPhone 6.7" (iPhone 14 Pro Max): 1290x2796 px
     - iPhone 6.5" (iPhone 11 Pro Max): 1242x2688 px
     - iPhone 5.5" (iPhone 8 Plus): 1242x2208 px
     - iPad Pro 12.9": 2048x2732 px
   - **Minimum**: At least one set of screenshots

3. **Description:**
   - **Name**: Ciphio (max 30 chars)
   - **Subtitle** (30 chars): "Secure encryption & passwords"
   - **Description** (4000 chars): [Write detailed description]
   - **Keywords** (100 chars): "encryption,decrypt,password,generator,secure,privacy"
   - **Support URL**: Your website or support page
   - **Marketing URL**: Optional

4. **App Icon:**
   - Upload 1024x1024 px icon

5. **Version Information:**
   - **Version**: 1.0
   - **Copyright**: © [Year] [Your Name]
   - **What's New**: "Initial release of Ciphio"

### Step 5: Upload Build

**Option 1: Via Xcode (Recommended)**
1. In Xcode: Product → Archive
2. Window → Organizer
3. Select your archive → **"Distribute App"**
4. Choose **"App Store Connect"**
5. Follow the wizard:
   - Upload
   - Select your team
   - Wait for upload to complete

**Option 2: Via Transporter App**
1. Download Transporter from Mac App Store
2. Export archive from Xcode as .ipa
3. Open Transporter → Add → Select .ipa
4. Upload

### Step 6: Select Build

1. Go back to App Store Connect
2. In **"Build"** section, select your uploaded build
3. Wait for processing (can take 10-30 minutes)

### Step 7: Complete App Review Information

1. **Contact Information:**
   - **First Name**: Your first name
   - **Last Name**: Your last name
   - **Phone**: Your phone number
   - **Email**: Your email

2. **Demo Account:**
   - Not required for Ciphio (no login needed)

3. **Notes:**
   - Optional: Add any notes for reviewers

### Step 8: Submit for Review

1. Review all information
2. Check for any warnings
3. Click **"Submit for Review"**
4. App will be submitted

**Review time:** Usually 1-3 days (can be longer)

---

## 📋 Submission Checklist

### Before Submitting

- [ ] Release build tested on real devices
- [ ] All features working correctly
- [ ] Privacy policy hosted and accessible
- [ ] App icons created (all sizes)
- [ ] Screenshots prepared
- [ ] Descriptions written
- [ ] Version numbers correct
- [ ] Signing configured correctly

### Google Play Store

- [ ] Developer account created
- [ ] App created in Play Console
- [ ] Store listing completed
- [ ] Privacy policy URL added
- [ ] Content rating completed
- [ ] AAB file uploaded
- [ ] Release created
- [ ] Submitted for review

### Apple App Store

- [ ] Developer account active
- [ ] App created in App Store Connect
- [ ] App information completed
- [ ] Pricing set to Free
- [ ] Screenshots uploaded (all sizes)
- [ ] App icon uploaded
- [ ] Privacy policy URL added
- [ ] Build uploaded via Xcode/Transporter
- [ ] Build selected in App Store Connect
- [ ] App review information completed
- [ ] Submitted for review

---

## ⏱️ Timeline

**Google Play Store:**
- Account setup: 1-2 hours
- App creation and listing: 2-4 hours
- Review: 1-3 days

**Apple App Store:**
- Account setup: 1-2 hours (if approved immediately)
- App creation and listing: 2-4 hours
- Build upload: 10-30 minutes processing
- Review: 1-3 days (can be longer)

---

## 🆘 Common Issues

### Google Play Store

**"App requires privacy policy"**
- Solution: Add privacy policy URL in Policy → App content

**"Content rating required"**
- Solution: Complete content rating questionnaire

**"AAB upload failed"**
- Solution: Check signing configuration, ensure AAB is signed correctly

### Apple App Store

**"Missing compliance"**
- Solution: Complete App Privacy section in App Store Connect

**"Build processing failed"**
- Solution: Check build settings, ensure all required capabilities are set

**"Missing screenshots"**
- Solution: Upload screenshots for at least one device size

---

## 📚 Related Guides

- [RELEASE_PREPARATION.md](RELEASE_PREPARATION.md) - Prepare apps for release
- [PRIVACY_POLICY.md](PRIVACY_POLICY.md) - Privacy policy template
- [GETTING_STARTED.md](GETTING_STARTED.md) - Development setup

---

## ✅ After Submission

1. **Monitor Status:**
   - Check Play Console / App Store Connect for review status
   - Respond to any reviewer questions

2. **If Rejected:**
   - Read rejection reason
   - Fix issues
   - Resubmit

3. **If Approved:**
   - App will be live in store
   - Monitor for user feedback
   - Plan updates

---

**Good luck with your submission! 🚀**

