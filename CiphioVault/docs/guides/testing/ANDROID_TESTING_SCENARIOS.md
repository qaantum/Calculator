# Android Testing Scenarios

**Date:** November 2025  
**Purpose:** Comprehensive test plan for Ciphio Vault on Android devices

---

## 📱 Pre-Testing Setup

### Before You Start
1. **Install the app** on your Android device
2. **Enable Developer Options** (if needed for debugging)
3. **Enable USB Debugging** (optional, for logs)
4. **Clear app data** (Settings → Apps → Ciphio Vault → Storage → Clear Data)
5. **Start fresh** - This ensures you test the full user journey

---

## 🎯 Test Scenarios

### 1. First Launch & Setup

#### Scenario 1.1: First-Time User Experience
**Steps:**
1. Launch Ciphio Vault for the first time
2. Navigate through the app
3. Check if all screens load properly

**Expected Results:**
- ✅ App opens without crashes
- ✅ Home screen displays correctly
- ✅ Navigation works smoothly
- ✅ Theme is applied (light/dark/system)

**What to Check:**
- [ ] No crashes or freezes
- [ ] UI elements are visible and properly sized
- [ ] Text is readable
- [ ] Buttons are tappable

---

#### Scenario 1.2: Master Password Setup
**Steps:**
1. Go to Password Manager
2. If no master password exists, you should see setup screen
3. Enter a master password (e.g., "TestPassword123!")
4. Confirm the master password
5. Complete setup

**Expected Results:**
- ✅ Setup screen appears if no master password exists
- ✅ Password field accepts input
- ✅ Confirmation field works
- ✅ Setup completes successfully
- ✅ You're taken to the password list (empty)

**What to Check:**
- [ ] Password is hidden (dots, not plain text)
- [ ] Confirmation must match
- [ ] Error shown if passwords don't match
- [ ] Success message or transition to list

---

#### Scenario 1.3: Master Password Unlock
**Steps:**
1. Close the app completely
2. Reopen the app
3. Go to Password Manager
4. Enter your master password
5. Unlock the vault

**Expected Results:**
- ✅ Unlock screen appears
- ✅ Password field works
- ✅ Unlock succeeds with correct password
- ✅ Error shown with incorrect password

**What to Check:**
- [ ] Unlock screen appears after setup
- [ ] Correct password unlocks successfully
- [ ] Wrong password shows error
- [ ] Can retry after error

---

### 2. Password Manager - Basic Operations

#### Scenario 2.1: Add New Password Entry
**Steps:**
1. Unlock the vault
2. Tap "Add" or "+" button
3. Fill in:
   - Service: "example.com"
   - Username: "testuser"
   - Password: "TestPass123!"
   - Notes: "Test account" (optional)
4. Save the entry

**Expected Results:**
- ✅ Add screen opens
- ✅ All fields accept input
- ✅ Save button works
- ✅ Entry appears in the list
- ✅ Entry is saved correctly

**What to Check:**
- [ ] All fields are editable
- [ ] Password field is hidden by default
- [ ] Toggle password visibility works
- [ ] Save button is enabled
- [ ] Entry appears in list after saving
- [ ] Entry details are correct

---

#### Scenario 2.2: View Password Entry
**Steps:**
1. From the password list, tap an entry
2. View all details

**Expected Results:**
- ✅ Entry details screen opens
- ✅ All information is displayed correctly
- ✅ Password is hidden by default
- ✅ Can toggle password visibility

**What to Check:**
- [ ] Service name is correct
- [ ] Username is correct
- [ ] Password is hidden (can be shown)
- [ ] Notes are displayed (if any)
- [ ] Date created/updated is shown

---

#### Scenario 2.3: Edit Password Entry
**Steps:**
1. Open an existing entry
2. Tap "Edit" button
3. Change the password to "NewPassword456!"
4. Save changes

