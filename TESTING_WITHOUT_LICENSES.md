# Testing Premium Purchases Without Developer Licenses

**Date:** November 2025  
**Purpose:** Test premium purchase flows before getting app store licenses

---

## 🎯 Overview

You can test **most** of the premium purchase flow without licenses, but **not** the actual store transactions. Here's what you can and can't test:

### ✅ What You CAN Test (Without Licenses)
- UI flows (buttons, navigation, error messages)
- Premium state changes (mock purchases)
- Feature unlocking logic
- Error handling
- App behavior when premium is active/inactive

### ❌ What You CAN'T Test (Without Licenses)
- Real store transactions
- StoreKit/Play Billing integration
- Purchase verification
- Restore purchases from store
- Actual payment processing

---

## 🤖 Solution 1: Use Mock Premium Manager (Recommended)

### Android: Switch to MockPremiumManager

**Current Setup:**
The app uses `RealPremiumManager` in `CiphioApp.kt`. You can easily switch to `MockPremiumManager` for testing.

**How to Switch:**

1. **Option A: Build Config Flag (Best Practice)**
   ```kotlin
   // In CiphioApp.kt
   val premiumManager = remember { 
       if (BuildConfig.DEBUG) {
           com.ciphio.premium.MockPremiumManager()
       } else {
           com.ciphio.premium.RealPremiumManager(context, scope)
       }
   }
   ```

2. **Option B: Temporary Switch (Quick Test)**
   ```kotlin
   // In CiphioApp.kt, line 37
   // Change from:
   val premiumManager = remember { com.ciphio.premium.RealPremiumManager(context, scope) }
   
   // To:
   val premiumManager = remember { com.ciphio.premium.MockPremiumManager() }
   ```

**How MockPremiumManager Works:**
- ✅ `startPurchaseFlow()` immediately sets `isPremium = true`
- ✅ No actual billing calls
- ✅ Perfect for testing UI and feature unlocking
- ✅ Works offline

**Test Scenarios:**
1. Tap "Upgrade to Premium" → Should immediately become premium
2. Check premium features unlock (unlimited passwords, etc.)
3. Verify premium UI indicators show correctly
4. Test premium state persistence (restart app)

---

### iOS: Create Mock Premium Manager

**Current Setup:**
iOS uses `PremiumManager` with StoreKit. We need to create a mock version.

**Create Mock Version:**

1. **Add Build Configuration Flag**
   ```swift
   // In PremiumManager.swift, add at the top:
   #if DEBUG
   let USE_MOCK_PREMIUM = true
   #else
   let USE_MOCK_PREMIUM = false
   #endif
   ```

2. **Create MockPremiumManager**
   ```swift
   // Add to PremiumManager.swift
   #if DEBUG
   @MainActor
   class MockPremiumManager: ObservableObject {
       @Published var isPremium: Bool = false
       
       static let shared = MockPremiumManager()
       
       private init() {}
       
       func upgradeToPremium() {
           // Simulate purchase delay
           Task {
               try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
               isPremium = true
           }
       }
       
       func updatePremiumStatus() async {
           // Mock: Check if premium is set
           // In real version, this checks StoreKit
       }
   }
   #endif
   ```

3. **Switch Based on Flag**
   ```swift
   // In ContentView.swift or wherever PremiumManager is used
   #if DEBUG
   let premiumManager = USE_MOCK_PREMIUM ? MockPremiumManager.shared : PremiumManager.shared
   #else
   let premiumManager = PremiumManager.shared
   #endif
   ```

**Or Simpler: Add Toggle in Settings (For Testing)**

Add a debug toggle in Settings to manually enable premium:
```swift
#if DEBUG
Toggle("Mock Premium (Debug Only)", isOn: $mockPremium)
    .onChange(of: mockPremium) { newValue in
        PremiumManager.shared.isPremium = newValue
    }
#endif
```

---

## 🧪 Solution 2: StoreKit Configuration (iOS - Advanced)

**For iOS Only:** You can test StoreKit locally without App Store Connect.

**Steps:**

1. **Create StoreKit Configuration File**
   - In Xcode: File → New → File → StoreKit Configuration File
   - Name it `Products.storekit`
   - Add product: `com.ciphio.premium` (one-time purchase, $4.99)

2. **Enable StoreKit Testing**
   - In Xcode: Product → Scheme → Edit Scheme
   - Run → Options → StoreKit Configuration
   - Select your `Products.storekit` file

3. **Test Purchases**
   - Run app in simulator/device
   - Tap "Upgrade to Premium"
   - StoreKit will show test purchase dialog
   - Purchase succeeds immediately (no real payment)

**Limitations:**
- Only works in Xcode
- Requires StoreKit Configuration file
- Still tests real StoreKit code (good!)

---

## 🧪 Solution 3: Google Play Billing Test (Android - Advanced)

**For Android Only:** Google Play Billing Library has test mode.

**Steps:**

1. **Use Test Product IDs**
   - Google provides test product IDs: `android.test.purchased`
   - Change product ID temporarily:
   ```kotlin
   // In RealPremiumManager.kt, line 54
   private val premiumProductId = if (BuildConfig.DEBUG) {
       "android.test.purchased" // Test product
   } else {
       "com.ciphio.premium" // Real product
   }
   ```

