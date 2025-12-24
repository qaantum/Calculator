import Foundation

struct SimpleInterestResult {
    let interest: Double
    let totalAmount: Double
}

class SimpleInterestCalculator {
    func calculate(principal: Double, annualRate: Double, timeYears: Double) -> SimpleInterestResult {
        let rate = annualRate / 100.0
        let interest = principal * rate * timeYears
        let total = principal + interest
        
        return SimpleInterestResult(
            interest: interest,
            totalAmount: total
        )
    }
}
