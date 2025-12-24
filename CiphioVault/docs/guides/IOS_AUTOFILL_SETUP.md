# iOS Autofill Setup Guide

## Overview

Ciphio Vault includes an AutoFill extension that allows you to automatically fill passwords in Safari and other apps. This guide explains how to enable and use it.

---

## ✅ Prerequisites

1. **Real iOS Device Required**: AutoFill extensions **do not work on the iOS Simulator**. You must test on a physical iPhone or iPad.

2. **iOS Version**: iOS 12.0 or later

3. **App Installed**: The Ciphio Vault app must be installed on your device

---

## 🔧 Enabling AutoFill in iOS Settings

### Step 1: Open iOS Settings

1. Open the **Settings** app on your iPhone/iPad

2. Scroll down and tap **Passwords**

3. Tap **Password Options**

### Step 2: Enable AutoFill Passwords

1. Make sure **AutoFill Passwords** is turned **ON** (green toggle)

2. Under **Allow Filling From**, you should see **Ciphio Vault** listed

3. Make sure **Ciphio Vault** is **checked/enabled**

### Step 3: Verify Setup

The AutoFill extension is now enabled! When you visit a website or app with login fields, iOS will show Ciphio Vault as an option for autofill.

---

## 📱 Using AutoFill

### In Safari or Other Apps

1. Navigate to a website or app with login fields

2. Tap on the username or password field

3. iOS will show a keyboard suggestion bar with **"Passwords"** option

4. Tap **"Passwords"** or look for the key icon

5. Select **Ciphio Vault** from the list

6. Authenticate with Face ID, Touch ID, or your master password

7. Select the credential you want to use

8. The username and password will be automatically filled

### Saving New Passwords

When you log in to a website with credentials that aren't saved:

1. After successful login, iOS may show a prompt: **"Save Password in Ciphio Vault?"**

2. Tap **"Save Password"** to add it to your vault

3. The credential will be automatically registered for future autofill

---

## 🔐 Authentication

When using AutoFill, you'll need to authenticate:

- **Face ID** (iPhone X and later)
- **Touch ID** (iPhone 8 and earlier, iPad with Touch ID)
- **Master Password** (fallback if biometrics fail)

**Note**: Biometric authentication is required for security. You cannot bypass this step.

---

## 🐛 Troubleshooting

### AutoFill Not Appearing

1. **Check Settings**: Go to Settings → Passwords → Password Options
   - Ensure "AutoFill Passwords" is ON
   - Ensure "Ciphio Vault" is enabled

2. **Restart Device**: Sometimes a restart helps iOS recognize the extension

3. **Reinstall App**: Uninstall and reinstall Ciphio Vault if the extension isn't showing

4. **Check Credentials**: Make sure you have saved passwords in Ciphio Vault
   - Open Ciphio Vault app
   - Go to Password Manager tab
   - Verify you have entries saved

5. **Check Website**: Some websites don't support AutoFill
   - Try a different website (e.g., apple.com, google.com)
   - Make sure the website uses standard HTML form fields

### Credentials Not Matching

AutoFill matches credentials based on:
- **Domain/URL**: The website URL must match the service name you saved
- **Username**: The username field must match

**Tips**:
- When saving a password, use the full website URL (e.g., "https://example.com")
- Make sure the service name matches the website domain

### Biometric Not Working

**On Simulator**: Biometric authentication doesn't work on iOS Simulator. Use a real device.

**On Real Device**:
- Go to Settings → Face ID & Passcode (or Touch ID & Passcode)
- Make sure Face ID/Touch ID is set up
- Try unlocking the device with biometrics first
- If it still doesn't work, use master password as fallback

---

## 📋 Technical Details

### How It Works

1. **Credential Registration**: When you add or update a password in Ciphio Vault, it's automatically registered with iOS's `ASCredentialIdentityStore`

2. **System Integration**: iOS maintains a database of registered credentials from all password managers

3. **AutoFill Trigger**: When you tap a login field, iOS checks all registered credentials and shows matching ones

4. **Authentication**: Before providing credentials, Ciphio Vault requires biometric or master password authentication

5. **Credential Selection**: You can choose which credential to use if multiple match

### Extension Architecture

- **Main App**: `CiphioVault` - The main password manager app
- **Extension**: `AutoFillExtension` - The credential provider extension
- **Shared Data**: Uses App Groups and Keychain Sharing to share data between app and extension

---

## ✅ Verification Checklist

- [ ] App installed on real iOS device (not simulator)
- [ ] Settings → Passwords → Password Options → AutoFill Passwords is ON
- [ ] Settings → Passwords → Password Options → Ciphio Vault is enabled
- [ ] At least one password saved in Ciphio Vault
- [ ] Tested on a website with login fields
- [ ] AutoFill option appears when tapping login field
- [ ] Authentication works (Face ID/Touch ID or master password)
- [ ] Credentials are filled correctly

---

## 🎯 Next Steps

Once AutoFill is working:

1. **Add More Passwords**: The more passwords you save, the more useful AutoFill becomes

2. **Organize Credentials**: Use categories and notes to keep your passwords organized

3. **Update Passwords**: When you change a password, update it in Ciphio Vault so AutoFill uses the new one

4. **Test on Multiple Sites**: Try AutoFill on different websites to ensure it works everywhere

---

## 📚 Related Documentation

- [Autofill Implementation Summary](../AUTOFILL_IMPLEMENTATION_SUMMARY.md)
- [iOS Setup Guide](../ios/SETUP.md)
- [Password Manager Guide](../password-manager/README.md)

---

## 💡 Tips

- **Service Names**: Use full URLs (e.g., "https://example.com") for better matching
- **Multiple Accounts**: You can save multiple credentials for the same website
- **Security**: Always use a strong master password
- **Backup**: Export your passwords regularly as a backup

---

**Last Updated**: November 2025

