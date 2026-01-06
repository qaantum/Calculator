package com.qaantum.calculatorhub.data

import com.qaantum.calculatorhub.customcalculator.CalculatorVariable
import com.qaantum.calculatorhub.customcalculator.CustomCalculator
import java.util.UUID

object CalculatorTemplates {
    fun getTemplate(route: String): CustomCalculator? {
        val baseId = UUID.randomUUID().toString()
        val now = System.currentTimeMillis()
        
        return when (route) {
            "/math/quadratic" -> CustomCalculator(
                id = baseId,
                title = "Quadratic Solver (Root 1)",
                inputs = listOf(
                    CalculatorVariable("a", "", "Coefficient x²"),
                    CalculatorVariable("b", "", "Coefficient x"),
                    CalculatorVariable("c", "", "Constant")
                ),
                formula = "(-b + sqrt(b^2 - 4*a*c)) / (2*a)",
                createdAt = now, updatedAt = now
            )
            "/electronics/ohms-law" -> CustomCalculator(
                id = baseId,
                title = "Ohm's Law (Voltage)",
                inputs = listOf(
                    CalculatorVariable("I", "A", "Current"),
                    CalculatorVariable("R", "Ω", "Resistance")
                ),
                formula = "I * R",
                createdAt = now, updatedAt = now
            )
            "/health/bmi" -> CustomCalculator(
                id = baseId,
                title = "BMI Calculator",
                inputs = listOf(
                    CalculatorVariable("weight", "kg", "Weight"),
                    CalculatorVariable("height", "m", "Height")
                ),
                formula = "weight / (height * height)",
                createdAt = now, updatedAt = now
            )
            "/finance/tip" -> CustomCalculator(
                id = baseId,
                title = "Tip Calculator",
                inputs = listOf(
                    CalculatorVariable("bill", "$", "Bill Amount"),
                    CalculatorVariable("rate", "%", "Tip Rate")
                ),
                formula = "bill * (rate / 100)",
                createdAt = now, updatedAt = now
            )
            "/science/force" -> CustomCalculator(
                id = baseId,
                title = "Force (F=ma)",
                inputs = listOf(
                    CalculatorVariable("m", "kg", "Mass"),
                    CalculatorVariable("a", "m/s²", "Acceleration")
                ),
                formula = "m * a",
                createdAt = now, updatedAt = now
            )
            // Add generic fallback if needed, or return null
            else -> null
        }
    }
}
