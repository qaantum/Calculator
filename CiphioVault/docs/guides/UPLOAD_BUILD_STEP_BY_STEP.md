# Upload Build to App Store Connect - Step by Step

**Step 8:** Upload your app build from Xcode to App Store Connect

---

## Prerequisites

Before you can upload:
- ✅ App is created in App Store Connect
- ✅ Bundle ID matches: `com.ciphio.vault`
- ✅ Code signing is configured in Xcode
- ✅ App builds successfully in Xcode

---

## Step-by-Step Instructions

### Step 1: Open Your Project in Xcode

1. **Open Xcode**
2. **Open your project:**
   - File → Open
   - Navigate to: `ios/CiphioVault/Ciphio.xcodeproj`
   - Click "Open"

---

### Step 2: Select Build Target

1. **At the top of Xcode**, you'll see a device selector
2. **Click the device dropdown** (next to the Play/Stop buttons)
3. **Select: "Any iOS Device"** or a specific device
   - **Important:** Don't select a simulator
   - Must be "Any iOS Device" or a real device

---

### Step 3: Clean Build Folder (Optional but Recommended)

1. **Product → Clean Build Folder**
   - Or press `⌘ + Shift + K`
2. **Wait for cleaning to complete**

---

### Step 4: Archive Your App

**Important:** Use Archive, NOT Xcode Cloud!

1. **Product → Archive**
   - Or press: `⌘ + B` (build first), then Product → Archive
   - **Do NOT use:** Product → Cloud → Start Build (that's Xcode Cloud, different service)
2. **Wait for archive to complete**
   - This can take 2-5 minutes
   - You'll see progress in the top bar
   - When done, Xcode will automatically open the Organizer window

**If you see "Start Build" dialog:**
- Click "Close" (don't use Xcode Cloud)
- Make sure you're using Product → Archive (not Cloud menu)

---

### Step 5: Organizer Window Opens

After archiving, the **Organizer** window should open automatically:
- **Window → Organizer** (or `⌘ + Shift + 2`)
- You'll see your archive listed with today's date

---

### Step 6: Distribute App

1. **Select your archive** (the one you just created)
2. **Click "Distribute App"** button (on the right)
3. **Choose distribution method:**
   - Select: **"App Store Connect"**
   - Click "Next"

---

### Step 7: Choose Upload

1. **Select: "Upload"**
   - (Not "Export" - that's for Ad Hoc distribution)
   - Click "Next"

---

### Step 8: Distribution Options

1. **Select: "Upload your app's symbols"** ✅
   - This helps with crash reporting
   - Recommended: Check this box
   - Click "Next"

---

### Step 9: App Thinning

1. **Select: "All compatible device variants"**
   - This creates optimized builds for different devices
   - Recommended: Leave as default
   - Click "Next"

---

### Step 10: Review and Upload

1. **Review the summary:**
   - App name: CiphioVault
   - Bundle ID: com.ciphio.vault
   - Version: (your version number)
   - Build: (your build number)

2. **Click "Upload"**
   - Upload starts immediately
   - Progress bar shows upload status

---

### Step 11: Wait for Upload

1. **Upload takes 2-10 minutes** (depending on app size)
2. **You'll see progress:**
   - "Preparing archive..."
   - "Uploading..."
   - "Upload complete"

3. **When done:**
   - You'll see "Upload Succeeded" message
   - Click "Done"

---

### Step 12: Wait for Processing

1. **Go to App Store Connect:**
   - https://appstoreconnect.apple.com
   - Navigate to: Your App → TestFlight

2. **Check build status:**
   - Your build will appear under "Builds"
   - Status: "Processing" (orange/yellow)
   - **Processing takes 10-30 minutes**

3. **You'll get an email when processing is complete:**
   - Subject: "Your build is ready for testing"
   - Status will change to "Ready to Submit" or "Ready to Test"

---

### Step 13: Select Build in App Store Connect

Once processing is complete:

1. **Go to:** App Store Connect → Your App → App Store → Version 1.0
2. **Scroll to "Build" section**
3. **Click: "Select a build before you submit your app"**
4. **Select your processed build:**
   - It will show version and build number
   - Example: "1.0.0 (1)"
5. **Click "Done"**

---

## Troubleshooting

### "No builds available"
- **Wait longer:** Processing takes 10-30 minutes
- **Check email:** You'll get notified when ready
- **Refresh page:** Sometimes needs a refresh

### "Archive failed"
- **Check build errors:** Fix any compilation errors first
- **Check code signing:** Ensure certificates are valid
- **Clean build folder:** Product → Clean Build Folder
- **Try again:** Product → Archive

### "Upload failed"
- **Check internet connection**
- **Check code signing:** Ensure valid certificates
- **Check bundle ID:** Must match App Store Connect exactly
- **Try again:** Click "Upload" again

### "Invalid bundle ID"
- **Check bundle ID in Xcode:**
  - Project → Target → General → Bundle Identifier
  - Must be: `com.ciphio.vault`
- **Check App Store Connect:**
  - Must match exactly

### "Code signing error"
- **Check certificates:**
  - Xcode → Preferences → Accounts
  - Select your Apple ID
  - Click "Download Manual Profiles"
- **Check provisioning profiles:**
  - Project → Target → Signing & Capabilities
  - Ensure "Automatically manage signing" is checked

---

## Quick Checklist

- [ ] Project opens in Xcode
- [ ] Selected "Any iOS Device" (not simulator)
- [ ] Cleaned build folder
- [ ] Created archive (Product → Archive)
- [ ] Organizer window opened
- [ ] Clicked "Distribute App"
- [ ] Selected "App Store Connect" → "Upload"
- [ ] Selected "Upload your app's symbols"
- [ ] Clicked "Upload"
- [ ] Upload completed successfully
- [ ] Waited 10-30 minutes for processing
- [ ] Build appears in App Store Connect
- [ ] Selected build in Version form

---

## Visual Guide

### Xcode Archive Process:
```
1. Product → Archive
   ↓
2. Wait for archive (2-5 min)
   ↓
3. Organizer opens automatically
   ↓
4. Click "Distribute App"
   ↓
5. Select "App Store Connect"
   ↓
6. Select "Upload"
   ↓
7. Review options
   ↓
8. Click "Upload"
   ↓
9. Wait for upload (2-10 min)
   ↓
10. Done!
```

### App Store Connect Process:
```
1. Upload completes
   ↓
2. Go to App Store Connect → TestFlight
   ↓
3. Build shows "Processing" (10-30 min)
   ↓
4. Email notification: "Build ready"
   ↓
5. Status changes to "Ready to Test"
   ↓
6. Go to Version 1.0 → Build section
   ↓
7. Click "Select a build"
   ↓
8. Select your build
   ↓
9. Build is now selected!
```

---

## Next Steps After Upload

1. ✅ Wait for processing (10-30 minutes)
2. ✅ Select build in Version form (Step 8)
3. ✅ Complete remaining form fields
4. ✅ Set up TestFlight
5. ✅ Add testers
6. ✅ Submit for review (if external testing)

---

**Last Updated:** November 2025