2. **Test Purchases**
   - Build and run app
   - Tap "Upgrade to Premium"
   - Google Play will show test purchase dialog
   - Purchase succeeds immediately (no real payment)

**Requirements:**
- Must be signed with debug keystore
- Must have Google Play Services installed
- Works on emulator or device

**Limitations:**
- Only works with debug builds
- Requires Google account (can be test account)
- Still tests real billing code (good!)

---

## 📋 Recommended Testing Plan

### Phase 1: Mock Testing (Now - No License Needed)
1. ✅ Switch Android to `MockPremiumManager`
2. ✅ Create iOS `MockPremiumManager`
3. ✅ Test all premium features unlock correctly
4. ✅ Test UI flows and error handling
5. ✅ Test premium state persistence

**Time:** 1-2 hours  
**Result:** Verify all premium logic works

### Phase 2: StoreKit/Play Billing Testing (After License)
1. ✅ Set up StoreKit Configuration (iOS)
2. ✅ Test with Google Play test products (Android)
3. ✅ Test real purchase flows
4. ✅ Test restore purchases
5. ✅ Test error scenarios

**Time:** 2-3 hours  
**Result:** Verify store integration works

### Phase 3: Production Testing (After App Store Setup)
1. ✅ Test with real products in sandbox
2. ✅ Test with real products in production
3. ✅ Verify receipts/verification
4. ✅ Test on multiple devices

**Time:** 1-2 days  
**Result:** Ready for launch

---

## 🛠️ Quick Implementation: Android Mock Switch

**File:** `android/app/src/main/java/com/ciphio/ui/CiphioApp.kt`

**Change line 37:**
```kotlin
// FROM:
val premiumManager = remember { com.ciphio.premium.RealPremiumManager(context, scope) }

// TO:
val premiumManager = remember { 
    if (com.ciphio.BuildConfig.DEBUG) {
        com.ciphio.premium.MockPremiumManager()
    } else {
        com.ciphio.premium.RealPremiumManager(context, scope)
    }
}
```

**Result:**
- Debug builds → Mock (instant premium)
- Release builds → Real (actual billing)

---

## 🛠️ Quick Implementation: iOS Mock Switch

**Option 1: Simple Toggle (Easiest)**

Add to `SettingsView.swift`:
```swift
#if DEBUG
Section("Debug") {
    Toggle("Enable Premium (Testing)", isOn: Binding(
        get: { PremiumManager.shared.isPremium },
        set: { PremiumManager.shared.isPremium = $0 }
    ))
}
#endif
```

**Option 2: Automatic Mock (Better)**

Modify `PremiumManager.swift`:
```swift
@MainActor
class PremiumManager: ObservableObject {
    @Published var isPremium: Bool = false
    
    #if DEBUG
    static let useMock = true // Set to false to test real StoreKit
    #else
    static let useMock = false
    #endif
    
    // ... existing code ...
    
    func upgradeToPremium() {
        #if DEBUG
        if Self.useMock {
            // Mock: Just set premium to true
            Task {
                try? await Task.sleep(nanoseconds: 500_000_000)
                isPremium = true
            }
            return
        }
        #endif
        
        // Real StoreKit code
        Task {
            do {
                try await purchase()
            } catch {
                print("Purchase failed: \(error)")
            }
        }
    }
}
```

---

## ✅ Testing Checklist

### Mock Testing (No License)
- [ ] Switch to mock premium manager
- [ ] Test "Upgrade to Premium" button works
- [ ] Verify premium features unlock (unlimited passwords)
- [ ] Test premium UI indicators show correctly
- [ ] Test app restart (premium state persists)
- [ ] Test 10-password limit (free) vs unlimited (premium)
- [ ] Test error messages when limit reached
- [ ] Test upgrade prompts appear correctly

### StoreKit/Play Billing Testing (After License)
- [ ] Set up StoreKit Configuration (iOS)
- [ ] Test purchase flow with test products
- [ ] Test purchase cancellation
- [ ] Test purchase errors
- [ ] Test restore purchases
- [ ] Verify premium status after purchase
- [ ] Test on multiple devices

---

## 🎯 Bottom Line

**You can test 90% of premium functionality right now using mocks:**

1. **Android:** Already has `MockPremiumManager` - just switch to it
2. **iOS:** Add simple mock or debug toggle
3. **Test:** All premium features, UI flows, error handling
4. **Later:** Test real store integration after getting licenses

**Estimated Time:**
- Set up mocks: 30 minutes
- Test all scenarios: 1-2 hours
- Total: ~2 hours to fully test premium logic

**What You'll Verify:**
- ✅ Premium purchase button works
- ✅ Premium features unlock correctly
- ✅ UI shows premium status correctly
- ✅ 10-password limit enforced for free users
- ✅ Unlimited passwords for premium users
- ✅ Error messages work correctly

**What You'll Need Licenses For:**
- ❌ Real store transactions
- ❌ Purchase verification
- ❌ Restore purchases
- ❌ Production testing

---

## 🚀 Next Steps

1. **Now:** Set up mock premium managers and test
2. **After License:** Test with StoreKit/Play Billing
3. **Before Launch:** Test with real products in sandbox

This way, you can verify all the premium logic works **before** getting licenses, then just test the store integration after!

