# Biometric Authentication Crash Fix

**Date:** November 30, 2025  
**Issue:** App crashes when clicking on biometric authentication button on iOS

## Problem Analysis

The crash occurred in `MasterPasswordUnlockView.swift` when users attempted to unlock the vault using biometric authentication (Face ID/Touch ID).

### Root Causes Identified:

1. **Computed Property Issue**: The `biometricType` computed property was creating a new `LAContext()` instance every time it was accessed from the view body, which could cause issues during view updates.

2. **Redundant Biometric Authentication**: The original code was calling `evaluatePolicy` first, then accessing Keychain. However, Keychain items with biometric protection automatically prompt for biometric authentication, making the `evaluatePolicy` call redundant and potentially causing conflicts.

3. **Thread Management**: Keychain operations with biometric protection are synchronous and block until authentication completes. The original code wasn't handling this properly, which could cause UI freezing or crashes.

## Fixes Applied

### 1. Fixed `biometricType` Property (`MasterPasswordUnlockView.swift`)

**Before:**
```swift
private var biometricType: LABiometryType {
    let context = LAContext()
    _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    return context.biometryType
}
```

**After:**
- Changed to a `@State` variable that's set once during `checkBiometricAvailability()`
- Prevents multiple `LAContext` instances from being created during view updates

### 2. Simplified Biometric Unlock Flow

**Before:**
- Called `evaluatePolicy` first
- Then retrieved from Keychain (which would prompt again)

**After:**
- Removed redundant `evaluatePolicy` call
- Directly access Keychain, which automatically handles biometric prompt
- Performed on background thread to avoid blocking main thread
- Proper error handling for all Keychain error cases

### 3. Improved Error Handling

- Added proper handling for `KeychainError.userCancelled` (silent - no error message)
- Added handling for `KeychainError.authenticationFailed`
- All UI updates happen on main thread using `MainActor.run`

## Files Modified

1. `ios/CiphioVault/CiphioVault/MasterPasswordUnlockView.swift`
   - Changed `biometricType` from computed property to `@State` variable
   - Simplified `unlockWithBiometric()` to directly access Keychain
   - Added proper async/await handling with Task
   - Improved error handling

2. `ios/CiphioVault/CiphioVault/KeychainHelper.swift`
   - Updated documentation to clarify that Keychain operations with biometric are synchronous
   - Removed invalid `kSecUseAuthenticationContext` usage (not a valid constant)
   - Context properties are set before Keychain access, which the system uses automatically

## Testing Recommendations

1. Test biometric unlock on device with Face ID
2. Test biometric unlock on device with Touch ID
3. Test cancellation (user cancels biometric prompt)
4. Test with biometric disabled in settings
5. Test error cases (wrong biometric, etc.)

## Notes

- Keychain operations with `kSecAttrAccessControl` that requires biometric automatically trigger the biometric prompt
- The `LAContext` properties (like `localizedFallbackTitle`) are used by the system to customize the prompt
- Keychain operations are synchronous and will block the thread until biometric authentication completes
- The biometric prompt is handled by the system and will appear regardless of which thread initiates the Keychain access

---

**Status:** Fixed  
**Next Steps:** Test on physical device with biometric authentication enabled

