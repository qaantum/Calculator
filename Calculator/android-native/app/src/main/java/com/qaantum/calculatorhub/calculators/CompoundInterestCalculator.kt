package com.qaantum.calculatorhub.calculators

import kotlin.math.pow

data class CompoundInterestResult(
    val futureValue: Double,
    val totalContributions: Double,
    val totalInterest: Double
)

class CompoundInterestCalculator {
    fun calculate(
        principal: Double,
        annualRate: Double,
        years: Double,
        contribution: Double = 0.0,
        compoundsPerYear: Double = 12.0
    ): CompoundInterestResult {
        val rate = annualRate / 100.0
        val n = compoundsPerYear

        // Future Value of Principal: P(1 + r/n)^(nt)
        val fvPrincipal = principal * (1 + rate / n).pow(n * years)

        // Future Value of Series (Contributions): PMT * [((1 + r/n)^(nt) - 1) / (r/n)]
        val fvContributions = if (rate > 0) {
            contribution * ((1 + rate / n).pow(n * years) - 1) / (rate / n)
        } else {
            contribution * n * years
        }

        val total = fvPrincipal + fvContributions
        val totalContributed = principal + (contribution * n * years)
        val totalInterest = total - totalContributed

        return CompoundInterestResult(
            futureValue = total,
            totalContributions = totalContributed,
            totalInterest = totalInterest
        )
    }
}