**Expected Results:**
- ✅ Edit screen opens with current values
- ✅ Can modify all fields
- ✅ Save button works
- ✅ Changes are saved
- ✅ Updated entry shows in list

**What to Check:**
- [ ] All fields are pre-filled with current values
- [ ] Can modify any field
- [ ] Save button updates the entry
- [ ] Changes persist after closing app

---

#### Scenario 2.4: Delete Password Entry
**Steps:**
1. Open an entry
2. Tap "Delete" button
3. Confirm deletion

**Expected Results:**
- ✅ Delete button is visible
- ✅ Confirmation dialog appears
- ✅ Entry is deleted after confirmation
- ✅ Entry disappears from list

**What to Check:**
- [ ] Confirmation dialog appears
- [ ] Can cancel deletion
- [ ] Entry is removed after confirmation
- [ ] List updates immediately

---

#### Scenario 2.5: Search Passwords
**Steps:**
1. Add 3-5 different password entries (different services)
2. Use the search bar
3. Type "example"
4. Check results

**Expected Results:**
- ✅ Search bar is visible
- ✅ Typing filters the list
- ✅ Only matching entries are shown
- ✅ Results update as you type

**What to Check:**
- [ ] Search works for service names
- [ ] Search works for usernames
- [ ] Case-insensitive search
- [ ] Empty search shows all entries
- [ ] Results update in real-time

---

### 3. Password Manager - Sorting

#### Scenario 3.1: Alphabetical Sorting (Ascending)
**Steps:**
1. Add multiple entries with different service names
2. Tap the "A-Z" sort button once
3. Check the order

**Expected Results:**
- ✅ Sort button cycles: Off → A-Z ↑ → A-Z ↓ → Off
- ✅ First tap: Sorts A-Z (ascending)
- ✅ Entries are in alphabetical order

**What to Check:**
- [ ] Button shows "A-Z" when active (ascending)
- [ ] Entries sorted A-Z
- [ ] List scrolls to top after sorting
- [ ] Sort persists after closing app

---

#### Scenario 3.2: Alphabetical Sorting (Descending)
**Steps:**
1. With entries in the list
2. Tap "A-Z" button twice (to get to descending)
3. Check the order

**Expected Results:**
- ✅ Second tap: Sorts Z-A (descending)
- ✅ Entries are in reverse alphabetical order
- ✅ Arrow icon shows direction

**What to Check:**
- [ ] Button shows arrow (↓) when descending
- [ ] Entries sorted Z-A
- [ ] List scrolls to top after sorting

---

#### Scenario 3.3: Date Sorting (Newest First)
**Steps:**
1. Add multiple entries
2. Tap the "Date" sort button once
3. Check the order

**Expected Results:**
- ✅ Sort button cycles: Off → Date ↓ → Date ↑ → Off
- ✅ First tap: Sorts by date (newest first)
- ✅ Most recently added/edited entries appear first

**What to Check:**
- [ ] Button shows "Date" with arrow (↓) when active
- [ ] Newest entries at top
- [ ] List scrolls to top after sorting

---

#### Scenario 3.4: Date Sorting (Oldest First)
**Steps:**
1. With entries in the list
2. Tap "Date" button twice (to get to ascending)
3. Check the order

**Expected Results:**
- ✅ Second tap: Sorts by date (oldest first)
- ✅ Oldest entries appear first
- ✅ Arrow icon shows direction

**What to Check:**
- [ ] Button shows arrow (↑) when ascending
- [ ] Oldest entries at top
- [ ] List scrolls to top after sorting

---

#### Scenario 3.5: Sort Persistence
**Steps:**
1. Set a sort option (e.g., A-Z ascending)
2. Close the app completely
3. Reopen the app
4. Unlock the vault
5. Check if sort option is still applied

**Expected Results:**
- ✅ Sort option is remembered
- ✅ List is sorted when you return
- ✅ Sort button shows correct state

