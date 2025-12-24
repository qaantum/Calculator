package com.qaantum.calculatorhub.calculators

import kotlin.math.pow

data class CAGRResult(
    val cagr: Double,
    val totalGrowth: Double
)

class CAGRCalculator {
    fun calculate(
        startValue: Double,
        endValue: Double,
        years: Double
    ): CAGRResult? {
        if (startValue == 0.0 || years == 0.0) return null

        // CAGR = (End / Start)^(1/n) - 1
        val cagrVal = (endValue / startValue).pow(1.0 / years) - 1
        val totalGrowthVal = (endValue - startValue) / startValue

        return CAGRResult(
            cagr = cagrVal * 100.0, // Return as percentage
            totalGrowth = totalGrowthVal * 100.0
        )
    }
}
