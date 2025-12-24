# Step-by-Step Guide: Export to TestFlight

**Complete guide for exporting Ciphio Vault to TestFlight for beta testing.**

---

## 📋 Prerequisites Checklist

Before starting, ensure you have:

- [ ] **Apple Developer Account** ($99/year) - Active and paid
- [ ] **Xcode** installed (latest version recommended)
- [ ] **App Store Connect** access (same Apple ID as Developer account)
- [ ] **Bundle ID** registered in App Store Connect: `com.ciphio.vault`
- [ ] **Code signing** configured in Xcode (Automatic signing recommended)

---

## 🚀 Step-by-Step Instructions

### **Step 1: Open Project in Xcode**

1. Open Xcode
2. Click **File → Open**
3. Navigate to the project's iOS folder and open: `ios/CiphioVault/Ciphio.xcodeproj`
   - From the project root directory, the path is: `ios/CiphioVault/Ciphio.xcodeproj`
4. Click **Open**

---

### **Step 2: Verify Project Settings**

1. In Xcode, click on the **CiphioVault** project (blue icon) in the left sidebar
2. Select the **CiphioVault** target (under TARGETS)
3. Go to the **General** tab
4. Verify these settings:

   **Identity:**
   - **Display Name**: Ciphio Vault
   - **Bundle Identifier**: `com.ciphio.vault`
   - **Version**: `1.0` (or your current version)
   - **Build**: `1` (increment this for each new build)

   **Deployment Info:**
   - **iOS**: `15.0` (set for broad device support - supports devices back to iPhone 6s)
   - **Devices**: iPhone, iPad (if supporting both)

5. Go to **Signing & Capabilities** tab:
   - ✅ **Automatically manage signing** should be checked
   - **Team**: Select your Apple Developer team
   - Verify no signing errors

---

### **Step 3: Clean Build Folder**

1. In Xcode menu: **Product → Clean Build Folder** (or press `⌘⇧K`)
2. Wait for cleaning to complete

---

### **Step 4: Select Build Destination**

1. At the top of Xcode, next to the play/stop buttons
2. Click the device selector dropdown
3. Select **"Any iOS Device"** (or a generic iOS device)
   - ⚠️ **DO NOT** select a simulator - you can't archive from simulator
   - ⚠️ **DO NOT** select a connected physical device

---

### **Step 5: Create Archive**

1. In Xcode menu: **Product → Archive**
   - Or press `⌘B` then wait, then **Product → Archive**
2. Wait for the build to complete (this may take 2-5 minutes)
3. The **Organizer** window will automatically open when archive completes
   - If it doesn't open: **Window → Organizer** (or press `⌘⇧O`)

---

### **Step 6: Verify Archive**

In the Organizer window:

1. You should see your archive listed with:
   - **Name**: CiphioVault
   - **Date**: Today's date/time
   - **Version**: Your version number
   - **Status**: Should show no errors

2. If you see any errors:
   - Click on the archive to see details
   - Fix any signing or build issues
   - Create a new archive after fixing

---

### **Step 7: Distribute to App Store Connect**

1. In the Organizer window, select your archive
2. Click **"Distribute App"** button (right side)
3. **Distribution Method** window appears:
   - Select **"App Store Connect"**
   - Click **"Next"**

4. **Distribution Options** window:
   - Select **"Upload"**
   - Click **"Next"**

5. **Distribution Options** (upload settings):
   - ✅ **Include bitcode**: Leave unchecked (usually not needed)
   - ✅ **Upload your app's symbols**: Check this (helps with crash reports)
   - Click **"Next"**

6. **App Thinning** window:
   - Select **"All compatible device variants"** (default)
   - Click **"Next"**

7. **Distribution Summary** window:
   - Review the information
   - Click **"Upload"**

8. **Signing** window:
   - Xcode will automatically manage signing
   - If prompted, select your **Team**
   - Click **"Upload"**

9. **Upload Progress**:
   - Wait for upload to complete (5-15 minutes depending on file size)
   - You'll see progress in the Organizer window
   - ⚠️ **Don't close Xcode** during upload

10. **Upload Complete**:
    - You'll see a success message
    - Click **"Done"**

---

### **Step 8: Wait for Processing**

