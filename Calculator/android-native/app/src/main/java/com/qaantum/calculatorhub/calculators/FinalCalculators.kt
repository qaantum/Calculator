package com.qaantum.calculatorhub.calculators

import kotlin.math.*

// Matrix Determinant Calculator (2x2 and 3x3)
class MatrixDeterminantCalculator {
    fun det2x2(a: Double, b: Double, c: Double, d: Double): Double = a * d - b * c
    
    fun det3x3(matrix: Array<DoubleArray>): Double {
        val a = matrix[0][0]; val b = matrix[0][1]; val c = matrix[0][2]
        val d = matrix[1][0]; val e = matrix[1][1]; val f = matrix[1][2]
        val g = matrix[2][0]; val h = matrix[2][1]; val i = matrix[2][2]
        return a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)
    }
}

// Color Converter (RGB/HEX/HSL)
data class ColorResult(val hex: String, val rgb: Triple<Int, Int, Int>, val hsl: Triple<Int, Int, Int>)
class ColorConverter {
    fun rgbToHex(r: Int, g: Int, b: Int): String = "#%02X%02X%02X".format(r, g, b)
    
    fun hexToRgb(hex: String): Triple<Int, Int, Int> {
        val clean = hex.removePrefix("#")
        return try {
            Triple(clean.substring(0, 2).toInt(16), clean.substring(2, 4).toInt(16), clean.substring(4, 6).toInt(16))
        } catch (e: Exception) { Triple(0, 0, 0) }
    }
    
    fun rgbToHsl(r: Int, g: Int, b: Int): Triple<Int, Int, Int> {
        val rf = r / 255.0; val gf = g / 255.0; val bf = b / 255.0
        val max = maxOf(rf, gf, bf); val min = minOf(rf, gf, bf)
        val l = (max + min) / 2
        if (max == min) return Triple(0, 0, (l * 100).toInt())
        val d = max - min
        val s = if (l > 0.5) d / (2 - max - min) else d / (max + min)
        val h = when (max) {
            rf -> ((gf - bf) / d + (if (gf < bf) 6 else 0)) / 6
            gf -> ((bf - rf) / d + 2) / 6
            else -> ((rf - gf) / d + 4) / 6
        }
        return Triple((h * 360).toInt(), (s * 100).toInt(), (l * 100).toInt())
    }
}

// Loan Affordability Calculator
data class LoanAffordabilityResult(val maxLoan: Double, val monthlyPayment: Double, val totalInterest: Double)
class LoanAffordabilityCalculator {
    fun calculate(monthlyIncome: Double, debtToIncomeRatio: Double, rate: Double, termMonths: Int): LoanAffordabilityResult {
        val maxPayment = monthlyIncome * (debtToIncomeRatio / 100)
        val monthlyRate = rate / 100 / 12
        val maxLoan = if (monthlyRate == 0.0) maxPayment * termMonths 
                      else maxPayment * (1 - (1 + monthlyRate).pow(-termMonths)) / monthlyRate
        return LoanAffordabilityResult(maxLoan, maxPayment, maxPayment * termMonths - maxLoan)
    }
}

// Refinance Calculator
data class RefinanceResult(val newPayment: Double, val oldPayment: Double, val monthlySavings: Double, val breakEvenMonths: Int)
class RefinanceCalculator {
    fun calculate(loanBalance: Double, oldRate: Double, newRate: Double, termMonths: Int, closingCosts: Double): RefinanceResult {
        val oldMonthlyRate = oldRate / 100 / 12
        val newMonthlyRate = newRate / 100 / 12
        val oldPayment = loanBalance * (oldMonthlyRate * (1 + oldMonthlyRate).pow(termMonths)) / ((1 + oldMonthlyRate).pow(termMonths) - 1)
        val newPayment = loanBalance * (newMonthlyRate * (1 + newMonthlyRate).pow(termMonths)) / ((1 + newMonthlyRate).pow(termMonths) - 1)
        val savings = oldPayment - newPayment
        val breakEven = if (savings > 0) ceil(closingCosts / savings).toInt() else Int.MAX_VALUE
        return RefinanceResult(newPayment, oldPayment, savings, breakEven)
    }
}

