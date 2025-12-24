import Foundation

struct InvestmentGrowthResult {
    let totalValue: Double
    let totalContributions: Double
    let totalInterest: Double
}

class InvestmentGrowthCalculator {
    func calculate(initialAmount: Double, monthlyContribution: Double, annualRate: Double, years: Double) -> InvestmentGrowthResult {
        let r = annualRate / 100.0
        let n = 12.0
        let t = years

        let fvInitial = initialAmount * pow(1 + r / n, n * t)
        let fvContributions: Double
        if r != 0 {
            fvContributions = monthlyContribution * (pow(1 + r / n, n * t) - 1) / (r / n)
        } else {
            fvContributions = monthlyContribution * n * t
        }

        let totalValue = fvInitial + fvContributions
        let totalContributed = initialAmount + (monthlyContribution * n * t)
        let totalInterest = totalValue - totalContributed

        return InvestmentGrowthResult(totalValue: totalValue, totalContributions: totalContributed, totalInterest: totalInterest)
    }
}
