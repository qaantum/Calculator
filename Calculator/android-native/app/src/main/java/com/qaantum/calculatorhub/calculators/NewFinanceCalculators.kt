package com.qaantum.calculatorhub.calculators

import kotlin.math.ln
import kotlin.math.log10
import kotlin.math.log2
import kotlin.math.pow

// NEW FINANCE CALCULATORS

// NPV Calculator
data class NPVResult(val npv: Double, val isProfitable: Boolean)
class NPVCalculator {
    fun calculate(initialInvestment: Double, cashFlows: List<Double>, discountRate: Double): NPVResult {
        val r = discountRate / 100
        var npv = -initialInvestment
        cashFlows.forEachIndexed { i, cf ->
            npv += cf / (1 + r).pow(i + 1)
        }
        return NPVResult(npv, npv >= 0)
    }
}

// IRR Calculator (Newton-Raphson approximation)
data class IRRResult(val irr: Double, val isValid: Boolean)
class IRRCalculator {
    fun calculate(initialInvestment: Double, cashFlows: List<Double>): IRRResult {
        val allCashFlows = listOf(-initialInvestment) + cashFlows
        var rate = 0.1 // Initial guess
        val maxIterations = 100
        val tolerance = 0.0001
        
        repeat(maxIterations) {
            var npv = 0.0
            var derivative = 0.0
            allCashFlows.forEachIndexed { j, cf ->
                npv += cf / (1 + rate).pow(j)
                if (j > 0) derivative -= j * cf / (1 + rate).pow(j + 1)
            }
            if (kotlin.math.abs(derivative) < 1e-10) return IRRResult(rate * 100, false)
            val newRate = rate - npv / derivative
            if (kotlin.math.abs(newRate - rate) < tolerance) {
                return IRRResult(newRate * 100, true)
            }
            rate = newRate
        }
        return IRRResult(rate * 100, true)
    }
}

// Down Payment Calculator
data class DownPaymentResult(val downPayment: Double, val loanAmount: Double, val monthlyPayment: Double)
class DownPaymentCalculator {
    fun calculate(purchasePrice: Double, downPaymentPercent: Double, interestRate: Double, loanTermYears: Int): DownPaymentResult {
        val downPayment = purchasePrice * (downPaymentPercent / 100)
        val loanAmount = purchasePrice - downPayment
        val monthlyRate = interestRate / 100 / 12
        val numPayments = loanTermYears * 12
        
        val monthlyPayment = if (monthlyRate == 0.0) {
            loanAmount / numPayments
        } else {
            loanAmount * (monthlyRate * (1 + monthlyRate).pow(numPayments)) / ((1 + monthlyRate).pow(numPayments) - 1)
        }
        return DownPaymentResult(downPayment, loanAmount, monthlyPayment)
    }
}

// Paycheck Calculator
data class PaycheckResult(
    val grossPay: Double, val federalTax: Double, val stateTax: Double,
    val socialSecurity: Double, val medicare: Double, val healthInsurance: Double,
    val retirement: Double, val totalDeductions: Double, val netPay: Double
)
class PaycheckCalculator {
    fun calculate(
        annualSalary: Double, payPeriod: String, federalRate: Double, stateRate: Double,
        ssRate: Double = 6.2, medicareRate: Double = 1.45, healthInsurance: Double = 0.0, retirementPercent: Double = 0.0
    ): PaycheckResult {
        val periodsPerYear = when (payPeriod) {
            "Weekly" -> 52; "Biweekly" -> 26; "Semi-Monthly" -> 24; "Monthly" -> 12; else -> 1
        }
        val grossPay = annualSalary / periodsPerYear
        val federal = grossPay * federalRate / 100
        val state = grossPay * stateRate / 100
        val ss = grossPay * ssRate / 100
        val medicare = grossPay * medicareRate / 100
        val retirement = grossPay * retirementPercent / 100
        val total = federal + state + ss + medicare + healthInsurance + retirement
        return PaycheckResult(grossPay, federal, state, ss, medicare, healthInsurance, retirement, total, grossPay - total)
    }
}

// CD Calculator
data class CDResult(val totalValue: Double, val interestEarned: Double)
class CDCalculator {
    fun calculate(deposit: Double, apy: Double, termMonths: Int, compoundingFrequency: Int = 365): CDResult {
        val t = termMonths / 12.0
        val r = apy / 100
        val total = deposit * (1 + r / compoundingFrequency).pow(compoundingFrequency * t)
        return CDResult(total, total - deposit)
    }
}

// Tip Split Calculator
data class TipSplitResult(val tipAmount: Double, val totalWithTip: Double, val perPersonAmount: Double, val perPersonTip: Double)
class TipSplitCalculator {
    fun calculate(billAmount: Double, tipPercent: Double, numberOfPeople: Int): TipSplitResult {
        val tip = billAmount * tipPercent / 100
        val total = billAmount + tip
        return TipSplitResult(tip, total, total / numberOfPeople, tip / numberOfPeople)
    }
}
