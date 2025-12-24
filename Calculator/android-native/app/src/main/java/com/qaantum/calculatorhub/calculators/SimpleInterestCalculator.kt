package com.qaantum.calculatorhub.calculators

data class SimpleInterestResult(
    val interest: Double,
    val totalAmount: Double
)

class SimpleInterestCalculator {
    fun calculate(
        principal: Double,
        annualRate: Double,
        timeYears: Double
    ): SimpleInterestResult {
        val rate = annualRate / 100.0
        val interest = principal * rate * timeYears
        val total = principal + interest
        
        return SimpleInterestResult(
            interest = interest,
            totalAmount = total
        )
    }
}
