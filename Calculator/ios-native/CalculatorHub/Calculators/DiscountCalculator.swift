import Foundation

struct DiscountResult {
    let savedAmount: Double
    let finalPrice: Double
}

class DiscountCalculator {
    func calculate(originalPrice: Double, discountPercentage: Double) -> DiscountResult {
        let saved = originalPrice * (discountPercentage / 100.0)
        let finalPrice = originalPrice - saved
        
        return DiscountResult(
            savedAmount: saved,
            finalPrice: finalPrice
        )
    }
}
