import Foundation
import Combine
import StoreKit

@MainActor
class PremiumManager: ObservableObject {
    @Published var isPremium: Bool = false
    
    // Singleton instance for easy access
    static let shared = PremiumManager()
    
    private let productId = "com.cryptatext.premium"
    private var updates: Task<Void, Never>? = nil
    
    private init() {
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
