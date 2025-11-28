# Ciphio Company Export Package

**What to Extract for Company-Wide Use**

---

## 🎨 Brand Assets (Export These)

### Logo Files
- ✅ `Ciphio_CompanyLogo.svg` - **Parent brand logo** (use everywhere)
- ✅ `Ciphio_Vault_Logo.svg` - **App logo template** (pattern for future apps)
- ✅ `Ciphio_Wordmark.svg` - **Text-only version** (for small spaces)

### Brand Guidelines to Create
1. **Color Palette** (extract from code):
   - Background: `#1D2440` (Deep Indigo)
   - Primary Accent: `#4ED6FF` (Soft Cyan)
   - Text/Shapes: `#F5F7FB` (Mist White)
   - Secondary: `#0F1626` (Dark Blue)

2. **Typography**:
   - Font: Arial, Helvetica, sans-serif
   - Weight: Bold for logos
   - Size: Scalable (220px base for logos)

3. **Design Elements**:
   - Cyan vertical bars (signature brand mark)
   - Glow effects (stdDeviation: 12-14)
   - Rounded corners (rx values)

---

## 💻 Reusable Code Components

### 1. Crypto Service (Cross-Platform Compatible)
**Location:** 
- Android: `android/app/src/main/java/com/ciphio/crypto/CryptoService.kt`
- iOS: `ios/Ciphio/Ciphio/CryptoService.swift`

**What it does:**
- AES-256 encryption (GCM, CBC, CTR modes)
- PBKDF2 key derivation (100,000 iterations)
- Cross-platform compatible format
- Can be used in any Ciphio app

**Export:** Copy both files → Create `ciphio-crypto` shared library

---

### 2. Premium Manager Pattern
**Location:**
- Android: `android/app/src/main/java/com/ciphio/premium/PremiumManager.kt`
- iOS: `ios/Ciphio/Ciphio/PremiumManager.swift`

**What it does:**
- In-app purchase abstraction
- Mock mode for testing
- Premium state management
- Works with Google Play Billing & StoreKit

**Export:** Copy pattern → Use in all premium apps

---

### 3. MVVM Architecture Pattern
**Pattern:**
- ViewModel with StateFlow/State
- Repository pattern for data
- Clean separation of concerns
- Works on both platforms

**Export:** Use as template for new apps

---

### 4. Navigation Patterns
**Android:** Navigation Compose with state-based routing
**iOS:** NavigationStack with conditional views

**Export:** Document patterns → Use as standard

---

## 📐 Design System

### Extract from `UNIFIED_DESIGN_SYSTEM.md`:
- Color tokens
- Spacing system (4/8/12/16/24dp)
- Typography scale
- Component patterns (buttons, cards, chips)
- Platform adaptations

**Export:** Create `Ciphio_DesignSystem.md` for company use

---

## 📚 Documentation Templates

### 1. App Store Submission Guide
**File:** `APP_STORE_GUIDE.md`
- iOS App Store checklist
- Google Play checklist
- Screenshot requirements
- Description templates

**Export:** Use as template for all apps

---

### 2. Release Preparation
**File:** `RELEASE_PREPARATION.md`
- Pre-launch checklist
- Testing procedures
- Submission workflow

**Export:** Standardize for all apps

---

### 3. Architecture Documentation
**Files:** `PROJECT_SUMMARY.md`, `CODEBASE_REVIEW_REPORT.md`
- Architecture patterns
- Code organization
- Best practices

**Export:** Company-wide standards

---

## 🏗️ Infrastructure Patterns

### 1. Data Storage Pattern
- Android: DataStore Preferences (encrypted)
- iOS: UserDefaults (encrypted)
- Keychain/Keystore integration

**Export:** Standard storage pattern for all apps

---

### 2. Biometric Authentication Pattern
- Android: `BiometricHelper.kt`, `KeystoreHelper.kt`
- iOS: `KeychainHelper.swift`
- Cross-platform biometric unlock

**Export:** Reusable biometric components

---

### 3. Error Handling Pattern
- Consistent error types
- User-friendly messages
- Logging patterns

**Export:** Standard error handling

---

## 📦 Recommended Export Structure

```
ciphio-company-assets/
├── branding/
│   ├── logos/
│   │   ├── Ciphio_CompanyLogo.svg
│   │   ├── Ciphio_Vault_Logo.svg
│   │   └── Ciphio_Wordmark.svg
│   ├── colors/
│   │   └── brand-colors.json
│   └── guidelines/
│       └── Ciphio_BrandGuidelines.md
│
├── code/
│   ├── crypto/
│   │   ├── CryptoService.kt (Android)
│   │   └── CryptoService.swift (iOS)
│   ├── premium/
│   │   ├── PremiumManager.kt (Android)
│   │   └── PremiumManager.swift (iOS)
│   └── patterns/
│       ├── MVVM_Template.md
│       └── Navigation_Patterns.md
│
├── design-system/
│   ├── Ciphio_DesignSystem.md
│   ├── components/
│   └── tokens/
│
└── documentation/
    ├── App_Store_Template.md
    ├── Release_Checklist.md
    └── Architecture_Standards.md
```

---

## 🎯 Quick Export Checklist

### Brand Assets
- [ ] Copy all SVG logo files
- [ ] Extract color palette to JSON/design tokens
- [ ] Create brand guidelines document

### Code Components
- [ ] Extract CryptoService (both platforms)
- [ ] Extract PremiumManager pattern
- [ ] Document MVVM architecture pattern
- [ ] Extract biometric helpers

### Documentation
- [ ] Copy design system documentation
- [ ] Copy app store submission guides
- [ ] Copy release preparation templates
- [ ] Extract architecture patterns

### Design System
- [ ] Export color tokens
- [ ] Export spacing system
- [ ] Export typography scale
- [ ] Export component patterns

---

## 💡 Usage Across Apps

### For Ciphio Spend (Future):
- Use `Ciphio_CompanyLogo.svg` as base
- Add financial symbol instead of vault
- Use same crypto service
- Use same premium manager pattern
- Follow same design system

### For Ciphio Calc (Future):
- Use `Ciphio_CompanyLogo.svg` as base
- Add calculator symbol instead of vault
- Use same design tokens
- Follow same architecture patterns

---

**Last Updated:** November 2025

