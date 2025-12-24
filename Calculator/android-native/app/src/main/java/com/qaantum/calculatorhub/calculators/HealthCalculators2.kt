package com.qaantum.calculatorhub.calculators

import kotlin.math.*
import java.time.LocalDate
import java.time.temporal.ChronoUnit

// Macro Calculator
data class MacroResult(val calories: Int, val protein: Int, val carbs: Int, val fat: Int)
class MacroCalculator {
    fun calculate(targetCalories: Int, proteinPercent: Int, carbsPercent: Int, fatPercent: Int): MacroResult {
        val protein = (targetCalories * proteinPercent / 100) / 4 // 4 cal per gram
        val carbs = (targetCalories * carbsPercent / 100) / 4
        val fat = (targetCalories * fatPercent / 100) / 9 // 9 cal per gram
        return MacroResult(targetCalories, protein, carbs, fat)
    }
}

// Protein Intake Calculator
data class ProteinResult(val minGrams: Double, val maxGrams: Double, val recommendedGrams: Double)
class ProteinIntakeCalculator {
    fun calculate(weightKg: Double, activityLevel: String): ProteinResult {
        val multiplier = when (activityLevel) {
            "Sedentary" -> 0.8 to 1.0
            "Active" -> 1.2 to 1.4
            "Athlete" -> 1.6 to 2.0
            else -> 1.0 to 1.2
        }
        return ProteinResult(weightKg * multiplier.first, weightKg * multiplier.second, weightKg * (multiplier.first + multiplier.second) / 2)
    }
}

// Water Intake Calculator
data class WaterResult(val liters: Double, val glasses: Int)
class WaterIntakeCalculator {
    fun calculate(weightKg: Double, activityLevel: String): WaterResult {
        val base = weightKg * 0.033
        val extra = when (activityLevel) { "Active" -> 0.5; "Athlete" -> 1.0; else -> 0.0 }
        val total = base + extra
        return WaterResult(total, (total / 0.25).toInt())
    }
}

// Target Heart Rate Calculator
data class TargetHRResult(val maxHR: Int, val zone1: Pair<Int, Int>, val zone2: Pair<Int, Int>, val zone3: Pair<Int, Int>, val zone4: Pair<Int, Int>, val zone5: Pair<Int, Int>)
class TargetHeartRateCalculator {
    fun calculate(age: Int): TargetHRResult {
        val max = 220 - age
        return TargetHRResult(max, (max * 0.5).toInt() to (max * 0.6).toInt(), (max * 0.6).toInt() to (max * 0.7).toInt(),
            (max * 0.7).toInt() to (max * 0.8).toInt(), (max * 0.8).toInt() to (max * 0.9).toInt(), (max * 0.9).toInt() to max)
    }
}

// BAC Calculator
data class BACResult(val bac: Double, val hoursToSober: Double)
class BACCalculator {
    fun calculate(drinks: Double, weight: Double, hours: Double, isMale: Boolean): BACResult {
        val r = if (isMale) 0.68 else 0.55
        val bac = ((drinks * 14) / (weight * 453.592 * r)) * 100 - (0.015 * hours)
        return BACResult(maxOf(0.0, bac), if (bac > 0) bac / 0.015 else 0.0)
    }
}

// Due Date Calculator
data class DueDateResult(val dueDate: LocalDate, val weeksPregnant: Int, val daysRemaining: Long)
class DueDateCalculator {
    fun calculate(lastPeriodYear: Int, lastPeriodMonth: Int, lastPeriodDay: Int): DueDateResult {
        val lmp = LocalDate.of(lastPeriodYear, lastPeriodMonth, lastPeriodDay)
        val dueDate = lmp.plusDays(280) // 40 weeks
        val now = LocalDate.now()
        val weeksPregnant = ChronoUnit.WEEKS.between(lmp, now).toInt()
        val daysRemaining = ChronoUnit.DAYS.between(now, dueDate)
        return DueDateResult(dueDate, weeksPregnant, daysRemaining)
    }
}

// Sleep Calculator
data class SleepResult(val wakeUpTimes: List<String>, val sleepTimes: List<String>)
class SleepCalculator {
    fun calculateWakeUp(bedtimeHour: Int, bedtimeMin: Int): SleepResult {
        val times = mutableListOf<String>()
        for (cycles in 4..6) {
            val mins = (bedtimeHour * 60 + bedtimeMin + 15 + cycles * 90) % (24 * 60) // 15 min to fall asleep
            times.add("%02d:%02d".format(mins / 60, mins % 60))
        }
        return SleepResult(times, emptyList())
    }
}

// Pace Calculator
data class PaceResult(val pacePerKm: String, val pacePerMile: String, val speed: Double)
class PaceCalculator {
    fun calculate(distanceKm: Double, hours: Int, minutes: Int, seconds: Int): PaceResult {
        val totalMinutes = hours * 60.0 + minutes + seconds / 60.0
        val paceKm = totalMinutes / distanceKm
        val paceMile = paceKm * 1.60934
        val speed = distanceKm / (totalMinutes / 60)
        return PaceResult("%d:%02d".format(paceKm.toInt(), ((paceKm % 1) * 60).toInt()),
            "%d:%02d".format(paceMile.toInt(), ((paceMile % 1) * 60).toInt()), speed)
    }
}
