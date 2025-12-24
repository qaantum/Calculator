# App Encryption Documentation - App Store Connect

**Location:** App Store Connect → Your App → App Information → App Encryption Documentation

---

## ✅ What I've Already Done

I've added the required Info.plist key to your Xcode project:

- **Key:** `ITSAppUsesNonExemptEncryption`
- **Value:** `NO` (because AES is exempt encryption)
- **Added to:**
  - ✅ Main app (CiphioVault) - Debug & Release
  - ✅ AutoFillExtension - Debug & Release

This key will be automatically included in your Info.plist when you build.

---

## 📋 What You Need to Do in App Store Connect

### Step 1: Answer the Encryption Questions

When you see the "App Encryption Documentation" section, answer:

**Question: "Does your app use encryption?"**
- ✅ **Yes** (your app uses AES encryption)

**Question: "Does your app use exempt encryption?"**
- ✅ **Yes** (AES is exempt under Category 5 Part 2)

**Question: "Does your app use standard encryption?"**
- ✅ **Yes** (AES-GCM, AES-CBC, AES-CTR are all standard)

---

### Step 2: Provide Documentation (If Required)

**You should NOT need to provide documentation** because:

1. ✅ **Standard Encryption:** Your app uses standard AES encryption (AES-GCM, AES-CBC, AES-CTR)
2. ✅ **Standard Key Derivation:** Your app uses PBKDF2 (standard)
3. ✅ **Standard Hash:** Your app uses SHA-256 (standard)
4. ✅ **All algorithms are accepted by international standards bodies:**
   - AES: NIST (National Institute of Standards and Technology)
   - PBKDF2: IETF RFC 2898
   - SHA-256: NIST

**If Apple still asks for documentation**, provide this:

```
App Encryption Documentation

This app uses standard encryption algorithms for password storage and text encryption:

1. AES (Advanced Encryption Standard)
   - Modes: AES-GCM, AES-CBC, AES-CTR
   - Key length: 256 bits
   - Standard: NIST FIPS 197

2. PBKDF2 (Password-Based Key Derivation Function 2)
   - Iterations: 100,000
   - Hash: SHA-256
   - Standard: IETF RFC 2898

3. SHA-256 (Secure Hash Algorithm 256)
   - Standard: NIST FIPS 180-4

All encryption is performed locally on the device. No proprietary or non-standard encryption algorithms are used. All algorithms are accepted by international standard bodies (NIST, IETF).

This encryption is exempt from export compliance requirements under Category 5 Part 2 of the Export Administration Regulations (EAR).
```

---

## 🔍 Verification

### Check Info.plist in Xcode

After building, verify the key is included:

1. **Build your app** (⌘ + B)
2. **Right-click on your app** in Products folder
3. **Show in Finder**
4. **Right-click the .app** → **Show Package Contents**
5. **Open Info.plist**
6. **Look for:** `ITSAppUsesNonExemptEncryption` = `NO`

Or check in Xcode:

1. **Select your target** (CiphioVault)
2. **Build Settings** tab
3. **Search for:** `ITSAppUsesNonExemptEncryption`
4. **Should show:** `NO`

---

## 📝 Quick Checklist

- [x] ✅ Added `ITSAppUsesNonExemptEncryption = NO` to Xcode project
- [ ] ⏳ Build app and verify key is in Info.plist
- [ ] ⏳ In App Store Connect, answer "Yes" to "Does your app use encryption?"
- [ ] ⏳ In App Store Connect, answer "Yes" to "Does your app use exempt encryption?"
- [ ] ⏳ Upload build to App Store Connect
- [ ] ⏳ Complete export compliance section

---

## ❓ Why "NO" for Non-Exempt?

**`ITSAppUsesNonExemptEncryption = NO`** means:
- Your app **does NOT use non-exempt encryption**
- Your app **uses exempt encryption** (standard AES)
- This is the **correct value** for standard encryption

**If you used proprietary encryption:**
- You would set it to `YES`
- You would need to provide detailed documentation
- You might need export licenses

**For standard AES (like your app):**
- Set to `NO` ✅
- No documentation needed ✅
- No export licenses needed ✅

---

## 🚨 Common Issues

### Issue: "You must provide documentation"

**Solution:**
1. Verify `ITSAppUsesNonExemptEncryption = NO` is in your build
2. Answer "Yes" to "Does your app use exempt encryption?"
3. If still asked, provide the documentation text above

### Issue: "Cannot find encryption key in Info.plist"

**Solution:**
1. Clean build folder (⌘ + Shift + K)
2. Rebuild (⌘ + B)
3. Check Build Settings for the key
4. Verify it's set to `NO`

### Issue: "Export compliance error"

**Solution:**
1. Make sure you answered "Yes" to exempt encryption
2. The key `ITSAppUsesNonExemptEncryption = NO` must be in your build
3. Re-upload the build if you fixed it

---

## 📚 References

- [Apple's Export Compliance Documentation](https://developer.apple.com/documentation/security/compiling_code_that_uses_encryption)
- [Info.plist Keys Reference](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html)
- [Export Administration Regulations (EAR)](https://www.bis.doc.gov/index.php/regulations/export-administration-regulations-ear)

---

**Last Updated:** November 2025

