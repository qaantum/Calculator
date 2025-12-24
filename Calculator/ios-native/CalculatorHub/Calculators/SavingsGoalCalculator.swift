import Foundation

struct SavingsGoalResult {
    let monthlyContribution: Double
}

class SavingsGoalCalculator {
    func calculate(goalAmount: Double, initialSavings: Double, annualRate: Double, years: Double) -> SavingsGoalResult {
        let rate = annualRate / 100.0 / 12.0
        let months = years * 12.0

        let pmt: Double
        if rate == 0 {
            pmt = (goalAmount - initialSavings) / months
        } else {
            pmt = (goalAmount - initialSavings * pow(1 + rate, months)) * rate / (pow(1 + rate, months) - 1)
        }

        return SavingsGoalResult(monthlyContribution: pmt > 0 ? pmt : 0)
    }
}
