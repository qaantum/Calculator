package com.qaantum.calculatorhub.calculators

import kotlin.math.pow

data class MortgageResult(
    val monthlyPrincipalAndInterest: Double,
    val monthlyTax: Double,
    val monthlyInsurance: Double,
    val monthlyHOA: Double,
    val totalMonthlyPayment: Double
)

class MortgageCalculator {
    fun calculate(
        principal: Double,
        annualRate: Double,
        termYears: Int,
        annualPropertyTax: Double = 0.0,
        annualInsurance: Double = 0.0,
        monthlyHOA: Double = 0.0
    ): MortgageResult {
        val monthlyRate = annualRate / 100.0 / 12.0
        val termMonths = termYears * 12
        
        val monthlyPI = if (monthlyRate == 0.0) {
            principal / termMonths
        } else {
            principal * (monthlyRate * (1 + monthlyRate).pow(termMonths)) /
                    ((1 + monthlyRate).pow(termMonths) - 1)
        }
        
        val monthlyTax = annualPropertyTax / 12.0
        val monthlyInsurance = annualInsurance / 12.0
        val totalMonthly = monthlyPI + monthlyTax + monthlyInsurance + monthlyHOA
        
        return MortgageResult(
            monthlyPrincipalAndInterest = monthlyPI,
            monthlyTax = monthlyTax,
            monthlyInsurance = monthlyInsurance,
            monthlyHOA = monthlyHOA,
            totalMonthlyPayment = totalMonthly
        )
    }
}