**What to Check:**
- [ ] Sort persists after app restart
- [ ] Sort button shows correct icon/state
- [ ] List is sorted correctly

---

### 4. Autofill - Fill Credentials

#### Scenario 4.1: Enable Autofill Service
**Steps:**
1. Go to Android Settings
2. System → Languages & input → Autofill service
3. Select "Ciphio Vault"
4. Grant necessary permissions

**Expected Results:**
- ✅ Ciphio Vault appears in autofill service list
- ✅ Can select it as autofill service
- ✅ Service is enabled

**What to Check:**
- [ ] Service is listed
- [ ] Can enable it
- [ ] No crashes when enabling

---

#### Scenario 4.2: Autofill in Chrome (Website)
**Steps:**
1. Open Chrome browser
2. Navigate to a login page (e.g., example.com/login)
3. Tap the username field
4. Look for autofill suggestion
5. Tap "Ciphio Vault" or autofill icon
6. Authenticate (biometric or password)
7. Select a credential
8. Check if fields are filled

**Expected Results:**
- ✅ Autofill suggestion appears
- ✅ Can tap to open Ciphio Vault
- ✅ Authentication screen appears
- ✅ Can select credential
- ✅ Username and password are filled automatically

**What to Check:**
- [ ] Autofill suggestion appears
- [ ] Authentication works (biometric/password)
- [ ] Credential list shows matching entries
- [ ] Fields are filled correctly
- [ ] Can fill without errors

---

#### Scenario 4.3: Autofill in Firefox (Website)
**Steps:**
1. Open Firefox browser
2. Navigate to a login page
3. Tap the username field
4. Use autofill (same as Chrome)

**Expected Results:**
- ✅ Same behavior as Chrome
- ✅ Autofill works in Firefox

**What to Check:**
- [ ] Works in Firefox
- [ ] No browser-specific issues

---

#### Scenario 4.4: Autofill in Native App (YouTube)
**Steps:**
1. Open YouTube app
2. Go to Sign In
3. Tap the username/email field
4. Use autofill
5. Authenticate and select credential

**Expected Results:**
- ✅ Autofill works in native apps
- ✅ Can fill YouTube login fields
- ✅ No crashes

**What to Check:**
- [ ] Works in native apps
- [ ] No crashes
- [ ] Fields are filled correctly

---

#### Scenario 4.5: Multiple Credentials for Same Domain
**Steps:**
1. Add 3 entries for "example.com" with different usernames
2. Go to example.com login page
3. Use autofill
4. Check credential list

**Expected Results:**
- ✅ All 3 credentials are shown
- ✅ Can select any of them
- ✅ Selected credential is filled

**What to Check:**
- [ ] All matching credentials appear
- [ ] Can scroll through list
- [ ] Selection works correctly

---

#### Scenario 4.6: No Matching Credentials
**Steps:**
1. Go to a website you don't have credentials for
2. Tap username field
3. Use autofill

**Expected Results:**
- ✅ Authentication still appears
- ✅ Empty list or "No credentials" message
- ✅ Can cancel

**What to Check:**
- [ ] No crashes
- [ ] Graceful handling of no matches
- [ ] Can cancel and return to app

---

### 5. Autofill - Save Credentials

#### Scenario 5.1: Save New Credential (First Time)
**Steps:**
1. Go to a website you don't have credentials for
2. Enter username and password manually
3. Submit the form
4. Look for "Save password" prompt
5. Tap "Save" or "Save with Ciphio Vault"
6. Authenticate
7. Save the credential

**Expected Results:**
- ✅ Save prompt appears
- ✅ Can choose to save
- ✅ Authentication screen appears
- ✅ Credential is saved
- ✅ Success message appears

**What to Check:**
- [ ] Save prompt appears
- [ ] Authentication works
- [ ] Credential is saved
- [ ] Can find it in password list
- [ ] Success toast/notification appears

---

