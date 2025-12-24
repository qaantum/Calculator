# Fix Screenshot Sizes - Quick Guide

**Problem:** Your screenshots are 1206 × 2622, but App Store needs 1242 × 2688 or 1284 × 2778

---

## Solution 1: Retake Screenshots (Best Quality)

### For 1242 × 2688 (iPhone 6.5"):
1. **Open Simulator**
2. **Device → Manage Devices**
3. **Select: iPhone 11 Pro Max** (or iPhone XS Max)
4. **Window → Physical Size** (important!)
5. **Run your app** from Xcode
6. **Navigate to screen you want**
7. **Press `⌘ + S`** to take screenshot
8. **Verify:** Right-click screenshot → Get Info → Should show 1242 × 2688

### For 1284 × 2778 (iPhone 6.7"):
1. **Open Simulator**
2. **Device → Manage Devices**
3. **Select: iPhone 15 Pro Max** (or iPhone 14 Pro Max)
4. **Window → Physical Size** (important!)
5. **Run your app** from Xcode
6. **Navigate to screen you want**
7. **Press `⌘ + S`** to take screenshot
8. **Verify:** Right-click screenshot → Get Info → Should show 1284 × 2778

---

## Solution 2: Resize Existing Screenshots (Quick Fix)

### Using Preview App (macOS):

1. **Open screenshot in Preview**
   - Double-click the screenshot file

2. **Adjust Size:**
   - Tools → Adjust Size
   - Or press `⌘ + Option + I`

3. **Enter Exact Dimensions:**
   - **For iPhone 6.5" (iPhone 11 Pro Max):**
     - Width: `1242` pixels
     - Height: `2688` pixels
   - **For iPhone 6.7" (iPhone 15 Pro Max):**
     - Width: `1284` pixels
     - Height: `2778` pixels
   - **Important:** Uncheck "Scale proportionally" if it's checked
   - Click "OK"

4. **Save:**
   - File → Save (or `⌘ + S`)
   - Or File → Export As... → Choose PNG format

### Using Online Tool:
- Go to: https://www.iloveimg.com/resize-image
- Upload your screenshot
- Set custom size: 1242 × 2688
- Download resized image

### Using Command Line:
```bash
# Install ImageMagick first: brew install imagemagick
# Then resize:
sips -z 2688 1242 your_screenshot.png --out resized_screenshot.png
```

---

## Which Size to Use?

**Minimum Required:**
- At least **one** screenshot at **1242 × 2688** (iPhone 6.5")
- Or **1284 × 2778** (iPhone 6.7")

**Recommended:**
- Use **both sizes** for better coverage:
  - 1242 × 2688 (iPhone 11 Pro Max / XS Max)
  - 1284 × 2778 (iPhone 15 Pro Max / 14 Pro Max)

---

## Quick Checklist

- [ ] Open Simulator
- [ ] Select correct device (iPhone 11 Pro Max or iPhone 15 Pro Max)
- [ ] Enable Physical Size (Window → Physical Size)
- [ ] Run app
- [ ] Navigate to desired screen
- [ ] Take screenshot (`⌘ + S`)
- [ ] Verify dimensions (Right-click → Get Info)
- [ ] Upload to App Store Connect

---

## Why Your Screenshots Were Wrong Size

**Common Causes:**
1. ❌ Simulator was scaled (not Physical Size)
2. ❌ Wrong device selected
3. ❌ Simulator window was resized manually

**Fix:**
- Always use **Window → Physical Size**
- Always use the **exact device models** listed above
- Don't manually resize simulator window

---

## App Store Connect Requirements

**Accepted Sizes:**
- ✅ 1242 × 2688px (portrait)
- ✅ 2688 × 1242px (landscape)
- ✅ 1284 × 2778px (portrait)
- ✅ 2778 × 1284px (landscape)

**Your Current Size:**
- ❌ 1206 × 2622px (too small)

**Fix:**
- Use iPhone 11 Pro Max for 1242 × 2688
- Or iPhone 15 Pro Max for 1284 × 2778

---

**Last Updated:** November 2025

