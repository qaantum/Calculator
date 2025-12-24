# Data Versioning & Migration Guide

**Purpose:** Ensure passwords don't break after app updates  
**Status:** ✅ Implemented

---

## Overview

The app now includes a data versioning system that tracks the format of stored password data. This allows the app to migrate data when the format changes in future updates, ensuring users' passwords are never lost.

---

## How It Works

### Data Version Storage

**iOS:**
- Stored in `UserDefaults` with key: `ciphio.data_version`
- Current version: `1`
- Updated automatically when passwords are saved

**Android:**
- Stored in `DataStore` with key: `data_version`
- Current version: `1`
- Updated automatically when passwords are saved

### Migration Process

1. **On App Launch:**
   - App checks stored data version
   - If version is `0` (old data), sets to current version
   - If version matches current, no migration needed
   - If version is older, runs migration logic

2. **When Saving Passwords:**
   - Data version is automatically stored with each save
   - Ensures all saved data has the correct version

---

## Current Implementation

### iOS (`PasswordVaultStore.swift`)

```swift
private let currentDataVersion = 1

private func migrateDataIfNeeded() {
    let storedVersion = defaults.integer(forKey: dataVersionKey)
    
    if storedVersion == 0 {
        // Old data - set to current version
        defaults.set(currentDataVersion, forKey: dataVersionKey)
        return
    }
    
    if storedVersion == currentDataVersion {
        // Already current - no migration needed
        return
    }
    
    // Future: Add migration logic here
    // Example:
    // if storedVersion < 2 {
    //     migrateFromV1ToV2()
    // }
    
    defaults.set(currentDataVersion, forKey: dataVersionKey)
}
```

### Android (`PasswordVaultRepository.kt`)

```kotlin
companion object {
    private const val CURRENT_DATA_VERSION = 1
}

init {
    migrateDataIfNeeded()
}

private fun migrateDataIfNeeded() {
    // Similar logic to iOS
    // Checks version and migrates if needed
}
```

---

## Adding Future Migrations

When you need to change the data format in the future:

### Step 1: Increment Version

**iOS:**
```swift
private let currentDataVersion = 2  // Increment from 1 to 2
```

**Android:**
```kotlin
private const val CURRENT_DATA_VERSION = 2  // Increment from 1 to 2
```

### Step 2: Add Migration Logic

**Important:** The migration system handles skipped versions automatically. If a user has version 1 and the app updates to version 5, all migrations (1→2, 2→3, 3→4, 4→5) will run sequentially.

**iOS Example (Recommended Pattern):**
```swift
private func migrateDataIfNeeded() {
    let storedVersion = defaults.integer(forKey: dataVersionKey)
    
    // If no version or already current, return early
    if storedVersion == 0 || storedVersion == currentDataVersion {
        if storedVersion == 0 {
            defaults.set(currentDataVersion, forKey: dataVersionKey)
        }
        return
    }
    
    // Run all migrations sequentially
    // Pattern: Each migration transforms from version N-1 to version N
    // If storedVersion is 1 and current is 5, all will run: 1→2, 2→3, 3→4, 4→5
    if storedVersion < 2 {
        migrateFromV1ToV2()  // Transforms v1 → v2
    }
    if storedVersion < 3 {
        migrateFromV2ToV3()  // Transforms v2 → v3 (assumes data is now v2)
    }
    if storedVersion < 4 {
        migrateFromV3ToV4()  // Transforms v3 → v4 (assumes data is now v3)
    }
    if storedVersion < 5 {
        migrateFromV4ToV5()  // Transforms v4 → v5 (assumes data is now v4)
    }
    
    defaults.set(currentDataVersion, forKey: dataVersionKey)
}

private func migrateFromV1ToV2() {
    // Migration logic here
    // IMPORTANT: This function should handle data in v1 format and transform to v2
    guard let masterPassword = currentMasterPassword else { return }
    
    do {
        let v1Entries = try getAllEntries(masterPassword: masterPassword)
        // Transform v1 format entries to v2 format
        let v2Entries = transformV1ToV2(v1Entries)
        // Save in v2 format
        try saveEntries(v2Entries, masterPassword: masterPassword)
    } catch {
        // Handle migration error
    }
}
```

**Android Example (Recommended Pattern):**
```kotlin
private fun migrateDataIfNeeded() {
    val prefs = dataStore.data.first()
    val storedVersion = prefs[DATA_VERSION_KEY] ?: 0
    
    // If no version or already current, return early
    if (storedVersion == 0 || storedVersion == CURRENT_DATA_VERSION) {
        if (storedVersion == 0) {
            dataStore.edit { editPrefs ->
                editPrefs[DATA_VERSION_KEY] = CURRENT_DATA_VERSION
            }
        }
        return
    }
    
    // Run all migrations sequentially
    // Pattern: Each migration transforms from version N-1 to version N
    // If storedVersion is 1 and current is 5, all will run: 1→2, 2→3, 3→4, 4→5
    if (storedVersion < 2) {
        migrateFromV1ToV2()  // Transforms v1 → v2
    }
    if (storedVersion < 3) {
        migrateFromV2ToV3()  // Transforms v2 → v3 (assumes data is now v2)
    }
    if (storedVersion < 4) {
        migrateFromV3ToV4()  // Transforms v3 → v4 (assumes data is now v3)
    }
    if (storedVersion < 5) {
        migrateFromV4ToV5()  // Transforms v4 → v5 (assumes data is now v4)
    }
    
    dataStore.edit { editPrefs ->
        editPrefs[DATA_VERSION_KEY] = CURRENT_DATA_VERSION
    }
}

private suspend fun migrateFromV1ToV2() {
    // Migration logic here
    // IMPORTANT: This function should handle data in v1 format and transform to v2
    val masterPassword = currentMasterPassword ?: return
    
    val v1Entries = getCurrentEntries(masterPassword)
    // Transform v1 format entries to v2 format
    val v2Entries = transformV1ToV2(v1Entries)
    // Save in v2 format
    saveEntries(v2Entries, masterPassword)
}
```

