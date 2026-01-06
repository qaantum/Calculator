package com.qaantum.calculatorhub.calculators

// Binary Converter
class BinaryConverter {
    fun decimalToBinary(decimal: Int): String = Integer.toBinaryString(decimal)
    fun binaryToDecimal(binary: String): Int = try { Integer.parseInt(binary, 2) } catch (e: Exception) { 0 }
    fun decimalToHex(decimal: Int): String = Integer.toHexString(decimal).uppercase()
    fun hexToDecimal(hex: String): Int = try { Integer.parseInt(hex, 16) } catch (e: Exception) { 0 }
    fun decimalToOctal(decimal: Int): String = Integer.toOctalString(decimal)
    fun octalToDecimal(octal: String): Int = try { Integer.parseInt(octal, 8) } catch (e: Exception) { 0 }
    fun binaryToHex(binary: String): String = decimalToHex(binaryToDecimal(binary))
    fun hexToBinary(hex: String): String = decimalToBinary(hexToDecimal(hex))
}

// Roman Numeral Converter
class RomanNumeralConverter {
    private val romanMap = listOf(
        1000 to "M", 900 to "CM", 500 to "D", 400 to "CD",
        100 to "C", 90 to "XC", 50 to "L", 40 to "XL",
        10 to "X", 9 to "IX", 5 to "V", 4 to "IV", 1 to "I"
    )
    
    fun toRoman(num: Int): String {
        if (num <= 0 || num > 3999) return "Invalid (1-3999)"
        var n = num
        val result = StringBuilder()
        for ((value, symbol) in romanMap) {
            while (n >= value) { result.append(symbol); n -= value }
        }
        return result.toString()
    }
    
    fun fromRoman(roman: String): Int {
        val romanValues = mapOf('I' to 1, 'V' to 5, 'X' to 10, 'L' to 50, 'C' to 100, 'D' to 500, 'M' to 1000)
        var result = 0
        var prevValue = 0
        for (c in roman.uppercase().reversed()) {
            val value = romanValues[c] ?: return 0
            result += if (value < prevValue) -value else value
            prevValue = value
        }
        return result
    }
}



// Grade Calculator
data class GradeResult(val average: Double, val letterGrade: String, val gpa: Double)
class GradeCalculator {
    fun calculate(grades: List<Double>, weights: List<Double>? = null): GradeResult {
        val avg = if (weights != null && weights.size == grades.size) {
            grades.zip(weights).sumOf { it.first * it.second } / weights.sum()
        } else {
            grades.average()
        }
        val letter = when {
            avg >= 90 -> "A"
            avg >= 80 -> "B"
            avg >= 70 -> "C"
            avg >= 60 -> "D"
            else -> "F"
        }
        val gpa = when {
            avg >= 93 -> 4.0; avg >= 90 -> 3.7; avg >= 87 -> 3.3; avg >= 83 -> 3.0
            avg >= 80 -> 2.7; avg >= 77 -> 2.3; avg >= 73 -> 2.0; avg >= 70 -> 1.7
            avg >= 67 -> 1.3; avg >= 63 -> 1.0; avg >= 60 -> 0.7; else -> 0.0
        }
        return GradeResult(avg, letter, gpa)
    }
}

// Time Zone Converter
class TimeZoneConverter {
    fun convert(hour: Int, fromOffset: Int, toOffset: Int): Int {
        val utc = hour - fromOffset
        var result = utc + toOffset
        if (result < 0) result += 24
        if (result >= 24) result -= 24
        return result
    }
}

// One Rep Max Calculator (Fitness)
data class OneRepMaxResult(val oneRepMax: Double, val estimatedReps: List<Pair<Int, Double>>)
class OneRepMaxCalculator {
    // Brzycki formula: 1RM = weight × (36 / (37 - reps))
    fun calculate(weight: Double, reps: Int): OneRepMaxResult {
        val oneRM = weight * (36.0 / (37 - reps))
        val estimates = (1..12).map { r -> r to oneRM * (37 - r) / 36 }
        return OneRepMaxResult(oneRM, estimates)
    }
}
