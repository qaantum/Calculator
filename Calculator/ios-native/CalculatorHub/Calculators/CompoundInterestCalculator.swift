import Foundation

struct CompoundInterestResult {
    let futureValue: Double
    let totalContributions: Double
    let totalInterest: Double
}

class CompoundInterestCalculator {
    func calculate(
        principal: Double,
        annualRate: Double,
        years: Double,
        contribution: Double = 0.0,
        compoundsPerYear: Double = 12.0
    ) -> CompoundInterestResult {
        let rate = annualRate / 100.0
        let n = compoundsPerYear
        
        // Future Value of Principal: P(1 + r/n)^(nt)
        let fvPrincipal = principal * pow(1 + rate / n, n * years)
        
        // Future Value of Series (Contributions): PMT * [((1 + r/n)^(nt) - 1) / (r/n)]
        let fvContributions: Double
        if rate > 0 {
            fvContributions = contribution * (pow(1 + rate / n, n * years) - 1) / (rate / n)
        } else {
            fvContributions = contribution * n * years
        }
        
        let total = fvPrincipal + fvContributions
        let totalContributed = principal + (contribution * n * years)
        let totalInterest = total - totalContributed
        
        return CompoundInterestResult(
            futureValue: total,
            totalContributions: totalContributed,
            totalInterest: totalInterest
        )
    }
}

