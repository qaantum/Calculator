# App Store Regulations & Permits

**Location:** App Store Connect → Your App → App Information → App Store Regulations & Permits

---

## 1. Digital Services Act

### ✅ Required Action

**Status:** You must complete this

**What it is:**
- EU regulation requiring account verification
- Must be completed to avoid payment delays or content removal in EU countries

**What to do:**
1. **Click "Set Up"** next to "Digital Services Act"
2. **Follow the verification process:**
   - Provide required business/individual information
   - Verify your identity
   - Complete any required forms

**Important:**
- ⚠️ **Must be completed** before your app can be sold in EU countries
- ⚠️ **Payment delays** may occur if not completed
- ⚠️ **Content may be removed** from sale if not verified

**Action:** ✅ **Click "Set Up" and complete the verification**

---

## 2. Vietnam Game License

### ❌ Skip This

**Status:** Not applicable

**Why:**
- Your app is a **password manager**, not a game
- This section is only for games distributed in Vietnam

**Action:** ✅ **Leave this section alone** (don't click anything)

---

## 3. App Store Server Notifications

### ❌ Skip This (Unless You Have IAP)

**Status:** Not applicable (you removed premium features)

**What it is:**
- Server notifications for in-app purchases and subscriptions
- Only needed if you have active IAP/subscriptions

**Do you need this?**
- ❌ **No** - You removed premium features
- ❌ **No** - You don't have active in-app purchases
- ❌ **No** - You don't have subscriptions

**If you add IAP later:**
- **Production Server URL:** Your server endpoint for production notifications
- **Sandbox Server URL:** Your server endpoint for testing notifications
- Used to receive purchase events (purchased, refunded, renewed, etc.)

**Action:** ✅ **Leave blank** (you don't have IAP)

---

## 4. App-Specific Shared Secret

### ❌ Skip This (Unless You Have Subscriptions)

**Status:** Not applicable (you don't have subscriptions)

**What it is:**
- Unique code for auto-renewable subscriptions
- Used to verify subscription receipts
- Only needed for subscription-based apps

**Do you need this?**
- ❌ **No** - You don't have subscriptions
- ❌ **No** - You removed premium features
- ❌ **No** - You don't have auto-renewable subscriptions

**If you add subscriptions later:**
1. **Generate the secret:**
   - App Store Connect → Your App → App-Specific Shared Secret
   - Click "Generate" to create a unique secret
   - Copy and store it securely

2. **Use it:**
   - Include in server requests to verify subscription receipts
   - Keep it private (don't commit to code repositories)

**Action:** ✅ **Leave blank** (you don't have subscriptions)

---

## Quick Checklist

- [ ] ✅ **Digital Services Act:** Click "Set Up" and complete verification (REQUIRED)
- [ ] ✅ **Vietnam Game License:** Skip (not a game)
- [ ] ✅ **App Store Server Notifications:** Leave blank (no IAP)
- [ ] ✅ **App-Specific Shared Secret:** Leave blank (no subscriptions)

---

## Summary

**Only action needed:**
1. ✅ **Complete Digital Services Act verification** (required)

**Everything else:**
- ❌ Skip (not applicable to your app)

---

## Future Considerations

### If You Add In-App Purchases Later:

**App Store Server Notifications:**
- Set up a server endpoint to receive purchase events
- Handle: `INITIAL_BUY`, `DID_RENEW`, `DID_FAIL_TO_RENEW`, `REFUND`, etc.
- Test with sandbox URL before going live

**App-Specific Shared Secret:**
- Generate when you add auto-renewable subscriptions
- Use to verify subscription receipts on your server
- Keep it secure and private

### If You Add Subscriptions Later:

1. **Create subscription products** in App Store Connect
2. **Set up server notifications** endpoint
3. **Generate app-specific shared secret**
4. **Implement receipt validation** on your server
5. **Test thoroughly** in sandbox before production

---

## References

- [Digital Services Act Information](https://developer.apple.com/support/digital-services-act/)
- [App Store Server Notifications](https://developer.apple.com/documentation/appstoreservernotifications)
- [Managing App-Specific Shared Secrets](https://developer.apple.com/help/app-store-connect/manage-app-specific-shared-secrets)

---

**Last Updated:** November 2025