### How It Handles Skipped Versions

**Example Scenario:**
- User has app version with data version **1**
- User doesn't update for 4 app releases
- App now has data version **5**
- User finally updates

**What Happens:**
1. App checks stored version: **1**
2. App checks current version: **5**
3. App runs all migrations sequentially:
   - `migrateFromV1ToV2()` - transforms v1 → v2
   - `migrateFromV2ToV3()` - transforms v2 → v3 (data is now v2)
   - `migrateFromV3ToV4()` - transforms v3 → v4 (data is now v3)
   - `migrateFromV4ToV5()` - transforms v4 → v5 (data is now v4)
4. App sets version to **5**
5. All passwords work correctly!

**Key Point:** Each migration function must:
- Accept data in the format of the **previous version** (N-1)
- Transform it to the format of the **next version** (N)
- Not assume what the stored version is - it always transforms from N-1 to N

---

## Best Practices

### 1. Always Increment Version
- **Never** change data format without incrementing version
- **Always** add migration logic for old versions

### 2. Test Migrations
- Test migration from each old version to current
- Test with real user data if possible
- Test edge cases (empty data, corrupted data, etc.)

### 3. Backward Compatibility
- Try to maintain backward compatibility when possible
- Only change format when absolutely necessary
- Document why format changed

### 4. Error Handling
- Migration should never lose data
- If migration fails, log error but don't crash
- Consider rollback strategy for critical migrations

---

## Migration Scenarios

### Scenario 1: Adding New Field to PasswordEntry

**Example:** Adding `tags` field to `PasswordEntry`

1. Increment version to `2`
2. Add migration:
   ```swift
   if storedVersion < 2 {
       // Old entries don't have tags - set to empty array
       // This happens automatically if PasswordEntry has default value
       // No explicit migration needed, but you can add explicit logic:
       migrateFromV1ToV2()
   }
   
   private func migrateFromV1ToV2() {
       // Load v1 entries (without tags field)
       // Add default tags = [] to each entry
       // Save as v2 entries (with tags field)
       // This ensures compatibility even if default values change
   }
   ```

### Scenario 2: Changing Field Type

**Example:** Changing `category` from `String` to `[String]`

1. Increment version to `2`
2. Add migration:
   ```swift
   if storedVersion < 2 {
       // Convert single category to array
       for entry in oldEntries {
           if entry.category is String {
               entry.categories = [entry.category]
               entry.category = ""
           }
       }
   }
   ```

### Scenario 3: Changing Encryption Format

**Example:** Changing from AES-CBC to AES-GCM

1. Increment version to `2`
2. Add migration:
   ```swift
   if storedVersion < 2 {
       // Re-encrypt all entries with new format
       let oldEntries = try getAllEntries(masterPassword: masterPassword)
       // Re-encrypt using new format
       try saveEntries(oldEntries, masterPassword: masterPassword)
   }
   ```

---

## Testing Migrations

### Test Checklist

- [ ] Test migration from version 1 to current
- [ ] Test migration from version 2 to current (if applicable)
- [ ] Test with empty data (no passwords)
- [ ] Test with corrupted data (handles gracefully)
- [ ] Test with large dataset (100+ passwords)
- [ ] Test on both iOS and Android
- [ ] Verify no data loss
- [ ] Verify all passwords still work after migration

### Test Procedure

1. **Create Test Data:**
   - Add passwords in old format
   - Verify they work

2. **Simulate Update:**
   - Increment version
   - Add migration logic
   - Run app

3. **Verify Migration:**
   - Check all passwords still exist
   - Check all passwords still work
   - Check data version is updated
   - Check no errors in logs

---

## Current Status

- ✅ **Data Versioning:** Implemented on both platforms
- ✅ **Version Storage:** Automatic on all save operations
- ✅ **Migration Framework:** Ready for future migrations
- ✅ **Current Version:** 1 (no migrations needed yet)

---

## Future Considerations

### When to Increment Version

Increment the version when:
- ✅ Changing `PasswordEntry` structure
- ✅ Changing encryption format
- ✅ Changing data storage format
- ✅ Changing key derivation method
- ✅ Any change that could break existing data

**Do NOT** increment for:
- ❌ UI changes
- ❌ Feature additions (unless they change data format)
- ❌ Bug fixes (unless they change data format)

---

## Troubleshooting

### Issue: Data Version Not Updating

**Solution:**
- Check that all save operations include version update
- Verify `DATA_VERSION_KEY` is correct
- Check logs for errors

### Issue: Migration Not Running

**Solution:**
- Verify `migrateDataIfNeeded()` is called in `init`
- Check stored version value
- Verify migration conditions are correct

### Issue: Data Lost After Update

**Solution:**
- Check migration logic for errors
- Verify backward compatibility
- Check logs for migration failures
- Consider rollback strategy

---

**Last Updated:** November 2025  
**Current Version:** 1

