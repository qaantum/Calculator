# After Uploading Build - Next Steps

**Your build has been uploaded to App Store Connect!** 🎉

---

## Step 1: Wait for Processing (5-30 minutes)

**What happens:**
- Apple processes your build
- Validates the app
- Generates symbols for crash reporting
- Makes it available in App Store Connect

**How to check:**
1. **Go to:** https://appstoreconnect.apple.com
2. **Click:** "My Apps"
3. **Select:** "Ciphio Vault"
4. **Click:** "TestFlight" tab (or "App Store" → Version)
5. **Look for:** Your build in the list

**Status will show:**
- ⏳ **"Processing"** - Still being processed (wait)
- ✅ **"Ready to Submit"** - Ready to use!
- ❌ **"Invalid"** - There's an issue (check errors)

---

## Step 2: Select Build in Version

Once build shows "Ready to Submit":

1. **Go to:** App Store Connect → Your App → App Store tab
2. **Click:** "Version 1.0" (or your version)
3. **Scroll to:** "Build" section
4. **Click:** "Select a build before you submit your app"
5. **Choose:** Your uploaded build (should show version 1.0, build 1)
6. **Click:** "Done" or "Save"

---

## Step 3: Complete Version Information

**Make sure you've filled out:**

- [ ] ✅ **Promotional Text** (optional but recommended)
- [ ] ✅ **Description** (required)
- [ ] ✅ **Keywords** (required)
- [ ] ✅ **Support URL** (required)
- [ ] ✅ **Marketing URL** (optional)
- [ ] ✅ **Copyright** (required)
- [ ] ✅ **App Review Information** (required)
- [ ] ✅ **Export Compliance** (required - you did this)
- [ ] ✅ **Screenshots** (required for each device size)
- [ ] ✅ **App Icon** (should be automatic)

**See:** `docs/guides/FILL_VERSION_FORM.md` for details

---

## Step 4: Submit for Review

Once everything is complete:

1. **Review all information** one more time
2. **Click:** "Submit for Review" button (top right)
3. **Answer any final questions:**
   - Export compliance (already done)
   - Content rights (already done)
   - Advertising identifier (if applicable)
4. **Click:** "Submit"

---

## Step 5: Wait for Review

**What happens:**
- Apple reviews your app (usually 24-48 hours)
- You'll get email notifications about status
- Check App Store Connect for updates

**Status:**
- ⏳ **"Waiting for Review"** - In queue
- 🔍 **"In Review"** - Being reviewed
- ✅ **"Ready for Sale"** - Approved!
- ❌ **"Rejected"** - Needs fixes (they'll tell you why)

---

## For Beta Testing (TestFlight)

**If you want to test before public release:**

1. **Go to:** TestFlight tab
2. **Your build** should appear there
3. **Add Internal Testers:**
   - Click "Internal Testing"
   - Add testers (up to 100)
   - They'll get email invites
4. **Or add External Testers:**
   - Click "External Testing"
   - Create a group
   - Add testers
   - Submit for Beta App Review (required for external)

---

## Quick Checklist

- [ ] ⏳ Wait for build to process (5-30 minutes)
- [ ] ✅ Check build status in App Store Connect
- [ ] ✅ Select build in version form
- [ ] ✅ Complete all version information
- [ ] ✅ Add screenshots (if not done)
- [ ] ✅ Review everything
- [ ] ✅ Submit for Review
- [ ] ⏳ Wait for Apple's review

---

## What to Do While Waiting

### If Build is Processing:
- ⏳ Just wait - check back in 10-15 minutes
- ✅ You can fill out version information while waiting
- ✅ Prepare screenshots if not done

### If Build is Ready:
- ✅ Select it in the version form
- ✅ Complete any missing information
- ✅ Submit for review

### If Build Shows Errors:
- ❌ Check the error message
- ❌ Fix the issue
- ❌ Upload a new build

---

## Common Issues

### "Build Not Showing Up"
- **Wait longer** - Processing can take 30+ minutes
- **Refresh the page**
- **Check "All Builds"** not just "Ready to Submit"

### "Build Invalid"
- **Check error message** in App Store Connect
- **Common issues:**
  - Missing entitlements (you fixed this!)
  - Invalid icons
  - Missing required files
- **Fix and upload new build**

### "Can't Select Build"
- **Make sure build status is "Ready to Submit"**
- **Check version number matches** (1.0)
- **Try refreshing the page**

---

## Next Steps Summary

1. **Wait 10-30 minutes** for processing
2. **Check App Store Connect** → TestFlight or App Store → Version
3. **Select your build** when it shows "Ready to Submit"
4. **Complete version form** (if not done)
5. **Submit for Review**

---

**Congratulations on uploading your build!** 🎉

The hard part (code signing, entitlements, etc.) is done. Now it's just waiting and filling out forms.

---

**Last Updated:** November 2025

