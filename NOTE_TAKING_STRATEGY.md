# Note-Taking Integration Strategy

## Executive Summary
Since you want to build a dedicated note-taking app, we will proceed with **The Ciphio Suite Strategy**.
*   **App 1: Ciphio Vault** (Existing): High-security storage for passwords and sensitive documents.
*   **App 2: Ciphio Notes** (New): Fast, beautiful, daily note-taking app.
*   **Integration**: Seamless "Move to Vault" feature using App Groups.

## The Ciphio Suite Strategy

### 1. Ciphio Notes (The "Daily Driver")
*   **Focus**: Speed, Aesthetics, Organization.
*   **Features**: Markdown support, folders/tags, rich text, images.
*   **Security**: Standard iOS protection (FaceID lock optional), but *not* zero-knowledge encrypted by default (for speed and Spotlight search).
*   **Use Case**: Meeting notes, grocery lists, draft blog posts, ideas.

### 2. Ciphio Vault (The "Digital Safe")
*   **Focus**: Maximum Security, Zero-Knowledge Encryption.
*   **Features**: Passwords, Secure Notes, Scanned Documents.
*   **Use Case**: Bank details, private journals, medical records, passport scans.

### 3. The "Lock" Workflow (Integration)
*   User writes a note in **Ciphio Notes**.
*   User decides "This is sensitive."
*   User taps **"Move to Vault"**.
*   **System Action**:
    1.  App copies content to Shared App Group.
    2.  Deep links to Ciphio Vault.
    3.  Vault imports, encrypts, and saves.
    4.  Vault signals success.
    5.  Ciphio Notes **securely deletes** the original file.

## Technical Implementation Plan

### Phase 1: Project Setup
*   Create new target `CiphioNotes` in the existing Xcode project (Monorepo approach).
*   Create Shared Framework `CiphioCore` (or use existing `Shared` folder) for:
    *   Design System (Colors, Fonts, UI Components).
    *   Utilities.

### Phase 2: Ciphio Notes MVP
*   Build `NoteListView` and `NoteEditorView`.
*   Implement CoreData or File-based storage for standard notes.

### Phase 3: Integration
*   Enable **App Groups** (`group.com.ciphio.vault`) for both targets.
*   Implement the "Handover" protocol for moving notes.

### Option 1: Tandem Apps (Two Separate Apps)
*   **Concept**: Keep "Ciphio Vault" for passwords and build a separate "Ciphio Notes" app.
*   **Pros**:
    *   Clear separation of concerns.
    *   "Ciphio Notes" can have a lighter, different UI focused purely on writing.
*   **Cons**:
    *   **High Friction**: User has to download, install, and log in to two different apps.
    *   **Double Maintenance**: You have to maintain two codebases, two App Store listings, two release cycles.
    *   **Confusing UX**: "Which app do I open to see my secure scan of my passport?"

### Option 2: Standalone Encrypted Notes App (General Purpose)
*   **Concept**: Build a generic "Markdown Note Taking" app that happens to have an encryption feature.
*   **Pros**:
    *   Broader market appeal (people looking for just a notes app).
*   **Cons**:
    *   Dilutes the "Ciphio" security brand.
    *   Competes with thousands of existing note apps (Bear, Obsidian, Apple Notes).
    *   Doesn't solve the "Secure Vault" problem for your existing users.

### Option 3: Integrated Notes in Ciphio Vault (Recommended)
*   **Concept**: Add a "Documents" or "Notes" tab to the existing Ciphio Vault app.
*   **Pros**:
    *   **Unified "Digital Safe"**: Users expect a Vault to hold *everything* secure (passwords, notes, photos, documents).
    *   **Single Sign-On**: Unlock once with FaceID/Master Password, access everything.
    *   **Code Reuse**: Reuse your existing `VaultDataManager`, `CryptoService`, and Authentication logic.
*   **Cons**:
    *   App size increases slightly.
    *   UI complexity increases (need to add Tabs).

### Option 4: The "Import to Vault" Workflow (User Proposed)
*   **Concept**: A full-fledged standard Note app where users can "send" notes to Ciphio Vault for encryption.
*   **Viability**: **Technically Viable, but Security Risky**.
*   **Pros**:
    *   **Best of Both Worlds (UX)**: The note app is fast, supports system features (Spotlight, Widgets) because it's not encrypted by default.
    *   **Clear Purpose**: "This app is for scribbling, that app is for secrets."
*   **Cons**:
    *   **CRITICAL SECURITY FLAW (Data Remanence)**: If a user writes a secret in the Note app *first*, it is saved unencrypted to the disk/cache. Even if you "move" it to the Vault and delete the original, **traces may remain** in system logs, snapshots, or iCloud backups.
    *   **One-Way Street**: Once moved to Vault, you can't easily edit it in the Note app anymore without decrypting and exporting it back (exposing it again).

## Technical Implementation for Option 3

The current architecture stores passwords in a single JSON blob in `UserDefaults`. **This will not work for documents/images** because it is too slow and has size limits.

**Proposed Hybrid Architecture:**
1.  **Passwords**: Continue using `UserDefaults` (fast, small data).
2.  **Documents/Notes**: Use **File System Storage**.
    *   Each note/document is saved as an individual encrypted file in the App's `Documents` directory.
    *   Filename is a UUID.
    *   Metadata (title, tags, date) can be stored in a lightweight index (JSON or CoreData) for fast searching.

### Required Changes
1.  **UI**: Add a `TabView` to `ContentView`.
    *   Tab 1: Passwords (existing view)
    *   Tab 2: Documents (new view)
    *   Tab 3: Settings (existing view)
2.  **Core**: Create `DocumentStore` class.
    *   Methods: `saveDocument(data: Data)`, `loadDocument(id: String)`, `deleteDocument(id: String)`.
    *   Uses `VaultDataManager` to derive keys from the Master Password.
