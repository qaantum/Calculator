package com.qaantum.calculatorhub.calculators

import kotlin.math.pow

data class BMIResult(
    val bmi: Double,
    val category: String
)

class BMICalculator {
    fun calculate(
        height: Double,
        weight: Double,
        isMetric: Boolean
    ): BMIResult {
        val bmi = if (isMetric) {
            // Metric: kg / (m^2)
            val heightInMeters = height / 100.0 // cm to m
            weight / heightInMeters.pow(2)
        } else {
            // Imperial: 703 * lbs / (in^2)
            weight * 703.0 / height.pow(2)
        }

        val category = when {
            bmi < 18.5 -> "Underweight"
            bmi < 25 -> "Normal"
            bmi < 30 -> "Overweight"
            else -> "Obese"
        }

        return BMIResult(bmi, category)
    }

    fun calculateImperial(
        feet: Double,
        inches: Double,
        weight: Double
    ): BMIResult {
        val totalInches = (feet * 12) + inches
        return calculate(totalInches, weight, isMetric = false)
    }
}

