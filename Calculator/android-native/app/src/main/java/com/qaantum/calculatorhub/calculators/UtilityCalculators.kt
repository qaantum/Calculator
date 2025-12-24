package com.qaantum.calculatorhub.calculators

import java.time.*
import java.time.temporal.ChronoUnit

// Age Calculator
data class AgeResult(val years: Int, val months: Int, val days: Int)
class AgeCalculator {
    fun calculate(birthYear: Int, birthMonth: Int, birthDay: Int): AgeResult {
        val birth = LocalDate.of(birthYear, birthMonth, birthDay)
        val now = LocalDate.now()
        val period = Period.between(birth, now)
        return AgeResult(period.years, period.months, period.days)
    }
}

// Date Difference Calculator
data class DateDiffResult(val days: Long, val weeks: Long, val months: Long, val years: Long)
class DateDiffCalculator {
    fun calculate(y1: Int, m1: Int, d1: Int, y2: Int, m2: Int, d2: Int): DateDiffResult {
        val date1 = LocalDate.of(y1, m1, d1)
        val date2 = LocalDate.of(y2, m2, d2)
        val days = ChronoUnit.DAYS.between(date1, date2).let { kotlin.math.abs(it) }
        return DateDiffResult(days, days / 7, days / 30, days / 365)
    }
}

// Time Calculator
data class TimeCalcResult(val hours: Int, val minutes: Int, val seconds: Int, val totalSeconds: Long)
class TimeCalculator {
    fun add(h1: Int, m1: Int, s1: Int, h2: Int, m2: Int, s2: Int): TimeCalcResult {
        val total = (h1 * 3600L + m1 * 60 + s1) + (h2 * 3600L + m2 * 60 + s2)
        return TimeCalcResult((total / 3600).toInt(), ((total % 3600) / 60).toInt(), (total % 60).toInt(), total)
    }
    fun diff(h1: Int, m1: Int, s1: Int, h2: Int, m2: Int, s2: Int): TimeCalcResult {
        val total = kotlin.math.abs((h1 * 3600L + m1 * 60 + s1) - (h2 * 3600L + m2 * 60 + s2))
        return TimeCalcResult((total / 3600).toInt(), ((total % 3600) / 60).toInt(), (total % 60).toInt(), total)
    }
}

// Work Hours Calculator
data class WorkHoursResult(val regularHours: Double, val overtimeHours: Double, val totalPay: Double)
class WorkHoursCalculator {
    fun calculate(hoursWorked: Double, hourlyRate: Double, overtimeThreshold: Double = 40.0, overtimeMultiplier: Double = 1.5): WorkHoursResult {
        val regular = minOf(hoursWorked, overtimeThreshold)
        val overtime = maxOf(0.0, hoursWorked - overtimeThreshold)
        val pay = regular * hourlyRate + overtime * hourlyRate * overtimeMultiplier
        return WorkHoursResult(regular, overtime, pay)
    }
}

// Fuel Cost Calculator
data class FuelCostResult(val fuelNeeded: Double, val totalCost: Double, val costPerMile: Double)
class FuelCostCalculator {
    fun calculate(distance: Double, mpg: Double, pricePerGallon: Double): FuelCostResult {
        val fuel = distance / mpg
        val cost = fuel * pricePerGallon
        return FuelCostResult(fuel, cost, cost / distance)
    }
}

// Password Generator
class PasswordGenerator {
    fun generate(length: Int, useUpper: Boolean = true, useLower: Boolean = true, useNumbers: Boolean = true, useSymbols: Boolean = true): String {
        var chars = ""
        if (useUpper) chars += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        if (useLower) chars += "abcdefghijklmnopqrstuvwxyz"
        if (useNumbers) chars += "0123456789"
        if (useSymbols) chars += "!@#$%^&*()_+-=[]{}|;:,.<>?"
        if (chars.isEmpty()) return ""
        return (1..length).map { chars.random() }.joinToString("")
    }
}
