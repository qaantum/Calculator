# Resize Screenshot from 1290 × 2796 to 1284 × 2778

**Problem:** Your iPhone 15 Pro Max screenshot is 1290 × 2796, but App Store needs exactly 1284 × 2778

---

## Quick Fix: Resize in Preview

### Steps:
1. **Open your screenshot in Preview**
   - Double-click the screenshot file

2. **Open Adjust Size:**
   - Tools → Adjust Size
   - Or press `⌘ + Option + I`

3. **Set Exact Dimensions:**
   - **Width:** `1284` pixels
   - **Height:** `2778` pixels
   - **Important:** 
     - Uncheck "Scale proportionally" if checked
     - Make sure "Resample image" is checked
   - Click "OK"

4. **Save:**
   - File → Save (or `⌘ + S`)
   - The file will be updated with correct dimensions

5. **Verify:**
   - Right-click file → Get Info
   - Check "More Info" → Dimensions should show `1284 x 2778`

---

## Why This Happens

**iPhone 15 Pro Max Simulator:**
- Sometimes captures at 1290 × 2796 (slightly larger)
- App Store requires exactly 1284 × 2778
- The difference is small (6 pixels width, 18 pixels height)
- Resizing fixes it without noticeable quality loss

---

## Alternative: Use iPhone 11 Pro Max Instead

If you want to avoid resizing, use a different device:

### For 1242 × 2688 (iPhone 6.5"):
1. **In Simulator:** Device → Manage Devices
2. **Select: iPhone 11 Pro Max**
3. **Window → Physical Size**
4. **Run your app**
5. **Take screenshot:** `⌘ + S`
6. **Should be exactly 1242 × 2688**

This size is also accepted by App Store Connect and might be easier to get right.

---

## Command Line Resize (Alternative)

If you prefer command line:

```bash
# Navigate to your screenshot location
cd ~/Desktop

# Resize using sips (built into macOS)
sips -z 2778 1284 "Simulator Screenshot - iPhone 15 Pro Max.png" --out "screenshot_1284x2778.png"
```

This creates a new file with correct dimensions.

---

## Quick Checklist

- [ ] Open screenshot in Preview
- [ ] Tools → Adjust Size
- [ ] Set: 1284 × 2778
- [ ] Uncheck "Scale proportionally"
- [ ] Click OK
- [ ] Save file
- [ ] Verify dimensions in Get Info
- [ ] Upload to App Store Connect

---

**Note:** The quality difference between 1290 × 2796 and 1284 × 2778 is minimal (less than 1% smaller), so resizing won't noticeably affect image quality.

---

**Last Updated:** November 2025

