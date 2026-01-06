import Foundation

// NEW FINANCE CALCULATORS

// NPV Calculator
struct NPVResult { let npv: Double; let isProfitable: Bool }
class NPVCalculator {
    func calculate(initialInvestment: Double, cashFlows: [Double], discountRate: Double) -> NPVResult {
        let r = discountRate / 100
        var npv = -initialInvestment
        for (i, cf) in cashFlows.enumerated() { npv += cf / pow(1 + r, Double(i + 1)) }
        return NPVResult(npv: npv, isProfitable: npv >= 0)
    }
}

// IRR Calculator
struct IRRResult { let irr: Double; let isValid: Bool }
class IRRCalculator {
    func calculate(initialInvestment: Double, cashFlows: [Double]) -> IRRResult {
        let allCashFlows = [-initialInvestment] + cashFlows
        var rate = 0.1
        for _ in 0..<100 {
            var npv = 0.0; var derivative = 0.0
            for (j, cf) in allCashFlows.enumerated() {
                npv += cf / pow(1 + rate, Double(j))
                if j > 0 { derivative -= Double(j) * cf / pow(1 + rate, Double(j + 1)) }
            }
            if abs(derivative) < 1e-10 { return IRRResult(irr: rate * 100, isValid: false) }
            let newRate = rate - npv / derivative
            if abs(newRate - rate) < 0.0001 { return IRRResult(irr: newRate * 100, isValid: true) }
            rate = newRate
        }
        return IRRResult(irr: rate * 100, isValid: true)
    }
}

// Down Payment Calculator
struct DownPaymentResult { let downPayment: Double; let loanAmount: Double; let monthlyPayment: Double }
class DownPaymentCalculator {
    func calculate(purchasePrice: Double, downPaymentPercent: Double, interestRate: Double, loanTermYears: Int) -> DownPaymentResult {
        let downPayment = purchasePrice * (downPaymentPercent / 100)
        let loanAmount = purchasePrice - downPayment
        let monthlyRate = interestRate / 100 / 12
        let numPayments = Double(loanTermYears * 12)
        let monthlyPayment = monthlyRate == 0 ? loanAmount / numPayments : loanAmount * (monthlyRate * pow(1 + monthlyRate, numPayments)) / (pow(1 + monthlyRate, numPayments) - 1)
        return DownPaymentResult(downPayment: downPayment, loanAmount: loanAmount, monthlyPayment: monthlyPayment)
    }
}

// Paycheck Calculator
struct PaycheckResult { let grossPay, federalTax, stateTax, socialSecurity, medicare, healthInsurance, retirement, totalDeductions, netPay: Double }
class PaycheckCalculator {
    func calculate(annualSalary: Double, payPeriod: String, federalRate: Double, stateRate: Double, ssRate: Double = 6.2, medicareRate: Double = 1.45, healthInsurance: Double = 0, retirementPercent: Double = 0) -> PaycheckResult {
        let periods: Double = { switch payPeriod { case "Weekly": return 52; case "Biweekly": return 26; case "Semi-Monthly": return 24; case "Monthly": return 12; default: return 1 } }()
        let grossPay = annualSalary / periods
        let federal = grossPay * federalRate / 100; let state = grossPay * stateRate / 100
        let ss = grossPay * ssRate / 100; let med = grossPay * medicareRate / 100; let ret = grossPay * retirementPercent / 100
        let total = federal + state + ss + med + healthInsurance + ret
        return PaycheckResult(grossPay: grossPay, federalTax: federal, stateTax: state, socialSecurity: ss, medicare: med, healthInsurance: healthInsurance, retirement: ret, totalDeductions: total, netPay: grossPay - total)
    }
}

// CD Calculator
struct CDResult { let totalValue: Double; let interestEarned: Double }
class CDCalculator {
    func calculate(deposit: Double, apy: Double, termMonths: Int, compoundingFrequency: Int = 365) -> CDResult {
        let t = Double(termMonths) / 12.0; let r = apy / 100
        let total = deposit * pow(1 + r / Double(compoundingFrequency), Double(compoundingFrequency) * t)
        return CDResult(totalValue: total, interestEarned: total - deposit)
    }
}

// Tip Split Calculator
struct TipSplitResult { let tipAmount, totalWithTip, perPersonAmount, perPersonTip: Double }
class TipSplitCalculator {
    func calculate(billAmount: Double, tipPercent: Double, numberOfPeople: Int) -> TipSplitResult {
        let tip = billAmount * tipPercent / 100; let total = billAmount + tip
        return TipSplitResult(tipAmount: tip, totalWithTip: total, perPersonAmount: total / Double(numberOfPeople), perPersonTip: tip / Double(numberOfPeople))
    }
}
