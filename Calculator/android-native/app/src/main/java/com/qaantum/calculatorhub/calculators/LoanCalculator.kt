package com.qaantum.calculatorhub.calculators

import kotlin.math.pow

data class LoanResult(
    val monthlyPayment: Double,
    val totalInterest: Double,
    val totalCost: Double
)

class LoanCalculator {
    fun calculate(
        principal: Double,
        annualRate: Double,
        termMonths: Int
    ): LoanResult {
        val monthlyRate = annualRate / 100.0 / 12.0
        
        val monthlyPayment = if (monthlyRate == 0.0) {
            principal / termMonths
        } else {
            principal * (monthlyRate * (1 + monthlyRate).pow(termMonths)) /
                    ((1 + monthlyRate).pow(termMonths) - 1)
        }
        
        val totalPayment = monthlyPayment * termMonths
        val totalInterest = totalPayment - principal
        
        return LoanResult(
            monthlyPayment = monthlyPayment,
            totalInterest = totalInterest,
            totalCost = totalPayment
        )
    }
}
