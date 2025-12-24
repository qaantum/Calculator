package com.qaantum.calculatorhub.customcalculator

import java.util.UUID
import kotlin.math.*

// ==================== DATA MODELS ====================

enum class VariableType { NUMBER, INTEGER, DATE }

data class CalculatorVariable(
    val name: String,
    val defaultValue: String = "0",
    val description: String? = null,
    val unitLabel: String? = null,
    val min: Double? = null,
    val max: Double? = null,
    val type: VariableType = VariableType.NUMBER
)

data class CustomCalculator(
    val id: String = UUID.randomUUID().toString(),
    val title: String,
    val iconName: String = "calculator",
    val inputs: List<CalculatorVariable>,
    val formula: String,
    val createdAt: Long = System.currentTimeMillis(),
    val updatedAt: Long = System.currentTimeMillis(),
    val pinned: Boolean = false,
    val version: Int = 1,
    val sourceRoute: String? = null // If forked from existing calculator
)

// ==================== ENHANCED MATH ENGINE ====================

sealed class MathResult {
    data class Success(val value: Double) : MathResult()
    data class Error(val message: String) : MathResult()
}

object MathEngine {
    
    // Supported functions documentation
    val supportedFunctions = listOf(
        "Basic: +, -, *, /, ^, (, )",
        "Trigonometry: sin, cos, tan, asin, acos, atan",
        "Hyperbolic: sinh, cosh, tanh",
        "Logarithmic: ln, log(x), log(x, base)",
        "Exponential: exp, sqrt, cbrt, root(x, n)",
        "Rounding: abs, ceil, floor, round",
        "Statistical: min(a,b), max(a,b)",
        "Calculus: deriv(expr, var, point), integrate(expr, var, a, b)",
        "Date: daysBetween(t1, t2), age(birthdate)",
        "Constants: pi, e, phi (golden ratio)"
    )
    
    fun evaluate(formula: String, variables: Map<String, Double>): MathResult {
        return try {
            if (formula.isBlank()) return MathResult.Error("Formula is empty")
            if (formula.length > 2000) return MathResult.Error("Formula too long")
            
            var processedFormula = formula.trim().lowercase()
            
            // Pre-process all custom functions
            processedFormula = processAdvancedFunctions(processedFormula, variables)
            
            // Replace constants
            processedFormula = processedFormula.replace("phi", "1.6180339887")
            processedFormula = processedFormula.replace(Regex("(?<![a-zA-Z])pi(?![a-zA-Z])"), PI.toString())
            processedFormula = processedFormula.replace(Regex("(?<![a-zA-Z])e(?![a-zA-Z])"), E.toString())
            
            // Replace variables (longest names first to avoid partial matches)
            variables.keys.sortedByDescending { it.length }.forEach { key ->
                processedFormula = processedFormula.replace(key.lowercase(), variables[key].toString())
            }
            
            val result = evaluateExpression(processedFormula)
            
            if (result.isNaN()) return MathResult.Error("Result is NaN (undefined)")
            if (result.isInfinite()) return MathResult.Error("Result is Infinite (division by zero?)")
            
            MathResult.Success(result)
        } catch (e: Exception) {
            MathResult.Error("Error: ${e.message ?: "Unknown error"}")
        }
    }
    
    private fun processAdvancedFunctions(formula: String, variables: Map<String, Double>): String {
        var result = formula
        
        // ===== CALCULUS =====
        
        // integrate(expression, var, start, end) - Simpson's rule
        val integrateRegex = Regex("""integrate\(([^,]+),\s*([^,]+),\s*([^,]+),\s*([^)]+)\)""")
        result = integrateRegex.replace(result) { match ->
            val expr = match.groupValues[1].trim()
            val varName = match.groupValues[2].trim()
            val startStr = match.groupValues[3].trim()
            val endStr = match.groupValues[4].trim()
            
            val start = evaluateSimple(startStr, variables)
            val end = evaluateSimple(endStr, variables)
            val integral = simpsonsRule(expr, varName, start, end, variables)
            integral.toString()
        }
        
        // deriv(expression, var, point) - Central difference
        val derivRegex = Regex("""deriv\(([^,]+),\s*([^,]+),\s*([^)]+)\)""")
        result = derivRegex.replace(result) { match ->
            val expr = match.groupValues[1].trim()
            val varName = match.groupValues[2].trim()
            val pointStr = match.groupValues[3].trim()
            
            val point = evaluateSimple(pointStr, variables)
            val derivative = centralDifference(expr, varName, point, variables)
            derivative.toString()
        }
        
        // ===== LOGARITHMIC =====
        
        // log(value, base) -> ln(value)/ln(base)
        val logBaseRegex = Regex("""log\(([^,]+),\s*([^)]+)\)""")
        result = logBaseRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            val base = evaluateSimple(match.groupValues[2], variables)
            if (value <= 0 || base <= 0 || base == 1.0) "NaN" else (ln(value) / ln(base)).toString()
        }
        
