# App Store Connect Setup Guide

**Purpose:** Create your app in App Store Connect for TestFlight beta testing

---

## Step 1: Create New App

### In App Store Connect:
1. Go to **My Apps** → Click **+** → **New App**
2. Fill out the form:

#### Platforms
- ✅ Check **iOS** only
- ❌ Uncheck macOS, tvOS, visionOS

#### Name
- **Value:** `Ciphio Vault`
- ✅ Already filled correctly (18 characters)

#### Primary Language
- **Value:** `English (U.S.)`
- ✅ Already selected correctly

#### Bundle ID
- **Value:** `com.ciphio.vault`
- ✅ Already filled correctly
- If you see "XC com ciphio vault - com.ciphio.vault", that's fine - it's showing the identifier

#### SKU (Required)
- **What is SKU?** Stock Keeping Unit - a unique identifier for your app
- **Format:** Letters, numbers, hyphens (no spaces)
- **Examples:**
  - `ciphio-vault-001`
  - `ciphio-vault-ios`
  - `com.ciphio.vault.sku`
- **Important:** This must be unique and cannot be changed later
- **Recommendation:** Use `ciphio-vault-ios` or `ciphio-vault-001`

#### User Access
- **Select:** `Full Access` (recommended)
  - Allows you to manage everything
  - Better for development and testing

### Click "Create"

---

## Step 2: App Information (After Creation)

After creating the app, you'll need to fill out:

### App Information Tab

#### App Privacy
- **Privacy Policy URL:** `https://www.ciphio.com/privacy.html`
- **Data Collection:** Select "No" (you don't collect user data)

#### App Store Information
- **Name:** `Ciphio Vault` (already set)
- **Subtitle:** `Secure Password Manager` (optional, 30 chars max)
- **Category:** 
  - Primary: `Productivity` or `Utilities`
  - Secondary: (optional)
- **Age Rating:** `4+` (no objectionable content)

#### Pricing and Availability
- **Price:** `Free` (for beta)
- **Availability:** Select countries (or "All Countries")

---

## Step 3: Prepare for TestFlight

### Version Information
- **Version:** `1.0.0` (or `1.0.0-beta.6` to match Android)
- **Build:** Will be set when you upload (starts at 1)

### Screenshots (Required for TestFlight)
You'll need at least one screenshot per device size:
- **iPhone 6.7"** (iPhone 14 Pro Max, 15 Pro Max)
- **iPhone 6.5"** (iPhone 11 Pro Max, XS Max)
- **iPad Pro 12.9"** (if supporting iPad)
- **iPad Pro 11"** (if supporting iPad)

**Note:** You can use the same screenshot for all sizes if needed for beta.

### App Description (For Beta)
- Can be brief: "Ciphio Vault - Secure password manager with encryption"
- Full description can be added later

---

## Step 4: Upload Your First Build

### In Xcode:
1. **Archive:**
   - Product → Archive
   - Wait for archive to complete

2. **Distribute:**
   - Window → Organizer
   - Select your archive
   - Click "Distribute App"
   - Choose "App Store Connect"
   - Choose "Upload"
   - Follow the prompts

3. **Wait for Processing:**
   - Upload takes a few minutes
   - Processing takes 10-30 minutes
   - You'll get an email when it's ready

---

## Step 5: Set Up TestFlight

### In App Store Connect → TestFlight:

1. **Create Test Group:**
   - Go to TestFlight tab
   - Click "Internal Testing" or "External Testing"
   - Create a new group (e.g., "Beta Testers")

2. **Add Testers:**
   - **Internal Testing:** Up to 100 testers (must be in your App Store Connect team)
   - **External Testing:** Up to 10,000 testers (anyone with email)
   - Click "Add Testers"
   - Enter email addresses
   - Testers will receive an email invite

3. **Configure Beta Information:**
   - Add release notes (what's new in this build)
   - Add feedback email (optional)
   - Set testing instructions (optional)

4. **Submit for Review (External Testing Only):**
   - External testing requires App Store review
   - Internal testing doesn't require review
   - Review takes 24-48 hours typically

---

## Step 6: Testers Install App

### What Testers Need to Do:

1. **Install TestFlight:**
   - Download "TestFlight" from App Store (free)

2. **Accept Invite:**
   - Open email invite
   - Tap "Start Testing" or "View in TestFlight"
   - Accept terms

3. **Install App:**
   - Open TestFlight app
   - Tap "Install" next to "Ciphio Vault"
   - App installs like a normal app

4. **Test:**
   - Use the app normally
   - Report bugs via TestFlight feedback

---

## Quick Reference

### Bundle ID
- **Main App:** `com.ciphio.vault`
- **AutoFill Extension:** `com.ciphio.vault.AutoFillExtension`

### App Group
- **Identifier:** `group.com.ciphio.vault`

### Keychain Access Group
- **Identifier:** `$(AppIdentifierPrefix)com.ciphio.vault`

### Minimum iOS Version
- **iOS 15.0+**

---

## Common Issues

### "Invalid Bundle ID"
- Ensure bundle ID matches exactly: `com.ciphio.vault`
- Check it exists in your Apple Developer account

### "Missing Compliance"
- When uploading, select "No" for export compliance
- (Unless you're using encryption that requires export documentation)

### "Processing Failed"
- Check build logs in App Store Connect
- Common causes: Invalid entitlements, missing icons, code signing issues

### "TestFlight Not Available"
- External testing requires App Store review first
- Internal testing is available immediately after upload

---

## Next Steps After Setup

1. ✅ Upload first build
2. ✅ Add internal testers (yourself and team)
3. ✅ Test on your device
4. ✅ Add external testers (friends, beta users)
5. ✅ Submit for external testing review
6. ✅ Distribute to testers

---

**Last Updated:** November 2025