1. Go to **App Store Connect**: https://appstoreconnect.apple.com
2. Sign in with your Apple Developer account
3. Click **"My Apps"**
4. Select **"Ciphio Vault"** (or create it if it doesn't exist)
5. Click **"TestFlight"** tab (top navigation)
6. Click **"iOS App"** section
7. You should see your build with status: **"Processing"**
   - ⏱️ This takes **10-30 minutes** (sometimes up to 1 hour)
   - Status will change to **"Ready to Submit"** when done

---

### **Step 9: Set Up TestFlight (After Processing)**

Once your build shows **"Ready to Submit"**:

1. **Add Internal Testers** (up to 100):
   - Go to **TestFlight → Internal Testing**
   - Click **"+"** to add testers
   - Add email addresses of testers
   - They must accept email invitation

2. **Add External Testers** (up to 10,000):
   - Go to **TestFlight → External Testing**
   - Click **"+"** to create a group
   - Add your build to the group
   - Add testers or enable public link
   - ⚠️ **Note**: External testing requires App Review (1-2 days)

3. **Configure Testing Information**:
   - Add **"What to Test"** notes for testers
   - Add **"Feedback Email"** if needed

---

### **Step 10: Testers Install App**

1. Testers receive email invitation (or use public link)
2. They install **TestFlight** app from App Store (if not already installed)
3. They open TestFlight app
4. They accept invitation
5. They tap **"Install"** to download your app
6. They can now test your app!

---

## ⚠️ Common Issues & Solutions

### **Issue: "No signing certificate found"**

**Solution:**
1. Go to **Signing & Capabilities** tab
2. Check **"Automatically manage signing"**
3. Select your **Team** from dropdown
4. Xcode will create certificates automatically
5. If still fails, go to https://developer.apple.com and verify your account is active

---

### **Issue: "Invalid Bundle Identifier"**

**Solution:**
1. Verify Bundle ID in Xcode matches App Store Connect
2. Go to App Store Connect → **My Apps → Ciphio Vault → App Information**
3. Check Bundle ID matches: `com.ciphio.vault`
4. If different, either:
   - Change Xcode to match App Store Connect, OR
   - Create new app in App Store Connect with correct Bundle ID

---

### **Issue: "Archive option is grayed out"**

**Solution:**
1. Make sure you selected **"Any iOS Device"** (not simulator)
2. Clean build folder: **Product → Clean Build Folder**
3. Close and reopen Xcode
4. Try archiving again

---

### **Issue: "Upload failed" or "Invalid archive"**

**Solution:**
1. Check that you're using **Release** configuration
2. Go to **Product → Scheme → Edit Scheme**
3. Select **Archive** on left
4. Set **Build Configuration** to **Release**
5. Create new archive and try again

---

### **Issue: "Build processing failed" in App Store Connect**

**Solution:**
1. Check email from Apple for specific error
2. Common causes:
   - Missing required capabilities
   - Invalid entitlements
   - Code signing issues
3. Fix issues in Xcode and upload new build

---

### **Issue: "Deployment target too high"**

**Solution:**
1. If you need to support older devices, lower the deployment target:
   - Project → Target → General → Deployment Info → iOS
   - Change to **15.0** for broadest support (iPhone 6s and newer)
   - Or **16.0** for iPhone 8 and newer
2. Create new archive

---

## 📝 Quick Reference

### **Version Numbers:**
- **Marketing Version**: User-facing (e.g., "1.0.0")
- **Build Number**: Internal, increment for each upload (1, 2, 3...)

### **Bundle Identifier:**
- Main App: `com.ciphio.vault`
- AutoFill Extension: `com.ciphio.vault.AutoFillExtension` (if configured)

### **Minimum iOS Version:**
- Currently set to: **iOS 15.0** (supports iPhone 6s and newer)
- Can be raised to **16.0** or **17.0** if you want to drop older device support

---

## ✅ Pre-Upload Checklist

Before uploading, verify:

- [ ] Version number is correct
- [ ] Build number is incremented
- [ ] Deployment target is set appropriately (currently iOS 15.0)
- [ ] Code signing is configured correctly
- [ ] No build errors or warnings
- [ ] App builds successfully
- [ ] Archive created successfully
- [ ] Bundle ID matches App Store Connect

---

## 🎯 Next Steps After Upload

1. **Wait for Processing** (10-30 minutes)
2. **Add Testers** in TestFlight
3. **Test the Build** yourself first
4. **Monitor Feedback** from testers
5. **Fix Issues** and upload new build if needed
6. **Submit for App Store Review** when ready (optional - can go straight to App Store)

---

## 📚 Related Documentation

- [iOS Release Guide](../release/IOS_RELEASE_GUIDE.md)
- [iOS Beta Release Checklist](../release/IOS_BETA_RELEASE_CHECKLIST.md)
- [App Store Guide](../release/APP_STORE_GUIDE.md)

---

**That's it! Your app should now be in TestFlight. 🚀**

If you encounter any issues not covered here, check the error message in Xcode or App Store Connect for specific guidance.

