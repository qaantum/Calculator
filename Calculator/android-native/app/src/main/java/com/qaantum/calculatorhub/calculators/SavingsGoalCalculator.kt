package com.qaantum.calculatorhub.calculators

import kotlin.math.pow

data class SavingsGoalResult(
    val monthlyContribution: Double
)

class SavingsGoalCalculator {
    fun calculate(
        goalAmount: Double,
        initialSavings: Double,
        annualRate: Double,
        years: Double
    ): SavingsGoalResult {
        val rate = annualRate / 100.0 / 12.0
        val months = years * 12.0

        // Formula: PMT = (FV - PV * (1 + r)^n) * r / ((1 + r)^n - 1)
        val pmt = if (rate == 0.0) {
            (goalAmount - initialSavings) / months
        } else {
            (goalAmount - initialSavings * (1 + rate).pow(months)) * rate /
                    ((1 + rate).pow(months) - 1)
        }

        return SavingsGoalResult(
            monthlyContribution = if (pmt > 0) pmt else 0.0
        )
    }
}
