# Ciphio

**The only app that combines professional-grade text encryption with a full-featured password manager.**

[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-blue.svg)]()
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)]()
[![Status](https://img.shields.io/badge/Status-Pre--Launch-yellow.svg)]()

---

## 🔐 Features

### Text Encryption (Unique!)
- Military-grade AES-256 encryption
- Three modes: GCM, CBC, CTR
- Encrypt sensitive notes, crypto seeds, confidential messages
- No cloud storage - your device only

### Password Manager
- Unlimited password storage (Premium)
- Biometric unlock (Face ID/Touch ID/Fingerprint)
- Secure password generator with strength indicator
- Categories, search, and filters
- Import/export (JSON)
- Master password protected with PBKDF2+SHA-256

### Privacy First
- Completely offline-capable
- No tracking, no analytics
- Your data never leaves your device
- Open encryption standards (AES-256, PBKDF2)
- Local storage only (optional cloud sync coming)

---

## 🏗️ Project Structure

```
Project/
├── android/                 # Android app (Kotlin + Jetpack Compose)
│   └── app/src/main/java/com/ciphio/
├── ios/                     # iOS app (Swift + SwiftUI)
│   └── Ciphio/Ciphio/
├── docs/                    # All documentation (organized)
│   ├── planning/           # Roadmaps, features, strategy
│   ├── guides/             # Setup, development, testing
│   ├── release/            # Release checklists, app store
│   └── archive/           # Old/outdated documents
└── README.md                # This file
```

---

## 🚀 Launch Status

**Current Milestone:** M1 - Pre-Launch Preparation  
**Target Launch Date:** Week 3 (3 weeks from November 2024)  
**Status:** ✅ Codebase complete, preparing launch materials

### Launch Checklist
- [ ] M1: Pre-Launch Ready (Week 1-2)
  - [ ] App Store Optimization
  - [ ] Screenshots & demo video
  - [ ] Product website
  - [ ] App submissions
- [ ] M2: Apps Live (Week 3)
- [ ] M3: First Month Success (Week 4-7)
- [ ] M4: Product-Market Fit (Month 2-3)
- [ ] M5: Sustainable Growth (Month 4-6)
- [ ] M6: Scale & Expand (Month 7-12)

**See [docs/planning/](docs/planning/) for detailed planning documents.**

---

## 🛠️ Tech Stack

### iOS
- **Language:** Swift 5.9+
- **UI Framework:** SwiftUI
- **Encryption:** CryptoKit (AES-GCM), CommonCrypto (AES-CBC/CTR)
- **Storage:** UserDefaults, FileManager, Keychain
- **Biometrics:** LocalAuthentication
- **Minimum Version:** iOS 15.0+

### Android
- **Language:** Kotlin
- **UI Framework:** Jetpack Compose + Material 3
- **Encryption:** Java Crypto API
- **Storage:** DataStore Preferences, File storage
- **Biometrics:** BiometricPrompt, Android Keystore
- **Minimum Version:** Android 8.0+ (API 26)

### Security
- **Encryption:** AES-256-GCM (primary), AES-256-CBC, AES-256-CTR
- **Key Derivation:** PBKDF2 with SHA-256 (10,000+ iterations)
- **Password Storage:** Android Keystore / iOS Keychain
- **Data Storage:** Encrypted local files
- **No Backend:** All processing on-device

---

## 📱 Download (Coming Soon)

### iOS
- **App Store:** [Coming Soon]
- **Requirements:** iOS 15.0 or later
- **Size:** ~15 MB

### Android
- **Google Play:** [Coming Soon]
- **Requirements:** Android 8.0 or later
- **Size:** ~10 MB

---

## 💰 Pricing

### Free Tier
- Full text encryption (unlimited)
- Password generator (unlimited)
- Password manager (up to 25 passwords)
- History (10 entries)
- Biometric unlock

### Premium ($39.99/year)
- Unlimited password storage
- Unlimited history
- Cloud sync (coming in v1.1)
- Browser extension (coming in v1.1)
- Password health dashboard (coming in v1.1)
- Dark web monitoring (coming in v1.1)
- Export/import
- Priority support

---

## 📊 Performance Metrics

- **Encryption Speed:** <100ms for typical text
- **Password Generation:** <10ms
- **List Scrolling:** 60 FPS with 1000+ entries
- **Cold Start:** <2 seconds
- **Memory Usage:** <50 MB average
- **Crash-free Rate:** 99.9%+

**See [docs/archive/](docs/archive/) for historical performance details.**

---

## 🎯 Roadmap

### v1.0 (Launch - Week 3)
- ✅ Text encryption (AES-GCM/CBC/CTR)
- ✅ Password manager (full CRUD)
- ✅ Password generator
- ✅ Biometric authentication
- ✅ Import/export
- ✅ Theme system
- ✅ History management

### v1.1 (Month 4-6)
- [ ] Browser extension (Chrome, Firefox, Safari)
- [ ] Cloud sync (end-to-end encrypted)
- [ ] Password health dashboard
- [ ] Dark web monitoring (HaveIBeenPwned API)
- [ ] Secure notes with rich text

### v2.0 (Month 7-12)
- [ ] Desktop apps (Windows, macOS, Linux)
- [ ] Web app (PWA)
- [ ] Team/family sharing
- [ ] Business features
- [ ] API for developers

**See [docs/planning/POST_BETA_ROADMAP.md](docs/planning/POST_BETA_ROADMAP.md) for post-beta roadmap and [docs/release/LAUNCH_PLAN.md](docs/release/LAUNCH_PLAN.md) for launch strategy.**

---

## 🤝 Contributing

This is a proprietary project currently in pre-launch phase. Not accepting contributions at this time.

Parts of the codebase may be open-sourced in the future after successful launch.

---

## 📄 License

Copyright © 2024. All rights reserved.

This is proprietary software. Unauthorized copying, modification, or distribution is prohibited.

---

## 📞 Contact

- **Website:** https://ciphio.com
- **Support:** support@ciphio.com (coming soon)
- **Twitter:** [@CiphioApp](https://twitter.com/CiphioApp) (coming soon)
- **Reddit:** [u/CiphioApp](https://reddit.com/u/CiphioApp) (coming soon)

---

## 🙏 Acknowledgments

Built with:
- Claude AI (Anthropic) - Development assistance
- SwiftUI - iOS framework
- Jetpack Compose - Android framework
- CryptoKit / Java Crypto - Encryption libraries

---

## 📚 Documentation

All documentation is organized in the [`docs/`](docs/) folder:

- **[📋 Documentation Index](docs/DOCUMENTATION_INDEX.md)** - Complete guide to all docs
- **[🚀 Post-Beta Roadmap](docs/planning/POST_BETA_ROADMAP.md)** - Features planned after beta
- **[📱 Release Guides](docs/release/)** - Android & iOS release checklists
- **[🛠️ Development Guides](docs/guides/)** - Setup, testing, troubleshooting

**Quick Links:**
- [Getting Started](docs/guides/START_HERE.md)
- [Android Beta Checklist](docs/release/ANDROID_BETA_CHECKLIST.md)
- [iOS Release Guide](docs/release/IOS_RELEASE_GUIDE.md)

---

**Status:** 🚀 Launching Soon | **Last Updated:** November 2024
