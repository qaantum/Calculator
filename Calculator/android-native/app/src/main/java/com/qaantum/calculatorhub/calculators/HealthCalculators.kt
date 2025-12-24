package com.qaantum.calculatorhub.calculators

import kotlin.math.ln
import kotlin.math.log10

data class BMRResult(val bmr: Double)
data class CaloriesResult(val tdee: Double)
data class BodyFatResult(val bodyFatPercentage: Double)
data class IdealWeightResult(val idealWeight: Double, val range: Pair<Double, Double>)

class BMRCalculator {
    // Mifflin-St Jeor Equation
    fun calculate(gender: String, age: Int, heightCm: Double, weightKg: Double): BMRResult {
        val bmr = if (gender == "Male") {
            (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5
        } else {
            (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161
        }
        return BMRResult(bmr)
    }
}

class CaloriesCalculator {
    // TDEE = BMR * Activity Level
    fun calculate(gender: String, age: Int, heightCm: Double, weightKg: Double, activityLevel: Double): CaloriesResult {
        val bmr = if (gender == "Male") {
            (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5
        } else {
            (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161
        }
        return CaloriesResult(bmr * activityLevel)
    }
}

class BodyFatCalculator {
    // US Navy Method
    fun calculate(gender: String, heightCm: Double, waistCm: Double, neckCm: Double, hipCm: Double = 0.0): BodyFatResult {
        val bodyFat = if (gender == "Male") {
            495 / (1.0324 - 0.19077 * log10(waistCm - neckCm) + 0.15456 * log10(heightCm)) - 450
        } else {
            495 / (1.29579 - 0.35004 * log10(waistCm + hipCm - neckCm) + 0.22100 * log10(heightCm)) - 450
        }
        return BodyFatResult(bodyFat)
    }
}

class IdealWeightCalculator {
    // Devine Formula
    fun calculate(gender: String, heightCm: Double): IdealWeightResult {
        val heightInches = heightCm / 2.54
        val baseHeight = 60.0 // 5 feet
        
        val ideal = if (gender == "Male") {
            50 + 2.3 * (heightInches - baseHeight)
        } else {
            45.5 + 2.3 * (heightInches - baseHeight)
        }
        
        // BMI-based range (18.5 - 24.9)
        val heightM = heightCm / 100.0
        val minWeight = 18.5 * heightM * heightM
        val maxWeight = 24.9 * heightM * heightM
        
        return IdealWeightResult(ideal.coerceAtLeast(0.0), Pair(minWeight, maxWeight))
    }
}
