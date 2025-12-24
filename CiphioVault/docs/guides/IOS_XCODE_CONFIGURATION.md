# iOS Xcode Configuration Guide

**Purpose:** Complete setup guide for configuring the AutoFill Extension in Xcode  
**Target:** Beta Release Preparation

---

## Prerequisites

- Xcode 14.0 or later
- Apple Developer Account (with active license)
- iOS device for testing (simulator won't work for AutoFill)

---

## Step 1: Verify AutoFill Extension Target

### Check if Extension Target Exists

1. Open `ios/CiphioVault/Ciphio.xcodeproj` in Xcode
2. In the Project Navigator, check if you see:
   - `CiphioVault` (main app target)
   - `AutoFillExtension` (extension target) - **May be missing**
   - `CiphioVaultTests` (test target)
   - `CiphioVaultUITests` (UI test target)

### If Extension Target is Missing

The extension code exists in `ios/CiphioVault/AutoFillExtension/` but may not be added as a target. You'll need to:

1. **Add Extension Target:**
   - File → New → Target
   - Select "Credential Provider Extension"
   - Name: `AutoFillExtension`
   - Bundle Identifier: `com.ciphio.vault.AutoFillExtension`
   - Language: Swift
   - Click "Finish"

2. **Replace Generated Files:**
   - Delete the generated `CredentialProviderViewController.swift`
   - Copy files from `ios/CiphioVault/AutoFillExtension/`:
     - `CredentialProviderViewController.swift`
     - `CredentialIdentityStore.swift`
     - `Info.plist`

3. **Add Files to Target:**
   - Select the extension files
   - In File Inspector, ensure "AutoFillExtension" target is checked

---

## Step 2: Configure App Groups

### For Main App Target

1. Select `CiphioVault` target in Project Navigator
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Select **App Groups**
5. Click **+** to add new group
6. Enter: `group.com.ciphio.vault`
7. Ensure it's checked/enabled

### For AutoFill Extension Target

1. Select `AutoFillExtension` target
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Select **App Groups**
5. Click **+** to add new group
6. Enter: `group.com.ciphio.vault` (same as main app)
7. Ensure it's checked/enabled

**Important:** Both targets must use the **exact same** App Group identifier.

---

## Step 3: Configure Keychain Sharing

### For Main App Target

1. Select `CiphioVault` target
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Select **Keychain Sharing**
5. Click **+** to add new group
6. Enter: `com.ciphio.vault`
7. Ensure it's checked/enabled

### For AutoFill Extension Target

1. Select `AutoFillExtension` target
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Select **Keychain Sharing**
5. Click **+** to add new group
6. Enter: `com.ciphio.vault` (same as main app)
7. Ensure it's checked/enabled

**Important:** Both targets must use the **exact same** Keychain Access Group.

---

## Step 4: Verify Bundle Identifiers

### Main App
- **Bundle Identifier:** `com.ciphio.vault`
- **Location:** Target → General → Identity

### AutoFill Extension
- **Bundle Identifier:** `com.ciphio.vault.AutoFillExtension`
- **Location:** Target → General → Identity

### Test Targets
- **CiphioVaultTests:** `com.ciphio.vault.CiphioVaultTests`
- **CiphioVaultUITests:** `com.ciphio.vault.CiphioVaultUITests`

---

## Step 5: Configure Build Settings

### Deployment Target

1. Select project in Project Navigator
2. Select **CiphioVault** target
3. Go to **Build Settings** tab
4. Search for "iOS Deployment Target"
5. Set to **iOS 15.0** (or your minimum version)

Repeat for **AutoFillExtension** target.

### Code Signing

1. Select target
2. Go to **Signing & Capabilities** tab
3. Check **"Automatically manage signing"**
4. Select your **Team** (Apple Developer account)
5. Xcode will automatically create provisioning profiles

**Important:** Ensure both main app and extension are signed with the same team.

---

## Step 6: Verify Info.plist Configuration

### AutoFill Extension Info.plist

Location: `ios/CiphioVault/AutoFillExtension/Info.plist`

Verify it contains:
```xml
<key>NSExtension</key>
<dict>
    <key>NSExtensionAttributes</key>
    <dict>
        <key>ASCredentialProviderExtensionCapabilities</key>
        <dict>
            <key>ProvidesPasswords</key>
            <true/>
        </dict>
    </dict>
    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.authentication-services-credential-provider-ui</string>
    <key>NSExtensionPrincipalClass</key>
    <string>$(PRODUCT_MODULE_NAME).CredentialProviderViewController</string>
</dict>
```

---

## Step 7: Verify Shared Code Access

### Check SharedConstants.swift

Location: `ios/CiphioVault/CiphioVault/Shared/SharedConstants.swift`

Verify App Group identifier:
```swift
static let appGroupIdentifier = "group.com.ciphio.vault"
```

### Add Shared Files to Extension Target

1. Select `SharedConstants.swift` in Project Navigator
2. In File Inspector, check **AutoFillExtension** target
3. Repeat for any other shared files needed by extension

---

## Step 8: Build and Test

### Build Project

1. Select **Any iOS Device** or your connected device
2. Product → Clean Build Folder (⇧⌘K)
3. Product → Build (⌘B)
4. Verify no build errors

### Test on Device

1. Connect iOS device via USB
2. Select device in Xcode
3. Product → Run (⌘R)
4. App should install and launch

### Verify AutoFill Extension

1. On device, go to **Settings → Passwords → Password Options**
2. Under **"Allow Filling From"**, you should see **"Ciphio Vault"**
3. Enable it if not already enabled

---

## Step 9: Troubleshooting

### Build Errors

**Error: "No such module 'AuthenticationServices'"**
- Solution: Ensure `import AuthenticationServices` is present
- Verify deployment target is iOS 12.0+

**Error: "App Groups entitlement missing"**
- Solution: Re-add App Groups capability
- Verify both targets have the same App Group identifier

**Error: "Keychain Sharing entitlement missing"**
- Solution: Re-add Keychain Sharing capability
- Verify both targets have the same Keychain Access Group

### Runtime Errors

**AutoFill doesn't appear in Settings**
- Solution: Ensure extension target is included in archive
- Verify Info.plist is correct
- Rebuild and reinstall app

**Extension can't access shared data**
- Solution: Verify App Groups are configured identically
- Check that `UserDefaults(suiteName:)` uses correct identifier
- Verify shared files are added to extension target

---

## Step 10: Archive for TestFlight

### Create Archive

1. Select **Any iOS Device** (not simulator)
2. Product → Archive
3. Wait for archive to complete

### Distribute to TestFlight

1. Window → Organizer (⇧⌘2)
2. Select your archive
3. Click **Distribute App**
4. Select **App Store Connect**
5. Follow the wizard to upload

---

## Verification Checklist

- [ ] AutoFill Extension target exists
- [ ] App Groups capability added to both targets
- [ ] Keychain Sharing capability added to both targets
- [ ] App Group identifier matches: `group.com.ciphio.vault`
- [ ] Keychain Access Group matches: `com.ciphio.vault`
- [ ] Bundle identifiers are correct
- [ ] Code signing is configured
- [ ] Project builds without errors
- [ ] App runs on device
- [ ] AutoFill appears in Settings
- [ ] Extension can access shared data

---

## Quick Reference

### Identifiers
- **App Group:** `group.com.ciphio.vault`
- **Keychain Group:** `com.ciphio.vault`
- **Main Bundle ID:** `com.ciphio.vault`
- **Extension Bundle ID:** `com.ciphio.vault.AutoFillExtension`

### File Locations
- Extension Code: `ios/CiphioVault/AutoFillExtension/`
- Shared Constants: `ios/CiphioVault/CiphioVault/Shared/SharedConstants.swift`
- Extension Info.plist: `ios/CiphioVault/AutoFillExtension/Info.plist`

---

**Last Updated:** November 2025

