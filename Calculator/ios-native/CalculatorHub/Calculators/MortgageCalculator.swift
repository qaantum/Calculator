import Foundation

struct MortgageResult {
    let monthlyPrincipalAndInterest: Double
    let monthlyTax: Double
    let monthlyInsurance: Double
    let monthlyHOA: Double
    let totalMonthlyPayment: Double
}

class MortgageCalculator {
    func calculate(
        principal: Double,
        annualRate: Double,
        termYears: Int,
        annualPropertyTax: Double = 0.0,
        annualInsurance: Double = 0.0,
        monthlyHOA: Double = 0.0
    ) -> MortgageResult {
        let monthlyRate = annualRate / 100.0 / 12.0
        let termMonths = termYears * 12
        
        let monthlyPI: Double
        if monthlyRate == 0 {
            monthlyPI = principal / Double(termMonths)
        } else {
            monthlyPI = principal * (monthlyRate * pow(1 + monthlyRate, Double(termMonths))) /
                (pow(1 + monthlyRate, Double(termMonths)) - 1)
        }
        
        let monthlyTax = annualPropertyTax / 12.0
        let monthlyInsurance = annualInsurance / 12.0
        let totalMonthly = monthlyPI + monthlyTax + monthlyInsurance + monthlyHOA
        
        return MortgageResult(
            monthlyPrincipalAndInterest: monthlyPI,
            monthlyTax: monthlyTax,
            monthlyInsurance: monthlyInsurance,
            monthlyHOA: monthlyHOA,
            totalMonthlyPayment: totalMonthly
        )
    }
}
