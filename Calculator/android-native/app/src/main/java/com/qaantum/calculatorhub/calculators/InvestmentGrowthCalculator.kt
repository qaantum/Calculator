package com.qaantum.calculatorhub.calculators

import kotlin.math.pow

data class InvestmentGrowthResult(
    val totalValue: Double,
    val totalContributions: Double,
    val totalInterest: Double
)

class InvestmentGrowthCalculator {
    fun calculate(
        initialAmount: Double,
        monthlyContribution: Double,
        annualRate: Double,
        years: Double
    ): InvestmentGrowthResult {
        val r = annualRate / 100.0
        val n = 12.0 // Monthly
        val t = years

        // Future Value of Initial Amount: P * (1 + r/n)^(nt)
        val fvInitial = initialAmount * (1 + r / n).pow(n * t)

        // Future Value of Contributions: PMT * ((1 + r/n)^(nt) - 1) / (r/n)
        val fvContributions = if (r != 0.0) {
            monthlyContribution * ((1 + r / n).pow(n * t) - 1) / (r / n)
        } else {
            monthlyContribution * n * t
        }

        val totalValue = fvInitial + fvContributions
        val totalContributed = initialAmount + (monthlyContribution * n * t)
        val totalInterest = totalValue - totalContributed

        return InvestmentGrowthResult(
            totalValue = totalValue,
            totalContributions = totalContributed,
            totalInterest = totalInterest
        )
    }
}
