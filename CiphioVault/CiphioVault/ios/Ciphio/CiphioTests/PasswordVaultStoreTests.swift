//
//  PasswordVaultStoreTests.swift
//  CiphioTests
//
//  Unit tests for PasswordVaultStore
//

import Testing
@testable import Ciphio
import Foundation

struct PasswordVaultStoreTests {
    
    private func createTestStore() -> PasswordVaultStore {
        let cryptoService = CryptoService()
        return PasswordVaultStore(cryptoService: cryptoService)
    }
    
    private let testMasterPassword = "TestPassword123!"
    
    @Test("Add entry successfully")
    func testAddEntry() async throws {
        let store = createTestStore()
        
        // Set master password first
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        let entry = PasswordEntry(
            service: "example.com",
            username: "testuser",
            password: "password123"
        )
        
        try await store.addEntry(entry)
        
        let entries = store.entries
        #expect(entries.count == 1)
        #expect(entries[0].service == "example.com")
        #expect(entries[0].username == "testuser")
    }
    
    @Test("Update entry modifies existing entry")
    func testUpdateEntry() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        let originalEntry = PasswordEntry(
            id: UUID().uuidString,
            service: "example.com",
            username: "testuser",
            password: "password123"
        )
        
        try await store.addEntry(originalEntry)
        
        let updatedEntry = PasswordEntry(
            id: originalEntry.id,
            service: "example.com",
            username: "updateduser",
            password: "newpassword"
        )
        
        try await store.updateEntry(updatedEntry)
        
        let entries = store.entries
        #expect(entries.count == 1)
        #expect(entries[0].username == "updateduser")
        #expect(entries[0].password == "newpassword")
    }
    
    @Test("Delete entry removes entry successfully")
    func testDeleteEntry() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        let entry1 = PasswordEntry(
            id: UUID().uuidString,
            service: "example.com",
            username: "user1",
            password: "pass1"
        )
        let entry2 = PasswordEntry(
            id: UUID().uuidString,
            service: "test.com",
            username: "user2",
            password: "pass2"
        )
        
        try await store.addEntry(entry1)
        try await store.addEntry(entry2)
        
        try await store.deleteEntry(id: entry1.id)
        
        let entries = store.entries
        #expect(entries.count == 1)
        #expect(entries[0].id == entry2.id)
    }
    
    @Test("Get all entries returns empty list when no entries exist")
    func testGetAllEntriesEmpty() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        let entries = store.entries
        #expect(entries.isEmpty)
    }
    
    @Test("Add entry prevents duplicate entries by ID")
    func testAddEntryPreventsDuplicates() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        let entryId = UUID().uuidString
        let entry1 = PasswordEntry(
            id: entryId,
            service: "example.com",
            username: "user1",
            password: "pass1"
        )
        let entry2 = PasswordEntry(
            id: entryId, // Same ID
            service: "example.com",
            username: "user2",
            password: "pass2"
        )
        
        try await store.addEntry(entry1)
        try await store.addEntry(entry2)
        
        let entries = store.entries
        #expect(entries.count == 1)
        // Should keep the latest entry
        #expect(entries[0].username == "user2")
    }
    
    @Test("Export entries returns encrypted JSON string")
    func testExportEntries() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        let entry = PasswordEntry(
            service: "example.com",
            username: "testuser",
            password: "password123"
        )
        
        try await store.addEntry(entry)
        
        let exported = try store.exportEntries()
        #expect(!exported.isEmpty)
        // Should contain encryption prefix
        #expect(exported.contains(":"))
    }
    
    @Test("Import entries from encrypted format works correctly")
    func testImportEntriesEncrypted() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        let entry = PasswordEntry(
            service: "example.com",
            username: "testuser",
            password: "password123"
        )
        
        try await store.addEntry(entry)
        let exported = try store.exportEntries()
        
        // Create new store instance to simulate import
        let newStore = createTestStore()
        try newStore.setMasterPassword(testMasterPassword)
        try newStore.unlock(masterPassword: testMasterPassword)
        
        let result = try newStore.importEntries(encryptedData: exported, merge: false)
        #expect(!result.isError)
        #expect(result.newEntriesCount == 1)
        
        let importedEntries = newStore.entries
        #expect(importedEntries.count == 1)
        #expect(importedEntries[0].service == "example.com")
    }
    
    @Test("Import entries from CSV format works correctly")
    func testImportEntriesCSV() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        let csvData = """
            url,username,password,name,notes
            https://example.com,testuser,password123,Example Site,Test notes
            https://test.com,user2,pass456,Test Site,More notes
        """
        
        let result = try store.importEntries(encryptedData: csvData, merge: false)
        #expect(!result.isError)
        #expect(result.newEntriesCount == 2)
        
        let entries = store.entries
        #expect(entries.count == 2)
        #expect(entries.contains { $0.service == "example.com" })
        #expect(entries.contains { $0.service == "test.com" })
    }
    
    @Test("Import entries with merge mode adds to existing entries")
    func testImportEntriesMerge() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        let existingEntry = PasswordEntry(
            service: "existing.com",
            username: "existinguser",
            password: "existingpass"
        )
        try await store.addEntry(existingEntry)
        
        let csvData = """
            url,username,password,name
            https://new.com,newuser,newpass,New Site
        """
        
        let result = try store.importEntries(encryptedData: csvData, merge: true)
        #expect(!result.isError)
        #expect(result.newEntriesCount == 1)
        
        let entries = store.entries
        #expect(entries.count == 2)
    }
    
    @Test("Set master password stores password hash")
    func testSetMasterPassword() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        
        let hasPassword = store.hasMasterPassword()
        #expect(hasPassword)
    }
    
    @Test("Verify master password returns true for correct password")
    func testVerifyMasterPasswordCorrect() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        let entry = PasswordEntry(
            service: "test.com",
            username: "user",
            password: "pass"
        )
        try store.unlock(masterPassword: testMasterPassword)
        try store.addEntry(entry)
        
        let isValid = store.verifyMasterPassword(testMasterPassword)
        #expect(isValid)
    }
    
    @Test("Verify master password returns false for incorrect password")
    func testVerifyMasterPasswordIncorrect() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        let entry = PasswordEntry(
            service: "test.com",
            username: "user",
            password: "pass"
        )
        try store.unlock(masterPassword: testMasterPassword)
        try await store.addEntry(entry)
        
        let isValid = store.verifyMasterPassword("WrongPassword")
        #expect(!isValid)
    }
    
    @Test("CSV parsing handles various formats")
    func testCSVParsing() async throws {
        let store = createTestStore()
        
        try store.setMasterPassword(testMasterPassword)
        try store.unlock(masterPassword: testMasterPassword)
        
        // Test different CSV formats
        let csvFormats = [
            // Standard format
            "url,username,password,name\nhttps://example.com,user,pass,Example",
            // With quotes
            "\"url\",\"username\",\"password\",\"name\"\n\"https://example.com\",\"user\",\"pass\",\"Example\"",
            // Different column order
            "name,password,username,url\nExample,pass,user,https://example.com"
        ]
        
        for csvData in csvFormats {
            let result = try store.importEntries(encryptedData: csvData, merge: false)
            #expect(!result.isError)
            #expect(result.newEntriesCount >= 1)
        }
    }
}

