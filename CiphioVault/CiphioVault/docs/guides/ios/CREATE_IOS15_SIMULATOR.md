# How to Create iOS 15.0 Simulator

## Steps to Create iOS 15.0 Simulator

### Method 1: Using Xcode Simulator Manager

1. **Open Simulator Manager:**
   - Xcode → Window → Devices and Simulators
   - Or press **⇧⌘2**

2. **Create New Simulator:**
   - Click the **"+"** button at the bottom left
   - Or right-click in the simulators list → "New Simulator"

3. **Configure the Simulator:**
   - **Simulator Name:** Enter a name (e.g., "iPhone 8 iOS 15")
   - **Device Type:** Select a device (e.g., "iPhone 8" or "iPhone XR")
   - **OS Version:** Click the dropdown
     - **IMPORTANT:** Don't select "iOS 18.6"
     - Scroll down or look for "iOS 15.0"
     - Select **"iOS 15.0"** (it should show "✓ iOS 15.0" if installed)
   - Click **"Create"**

### Method 2: Using Command Line

```bash
xcrun simctl create "iPhone 8 iOS 15" "iPhone 8" "iOS15.0"
```

Or for iPhone XR:
```bash
xcrun simctl create "iPhone XR iOS 15" "iPhone XR" "iOS15.0"
```

### Method 3: If iOS 15.0 Doesn't Appear

If iOS 15.0 doesn't show in the dropdown:

1. **Check if it's installed:**
   - Xcode → Settings → Components
   - Look for "iOS 15.0 Simulator" in the list
   - If it shows "Installed", it's available

2. **Download if needed:**
   - Xcode → Settings → Components
   - Find "iOS 15.0 Simulator"
   - Click "Get" or download button if not installed

3. **Restart Xcode** after downloading

---

## Verify You're Using iOS 15.0

### Check Simulator Version

1. **In Simulator:**
   - Open the simulator
   - Settings → General → About
   - Check "Software Version" - should show "iOS 15.0"

2. **In Xcode:**
   - Look at the top bar when simulator is selected
   - Should show "iPhone X iOS 15.0" or similar

3. **In Simulator Manager:**
   - The simulator name should indicate iOS 15.0
   - Or check the details panel on the right

---

## Your Current Setup

✅ **Deployment Target:** iOS 15 (correct!)
✅ **iOS 15.0 Simulator:** Installed (shown in Components)
❓ **Simulator Selection:** Make sure you select iOS 15.0 simulator, not 18.6

---

## Quick Test

1. **Create iOS 15.0 Simulator:**
   - Use steps above
   - Name it clearly: "iPhone 8 iOS 15"

2. **Select it in Xcode:**
   - Top bar → Device selector
   - Choose your iOS 15.0 simulator

3. **Build and Run:**
   - Press **⌘R**
   - App should launch on iOS 15.0

4. **Verify:**
   - Check Settings → General → About in simulator
   - Should show "iOS 15.0"

---

## Troubleshooting

### "iOS 15.0 not in dropdown"
- Make sure it's installed (Xcode → Settings → Components)
- Restart Xcode
- Try command line method

### "Simulator defaults to 18.6"
- When creating new simulator, manually select iOS 15.0 from dropdown
- Don't use the default selection

### "How to change existing simulator to iOS 15.0"
- You can't change an existing simulator's OS version
- Delete the old simulator and create a new one with iOS 15.0

---

## Recommended Simulators for Testing

1. **iPhone 8 iOS 15.0** - Good for minimum testing
2. **iPhone XR iOS 15.0** - Common device
3. **iPhone 15 iOS 17.0+** - Latest for comparison

