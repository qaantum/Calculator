# Monetization Strategy for Ciphio (Updated)

## 🎯 Current Strategy: Beta Phase (Growth First)

**Goal:** Build user base, gather feedback, and establish trust.
**Model:** **Free + Optional Donations**

### Why this approach?
1.  **Trust:** Critical for a new security app. "Free" lowers the barrier to entry.
2.  **Feedback:** We need users to test features (like the new Password Manager) without paywalls blocking them.
3.  **Simplicity:** Avoids complex "grandfathering" logic for now (though we will plan for it).

### Implementation Details
- **All Features Unlocked:**
    - Unlimited History
    - Export/Import
    - Password Generator
    - Biometrics
- **Monetization:**
    - "Support Development" button in Settings.
    - Consumable IAPs: "Coffee" ($1.99), "Lunch" ($4.99), "Server Time" ($9.99).

---

## 🔮 Future Strategy: Post-Beta (1-2 Months)

**Goal:** Sustainable revenue.
**Model:** **Freemium + One-Time Purchase ($2.99 - $4.99)**

### The Plan
1.  **Transition:** Announce the end of Beta 2 weeks in advance.
2.  **Grandfathering:** Any user who installed *during* Beta gets "Premium" for free (lifetime).
    - *Technical:* Store a `first_install_date` or `is_beta_user` flag in Keychain/Keystore.
3.  **New Users (Post-Beta):**
    - **Free:** 25 Password limit, 10 History limit.
    - **Premium ($2.99):** Unlimited everything.

### Future Premium Features
- **Cloud Sync:** (Requires backend cost -> Subscription model?)
- **File Encryption:** (High value -> Premium)
- **Biometric Unlock:** (Standard Premium feature)

---

## 📊 Competitor Pricing Context

| App | Model | Price |
|-----|-------|-------|
| **SafeInCloud** | One-time | $4.99 |
| **Enpass** | One-time/Sub | $79.99 lifetime / $2/mo |
| **Bitwarden** | Freemium | $10/year |
| **Minimalist** | Freemium | ~$20 lifetime |
| **Ciphio (Planned)** | One-time | **$2.99** (Aggressive entry pricing) |
