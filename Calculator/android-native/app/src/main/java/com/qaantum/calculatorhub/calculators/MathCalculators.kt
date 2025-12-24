package com.qaantum.calculatorhub.calculators

import kotlin.math.*

// Percentage Calculator
data class PercentageResult(val value: Double)
class PercentageCalculator {
    fun whatIsXPercentOfY(x: Double, y: Double) = PercentageResult((x / 100) * y)
    fun xIsWhatPercentOfY(x: Double, y: Double) = if (y != 0.0) PercentageResult((x / y) * 100) else PercentageResult(0.0)
    fun percentageChange(from: Double, to: Double) = if (from != 0.0) PercentageResult(((to - from) / from) * 100) else PercentageResult(0.0)
}

// Quadratic Solver
sealed class QuadraticResult {
    data class TwoRealRoots(val x1: Double, val x2: Double) : QuadraticResult()
    data class OneRealRoot(val x: Double) : QuadraticResult()
    data class ComplexRoots(val real: Double, val imaginary: Double) : QuadraticResult()
    object NotQuadratic : QuadraticResult()
}
class QuadraticSolver {
    fun solve(a: Double, b: Double, c: Double): QuadraticResult {
        if (a == 0.0) return QuadraticResult.NotQuadratic
        val d = b * b - 4 * a * c
        return when {
            d > 0 -> QuadraticResult.TwoRealRoots((-b + sqrt(d)) / (2 * a), (-b - sqrt(d)) / (2 * a))
            d == 0.0 -> QuadraticResult.OneRealRoot(-b / (2 * a))
            else -> QuadraticResult.ComplexRoots(-b / (2 * a), sqrt(-d) / (2 * a))
        }
    }
}

// GCD/LCM Calculator
data class GcdLcmResult(val gcd: Long, val lcm: Long)
class GcdLcmCalculator {
    private fun gcd(a: Long, b: Long): Long = if (b == 0L) abs(a) else gcd(b, a % b)
    fun calculate(a: Long, b: Long): GcdLcmResult {
        val g = gcd(a, b)
        val l = if (g != 0L) abs(a * b) / g else 0L
        return GcdLcmResult(g, l)
    }
}

// Factorial Calculator
class FactorialCalculator {
    fun calculate(n: Int): String {
        if (n < 0) return "Error"
        if (n > 170) return "Too large"
        var result = 1.0
        for (i in 2..n) result *= i
        return if (n <= 20) result.toLong().toString() else "%.4e".format(result)
    }
}

// Fibonacci Generator
class FibonacciGenerator {
    fun generate(count: Int): List<Long> {
        if (count <= 0) return emptyList()
        val seq = mutableListOf(0L, 1L)
        for (i in 2 until count) seq.add(seq[i - 1] + seq[i - 2])
        return seq.take(count)
    }
}

// Prime Factorization
class PrimeFactorizationCalculator {
    fun factorize(n: Long): List<Long> {
        if (n <= 1) return emptyList()
        val factors = mutableListOf<Long>()
        var num = n
        var d = 2L
        while (d * d <= num) {
            while (num % d == 0L) { factors.add(d); num /= d }
            d++
        }
        if (num > 1) factors.add(num)
        return factors
    }
}

// Random Number Generator
class RandomNumberGenerator {
    fun generate(min: Int, max: Int, count: Int = 1): List<Int> {
        if (min > max) return emptyList()
        return List(count) { (min..max).random() }
    }
}