// TVM Calculator (Time Value of Money)
data class TVMResult(val futureValue: Double?, val presentValue: Double?, val payment: Double?, val periods: Int?, val rate: Double?)
class TVMCalculator {
    fun futureValue(pv: Double, rate: Double, periods: Int, pmt: Double = 0.0): Double {
        val r = rate / 100
        return pv * (1 + r).pow(periods) + pmt * ((1 + r).pow(periods) - 1) / r
    }
    fun presentValue(fv: Double, rate: Double, periods: Int, pmt: Double = 0.0): Double {
        val r = rate / 100
        return fv / (1 + r).pow(periods) - pmt * (1 - (1 + r).pow(-periods)) / r
    }
}

// Debt Snowball Calculator
data class DebtInfo(val name: String, val balance: Double, val minPayment: Double, val rate: Double)
data class DebtPayoffResult(val totalMonths: Int, val totalInterest: Double, val payoffOrder: List<String>)
class DebtSnowballCalculator {
    fun calculate(debts: List<DebtInfo>, extraPayment: Double): DebtPayoffResult {
        val sorted = debts.sortedBy { it.balance } // Snowball: smallest first
        var totalMonths = 0
        var totalInterest = 0.0
        val order = mutableListOf<String>()
        var extra = extraPayment
        val balances = sorted.map { it.balance }.toMutableList()
        
        while (balances.any { it > 0 }) {
            totalMonths++
            if (totalMonths > 600) break // Safety limit
            
            for (i in sorted.indices) {
                if (balances[i] <= 0) continue
                val interest = balances[i] * sorted[i].rate / 100 / 12
                totalInterest += interest
                val payment = sorted[i].minPayment + (if (balances.take(i).all { it <= 0 }) extra else 0.0)
                balances[i] = balances[i] + interest - payment
                if (balances[i] <= 0 && !order.contains(sorted[i].name)) {
                    order.add(sorted[i].name)
                }
            }
        }
        return DebtPayoffResult(totalMonths, totalInterest, order)
    }
}

// Amortization Schedule
data class AmortizationRow(val month: Int, val payment: Double, val principal: Double, val interest: Double, val balance: Double)
class AmortizationCalculator {
    fun generate(loanAmount: Double, rate: Double, termMonths: Int): List<AmortizationRow> {
        val monthlyRate = rate / 100 / 12
        val payment = loanAmount * (monthlyRate * (1 + monthlyRate).pow(termMonths)) / ((1 + monthlyRate).pow(termMonths) - 1)
        val schedule = mutableListOf<AmortizationRow>()
        var balance = loanAmount
        
        for (month in 1..termMonths) {
            val interest = balance * monthlyRate
            val principal = payment - interest
            balance -= principal
            schedule.add(AmortizationRow(month, payment, principal, interest, maxOf(0.0, balance)))
        }
        return schedule
    }
}

// Rental Property Calculator
data class RentalResult(val cashFlow: Double, val capRate: Double, val roi: Double, val cashOnCash: Double)
class RentalPropertyCalculator {
    fun calculate(purchasePrice: Double, downPayment: Double, monthlyRent: Double, monthlyExpenses: Double, mortgagePayment: Double): RentalResult {
        val annualIncome = monthlyRent * 12
        val annualExpenses = (monthlyExpenses + mortgagePayment) * 12
        val noi = annualIncome - (monthlyExpenses * 12) // Net Operating Income (before mortgage)
        val cashFlow = monthlyRent - monthlyExpenses - mortgagePayment
        val capRate = (noi / purchasePrice) * 100
        val roi = ((cashFlow * 12) / purchasePrice) * 100
        val cashOnCash = ((cashFlow * 12) / downPayment) * 100
        return RentalResult(cashFlow * 12, capRate, roi, cashOnCash)
    }
}
