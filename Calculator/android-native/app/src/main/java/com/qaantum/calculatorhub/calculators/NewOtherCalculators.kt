package com.qaantum.calculatorhub.calculators

import java.security.MessageDigest
import kotlin.math.cos
import kotlin.math.floor
import kotlin.math.PI
import kotlin.random.Random

// NEW OTHER CALCULATORS

// Moon Phase Calculator
data class MoonPhaseResult(val phaseName: String, val illumination: Double, val phaseDay: Double)
class MoonPhaseCalculator {
    fun calculate(year: Int, month: Int, day: Int): MoonPhaseResult {
        var y = year; var m = month
        if (m < 3) { y--; m += 12 }
        val a = y / 100; val b = a / 4; val c = 2 - a + b
        val e = (365.25 * (y + 4716)).toInt()
        val f = (30.6001 * (m + 1)).toInt()
        val jd = c + day + e + f - 1524.5
        val daysSinceNew = jd - 2451549.5
        val lunation = daysSinceNew / 29.53059
        val phase = (lunation - floor(lunation)) * 29.53059
        val illumination = ((1 - cos(2 * PI * phase / 29.53)) / 2 * 100)
        return MoonPhaseResult(getPhaseName(phase), illumination, phase)
    }
    
    private fun getPhaseName(phase: Double) = when {
        phase < 1.85 -> "New Moon"
        phase < 5.53 -> "Waxing Crescent"
        phase < 9.22 -> "First Quarter"
        phase < 12.91 -> "Waxing Gibbous"
        phase < 16.61 -> "Full Moon"
        phase < 20.30 -> "Waning Gibbous"
        phase < 23.99 -> "Last Quarter"
        phase < 27.68 -> "Waning Crescent"
        else -> "New Moon"
    }
}

// Dice Roller
data class DiceRollResult(val rolls: List<Int>, val total: Int, val min: Int, val max: Int)
class DiceRoller {
    private val random = Random
    
    fun roll(sides: Int, count: Int): DiceRollResult {
        val rolls = (1..count).map { random.nextInt(1, sides + 1) }
        return DiceRollResult(rolls, rolls.sum(), count, count * sides)
    }
}

// Hash Generator
data class HashResult(val md5: String, val sha1: String, val sha256: String, val sha512: String)
class HashGenerator {
    fun generate(input: String): HashResult {
        return HashResult(
            hash(input, "MD5"),
            hash(input, "SHA-1"),
            hash(input, "SHA-256"),
            hash(input, "SHA-512")
        )
    }
    
    private fun hash(input: String, algorithm: String): String {
        return try {
            val bytes = MessageDigest.getInstance(algorithm).digest(input.toByteArray())
            bytes.joinToString("") { "%02x".format(it) }
        } catch (e: Exception) {
            "Error"
        }
    }
}
