package com.qaantum.calculatorhub.calculators

import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.time.temporal.ChronoUnit

// Currency Converter (with static fallback rates - can be updated via API)
data class CurrencyConversionResult(val amount: Double, val fromCurrency: String, val toCurrency: String, val result: Double, val rate: Double)
class CurrencyConverter {
    // Static exchange rates (relative to USD) - can be updated via API
    private val rates = mapOf(
        "USD" to 1.0, "EUR" to 0.92, "GBP" to 0.79, "JPY" to 149.50,
        "CAD" to 1.36, "AUD" to 1.53, "CHF" to 0.88, "CNY" to 7.24,
        "INR" to 83.12, "MXN" to 17.15, "BRL" to 4.97, "KRW" to 1320.0,
        "SGD" to 1.34, "HKD" to 7.82, "NZD" to 1.64, "SEK" to 10.42
    )
    
    val currencies = rates.keys.toList()
    
    fun convert(amount: Double, from: String, to: String): CurrencyConversionResult {
        val fromRate = rates[from] ?: 1.0
        val toRate = rates[to] ?: 1.0
        val amountInUSD = amount / fromRate
        val result = amountInUSD * toRate
        return CurrencyConversionResult(amount, from, to, result, toRate / fromRate)
    }
}

// Ovulation Calculator
data class OvulationResult(val ovulationDate: String, val fertileWindowStart: String, val fertileWindowEnd: String, val nextPeriodDate: String)
class OvulationCalculator {
    fun calculate(lastPeriodYear: Int, lastPeriodMonth: Int, lastPeriodDay: Int, cycleLength: Int): OvulationResult {
        val lmp = LocalDate.of(lastPeriodYear, lastPeriodMonth, lastPeriodDay)
        val nextPeriod = lmp.plusDays(cycleLength.toLong())
        val ovulation = nextPeriod.minusDays(14) // 14 days before next period
        val fertileStart = ovulation.minusDays(5)
        val fertileEnd = ovulation
        val formatter = DateTimeFormatter.ofPattern("MMM d, yyyy")
        return OvulationResult(
            ovulation.format(formatter),
            fertileStart.format(formatter),
            fertileEnd.format(formatter),
            nextPeriod.format(formatter)
        )
    }
}

// Child Height Predictor (Mid-Parental Method)
data class ChildHeightResult(val predictedHeightCm: Double, val predictedHeightFtIn: String, val rangeCm: String)
class ChildHeightPredictor {
    fun predict(fatherHeightCm: Double, motherHeightCm: Double, isBoy: Boolean): ChildHeightResult {
        // Mid-Parental Height Method
        // Boy: (Father + Mother + 13) / 2
        // Girl: (Father + Mother - 13) / 2
        val predicted = if (isBoy) {
            (fatherHeightCm + motherHeightCm + 13) / 2
        } else {
            (fatherHeightCm + motherHeightCm - 13) / 2
        }
        
        val totalInches = predicted / 2.54
        val feet = (totalInches / 12).toInt()
        val inches = totalInches % 12
        
        return ChildHeightResult(
            predicted,
            "$feet' ${String.format("%.1f", inches)}\"",
            "${String.format("%.1f", predicted - 5)} - ${String.format("%.1f", predicted + 5)} cm"
        )
    }
    
    fun feetIncesToCm(feet: Double, inches: Double): Double = (feet * 12 + inches) * 2.54
}

// Smoking Cost Calculator
data class SmokingCostResult(val dailyCost: Double, val weeklyCost: Double, val monthlyCost: Double, val yearlyCost: Double, val lifetimeCost: Double)
class SmokingCostCalculator {
    fun calculate(packsPerDay: Double, costPerPack: Double, yearsSmoked: Double): SmokingCostResult {
        val daily = packsPerDay * costPerPack
        val weekly = daily * 7
        val monthly = daily * 30.44 // Average days per month
        val yearly = daily * 365.25
        val lifetime = yearly * yearsSmoked
        return SmokingCostResult(daily, weekly, monthly, yearly, lifetime)
    }
}
