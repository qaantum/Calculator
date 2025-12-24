import Foundation

struct RetirementResult {
    let totalSavings: Double
    let monthlyIncome: Double
}

class RetirementCalculator {
    func calculate(currentAge: Int, retirementAge: Int, currentSavings: Double, monthlyContribution: Double, annualRate: Double) -> RetirementResult? {
        let years = retirementAge - currentAge
        let months = years * 12
        
        guard months > 0 else { return nil }

        let rate = annualRate / 100.0 / 12.0
        let fvSavings = currentSavings * pow(1 + rate, Double(months))
        
        let fvContributions: Double
        if rate != 0 {
            fvContributions = monthlyContribution * (pow(1 + rate, Double(months)) - 1) / rate
        } else {
            fvContributions = monthlyContribution * Double(months)
        }

        let total = fvSavings + fvContributions
        let monthlyIncome = (total * 0.04) / 12.0

        return RetirementResult(totalSavings: total, monthlyIncome: monthlyIncome)
    }
}
