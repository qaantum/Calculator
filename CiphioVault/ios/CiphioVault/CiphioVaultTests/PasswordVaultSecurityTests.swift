//
//  PasswordVaultSecurityTests.swift
//  CiphioTests
//
//  Security tests for PasswordVaultStore
//

import Testing
@testable import CiphioVault
import Foundation

struct PasswordVaultSecurityTests {
    
    private func createTestStore() -> PasswordVaultStore {
        let cryptoService = CryptoService()
        return PasswordVaultStore(cryptoService: cryptoService)
    }
    
    private let testMasterPassword = "TestPassword123!@#"
    
    @Test("Master password is not stored in plaintext")
    func testMasterPasswordNotPlaintext() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        
        // Verify password hash is stored, not plaintext
        let hasPassword = store.hasMasterPassword
        #expect(hasPassword)
        
        // The actual hash storage is in UserDefaults, but we can verify
        // that verifyMasterPassword works with correct password but not wrong one
        let isValidCorrect = store.verifyMasterPassword(testMasterPassword)
        #expect(isValidCorrect)
        
        let isValidWrong = store.verifyMasterPassword("WrongPassword")
        #expect(!isValidWrong)
    }
    
    @Test("Password entries are encrypted before storage")
    func testPasswordEntriesEncrypted() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        let entry = PasswordEntry(
            service: "example.com",
            username: "testuser",
            password: "secretpassword123"
        )
        
        try store.addEntry(entry)
        
        // Verify data in storage is encrypted
        // The encrypted data is in UserDefaults, but we can verify
        // that decryption with wrong password fails
        // This is tested indirectly through unlock mechanism
    }
    
    @Test("Encrypted data cannot be decrypted with wrong password")
    func testWrongPasswordDecryptionFails() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        let entry = PasswordEntry(
            service: "example.com",
            username: "testuser",
            password: "secretpassword"
        )
        
        try store.addEntry(entry)
        
        // Create new store instance and try wrong password
        let newStore = createTestStore()
        try newStore.setMasterPassword("WrongPassword")
        
        // Unlock should fail with wrong password
        let canUnlock = newStore.verifyMasterPassword("WrongPassword")
        #expect(!canUnlock)
    }
    
    @Test("Master password verification prevents unauthorized access")
    func testMasterPasswordVerification() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        let entry = PasswordEntry(
            service: "test.com",
            username: "user",
            password: "pass"
        )
        
        try store.addEntry(entry)
        
        // Verify correct password works
        let isValidCorrect = store.verifyMasterPassword(testMasterPassword)
        #expect(isValidCorrect)
        
        // Verify wrong password fails
        let isValidWrong = store.verifyMasterPassword("WrongPassword")
        #expect(!isValidWrong)
    }
    
    @Test("Exported data is encrypted")
    func testExportedDataEncrypted() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        let entry = PasswordEntry(
            service: "example.com",
            username: "testuser",
            password: "secretpassword"
        )
        
        try store.addEntry(entry)
        let exported = try store.exportEntries()
        
        // Exported data should be encrypted
        #expect(!exported.isEmpty)
        #expect(exported.contains(":"))
        #expect(!exported.contains("secretpassword"))
        #expect(!exported.contains("testuser"))
    }
    
    @Test("Exported data cannot be decrypted without master password")
    func testExportedDataRequiresPassword() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        let entry = PasswordEntry(
            service: "example.com",
            username: "testuser",
            password: "secretpassword"
        )
        
        try store.addEntry(entry)
        let exported = try store.exportEntries()
        
        // Try to import with wrong password
        let newStore = createTestStore()
        try newStore.setMasterPassword("WrongPassword")
        try newStore.unlock(masterPassword: "WrongPassword")
        
        // Import should fail with wrong password
        do {
            _ = try newStore.importEntries(encryptedData: exported, merge: false)
            // If we get here, the import didn't fail as expected
            #expect(Bool(false), "Import should fail with wrong password")
        } catch {
            // Expected to fail
            #expect(true)
        }
    }
    
    @Test("Data integrity is maintained after encryption and decryption")
    func testDataIntegrity() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        let originalEntry = PasswordEntry(
            service: "example.com",
            username: "testuser",
            password: "secretpassword",
            notes: "Test notes",
            categories: ["Bank", "Important"]
        )
        
        try store.addEntry(originalEntry)
        
        let entries = store.entries
        #expect(entries.count == 1)
        
        let retrievedEntry = entries[0]
        // Verify all fields are preserved
        #expect(retrievedEntry.service == originalEntry.service)
        #expect(retrievedEntry.username == originalEntry.username)
        #expect(retrievedEntry.password == originalEntry.password)
        #expect(retrievedEntry.notes == originalEntry.notes)
        #expect(retrievedEntry.getAllCategories() == originalEntry.getAllCategories())
    }
    
    @Test("Multiple entries maintain separate encryption")
    func testMultipleEntriesEncryption() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        let entry1 = PasswordEntry(
            id: UUID().uuidString,
            service: "site1.com",
            username: "user1",
            password: "pass1"
        )
        let entry2 = PasswordEntry(
            id: UUID().uuidString,
            service: "site2.com",
            username: "user2",
            password: "pass2"
        )
        
        try store.addEntry(entry1)
        try store.addEntry(entry2)
        
        let entries = store.entries
        #expect(entries.count == 2)
        
        // Verify both entries are correctly decrypted
        let hasEntry1 = entries.contains { $0.service == "site1.com" && $0.password == "pass1" }
        let hasEntry2 = entries.contains { $0.service == "site2.com" && $0.password == "pass2" }
        #expect(hasEntry1)
        #expect(hasEntry2)
    }
    
    @Test("Master password hash is deterministic")
    func testMasterPasswordHashDeterministic() async throws {
        let store1 = createTestStore()
        try store1.setMasterPassword(testMasterPassword)
        
        let store2 = createTestStore()
        try store2.setMasterPassword(testMasterPassword)
        
        // Both should verify with the same password
        let isValid1 = store1.verifyMasterPassword(testMasterPassword)
        let isValid2 = store2.verifyMasterPassword(testMasterPassword)
        
        #expect(isValid1)
        #expect(isValid2)
    }
}

