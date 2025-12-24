package com.ciphio.vault.ui

internal val AlgorithmsInfo: List<String> = listOf(
    "Ciphio supports three AES block cipher modes to balance usability and security across scenarios.",
    "AES-GCM (Galois/Counter Mode) is the default. It provides authenticated encryption, ensuring both confidentiality and integrity of your data using a 12-byte nonce and a 16-byte authentication tag.",
    "AES-CBC (Cipher Block Chaining) is included for compatibility with legacy systems. It uses PKCS#5 padding and a fresh 16-byte IV per operation. Integrity checks should be handled separately if you choose this mode.",
    "AES-CTR (Counter Mode) turns AES into a stream cipher with a 16-byte nonce. It is fast and avoids padding altogether. Because it lacks built-in authentication, pair it with a signature or MAC when possible.",
    "All modes derive a 256-bit key from your passphrase using PBKDF2 (SHA-256, 100k iterations, 16-byte salt) per encryption event, keeping raw secrets off disk."
)

internal val TermsContent: List<String> = listOf(
    "Welcome to Ciphio. By accessing or using our applications, website, or related services, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use Ciphio.",
    "Ciphio is designed as a privacy first, security focused application for managing and protecting sensitive credentials and encrypted content.",
    "You are responsible for maintaining the confidentiality of your device access and any authentication methods used to protect your Ciphio vault. You agree to use the service only for lawful purposes and in a manner that does not infringe upon the rights of others.",
    "You agree NOT to: Use the service for illegal, harmful, or fraudulent activities; Attempt to reverse engineer, decompile, or bypass security mechanisms; Interfere with or disrupt the integrity or performance of the service; Attempt unauthorized access to systems or data.",
    "You remain solely responsible for the security of your master password and device protections.",
    "Ciphio is provided on an \"as available\" basis. While we strive for reliability, we do not guarantee uninterrupted service or permanent accessibility to features. We reserve the right to modify, suspend, or discontinue any part of the service at any time without prior notice.",
    "Ciphio is provided \"as is\" and \"as available\" without warranties of any kind, either express or implied. Ciphio shall not be liable for any damages arising from the use or inability to use the service, including: Data loss; Security breaches resulting from user negligence; Device failure or unauthorized access; Indirect or consequential damages.",
    "We may update these Terms at any time. Any changes will be reflected on this page and the \"Last updated\" date will be revised accordingly. Continued use of the service after changes constitutes acceptance of the new terms.",
    "Last updated: November 24, 2025"
)

internal val PrivacyContent: List<String> = listOf(
    "Ciphio is built on a zero access design philosophy. All sensitive data including passwords, encrypted text, and vault contents are encrypted and stored locally on your device. Ciphio does not have access to your vault contents and cannot decrypt them.",
    "We do not collect, view, sell, or share user vault data.",
    "Ciphio does NOT collect: Stored passwords; Vault contents; Encrypted text data; Notes or private content; Biometric data; Personal identity profiles. All such data remains encrypted and fully under user control on the device.",
    "Ciphio may process limited technical metrics for application improvement and stability purposes. These metrics are anonymous and cannot be used to identify you. This may include: App performance statistics; Feature usage trends; Crash diagnostics; Session duration patterns; Basic device and operating system version.",
    "These metrics: Do NOT include personal data; Are NOT linked to individual users; Are NOT used for profiling or advertising. Ciphio does not monitor or track user behavior for marketing or behavioral analysis.",
    "We employ industry standard encryption and secure coding practices to protect all sensitive data: AES GCM encryption; Secure key derivation; Local only storage architecture; Platform level security features (Android Keystore and Apple Keychain). Your master password and vault data are never transmitted to Ciphio servers.",
    "In limited cases, essential third party services may be used for operational functionality such as crash reporting or application performance. These services are configured to respect anonymization standards and do not receive vault data or personal identity information.",
    "You maintain full control over your data on your device. Since vault data is not stored on Ciphio servers, requests for deletion or access apply only to locally stored content, which you can manage directly within the app.",
    "We may update this Privacy Policy periodically. Any changes will be published on this page with a revised date.",
    "Last updated: November 24, 2025"
)
