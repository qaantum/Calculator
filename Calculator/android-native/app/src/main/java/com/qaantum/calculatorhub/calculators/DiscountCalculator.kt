package com.qaantum.calculatorhub.calculators

data class DiscountResult(
    val savedAmount: Double,
    val finalPrice: Double
)

class DiscountCalculator {
    fun calculate(
        originalPrice: Double,
        discountPercentage: Double
    ): DiscountResult {
        val saved = originalPrice * (discountPercentage / 100.0)
        val finalPrice = originalPrice - saved
        
        return DiscountResult(
            savedAmount = saved,
            finalPrice = finalPrice
        )
    }
}
