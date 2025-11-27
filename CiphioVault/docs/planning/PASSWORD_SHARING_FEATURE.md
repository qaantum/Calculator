# Password Entry Sharing Feature

## 🎯 Overview

Add ability to share individual password entries with options to include or exclude the password for security.

---

## ✅ Use Cases

### Share With Password
- **When:** Sharing account access with trusted person (family member, colleague)
- **Format:** Plain text or structured format (JSON, CSV)
- **Example:** "Service: GitHub\nUsername: john@example.com\nPassword: mySecurePass123"

### Share Without Password
- **When:** Sharing account info without exposing password (for setup, documentation)
- **Format:** Service and username only
- **Example:** "Service: GitHub\nUsername: john@example.com\nPassword: [Hidden]"

### Share as Importable Format
- **When:** Transferring password to another password manager
- **Format:** JSON compatible with Ciphio import format
- **Benefit:** Recipient can import directly into their vault

---

## 🔧 Implementation

### Android Implementation

**Location:** `ViewPasswordEntryScreen` - Add share button in toolbar

**Options:**
1. **Share with password** - Full entry as text
2. **Share without password** - Service + username only
3. **Share as JSON** - Importable format (with/without password)

**Code approach:**
```kotlin
// In ViewPasswordEntryScreen toolbar
IconButton(onClick = { showShareDialog = true }) {
    Icon(Icons.Filled.Share, "Share")
}

// Share dialog with options
AlertDialog(
    title = "Share Password Entry",
    text = {
        Column {
            Text("Choose what to share:")
            RadioButton("With password")
            RadioButton("Without password")
            RadioButton("As JSON (importable)")
        }
    },
    confirmButton = { /* Share action */ }
)
```

**Sharing implementation:**
```kotlin
fun sharePasswordEntry(entry: PasswordEntry, includePassword: Boolean, format: ShareFormat) {
    val shareText = when (format) {
        ShareFormat.TEXT -> {
            buildString {
                appendLine("Service: ${entry.service}")
                appendLine("Username: ${entry.username}")
                if (includePassword) {
                    appendLine("Password: ${entry.password}")
                } else {
                    appendLine("Password: [Hidden]")
                }
                if (entry.notes.isNotEmpty()) {
                    appendLine("Notes: ${entry.notes}")
                }
            }
        }
        ShareFormat.JSON -> {
            // Create single-entry JSON compatible with import
            val entryToShare = if (includePassword) entry else entry.copy(password = "")
            json.encodeToString(entryToShare)
        }
    }
    
    val shareIntent = Intent(Intent.ACTION_SEND).apply {
        type = "text/plain"
        putExtra(Intent.EXTRA_TEXT, shareText)
    }
    context.startActivity(Intent.createChooser(shareIntent, "Share password entry"))
}
```

### iOS Implementation

**Location:** `ViewPasswordEntryView` - Add share button in toolbar

**Options:** Same as Android

**Code approach:**
```swift
// In ViewPasswordEntryView toolbar
ToolbarItem(placement: .navigationBarTrailing) {
    Menu {
        Button("Share with Password") {
            shareEntry(includePassword: true, format: .text)
        }
        Button("Share without Password") {
            shareEntry(includePassword: false, format: .text)
        }
        Button("Share as JSON") {
            shareEntry(includePassword: true, format: .json)
        }
    } label: {
        Image(systemName: "square.and.arrow.up")
    }
}

private func shareEntry(includePassword: Bool, format: ShareFormat) {
    let shareText: String
    switch format {
    case .text:
        var text = "Service: \(entry.service)\n"
        text += "Username: \(entry.username)\n"
        if includePassword {
            text += "Password: \(entry.password)\n"
        } else {
            text += "Password: [Hidden]\n"
        }
        if !entry.notes.isEmpty {
            text += "Notes: \(entry.notes)\n"
        }
        shareText = text
    case .json:
        let entryToShare = includePassword ? entry : PasswordEntry(
            id: entry.id,
            service: entry.service,
            username: entry.username,
            password: "", // Hidden
            notes: entry.notes,
            categories: entry.categories
        )
        shareText = try? encoder.encode(entryToShare) ?? ""
    }
    
    let activityVC = UIActivityViewController(
        activityItems: [shareText],
        applicationActivities: nil
    )
    // Present activityVC
}
```