#### Scenario 5.2: Save Credential (With Cached Password)
**Steps:**
1. Use autofill to fill a credential (authenticate)
2. Within 5 minutes, go to a different website
3. Enter new credentials
4. Save the credential

**Expected Results:**
- ✅ Save happens without re-authentication
- ✅ Credential is saved directly
- ✅ Faster save experience

**What to Check:**
- [ ] No authentication prompt (within 5 min)
- [ ] Save happens automatically
- [ ] Credential is saved correctly

---

#### Scenario 5.3: Save Credential (After 5 Minutes)
**Steps:**
1. Authenticate for autofill
2. Wait 5+ minutes (or change time manually)
3. Try to save a new credential

**Expected Results:**
- ✅ Authentication prompt appears
- ✅ Must authenticate again
- ✅ Credential is saved after authentication

**What to Check:**
- [ ] Authentication required after 5 minutes
- [ ] Save works after authentication

---

### 6. Biometric Authentication

#### Scenario 6.1: Enable Biometric Unlock
**Steps:**
1. Go to Settings in Ciphio Vault
2. Find biometric option
3. Enable biometric unlock
4. Follow setup instructions

**Expected Results:**
- ✅ Biometric option is available
- ✅ Can enable it
- ✅ Setup completes successfully

**What to Check:**
- [ ] Option is visible
- [ ] Can enable/disable
- [ ] Setup works

---

#### Scenario 6.2: Unlock with Fingerprint/Face
**Steps:**
1. Close the app
2. Reopen and go to Password Manager
3. Use fingerprint/face to unlock

**Expected Results:**
- ✅ Biometric prompt appears
- ✅ Can unlock with biometric
- ✅ Vault unlocks successfully

**What to Check:**
- [ ] Biometric prompt appears
- [ ] Unlock works
- [ ] Falls back to password if biometric fails

---

#### Scenario 6.3: Biometric for Autofill
**Steps:**
1. Enable biometric unlock
2. Use autofill in Chrome
3. Authenticate with biometric

**Expected Results:**
- ✅ Biometric prompt appears in autofill
- ✅ Can authenticate with biometric
- ✅ Autofill proceeds after authentication

**What to Check:**
- [ ] Biometric works in autofill flow
- [ ] Can use biometric instead of password

---

### 7. Premium Features

#### Scenario 7.1: Free Tier Limit (10 Passwords)
**Steps:**
1. Add 10 password entries
2. Try to add an 11th entry

**Expected Results:**
- ✅ 10 entries can be added
- ✅ 11th entry shows premium prompt
- ✅ Cannot add more without premium

**What to Check:**
- [ ] Limit is enforced
- [ ] Premium prompt appears
- [ ] Can't bypass limit

---

#### Scenario 7.2: Premium Purchase Flow
**Steps:**
1. Tap premium upgrade button
2. Follow purchase flow
3. Complete purchase

**Expected Results:**
- ✅ Purchase screen appears
- ✅ Can select premium option
- ✅ Purchase completes
- ✅ Premium features unlock

**What to Check:**
- [ ] Purchase flow works
- [ ] Can complete purchase
- [ ] Premium status updates
- [ ] Can add unlimited passwords after purchase

---

#### Scenario 7.3: Export (Premium Feature)
**Steps:**
1. Have premium status
2. Go to Settings
3. Tap "Export"
4. Export passwords

**Expected Results:**
- ✅ Export option is available
- ✅ Can export to file
- ✅ File is created correctly

**What to Check:**
- [ ] Export works
- [ ] File is encrypted
- [ ] Can share file

---

### 8. Error Handling & Edge Cases

#### Scenario 8.1: Wrong Master Password
**Steps:**
1. Try to unlock with wrong password
2. Check error message

**Expected Results:**
- ✅ Error message appears
- ✅ Can retry
- ✅ Doesn't crash

**What to Check:**
- [ ] Clear error message
- [ ] Can retry
- [ ] No crashes

