import Foundation

struct LoanResult {
    let monthlyPayment: Double
    let totalInterest: Double
    let totalCost: Double
}

class LoanCalculator {
    func calculate(principal: Double, annualRate: Double, termMonths: Int) -> LoanResult {
        let monthlyRate = annualRate / 100.0 / 12.0
        
        let monthlyPayment: Double
        if monthlyRate == 0 {
            monthlyPayment = principal / Double(termMonths)
        } else {
            monthlyPayment = principal * (monthlyRate * pow(1 + monthlyRate, Double(termMonths))) /
                (pow(1 + monthlyRate, Double(termMonths)) - 1)
        }
        
        let totalPayment = monthlyPayment * Double(termMonths)
        let totalInterest = totalPayment - principal
        
        return LoanResult(
            monthlyPayment: monthlyPayment,
            totalInterest: totalInterest,
            totalCost: totalPayment
        )
    }
}
