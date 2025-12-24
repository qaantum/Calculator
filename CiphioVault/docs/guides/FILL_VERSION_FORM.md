# Fill Out App Store Connect Version Form

**Location:** App Store Connect → Your App → App Store → Version 1.0

---

## Required Fields

### 1. Promotional Text (170 characters max)
**What it is:** Short text that appears above your description on the App Store

**Use this:**
```
Secure password manager with AES encryption. Master password protection, AutoFill support, and biometric authentication.
```

---

### 2. Description (4,000 characters max)
**What it is:** Full app description shown on the App Store

**Use this:**
```
Ciphio Vault - Secure Password Manager

Ciphio Vault is a secure password manager that helps you store and manage your passwords safely. All your passwords are encrypted using AES-GCM encryption and protected by a master password.

Features:
• Secure Password Storage - All passwords encrypted with AES-GCM
• Master Password Protection - Your data is protected by a single master password
• AutoFill Support - Seamlessly fill passwords in Safari and other apps
• Biometric Authentication - Unlock with Face ID or Touch ID
• Text Encryption - Encrypt any text with multiple algorithms (AES-GCM, AES-CBC, AES-CTR)
• Password Generator - Generate strong, secure passwords
• Categories - Organize passwords with custom categories
• Search & Filter - Quickly find your passwords
• Import/Export - Backup and restore your passwords
• Dark Mode - Beautiful dark and light themes

Privacy & Security:
• All data encrypted locally on your device
• No cloud sync - your data stays on your device
• No data collection - we don't collect any user data

Perfect for:
• Personal password management
• Secure credential storage
• Text encryption needs
• Password generation

Download Ciphio Vault today and take control of your digital security.
```

---

### 3. Keywords (100 characters max)
**What it is:** Search keywords (comma-separated, no spaces after commas)

**Use this:**
```
password,manager,vault,security,encryption,autofill,biometric,secure,privacy,passwords,keychain
```

---

### 4. Support URL
**What it is:** URL where users can get support

**Options:**
- Your website support page
- GitHub issues page
- Email support page

**Example:**
```
https://www.ciphio.com/support
```

**Or if you don't have a support page:**
```
https://www.ciphio.com
```

---

### 5. Marketing URL (Optional)
**What it is:** URL to your app's marketing website

**Example:**
```
https://www.ciphio.com
```

**Or leave blank if you don't have one**

---

### 6. Version
**What it is:** Marketing version number (user-facing)

**Options:**
- `1.0.0` (for release)
- `1.0.0-beta.6` (to match Android beta)

**For beta, use:**
```
1.0.0-beta.6
```

**For release, use:**
```
1.0.0
```

---

### 7. Copyright
**What it is:** Copyright notice

**Format:**
```
Copyright © 2025 [Your Name/Company]. All rights reserved.
```

**Example:**
```
Copyright © 2025 Ciphio. All rights reserved.
```

**Or:**
```
Copyright © 2025 [Your Name]. All rights reserved.
```

---

### 8. Build
**What it is:** Select the build you uploaded

**Steps:**
1. Click "Select a build before you submit your app"
2. Choose your uploaded build
3. Build must be "Ready to Submit" status

**Note:** You need to upload a build first (from Xcode)

---

### 9. Export Compliance
**What it is:** Required if your app uses encryption

**Since you use encryption (AES):**
- ✅ **Yes, your app uses encryption**
- ✅ **Yes, it uses exempt encryption** (standard AES encryption)
- **Explanation:**
  ```
  App uses standard AES encryption (AES-GCM) for password storage, which is exempt from export compliance requirements under Category 5 Part 2.
  ```

---

### 10. App Review Information

#### Sign-In Information
**For password manager:**
- **Sign-in required:** ✅ Yes (users need to set up master password)
- **Username:** Leave blank (users create their own)
- **Password:** Leave blank (users create their own)
- **Notes:** 
  ```
  Users must set up a master password on first launch. No demo account needed.
  ```

#### Contact Information
- **First Name:** Your first name
- **Last Name:** Your last name
- **Phone Number:** Your phone number (required)
- **Email:** Your email address (required)

#### Notes (4,000 characters max)
**Optional:** Any special instructions for reviewers

**Use this:**
```
This is a password manager app. Users must set up a master password on first launch. The app uses local encryption only - no cloud sync. All data is stored locally on the device.

Key features to test:
- Master password setup
- Password entry CRUD operations
- AutoFill functionality (requires enabling in Settings)
- Biometric authentication (Face ID/Touch ID)

For AutoFill testing:
1. Enable AutoFill in Settings → Passwords → Password Options
2. Enable "Ciphio Vault" in the list
3. Test in Safari or other apps

Thank you for reviewing!
```

---

### 11. App Store Version Release

**For Beta Testing:**
- ✅ Select: **"Manually release this version"**
- This lets you control when it goes live

**For Production Release:**
- Select: **"Automatically release this version"**
- Or: **"Manually release this version"** (if you want to control timing)

**For beta, choose:**
```
Manually release this version
```

---

## Quick Fill-Out Guide

### Copy-Paste Ready:

**Promotional Text:**
```
Secure password manager with AES encryption. Master password protection, AutoFill support, and biometric authentication.
```

**Keywords:**
```
password,manager,vault,security,encryption,autofill,biometric,secure,privacy,passwords,keychain
```

**Support URL:**
```
https://www.ciphio.com
```

**Marketing URL:**
```
https://www.ciphio.com
```

**Version:**
```
1.0.0-beta.6
```

**Copyright:**
```
Copyright © 2025 Ciphio. All rights reserved.
```

**Export Compliance:**
- ✅ Uses encryption: Yes
- ✅ Exempt encryption: Yes
- **Explanation:** App uses standard AES encryption (AES-GCM) for password storage, which is exempt from export compliance requirements under Category 5 Part 2.

**App Review Notes:**
```
This is a password manager app. Users must set up a master password on first launch. The app uses local encryption only - no cloud sync. All data is stored locally on the device.

Key features to test:
- Master password setup
- Password entry CRUD operations
- AutoFill functionality (requires enabling in Settings → Passwords → Password Options)
- Biometric authentication (Face ID/Touch ID)

For AutoFill testing:
1. Enable AutoFill in Settings → Passwords → Password Options
2. Enable "Ciphio Vault" in the list
3. Test in Safari or other apps

Thank you for reviewing!
```

**Release:**
```
Manually release this version
```

---

## Important Notes

### Before Submitting:
1. ✅ Upload a build first (from Xcode)
2. ✅ Fill out all required fields
3. ✅ Complete App Privacy section
4. ✅ Add Privacy Policy URL
5. ✅ Verify screenshots are correct size

### For Beta:
- You can use shorter descriptions
- Focus on core features
- Add "Beta" to version number
- Use manual release

### For Production:
- Use full, polished descriptions
- Complete all optional fields
- Consider automatic release
- Add marketing materials

---

**Last Updated:** November 2025