---

#### Scenario 8.2: Corrupted Data (Simulated)
**Steps:**
1. Add some entries
2. Manually corrupt data (advanced - skip if not comfortable)
3. Try to unlock

**Expected Results:**
- ✅ Graceful error handling
- ✅ Clear error message
- ✅ Option to reset vault

**What to Check:**
- [ ] Handles corruption gracefully
- [ ] Doesn't crash
- [ ] User can recover

---

#### Scenario 8.3: App Restart During Autofill
**Steps:**
1. Start autofill flow
2. Close app during authentication
3. Reopen app
4. Try autofill again

**Expected Results:**
- ✅ No crashes
- ✅ Can restart autofill flow
- ✅ Previous state doesn't interfere

**What to Check:**
- [ ] No crashes
- [ ] Can use autofill after restart
- [ ] No stuck states

---

### 9. Performance & UI

#### Scenario 9.1: Large List Performance
**Steps:**
1. Add 50+ password entries
2. Scroll through the list
3. Use search
4. Sort the list

**Expected Results:**
- ✅ List scrolls smoothly
- ✅ No lag or freezes
- ✅ Search works quickly
- ✅ Sorting is fast

**What to Check:**
- [ ] Smooth scrolling
- [ ] Fast search
- [ ] Quick sorting
- [ ] No memory issues

---

#### Scenario 9.2: Theme Switching
**Steps:**
1. Go to Settings
2. Change theme (Light/Dark/System)
3. Check all screens

**Expected Results:**
- ✅ Theme changes immediately
- ✅ All screens use new theme
- ✅ Theme persists after restart

**What to Check:**
- [ ] Theme applies correctly
- [ ] All screens update
- [ ] Persists after restart

---

#### Scenario 9.3: Screen Rotation
**Steps:**
1. Open password list
2. Rotate device
3. Check UI

**Expected Results:**
- ✅ UI adapts to rotation
- ✅ No crashes
- ✅ Data is preserved

**What to Check:**
- [ ] UI works in both orientations
- [ ] No layout issues
- [ ] No data loss

---

## 📋 Testing Checklist

### Core Features
- [ ] First launch works
- [ ] Master password setup
- [ ] Master password unlock
- [ ] Add password entry
- [ ] View password entry
- [ ] Edit password entry
- [ ] Delete password entry
- [ ] Search passwords
- [ ] Sort passwords (all modes)
- [ ] Sort persistence

### Autofill - Fill
- [ ] Enable autofill service
- [ ] Autofill in Chrome
- [ ] Autofill in Firefox
- [ ] Autofill in native app (YouTube)
- [ ] Multiple credentials for same domain
- [ ] No matching credentials

### Autofill - Save
- [ ] Save new credential (first time)
- [ ] Save with cached password
- [ ] Save after 5 minutes (re-auth)

### Biometric
- [ ] Enable biometric unlock
- [ ] Unlock with biometric
- [ ] Biometric for autofill

### Premium
- [ ] Free tier limit (10 passwords)
- [ ] Premium purchase flow
- [ ] Export feature

### Error Handling
- [ ] Wrong master password
- [ ] App restart during autofill
- [ ] Network errors (if applicable)

### Performance
- [ ] Large list performance
- [ ] Theme switching
- [ ] Screen rotation

---

## 🐛 What to Report

If you find issues, note:
1. **What you were doing** (steps to reproduce)
2. **What happened** (actual result)
3. **What should happen** (expected result)
4. **Screenshots** (if possible)
5. **Device info** (Android version, device model)

---

## ✅ Success Criteria

The app is ready if:
- ✅ All core features work
- ✅ Autofill works in Chrome, Firefox, and native apps
- ✅ Save functionality works
- ✅ No crashes during normal use
- ✅ Performance is acceptable
- ✅ Error handling is graceful

---

**Happy Testing!** 🚀

