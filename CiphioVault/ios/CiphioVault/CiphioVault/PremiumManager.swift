import Foundation
import Combine
import StoreKit

@MainActor
class PremiumManager: ObservableObject {
    @Published var isPremium: Bool = false
    
    // Singleton instance for easy access
    static let shared = PremiumManager()
    
    // Set to true to use mock mode (for testing without App Store Connect)
    #if DEBUG
    static let useMockMode = true // Change to false to test real StoreKit
    #else
    static let useMockMode = false
    #endif
    
    private let productId = "com.ciphio.vault.premium"
    private var updates: Task<Void, Never>? = nil
    
    private init() {
        #if DEBUG
        if Self.useMockMode {
            // Mock mode: Skip StoreKit initialization
            return
        }
        #endif
        
        updates = newTransactionListenerTask()
        Task {
            await updatePremiumStatus()
        }
    }
    
    deinit {
        updates?.cancel()
    }
    
    private func newTransactionListenerTask() -> Task<Void, Never> {
        Task.detached {
            for await result in Transaction.updates {
                if let transaction = try? result.payloadValue {
                    await self.updatePremiumStatus()
                    await transaction.finish()
                }
            }
        }
    }
    
    func updatePremiumStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productID == productId {
                    isPremium = true
                    return
                }
            }
        }
        isPremium = false
    }
    
    func upgradeToPremium() {
        #if DEBUG
        if Self.useMockMode {
            // Mock mode: Simulate purchase with delay
            Task {
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                isPremium = true
                print("✅ Mock Premium activated (testing mode)")
            }
            return
        }
        #endif
        
        // Real StoreKit purchase flow
        Task {
            do {
                try await purchase()
            } catch {
                print("Purchase failed: \(error)")
            }
        }
    }
    
    func purchase() async throws {
        guard let product = try await Product.products(for: [productId]).first else {
            throw PremiumError.productNotFound
        }
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            if case .verified(let transaction) = verification {
                await updatePremiumStatus()
                await transaction.finish()
            }
        case .userCancelled, .pending:
            break
        @unknown default:
            break
        }
    }
}

enum PremiumError: Error {
    case productNotFound
}
