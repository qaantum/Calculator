# Issue: Fix Deprecation Warning in PremiumManager

**Type:** Bug Fix  
**Labels:** bug, refactor  
**Related Commit:** 392118e

## Description

Fixed deprecation warning in `PremiumManager.kt` by removing the deprecated `enablePendingPurchases()` method call from the BillingClient builder.

## What Changed

- Removed `enablePendingPurchases()` call from `BillingClient.newBuilder()`
- This method is deprecated in Billing Library 7.1.1
- Pending purchases are now enabled by default, making this call unnecessary

## Technical Details

**File:** `android/app/src/main/java/com/ciphio/vault/premium/PremiumManager.kt`

**Before:**
```kotlin
private val billingClient = BillingClient.newBuilder(context)
    .setListener(this)
    .enablePendingPurchases()  // ❌ Deprecated
    .build()
```

**After:**
```kotlin
private val billingClient = BillingClient.newBuilder(context)
    .setListener(this)
    .build()  // ✅ Clean
```

## Impact

- ✅ Build now completes without deprecation warnings
- ✅ Code is updated to use current Billing Library best practices
- ✅ No functional changes - behavior remains the same

## Verification

Build completed successfully:
```
BUILD SUCCESSFUL in 43s
39 actionable tasks: 16 executed, 23 up-to-date
```

## Related

- Commit: 392118e - "Fix deprecation warning: Remove enablePendingPurchases() from BillingClient"
- Billing Library Version: 7.1.1