        // log(x) -> log base 10
        val log10Regex = Regex("""log\(([^,)]+)\)""")
        result = log10Regex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            if (value <= 0) "NaN" else log10(value).toString()
        }
        
        // ln(x) -> natural log
        val lnRegex = Regex("""ln\(([^)]+)\)""")
        result = lnRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            if (value <= 0) "NaN" else ln(value).toString()
        }
        
        // exp(x) -> e^x
        val expRegex = Regex("""exp\(([^)]+)\)""")
        result = expRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            exp(value).toString()
        }
        
        // ===== ROOT FUNCTIONS =====
        
        // root(value, n) -> value^(1/n)
        val rootRegex = Regex("""root\(([^,]+),\s*([^)]+)\)""")
        result = rootRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            val n = evaluateSimple(match.groupValues[2], variables)
            value.pow(1.0 / n).toString()
        }
        
        // sqrt(x)
        val sqrtRegex = Regex("""sqrt\(([^)]+)\)""")
        result = sqrtRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            if (value < 0) "NaN" else sqrt(value).toString()
        }
        
        // cbrt(x) - cube root
        val cbrtRegex = Regex("""cbrt\(([^)]+)\)""")
        result = cbrtRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            cbrt(value).toString()
        }
        
        // ===== TRIGONOMETRIC =====
        
        // Inverse trig
        val asinRegex = Regex("""asin\(([^)]+)\)""")
        result = asinRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            asin(value).toString()
        }
        
        val acosRegex = Regex("""acos\(([^)]+)\)""")
        result = acosRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            acos(value).toString()
        }
        
        val atanRegex = Regex("""atan\(([^)]+)\)""")
        result = atanRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            atan(value).toString()
        }
        
        // Standard trig
        val sinRegex = Regex("""sin\(([^)]+)\)""")
        result = sinRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            sin(value).toString()
        }
        
        val cosRegex = Regex("""cos\(([^)]+)\)""")
        result = cosRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            cos(value).toString()
        }
        
        val tanRegex = Regex("""tan\(([^)]+)\)""")
        result = tanRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            tan(value).toString()
        }
        
        // Hyperbolic
        val sinhRegex = Regex("""sinh\(([^)]+)\)""")
        result = sinhRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            sinh(value).toString()
        }
        
        val coshRegex = Regex("""cosh\(([^)]+)\)""")
        result = coshRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            cosh(value).toString()
        }
        
        val tanhRegex = Regex("""tanh\(([^)]+)\)""")
        result = tanhRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            tanh(value).toString()
        }
        
        // ===== ROUNDING & ABSOLUTE =====
        
        val absRegex = Regex("""abs\(([^)]+)\)""")
        result = absRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            abs(value).toString()
        }
        
        val ceilRegex = Regex("""ceil\(([^)]+)\)""")
        result = ceilRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            ceil(value).toString()
        }
        
        val floorRegex = Regex("""floor\(([^)]+)\)""")
        result = floorRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            floor(value).toString()
        }
        
        val roundRegex = Regex("""round\(([^)]+)\)""")
        result = roundRegex.replace(result) { match ->
            val value = evaluateSimple(match.groupValues[1], variables)
            round(value).toString()
        }
        
        // ===== STATISTICAL =====
        
        val minRegex = Regex("""min\(([^,]+),\s*([^)]+)\)""")
        result = minRegex.replace(result) { match ->
            val a = evaluateSimple(match.groupValues[1], variables)
            val b = evaluateSimple(match.groupValues[2], variables)
            min(a, b).toString()
        }
        
        val maxRegex = Regex("""max\(([^,]+),\s*([^)]+)\)""")
        result = maxRegex.replace(result) { match ->
            val a = evaluateSimple(match.groupValues[1], variables)
            val b = evaluateSimple(match.groupValues[2], variables)
            max(a, b).toString()
        }
        
        // ===== DATE FUNCTIONS =====
        
        val daysBetweenRegex = Regex("""daysbetween\(([^,]+),\s*([^)]+)\)""")
        result = daysBetweenRegex.replace(result) { match ->
            val t1 = evaluateSimple(match.groupValues[1], variables)
            val t2 = evaluateSimple(match.groupValues[2], variables)
            (abs(t1 - t2) / 86400).toString()
        }
        
        val ageRegex = Regex("""age\(([^)]+)\)""")
        result = ageRegex.replace(result) { match ->
            val birthdate = evaluateSimple(match.groupValues[1], variables)
            val now = System.currentTimeMillis() / 1000.0
            ((now - birthdate) / 31557600).toString()
        }
        
        // ===== SPECIAL FUNCTIONS =====
        
        // factorial(n) - for small integers only
        val factorialRegex = Regex("""factorial\(([^)]+)\)""")
        result = factorialRegex.replace(result) { match ->
            val n = evaluateSimple(match.groupValues[1], variables).toInt()
            if (n < 0 || n > 20) "NaN" else factorial(n).toString()
        }
        
        // mod(a, b) - modulo
        val modRegex = Regex("""mod\(([^,]+),\s*([^)]+)\)""")
        result = modRegex.replace(result) { match ->
            val a = evaluateSimple(match.groupValues[1], variables)
            val b = evaluateSimple(match.groupValues[2], variables)
            (a % b).toString()
        }
        
        return result
    }
    
    private fun factorial(n: Int): Long {
        var result = 1L
        for (i in 2..n) result *= i
        return result
    }
    
    private fun simpsonsRule(expr: String, varName: String, a: Double, b: Double, variables: Map<String, Double>): Double {
        val n = 100 // Number of intervals (must be even)
        val h = (b - a) / n
        
        fun f(x: Double): Double {
            val localVars = variables.toMutableMap()
            localVars[varName] = x
            return evaluateSimple(expr, localVars)
        }
        
        var sum = f(a) + f(b)
        for (i in 1 until n) {
            val x = a + i * h
            sum += (if (i % 2 == 0) 2 else 4) * f(x)
        }
        
        return (h / 3) * sum
    }
    
    private fun centralDifference(expr: String, varName: String, x: Double, variables: Map<String, Double>): Double {
        val h = 1e-5
        
        fun f(value: Double): Double {
            val localVars = variables.toMutableMap()
            localVars[varName] = value
            return evaluateSimple(expr, localVars)
        }
        
        return (f(x + h) - f(x - h)) / (2 * h)
    }
    
    private fun evaluateSimple(expr: String, variables: Map<String, Double>): Double {
        var evaluable = expr.trim().lowercase()
        evaluable = evaluable.replace("phi", "1.6180339887")
        evaluable = evaluable.replace(Regex("(?<![a-zA-Z])pi(?![a-zA-Z])"), PI.toString())
        evaluable = evaluable.replace(Regex("(?<![a-zA-Z])e(?![a-zA-Z])"), E.toString())
        variables.keys.sortedByDescending { it.length }.forEach { key ->
            evaluable = evaluable.replace(key.lowercase(), variables[key].toString())
        }
        return evaluateExpression(evaluable)
    }
    
    // Recursive descent parser for mathematical expressions
    private fun evaluateExpression(expression: String): Double {
        val expr = expression.replace(" ", "")
        return parseExpression(expr, 0).first
    }
    
    private fun parseExpression(expr: String, index: Int): Pair<Double, Int> {
        var (result, i) = parseTerm(expr, index)
        
        while (i < expr.length) {
            when (expr[i]) {
                '+' -> {
                    val (term, newIndex) = parseTerm(expr, i + 1)
                    result += term
                    i = newIndex
                }
                '-' -> {
                    val (term, newIndex) = parseTerm(expr, i + 1)
                    result -= term
                    i = newIndex
                }
                else -> break
            }
        }
        return Pair(result, i)
    }
    
    private fun parseTerm(expr: String, index: Int): Pair<Double, Int> {
        var (result, i) = parsePower(expr, index)
        
        while (i < expr.length) {
            when (expr[i]) {
                '*' -> {
                    val (factor, newIndex) = parsePower(expr, i + 1)
                    result *= factor
                    i = newIndex
                }
                '/' -> {
                    val (factor, newIndex) = parsePower(expr, i + 1)
                    result /= factor
                    i = newIndex
                }
                else -> break
            }
        }
        return Pair(result, i)
    }
    
    private fun parsePower(expr: String, index: Int): Pair<Double, Int> {
        var (base, i) = parseFactor(expr, index)
        
        if (i < expr.length && expr[i] == '^') {
            val (exponent, newIndex) = parsePower(expr, i + 1)
            base = base.pow(exponent)
            i = newIndex
        }
        
        return Pair(base, i)
    }
    
    private fun parseFactor(expr: String, index: Int): Pair<Double, Int> {
        var i = index
        
        // Handle negative numbers
        var negative = false
        if (i < expr.length && expr[i] == '-') {
            negative = true
            i++
        }
        
        val result: Double
        
        if (i < expr.length && expr[i] == '(') {
            val (value, newIndex) = parseExpression(expr, i + 1)
            result = value
            i = newIndex
            if (i < expr.length && expr[i] == ')') i++
        } else {
            // Parse number
            val start = i
            while (i < expr.length && (expr[i].isDigit() || expr[i] == '.')) {
                i++
            }
            result = if (start < i) expr.substring(start, i).toDoubleOrNull() ?: 0.0 else 0.0
        }
        
        return Pair(if (negative) -result else result, i)
    }
}