---

## 🎨 User Experience

### Share Button Location
- **Android:** Toolbar action (next to Edit button)
- **iOS:** Toolbar menu (three-dot menu or share icon)

### Share Options Dialog
**Option 1: Quick Menu (Recommended)**
- Long-press or tap share icon
- Show menu with 3 options:
  - "Share with Password"
  - "Share without Password"  
  - "Share as JSON"

**Option 2: Dialog First**
- Tap share icon
- Show dialog: "What would you like to share?"
- Radio buttons for options
- Confirm button

**Recommendation:** Use **Option 1 (Quick Menu)** - faster, more intuitive

### Share Format Examples

**Text Format (With Password):**
```
Service: GitHub
Username: john@example.com
Password: mySecurePass123
Notes: Personal account
```

**Text Format (Without Password):**
```
Service: GitHub
Username: john@example.com
Password: [Hidden]
Notes: Personal account
```

**JSON Format:**
```json
{
  "id": "abc123",
  "service": "GitHub",
  "username": "john@example.com",
  "password": "mySecurePass123",
  "notes": "Personal account",
  "categories": []
}
```

---

## 🔒 Security Considerations

### Warnings
- **When sharing with password:** Show warning dialog
  - "⚠️ Sharing passwords is risky. Only share with trusted recipients."
  - "This password will be sent in plain text."
  - Options: "Share Anyway" / "Cancel"

- **When sharing without password:** No warning needed (safe)

### Best Practices
- ✅ Default to "Share without password" option
- ✅ Show password in warning dialog (so user knows what they're sharing)
- ✅ Log share actions (optional, for audit)
- ✅ Consider screenshot prevention when showing share dialog

### Limitations
- ⚠️ Cannot prevent recipient from sharing further
- ⚠️ Plain text sharing is not encrypted
- ⚠️ User must trust the sharing method (email, messaging, etc.)

---

## 📋 Implementation Plan

### Phase 1: Basic Sharing (Week 1)
1. Add share button to `ViewPasswordEntryScreen` (Android)
2. Add share button to `ViewPasswordEntryView` (iOS)
3. Implement text format sharing (with/without password)
4. Test on both platforms

### Phase 2: JSON Format (Week 1-2)
1. Add JSON format option
2. Ensure compatibility with import function
3. Test import of shared JSON

### Phase 3: Polish (Week 2)
1. Add security warnings
2. Improve UI/UX
3. Add to edit screen (optional - share while editing)

---

## 🎯 Priority

**Priority:** 🟡 **MEDIUM-HIGH**

**Why:**
- Useful feature for sharing account access
- Common in password managers
- Relatively easy to implement
- Good user experience improvement

**Timeline:**
- **Android:** 2-3 hours
- **iOS:** 2-3 hours
- **Testing:** 1-2 hours
- **Total:** ~1 day of work

---

## 📝 Additional Considerations

### Future Enhancements
- **QR Code Sharing:** Generate QR code with password data
- **Secure Sharing:** Encrypt shared password (requires key exchange)
- **Time-Limited Links:** Share via secure link that expires
- **Share to Another Ciphio User:** Direct app-to-app sharing

### Edge Cases
- **Empty fields:** Handle missing username/password gracefully
- **Special characters:** Ensure proper encoding in JSON/text
- **Long passwords:** Truncate in preview if needed
- **Multiple categories:** Include in share format

---

## 🚀 Recommendation

**Add to Phase 1 (Beta Feedback & Polish)** or **Phase 2 (Core Enhancements)**

**Best approach:**
1. Start with text format (with/without password)
2. Add JSON format in same release
3. Add security warnings
4. Consider future secure sharing options

**Would you like me to implement this feature now, or add it to the roadmap?**

