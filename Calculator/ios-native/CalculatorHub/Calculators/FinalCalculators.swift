import Foundation

// Matrix Determinant Calculator
class MatrixDeterminantCalculator {
    func det2x2(_ a: Double, _ b: Double, _ c: Double, _ d: Double) -> Double { a * d - b * c }
    
    func det3x3(_ matrix: [[Double]]) -> Double {
        let a = matrix[0][0]; let b = matrix[0][1]; let c = matrix[0][2]
        let d = matrix[1][0]; let e = matrix[1][1]; let f = matrix[1][2]
        let g = matrix[2][0]; let h = matrix[2][1]; let i = matrix[2][2]
        return a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)
    }
}

// Color Converter
struct ColorResult { let hex: String; let rgb: (Int, Int, Int); let hsl: (Int, Int, Int) }
class ColorConverter {
    func rgbToHex(_ r: Int, _ g: Int, _ b: Int) -> String { String(format: "#%02X%02X%02X", r, g, b) }
    
    func hexToRgb(_ hex: String) -> (Int, Int, Int) {
        let clean = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        guard clean.count == 6 else { return (0, 0, 0) }
        let r = Int(clean.prefix(2), radix: 16) ?? 0
        let g = Int(clean.dropFirst(2).prefix(2), radix: 16) ?? 0
        let b = Int(clean.suffix(2), radix: 16) ?? 0
        return (r, g, b)
    }
    
    func rgbToHsl(_ r: Int, _ g: Int, _ b: Int) -> (Int, Int, Int) {
        let rf = Double(r) / 255; let gf = Double(g) / 255; let bf = Double(b) / 255
        let maxC = max(rf, gf, bf); let minC = min(rf, gf, bf)
        let l = (maxC + minC) / 2
        guard maxC != minC else { return (0, 0, Int(l * 100)) }
        let d = maxC - minC
        let s = l > 0.5 ? d / (2 - maxC - minC) : d / (maxC + minC)
        var h: Double
        switch maxC {
        case rf: h = ((gf - bf) / d + (gf < bf ? 6 : 0)) / 6
        case gf: h = ((bf - rf) / d + 2) / 6
        default: h = ((rf - gf) / d + 4) / 6
        }
        return (Int(h * 360), Int(s * 100), Int(l * 100))
    }
}

// Loan Affordability Calculator
struct LoanAffordabilityResult { let maxLoan: Double; let monthlyPayment: Double; let totalInterest: Double }
class LoanAffordabilityCalculator {
    func calculate(monthlyIncome: Double, debtToIncomeRatio: Double, rate: Double, termMonths: Int) -> LoanAffordabilityResult {
        let maxPayment = monthlyIncome * (debtToIncomeRatio / 100)
        let monthlyRate = rate / 100 / 12
        let maxLoan = monthlyRate == 0 ? maxPayment * Double(termMonths) : maxPayment * (1 - pow(1 + monthlyRate, Double(-termMonths))) / monthlyRate
        return LoanAffordabilityResult(maxLoan: maxLoan, monthlyPayment: maxPayment, totalInterest: maxPayment * Double(termMonths) - maxLoan)
    }
}

// Refinance Calculator
struct RefinanceResult { let newPayment: Double; let oldPayment: Double; let monthlySavings: Double; let breakEvenMonths: Int }
class RefinanceCalculator {
    func calculate(loanBalance: Double, oldRate: Double, newRate: Double, termMonths: Int, closingCosts: Double) -> RefinanceResult {
        let oldMonthlyRate = oldRate / 100 / 12
        let newMonthlyRate = newRate / 100 / 12
        let oldPayment = loanBalance * (oldMonthlyRate * pow(1 + oldMonthlyRate, Double(termMonths))) / (pow(1 + oldMonthlyRate, Double(termMonths)) - 1)
        let newPayment = loanBalance * (newMonthlyRate * pow(1 + newMonthlyRate, Double(termMonths))) / (pow(1 + newMonthlyRate, Double(termMonths)) - 1)
        let savings = oldPayment - newPayment
        let breakEven = savings > 0 ? Int(ceil(closingCosts / savings)) : Int.max
        return RefinanceResult(newPayment: newPayment, oldPayment: oldPayment, monthlySavings: savings, breakEvenMonths: breakEven)
    }
}

// TVM Calculator
class TVMCalculator {
    func futureValue(pv: Double, rate: Double, periods: Int, pmt: Double = 0) -> Double {
        let r = rate / 100
        return pv * pow(1 + r, Double(periods)) + pmt * (pow(1 + r, Double(periods)) - 1) / r
    }
    func presentValue(fv: Double, rate: Double, periods: Int, pmt: Double = 0) -> Double {
        let r = rate / 100
        return fv / pow(1 + r, Double(periods)) - pmt * (1 - pow(1 + r, Double(-periods))) / r
    }
}

// Amortization Schedule
struct AmortizationRow { let month: Int; let payment: Double; let principal: Double; let interest: Double; let balance: Double }
class AmortizationCalculator {
    func generate(loanAmount: Double, rate: Double, termMonths: Int) -> [AmortizationRow] {
        let monthlyRate = rate / 100 / 12
        let payment = loanAmount * (monthlyRate * pow(1 + monthlyRate, Double(termMonths))) / (pow(1 + monthlyRate, Double(termMonths)) - 1)
        var schedule: [AmortizationRow] = []; var balance = loanAmount
        
        for month in 1...termMonths {
            let interest = balance * monthlyRate
            let principal = payment - interest
            balance -= principal
            schedule.append(AmortizationRow(month: month, payment: payment, principal: principal, interest: interest, balance: max(0, balance)))
        }
        return schedule
    }
}

// Rental Property Calculator
struct RentalResult { let annualCashFlow: Double; let capRate: Double; let roi: Double; let cashOnCash: Double }
class RentalPropertyCalculator {
    func calculate(purchasePrice: Double, downPayment: Double, monthlyRent: Double, monthlyExpenses: Double, mortgagePayment: Double) -> RentalResult {
        let noi = monthlyRent * 12 - monthlyExpenses * 12
        let cashFlow = monthlyRent - monthlyExpenses - mortgagePayment
        let capRate = (noi / purchasePrice) * 100
        let roi = ((cashFlow * 12) / purchasePrice) * 100
        let cashOnCash = ((cashFlow * 12) / downPayment) * 100
        return RentalResult(annualCashFlow: cashFlow * 12, capRate: capRate, roi: roi, cashOnCash: cashOnCash)
    }
}
