package com.qaantum.calculatorhub.calculators

import kotlin.math.pow

data class RetirementResult(
    val totalSavings: Double,
    val monthlyIncome: Double // Based on 4% rule
)

class RetirementCalculator {
    fun calculate(
        currentAge: Int,
        retirementAge: Int,
        currentSavings: Double,
        monthlyContribution: Double,
        annualRate: Double
    ): RetirementResult? {
        val years = retirementAge - currentAge
        val months = years * 12
        
        if (months <= 0) return null

        val rate = annualRate / 100.0 / 12.0

        // FV of Initial Savings
        val fvSavings = currentSavings * (1 + rate).pow(months.toDouble())

        // FV of Contributions
        val fvContributions = if (rate != 0.0) {
            monthlyContribution * ((1 + rate).pow(months.toDouble()) - 1) / rate
        } else {
            monthlyContribution * months
        }

        val total = fvSavings + fvContributions
        // 4% Rule for safe withdrawal rate (annual) -> monthly
        val monthlyIncome = (total * 0.04) / 12.0

        return RetirementResult(
            totalSavings = total,
            monthlyIncome = monthlyIncome
        )
    }
}
