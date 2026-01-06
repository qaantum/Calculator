package com.qaantum.calculatorhub.calculators

import kotlin.math.ln
import kotlin.math.log10
import kotlin.math.log2

// NEW MATH CALCULATORS

// Logarithm Calculator
data class LogarithmResult(val result: Double, val formula: String)
class LogarithmCalculator {
    fun naturalLog(value: Double) = LogarithmResult(ln(value), "ln($value)")
    fun commonLog(value: Double) = LogarithmResult(log10(value), "log₁₀($value)")
    fun binaryLog(value: Double) = LogarithmResult(log2(value), "log₂($value)")
    fun customLog(value: Double, base: Double) = LogarithmResult(ln(value) / ln(base), "log$base($value)")
}

// Statistics Calculator
data class StatisticsResult(val mean: Double, val median: Double, val mode: List<Double>?, val range: Double, val count: Int)
class StatisticsCalculator {
    fun calculate(numbers: List<Double>): StatisticsResult {
        if (numbers.isEmpty()) return StatisticsResult(0.0, 0.0, null, 0.0, 0)
        val sorted = numbers.sorted()
        val count = numbers.size
        val mean = numbers.sum() / count
        val median = if (count % 2 == 0) (sorted[count / 2 - 1] + sorted[count / 2]) / 2 else sorted[count / 2]
        val frequency = numbers.groupingBy { it }.eachCount()
        val maxFreq = frequency.values.maxOrNull() ?: 0
        val mode = if (maxFreq > 1) frequency.filter { it.value == maxFreq }.keys.toList() else null
        return StatisticsResult(mean, median, mode, range = sorted.last() - sorted.first(), count)
    }
}

// Summation Calculator
data class SummationResult(val sum: Double, val nthTerm: Double, val terms: List<Double>)
class SummationCalculator {
    fun arithmetic(firstTerm: Double, commonDiff: Double, numTerms: Int): SummationResult {
        val nthTerm = firstTerm + (numTerms - 1) * commonDiff
        val sum = numTerms / 2.0 * (2 * firstTerm + (numTerms - 1) * commonDiff)
        val terms = (0 until minOf(numTerms, 10)).map { i -> firstTerm + i * commonDiff }
        return SummationResult(sum, nthTerm, terms)
    }
    
    fun geometric(firstTerm: Double, commonRatio: Double, numTerms: Int): SummationResult {
        val nthTerm = firstTerm * Math.pow(commonRatio, (numTerms - 1).toDouble())
        val sum = if (commonRatio == 1.0) {
            firstTerm * numTerms
        } else {
            firstTerm * (1 - Math.pow(commonRatio, numTerms.toDouble())) / (1 - commonRatio)
        }
        val terms = (0 until minOf(numTerms, 10)).map { i -> firstTerm * Math.pow(commonRatio, i.toDouble()) }
        return SummationResult(sum, nthTerm, terms)
    }
}
