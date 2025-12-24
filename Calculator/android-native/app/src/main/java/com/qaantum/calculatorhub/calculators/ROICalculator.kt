package com.qaantum.calculatorhub.calculators

data class ROIResult(
    val returnAmount: Double,
    val roiPercentage: Double
)

class ROICalculator {
    fun calculate(
        initialInvestment: Double,
        finalValue: Double
    ): ROIResult? {
        if (initialInvestment == 0.0) return null

        val gain = finalValue - initialInvestment
        val roi = (gain / initialInvestment) * 100.0

        return ROIResult(
            returnAmount = gain,
            roiPercentage = roi
        )
    }
}
