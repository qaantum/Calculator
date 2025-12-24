# Xcode Cloud vs Archive - Which to Use?

**For beta testing, you need to use Archive, NOT Xcode Cloud.**

---

## The Difference

### Xcode Cloud (CI/CD Service)
- **What it is:** Automated build service (like GitHub Actions)
- **When to use:** For automated testing and continuous integration
- **Not needed for:** Manual beta uploads
- **Cost:** Requires paid Apple Developer account with Xcode Cloud access

### Archive (Traditional Method)
- **What it is:** Manual build and upload process
- **When to use:** For beta testing, App Store submissions
- **What you need:** Standard Apple Developer account
- **Cost:** Included with Apple Developer account

---

## For Beta Testing: Use Archive

### Correct Steps:

1. **Product → Archive** ✅
   - NOT: Product → Cloud → Start Build ❌

2. **Wait for archive to complete**

3. **Organizer opens automatically**

4. **Click "Distribute App"**

5. **Select "App Store Connect" → "Upload"**

---

## If You See "Start Build" Dialog

**This is Xcode Cloud, not what you need:**

1. **Click "Close"** on the Xcode Cloud dialog
2. **Make sure you're using:**
   - Product → Archive (correct)
   - NOT: Product → Cloud → Start Build (wrong)

---

## How to Archive Correctly

### Step-by-Step:

1. **Open Xcode**
2. **Select "Any iOS Device"** (not simulator)
3. **Product → Archive**
   - Look for "Archive" in the menu
   - It should be under "Product" menu
   - NOT under "Product → Cloud"

4. **Wait for archive**
   - Progress bar at top of Xcode
   - Takes 2-5 minutes

5. **Organizer opens automatically**
   - Window → Organizer (or `⌘ + Shift + 2`)
   - You'll see your archive

6. **Click "Distribute App"**
   - Button on the right side
   - NOT "Start Build"

---

## Troubleshooting

### "Start Build keeps appearing"
- **Problem:** You're clicking the wrong menu item
- **Solution:** Use Product → Archive (not Cloud menu)

### "Archive option is grayed out"
- **Problem:** Wrong device selected
- **Solution:** Select "Any iOS Device" (not simulator)

### "No Archive option"
- **Problem:** Menu might be different
- **Solution:** 
  - Look for: Product → Archive
  - Or: Product → Build For → Archiving
  - Then: Window → Organizer

---

## Visual Guide

### Correct Menu Path:
```
Product
  ├── Build (⌘B)
  ├── Clean Build Folder (⌘⇧K)
  ├── Archive ✅ (USE THIS)
  └── Cloud
      └── Start Build ❌ (NOT THIS)
```

### What You Should See:
1. **Archive starts** → Progress bar at top
2. **Archive completes** → Organizer opens
3. **Archive listed** → With today's date
4. **"Distribute App" button** → On the right

### What You Should NOT See:
- ❌ "Start Build" dialog
- ❌ Xcode Cloud configuration
- ❌ Branch selector

---

## Quick Fix

**If you're stuck on Xcode Cloud dialog:**

1. Click "Close" on the dialog
2. Go to: **Product → Archive**
3. Wait for archive to complete
4. Organizer will open automatically
5. Click "Distribute App"
6. Select "App Store Connect" → "Upload"

---

**Remember:** For beta testing, always use **Archive**, not Xcode Cloud!

---

**Last Updated:** November 2025

