package com.qaantum.calculatorhub.calculators

import kotlin.math.pow

// Auto Loan Calculator
data class AutoLoanResult(val monthlyPayment: Double, val totalInterest: Double, val totalCost: Double)

class AutoLoanCalculator {
    fun calculate(price: Double, downPayment: Double, tradeIn: Double, rate: Double, termMonths: Int, taxRate: Double): AutoLoanResult {
        val taxableAmount = price - tradeIn
        val salesTax = taxableAmount * (taxRate / 100)
        val loanAmount = price + salesTax - downPayment - tradeIn
        if (loanAmount <= 0) return AutoLoanResult(0.0, 0.0, 0.0)
        val monthlyRate = rate / 100 / 12
        if (monthlyRate == 0.0) return AutoLoanResult(loanAmount / termMonths, 0.0, loanAmount)
        val mp = loanAmount * (monthlyRate * (1 + monthlyRate).pow(termMonths)) / ((1 + monthlyRate).pow(termMonths) - 1)
        return AutoLoanResult(mp, mp * termMonths - loanAmount, mp * termMonths)
    }
}

// Commission Calculator
data class CommissionResult(val commission: Double, val netProceeds: Double)
class CommissionCalculator {
    fun calculate(salePrice: Double, commissionRate: Double): CommissionResult {
        val commission = salePrice * (commissionRate / 100)
        return CommissionResult(commission, salePrice - commission)
    }
}

// Sales Tax Calculator
data class SalesTaxResult(val netAmount: Double, val taxAmount: Double, val totalAmount: Double)
class SalesTaxCalculator {
    fun calculate(amount: Double, taxRate: Double, isReverse: Boolean): SalesTaxResult {
        return if (isReverse) {
            val net = amount / (1 + taxRate / 100)
            SalesTaxResult(net, amount - net, amount)
        } else {
            val tax = amount * (taxRate / 100)
            SalesTaxResult(amount, tax, amount + tax)
        }
    }
}

// Salary Calculator
data class SalaryResult(val annual: Double, val monthly: Double, val biWeekly: Double, val weekly: Double, val daily: Double, val hourly: Double)
class SalaryCalculator {
    fun calculate(amount: Double, frequency: String, hoursPerWeek: Double, daysPerWeek: Double): SalaryResult {
        val annual = when (frequency) {
            "Annual" -> amount
            "Monthly" -> amount * 12
            "Bi-Weekly" -> amount * 26
            "Weekly" -> amount * 52
            "Daily" -> amount * daysPerWeek * 52
            "Hourly" -> amount * hoursPerWeek * 52
            else -> 0.0
        }
        return SalaryResult(annual, annual / 12, annual / 26, annual / 52, annual / 52 / daysPerWeek, annual / 52 / hoursPerWeek)
    }
}
