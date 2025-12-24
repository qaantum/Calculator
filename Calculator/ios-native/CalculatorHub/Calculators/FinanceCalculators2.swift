import Foundation

// Auto Loan Calculator
struct AutoLoanResult { let monthlyPayment: Double; let totalInterest: Double; let totalCost: Double }
class AutoLoanCalculator {
    func calculate(price: Double, downPayment: Double, tradeIn: Double, rate: Double, termMonths: Int, taxRate: Double) -> AutoLoanResult {
        let taxableAmount = price - tradeIn
        let salesTax = taxableAmount * (taxRate / 100)
        let loanAmount = price + salesTax - downPayment - tradeIn
        guard loanAmount > 0 else { return AutoLoanResult(monthlyPayment: 0, totalInterest: 0, totalCost: 0) }
        let monthlyRate = rate / 100 / 12
        if monthlyRate == 0 { return AutoLoanResult(monthlyPayment: loanAmount / Double(termMonths), totalInterest: 0, totalCost: loanAmount) }
        let mp = loanAmount * (monthlyRate * pow(1 + monthlyRate, Double(termMonths))) / (pow(1 + monthlyRate, Double(termMonths)) - 1)
        return AutoLoanResult(monthlyPayment: mp, totalInterest: mp * Double(termMonths) - loanAmount, totalCost: mp * Double(termMonths))
    }
}

// Commission Calculator
struct CommissionResult { let commission: Double; let netProceeds: Double }
class CommissionCalculator {
    func calculate(salePrice: Double, commissionRate: Double) -> CommissionResult {
        let commission = salePrice * (commissionRate / 100)
        return CommissionResult(commission: commission, netProceeds: salePrice - commission)
    }
}

// Sales Tax Calculator
struct SalesTaxResult { let netAmount: Double; let taxAmount: Double; let totalAmount: Double }
class SalesTaxCalculator {
    func calculate(amount: Double, taxRate: Double, isReverse: Bool) -> SalesTaxResult {
        if isReverse {
            let net = amount / (1 + taxRate / 100)
            return SalesTaxResult(netAmount: net, taxAmount: amount - net, totalAmount: amount)
        } else {
            let tax = amount * (taxRate / 100)
            return SalesTaxResult(netAmount: amount, taxAmount: tax, totalAmount: amount + tax)
        }
    }
}

// Salary Calculator
struct SalaryResult { let annual: Double; let monthly: Double; let biWeekly: Double; let weekly: Double; let daily: Double; let hourly: Double }
class SalaryCalculator {
    func calculate(amount: Double, frequency: String, hoursPerWeek: Double, daysPerWeek: Double) -> SalaryResult {
        var annual: Double
        switch frequency {
        case "Annual": annual = amount
        case "Monthly": annual = amount * 12
        case "Bi-Weekly": annual = amount * 26
        case "Weekly": annual = amount * 52
        case "Daily": annual = amount * daysPerWeek * 52
        case "Hourly": annual = amount * hoursPerWeek * 52
        default: annual = 0
        }
        return SalaryResult(annual: annual, monthly: annual / 12, biWeekly: annual / 26, weekly: annual / 52, daily: annual / 52 / daysPerWeek, hourly: annual / 52 / hoursPerWeek)
    }
}
