# Export Compliance Guide for Ciphio Vault

**Date:** December 2024  
**Reference:** [BIS Encryption Controls](https://www.bis.gov/learn-support/encryption-controls)

---

## Overview

Ciphio Vault uses encryption for:
1. **Text Encryption:** AES-GCM, AES-CBC, AES-CTR (256-bit keys)
2. **Password Storage:** AES-GCM encryption (256-bit keys)
3. **Key Derivation:** PBKDF2-HMAC-SHA256 (100,000 iterations)
4. **Libraries:** Standard platform APIs (Java Cryptography Extension, CryptoKit, CommonCrypto) + BouncyCastle (standard library)

According to BIS regulations, apps using encryption fall under **Category 5, Part 2** of the Export Administration Regulations (EAR).

## ✅ Encryption Compliance Check

### All Algorithms Used Are PERMITTED ✅

**Symmetric Encryption:**
- ✅ **AES-GCM** - Standard algorithm, permitted
- ✅ **AES-CBC** - Standard algorithm, permitted  
- ✅ **AES-CTR** - Standard algorithm, permitted
- ✅ **Key Length: 256-bit** - Standard, permitted

**Key Derivation:**
- ✅ **PBKDF2** - Standard algorithm, permitted
- ✅ **HMAC-SHA256** - Standard hash function, permitted
- ✅ **100,000 iterations** - Standard parameter, permitted

**Cryptographic Libraries:**
- ✅ **Java Cryptography Extension (JCE)** - Standard platform API, permitted
- ✅ **BouncyCastle** - Standard open-source cryptographic library, permitted
- ✅ **CryptoKit (iOS)** - Standard platform API, permitted
- ✅ **CommonCrypto (iOS)** - Standard platform API, permitted

**Platform Security:**
- ✅ **Android Keystore** - Standard platform API, permitted
- ✅ **iOS Keychain** - Standard platform API, permitted

### ❌ NOT Using Any Restricted Encryption

Your app does **NOT** use:
- ❌ Non-standard algorithms
- ❌ Custom encryption implementations
- ❌ Military/classified algorithms
- ❌ Algorithms that bypass security
- ❌ Elliptic curve cryptography (ECC) - Not used, but would be permitted if used
- ❌ RSA or other asymmetric encryption - Not used, but would be permitted if used

### ✅ Conclusion: FULLY COMPLIANT

**All encryption used in Ciphio Vault is standard, publicly available, and fully permitted under License Exception ENC (Mass Market).**

---

## Good News: License Exception ENC Applies

Most consumer encryption apps qualify for **License Exception ENC (Section 740.17)**, which allows export to most destinations without a license, provided you:

1. ✅ **Classify your app correctly**
2. ✅ **Submit required reports** (if applicable)
3. ✅ **Answer Google Play Console questions accurately**

---

## What You Need to Do in Google Play Console

### Step 1: Answer Encryption Questions

When uploading your app, Google Play Console will ask:

**Question 1: "Does your app use encryption?"**
- **Answer: YES** ✅
- Ciphio Vault uses AES encryption for text and password storage

**Question 2: "Does your app use encryption for purposes other than authentication, digital signatures, decryption of data or files, or copy protection?"**
- **Answer: YES** ✅
- Your app uses encryption for general-purpose text encryption and password storage

**Question 3: "Does your app use standard encryption algorithms?"**
- **Answer: YES** ✅
- AES-GCM, AES-CBC, AES-CTR are all standard algorithms

**Question 4: "Is your app available to the general public?"**
- **Answer: YES** ✅
- It's a consumer app on Google Play

**Question 5: "Does your app use encryption that is exempt from classification?"**
- **Answer: YES** ✅ (for most cases)
- Standard encryption for general-purpose use is typically exempt

---

## Classification: Category 5, Part 2

### Your App's Classification

**Category:** 5A002.a.1 (Information Security - Cryptographic Information Security)

**Key Points:**
- ✅ Uses standard encryption (AES)
- ✅ General-purpose encryption (not restricted)
- ✅ Available to general public
- ✅ Uses standard cryptographic libraries

**Classification Result:** Likely **5D992.c** (mass market encryption software) or eligible for **License Exception ENC**

---

## License Exception ENC Requirements

### ✅ What You Likely Qualify For:

**ENC - Mass Market (740.17(b)(3)):**
- Apps using standard encryption
- Available to general public
- No restrictions on end-users
- **No reporting required** for most cases

**ENC - Retail (740.17(b)(2)):**
- Consumer encryption products
- Standard algorithms
- **May require annual self-classification report** (if applicable)

---

## Required Actions

### 1. Self-Classification Report (If Required)

**When Required:**
- If your app uses encryption for purposes beyond authentication/copy protection
- If you're exporting to certain countries
- **Most consumer apps: NOT REQUIRED** if using standard encryption

**If Required:**
- Submit to: `enc@bis.doc.gov` and `encsupport@nsa.gov`
- Include: App name, encryption description, classification
- Format: Email with specific subject line
- **Deadline:** Within 30 days of first export

**For Ciphio Vault:** Likely **NOT REQUIRED** because:
- ✅ Uses standard encryption (AES)
- ✅ General-purpose consumer app
- ✅ No restricted end-users
- ✅ Available to general public

### 2. Google Play Console Declaration

**What to Declare:**
1. ✅ App uses encryption
2. ✅ Uses standard encryption algorithms
3. ✅ General-purpose encryption
4. ✅ Available to general public
5. ✅ No restricted end-users

**Declaration Text (Suggested):**
```
Ciphio Vault uses AES-256 encryption (GCM, CBC, CTR modes) for:
- Text encryption/decryption (user data)
- Password storage (encrypted vault)

Key derivation: PBKDF2-HMAC-SHA256 (100,000 iterations)
Encryption libraries: Standard platform libraries (Android Keystore, iOS Keychain)

Classification: 5D992.c (Mass Market Encryption Software)
License Exception: ENC - Mass Market (740.17(b)(3))
```

---

## What NOT to Worry About

### ❌ You DON'T Need:
- Individual export licenses (for most countries)
- Pre-export review
- Technical support documentation
- Source code submission
- Detailed technical specifications

### ✅ You DO Need:
- Accurate answers in Google Play Console
- Proper classification
- Compliance with License Exception ENC terms

---

## Countries & Restrictions

### ✅ Can Export To (Most Countries):
- All EU countries
- Most developed countries
- Consumer markets worldwide

### ⚠️ May Need License For:
- Certain embargoed countries (Cuba, Iran, North Korea, Syria, etc.)
- **Google Play handles this automatically** - these countries are typically blocked by Google

---

## Practical Steps for Google Play Console

### 1. During App Upload

When you see encryption questions:

1. **"Does your app use encryption?"** → **YES**
2. **"Purpose of encryption?"** → Select "General-purpose encryption" or "Data protection"
3. **"Encryption algorithms?"** → Select "AES" or "Standard algorithms"
4. **"Key length?"** → Select "256-bit" or "128-bit or higher"
5. **"Available to public?"** → **YES**

### 2. Export Compliance Form

Google Play may ask you to fill an export compliance form:

**Section 1: Encryption Description**
```
Ciphio Vault uses AES-256 encryption for:
- Encrypting/decrypting user text data
- Securely storing passwords in encrypted vault

Algorithms: AES-GCM, AES-CBC, AES-CTR (256-bit keys)
Key Derivation: PBKDF2-HMAC-SHA256 (100,000 iterations)
```

**Section 2: Classification**
```
Category: 5D992.c (Mass Market Encryption Software)
License Exception: ENC - Mass Market (740.17(b)(3))
```

**Section 3: End-Users**
```
General public / Consumer app
No restricted end-users
```

### 3. After Submission

- ✅ Google will review your answers
- ✅ Most apps are approved automatically
- ✅ If questions arise, Google will contact you
- ✅ Approval typically takes 1-3 business days

---

## iOS App Store

**Note:** Apple App Store has similar requirements but handles it differently:

1. **Export Compliance:** Answer "YES" to encryption question
2. **Encryption Type:** Select "App uses encryption but is exempt"
3. **Reason:** "Uses standard encryption for data protection"

Apple typically approves automatically for standard encryption apps.

---

## Resources

- **BIS Encryption Controls:** https://www.bis.gov/learn-support/encryption-controls
- **License Exception ENC:** Section 740.17 of EAR
- **Google Play Help:** Search "encryption export compliance"
- **BIS Email:** `enc@bis.doc.gov` (for questions)

---

## Summary

### ✅ For Ciphio Vault:

1. **Classification:** 5D992.c (Mass Market Encryption Software)
2. **License Exception:** ENC - Mass Market (740.17(b)(3))
3. **Reporting:** Likely NOT REQUIRED (standard encryption, consumer app)
4. **Google Play:** Answer questions accurately, declare encryption use
5. **Result:** Should be approved automatically

### 🎯 Action Items:

1. ✅ Answer encryption questions in Google Play Console
2. ✅ Declare encryption use accurately
3. ✅ Select "Mass Market" or "Standard Encryption" options
4. ✅ Wait for Google's review (typically 1-3 days)
5. ✅ If questions arise, refer to this guide

---

## Important Notes

- ⚠️ **Don't overthink it:** Most consumer encryption apps are approved automatically
- ⚠️ **Be accurate:** Don't claim "no encryption" if you use it
- ⚠️ **Standard algorithms:** Using AES is good - it's well-understood and approved
- ⚠️ **Consumer app:** Being available to general public simplifies compliance

---

**Last Updated:** December 2024  
**Status:** Ready for Google Play Console submission

