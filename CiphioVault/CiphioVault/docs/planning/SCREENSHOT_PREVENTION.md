# Screenshot Prevention Feature

## 🎯 Overview

**Screenshot prevention** blocks users from taking screenshots of sensitive content (passwords, encrypted text, etc.). This is a standard security feature in password managers and banking apps.

---

## ✅ Should We Add It?

### Pros ✅
- **Security**: Prevents accidental exposure of passwords in screenshots
- **Privacy**: Protects sensitive data from being shared via screenshots
- **Professional**: Standard feature users expect from password managers
- **Compliance**: May help with security certifications/audits

### Cons ❌
- **Not 100% secure**: Can be bypassed (rooted/jailbroken devices, screen recording, etc.)
- **UX impact**: Some users may want to screenshot for legitimate reasons (support, documentation)
- **Platform limitations**: iOS has limited screenshot prevention capabilities
- **Development time**: Requires implementation on both platforms

### Recommendation: **YES, but selective**

**Apply to:**
- ✅ Password viewing screens (when password is visible)
- ✅ Text encryption/decryption screens (when decrypted text is shown)
- ✅ Master password entry screens

**Don't apply to:**
- ❌ Password list (no passwords visible)
- ❌ Settings screens
- ❌ Home screen (no sensitive data)

---

## 🔧 Implementation

### Android Implementation

**Method:** Use `Window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, ...)`

**Where to apply:**
1. `ViewPasswordEntryScreen` - When password is visible
2. `AddEditPasswordEntryScreen` - When editing password field
3. Text encryption screens - When showing decrypted text
4. `MasterPasswordUnlockScreen` - Master password entry

**Implementation approach:**
- Create a Composable modifier that sets FLAG_SECURE
- Apply conditionally (only when sensitive data is visible)
- Remove flag when navigating away

### iOS Implementation

**Method:** Use `UIView.isHidden` + screenshot detection (limited)

**Limitations:**
- iOS doesn't have a direct equivalent to Android's FLAG_SECURE
- Can detect screenshots but can't prevent them
- Best approach: Hide sensitive content when app goes to background

**Where to apply:**
1. `ViewPasswordEntryView` - When password is visible
2. `AddEditPasswordEntryView` - When editing password
3. Text encryption views - When showing decrypted text
4. `MasterPasswordUnlockView` - Master password entry

**Implementation approach:**
- Use `UIApplication.willResignActiveNotification` to hide sensitive content
- Use `UITextField.isSecureTextEntry` for password fields (already done)
- Show warning message about screenshot risks

---

## 📋 Implementation Plan

### Phase 1: Android (Easier)
1. Create `SecureScreen` modifier for Compose
2. Apply to password viewing screens
3. Apply to text encryption screens
4. Test on various Android versions

### Phase 2: iOS (More Limited)
1. Implement background detection
2. Hide sensitive content when app goes to background
3. Add warning messages
4. Test on various iOS versions

### Phase 3: User Settings (Optional)
- Add toggle: "Prevent Screenshots" (default: ON)
- Allow users to disable if needed
- Show warning when disabled

---

## 🎨 User Experience

### What Users Will See:
- **Android**: Screenshot attempt shows "Can't take screenshot" message
- **iOS**: Sensitive content hidden when app goes to background
- **Both**: No visual indication when feature is active (invisible security)

### Edge Cases:
- **Screen recording**: Can't prevent (but can detect on some platforms)
- **Rooted/Jailbroken devices**: Can be bypassed
- **Accessibility services**: May still capture content
- **App switcher**: May show content in recent apps (Android)

---

## 🔒 Security Considerations

### What It Protects:
- ✅ Accidental screenshots
- ✅ Casual screenshot sharing
- ✅ Screenshots in app switcher (Android, partially)

### What It Doesn't Protect:
- ❌ Screen recording
- ❌ Rooted/jailbroken devices
- ❌ Accessibility services
- ❌ Physical access to device
- ❌ Malware with screen capture

**Important:** This is a **defense-in-depth** measure, not a complete security solution.

---

## 📊 Priority

**Priority:** 🟡 **MEDIUM-HIGH**

**Why:**
- Good security practice
- Expected feature in password managers
- Relatively easy to implement (Android)
- Can be added post-beta if needed

**Timeline:**
- **Android**: 2-3 hours
- **iOS**: 4-6 hours (more limited)
- **Testing**: 2-3 hours
- **Total**: ~1 day of work

---

## 🚀 Recommendation

**Add it, but:**
1. Start with Android (easier, more effective)
2. Add iOS version (limited but better than nothing)
3. Make it optional in settings (for flexibility)
4. Add to post-beta roadmap if time is tight

**Best approach:**
- Implement Android version before beta
- Add iOS version in first post-beta update
- Make it a user preference (default ON)

---

## 📝 Next Steps

If you want to implement:

1. **Android**: I can add FLAG_SECURE to sensitive screens
2. **iOS**: I can add background detection and content hiding
3. **Settings**: Add toggle for screenshot prevention
4. **Testing**: Test on various devices and OS versions

**Would you like me to implement this now, or add it to the post-beta roadmap?**

