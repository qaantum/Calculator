# Complete App Store Connect Setup - Step by Step

**After adding screenshots, here's what to do next:**

---

## ✅ Step 1: App Information Tab

### Navigate to: App Store Connect → Your App → App Information

#### App Privacy (Required)
1. **Click "App Privacy"**
2. **Data Collection:**
   - Select: **"No, we do not collect data from this app"**
   - (Since you don't collect user data)
3. **Privacy Policy URL:**
   - Enter: `https://www.ciphio.com/privacy.html`
   - ✅ This is required

#### App Store Information
1. **Name:** `Ciphio Vault` (already set)
2. **Subtitle:** (Optional, 30 chars max)
   - Example: `Secure Password Manager`
3. **Category:**
   - **Primary:** `Productivity` or `Utilities`
   - **Secondary:** (Optional)
4. **Age Rating:**
   - Click "Edit" → Answer questions
   - Should result in **4+** (no objectionable content)

---

## ✅ Step 2: Pricing and Availability

### Navigate to: Pricing and Availability

1. **Price:**
   - Select: **Free** (for beta)
2. **Availability:**
   - Select countries (or "All Countries")
   - For beta, you can limit to specific countries if needed

---

## ✅ Step 3: Version Information

### Navigate to: App Store → Version 1.0

#### Version Details
1. **Version:** `1.0.0` (or `1.0.0-beta.6` to match Android)
2. **What's New in This Version:**
   - Add release notes for beta testers
   - Example:
     ```
     Welcome to Ciphio Vault Beta!
     
     Features:
     - Secure password management
     - AutoFill support
     - Biometric authentication
     - Text encryption
     - Password generator
     
     This is a beta version. Please report any issues.
     ```

#### App Review Information
1. **Contact Information:**
   - Your contact details (required)
2. **Demo Account:** (Optional)
   - Not needed for password manager
3. **Notes:** (Optional)
   - Any special instructions for reviewers

#### Version Release
- **Automatically release this version:** Leave unchecked for now
- You'll manually release after testing

---

## ✅ Step 4: TestFlight Setup

### Navigate to: TestFlight Tab

### Internal Testing (No Review Required)

1. **Create Internal Test Group:**
   - Click "Internal Testing"
   - Click "+" to create new group
   - Name: `Beta Testers` or `Internal Team`
   - Click "Create"

2. **Add Your Build:**
   - If you've uploaded a build, it will appear here
   - Select the build
   - Click "Add to Test Group"
   - Select your test group

3. **Add Internal Testers:**
   - Click on your test group
   - Click "Add Testers"
   - Add email addresses (up to 100)
   - Testers must be in your App Store Connect team
   - Click "Add"

4. **Enable Testing:**
   - Toggle "Enable Testing" to ON
   - Testers will receive email invites

### External Testing (Requires Review)

**Note:** External testing requires App Store review (24-48 hours)

1. **Create External Test Group:**
   - Click "External Testing"
   - Click "+" to create new group
   - Name: `Beta Testers`
   - Click "Create"

2. **Add Build:**
   - Select your uploaded build
   - Click "Add to Test Group"

3. **Beta App Information:**
   - **Beta App Description:**
     ```
     Ciphio Vault - Secure password manager with encryption
     
     Features:
     - Master password protection
     - AutoFill support
     - Biometric authentication
     - Text encryption (AES-GCM, CBC, CTR)
     - Password generator
     ```
   - **Feedback Email:** Your email address
   - **Marketing URL:** (Optional) `https://www.ciphio.com`
   - **Privacy Policy URL:** `https://www.ciphio.com/privacy.html` ✅ Required

4. **Add External Testers:**
   - Click "Add Testers"
   - Enter email addresses (up to 10,000)
   - Click "Add"
   - Testers don't need to be in your team

5. **Submit for Review:**
   - Click "Submit for Review"
   - Answer export compliance questions:
     - **Does your app use encryption?** → Yes
     - **Does your app use exempt encryption?** → Yes
     - **Explanation:** "App uses standard encryption (AES) for password storage, which is exempt from export compliance requirements."
   - Submit

---

## ✅ Step 5: Upload Your Build

### In Xcode:

1. **Archive:**
   - Product → Archive
   - Wait for archive to complete

2. **Distribute:**
   - Window → Organizer (or `⌘ + Shift + 2`)
   - Select your archive
   - Click "Distribute App"
   - Choose: **"App Store Connect"**
   - Choose: **"Upload"**
   - Click "Next"

3. **Distribution Options:**
   - Select: **"Upload your app's symbols"** (recommended)
   - Click "Next"

4. **App Thinning:**
   - Select: **"All compatible device variants"**
   - Click "Next"

5. **Review:**
   - Check the summary
   - Click "Upload"

6. **Wait:**
   - Upload takes a few minutes
   - Processing takes 10-30 minutes
   - You'll get an email when it's ready

---

## ✅ Step 6: After Build is Processed

### In App Store Connect:

1. **Check Build Status:**
   - Go to TestFlight tab
   - Your build should appear under "Builds"
   - Status: "Processing" → "Ready to Submit" → "Ready to Test"

2. **Add Build to Test Group:**
   - Go to your test group
   - Click "Add Build"
   - Select the processed build
   - Click "Done"

3. **Enable Testing:**
   - Toggle "Enable Testing" to ON
   - Testers will receive invites

---

## ✅ Step 7: Testers Install App

### What Testers Need to Do:

1. **Install TestFlight:**
   - Download "TestFlight" from App Store (free)

2. **Accept Invite:**
   - Open email invite from Apple
   - Tap "Start Testing" or "View in TestFlight"
   - Accept terms

3. **Install App:**
   - Open TestFlight app
   - Tap "Install" next to "Ciphio Vault"
   - App installs like normal app

4. **Test:**
   - Use app normally
   - Report bugs via TestFlight feedback button

---

## 📋 Quick Checklist

### App Information:
- [ ] App Privacy configured (No data collection)
- [ ] Privacy Policy URL added
- [ ] Category selected
- [ ] Age rating completed

### Version Information:
- [ ] Version number set
- [ ] Release notes added
- [ ] Contact information added

### TestFlight:
- [ ] Build uploaded and processed
- [ ] Internal test group created
- [ ] Testers added
- [ ] Testing enabled

### External Testing (Optional):
- [ ] External test group created
- [ ] Beta app information filled
- [ ] External testers added
- [ ] Submitted for review

---

## 🚨 Common Issues

### "Build Not Available"
- Wait for processing (10-30 minutes)
- Check email for processing status
- Make sure build is "Ready to Test"

### "Export Compliance Required"
- Answer: Yes, app uses encryption
- Select: Exempt encryption
- Explain: Standard AES encryption for password storage

### "Privacy Policy Required"
- Must have publicly accessible privacy policy
- URL: `https://www.ciphio.com/privacy.html`
- Must be accessible without login

### "Testers Not Receiving Invites"
- Check spam folder
- Verify email addresses are correct
- Make sure testing is enabled
- For external testing, wait for review approval

---

## 🎯 Next Steps After Setup

1. ✅ Test on your own device first (internal testing)
2. ✅ Add friends/colleagues as external testers
3. ✅ Collect feedback
4. ✅ Fix any issues
5. ✅ Upload new builds as needed
6. ✅ Submit to App Store when ready

---

## 📞 Need Help?

- **App Store Connect Help:** https://help.apple.com/app-store-connect/
- **TestFlight Guide:** https://developer.apple.com/testflight/
- **Export Compliance:** https://developer.apple.com/documentation/security/complying-with-encryption-export-regulations

---

**Last Updated:** November 2025

