# iOS Screenshots Guide

**Purpose:** Capture screenshots from iOS Simulator for App Store Connect

---

## Method 1: Using Simulator Menu (Easiest)

### Steps:
1. **Open your app in Simulator**
2. **Navigate to the screen you want to capture**
3. **Take screenshot:**
   - **Menu:** Device → Screenshot
   - **Keyboard:** `⌘ + S` (Command + S)
4. **Screenshot is saved automatically:**
   - Location: `~/Desktop/` (or your Desktop)
   - Filename: `Screen Shot [date] at [time].png`

### Tips:
- Make sure the simulator window is focused
- Screenshots are saved at the current simulator size
- Use different simulator sizes for different device screenshots

---

## Method 2: Using Xcode

### Steps:
1. **Run your app in Simulator from Xcode**
2. **In Xcode:** Product → Create Screenshot
3. **Screenshot opens in Preview**
4. **Save or export as needed**

---

## Method 3: Manual Screenshot (macOS)

### Steps:
1. **Open your app in Simulator**
2. **Click on simulator window to focus it**
3. **Use macOS screenshot:**
   - `⌘ + Shift + 3` - Full screen
   - `⌘ + Shift + 4` - Select area
   - `⌘ + Shift + 4` then `Space` - Capture window
4. **Screenshot saved to Desktop**

---

## Required Screenshot Sizes for App Store

### iPhone Screenshots (App Store Connect Requirements):
- **iPhone 6.5"** (iPhone 11 Pro Max, XS Max) - **REQUIRED**
  - Size: **1242 × 2688 pixels** (portrait)
  - Size: **2688 × 1242 pixels** (landscape)
  - Simulator: **iPhone 11 Pro Max** or **iPhone XS Max**
  
- **iPhone 6.7"** (iPhone 14 Pro Max, 15 Pro Max) - **REQUIRED**
  - Size: **1284 × 2778 pixels** (portrait)
  - Size: **2778 × 1284 pixels** (landscape)
  - Simulator: **iPhone 15 Pro Max** or **iPhone 14 Pro Max**

- **iPhone 5.5"** (iPhone 8 Plus, 7 Plus, 6s Plus) - Optional
  - Size: 1242 x 2208 pixels
  - Simulator: iPhone 8 Plus

### iPad Screenshots (if supporting iPad):
- **iPad Pro 12.9"**
  - Size: 2048 x 2732 pixels
  - Simulator: iPad Pro 12.9-inch
  
- **iPad Pro 11"**
  - Size: 1668 x 2388 pixels
  - Simulator: iPad Pro 11-inch

---

## How to Get Correct Size Screenshots

### Step 1: Use Correct Simulator Device
**For 1242 × 2688 (iPhone 6.5"):**
1. In Simulator: **Device → Manage Devices**
2. Select: **iPhone 11 Pro Max** or **iPhone XS Max**
3. Run your app on this device

**For 1284 × 2778 (iPhone 6.7"):**
1. In Simulator: **Device → Manage Devices**
2. Select: **iPhone 15 Pro Max** or **iPhone 14 Pro Max**
3. Run your app on this device

### Step 2: Set Simulator to Physical Size
1. **In Simulator:** Window → Physical Size
   - This ensures 1:1 pixel ratio
   - Don't use scaled sizes

### Step 3: Take Screenshot
1. **Navigate to the screen you want**
2. **Take screenshot:** `⌘ + S`
3. **Verify size:**
   - Right-click screenshot → Get Info
   - Check dimensions match exactly

### Step 4: If Screenshot is Wrong Size

**Option A: Retake with Correct Device (Recommended)**
- Use the correct simulator device listed above
- Make sure Window → Physical Size is enabled
- Retake screenshot

**Option B: Resize Existing Screenshot**
- Open screenshot in Preview app
- Tools → Adjust Size
- Enter exact dimensions: 1242 × 2688 or 1284 × 2778
- Uncheck "Scale proportionally" if needed
- Save
- **Note:** Resizing may reduce quality slightly

---

## Recommended Screenshots for Ciphio Vault

### Minimum Required (1 per device size):
1. **Main Password List Screen**
   - Shows the password manager interface
   - Shows some password entries (if you have test data)

### Recommended (3-5 per device size):
1. **Main Password List** - Shows password entries
2. **Add/Edit Password** - Shows the form
3. **Settings Screen** - Shows app features
4. **Text Encryption Screen** - Shows encryption feature
5. **Password Generator** - Shows generator feature

---

## Quick Workflow

### For App Store Connect:

1. **Open Simulator:**
   ```
   Xcode → Open Developer Tool → Simulator
   ```

2. **Select Device:**
   - Device → Manage Devices
   - Or use dropdown in Simulator toolbar
   - Select: iPhone 15 Pro Max (for 6.7" screenshots)

3. **Run Your App:**
   - Open Xcode
   - Run app on selected simulator
   - Navigate to desired screen

4. **Take Screenshot:**
   - `⌘ + S` in Simulator
   - Or Device → Screenshot

5. **Repeat for Different Screens:**
   - Change simulator device for different sizes
   - Take screenshots of different screens

6. **Upload to App Store Connect:**
   - Go to App Store Connect → Your App → App Store → Version
   - Scroll to Screenshots section
   - Drag and drop screenshots
   - Or click "+" to upload

---

## Tips

### For Best Results:
- ✅ Use actual device sizes (not scaled)
- ✅ Show real content (not empty states)
- ✅ Use consistent design across screenshots
- ✅ Show key features
- ✅ Keep it simple and clear

### For Beta Testing:
- ⚠️ You can use the same screenshot for all sizes (not ideal but works)
- ⚠️ Minimum: 1 screenshot per required device size
- ⚠️ Better: 3-5 screenshots showing different features

### File Format:
- ✅ PNG format (recommended)
- ✅ JPEG also accepted
- ✅ No transparency (App Store requirement)

---

## Finding Your Screenshots

### Default Location:
```
~/Desktop/Screen Shot [date] at [time].png
```

### Or Check:
- Desktop folder
- Downloads folder
- Screenshots folder (if you have one)

### In Finder:
1. Open Finder
2. Press `⌘ + Shift + G`
3. Type: `~/Desktop`
4. Look for files starting with "Screen Shot"

---

## Alternative: Use Simulator's Screenshot Tool

### In Simulator:
1. **Device → Screenshot**
2. **Screenshot opens in Preview**
3. **File → Export As...**
4. **Choose location and format**

---

## Troubleshooting

### Screenshot is wrong size:
- Make sure simulator is set to actual/physical size
- Use the correct device model
- Check Window → Physical Size is enabled

### Screenshot not saving:
- Check Desktop folder permissions
- Try saving manually from Preview
- Check disk space

### Screenshot quality:
- Use actual device size (not scaled)
- Don't zoom in/out
- Use high-resolution simulator devices

---

## Quick Command Reference

| Action | Shortcut |
|-------|----------|
| Take Screenshot | `⌘ + S` |
| Physical Size | Window → Physical Size |
| Change Device | Device → Manage Devices |
| Screenshot Menu | Device → Screenshot |

---

**Last Updated:** November 2025

