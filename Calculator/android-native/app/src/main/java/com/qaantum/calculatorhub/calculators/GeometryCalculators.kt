package com.qaantum.calculatorhub.calculators

import kotlin.math.*

// Geometry Calculators

// Circle Properties
data class CircleResult(val circumference: Double, val area: Double, val diameter: Double)
class CircleCalculator {
    fun fromRadius(r: Double) = CircleResult(2 * PI * r, PI * r * r, 2 * r)
    fun fromDiameter(d: Double) = CircleResult(PI * d, PI * (d/2) * (d/2), d)
    fun fromCircumference(c: Double): CircleResult { val r = c / (2 * PI); return CircleResult(c, PI * r * r, 2 * r) }
}

// Slope Calculator
data class SlopeResult(val slope: Double, val yIntercept: Double, val equation: String, val distance: Double)
class SlopeCalculator {
    fun calculate(x1: Double, y1: Double, x2: Double, y2: Double): SlopeResult {
        val slope = (y2 - y1) / (x2 - x1)
        val yInt = y1 - slope * x1
        val dist = sqrt((x2 - x1).pow(2) + (y2 - y1).pow(2))
        return SlopeResult(slope, yInt, "y = ${slope}x + $yInt", dist)
    }
}

// Triangle Calculator
data class TriangleResult(val area: Double, val perimeter: Double, val hypotenuse: Double?)
class TriangleCalculator {
    fun fromBasHeight(base: Double, height: Double) = TriangleResult(0.5 * base * height, 0.0, null)
    fun fromSides(a: Double, b: Double, c: Double): TriangleResult {
        val s = (a + b + c) / 2
        val area = sqrt(s * (s-a) * (s-b) * (s-c)) // Heron's formula
        return TriangleResult(area, a + b + c, null)
    }
    fun pythagorean(a: Double, b: Double) = TriangleResult(0.5 * a * b, a + b + sqrt(a*a + b*b), sqrt(a*a + b*b))
}

// Volume Calculator
data class VolumeResult(val volume: Double, val surfaceArea: Double)
class VolumeCalculator {
    fun cube(side: Double) = VolumeResult(side.pow(3), 6 * side.pow(2))
    fun sphere(radius: Double) = VolumeResult((4.0/3.0) * PI * radius.pow(3), 4 * PI * radius.pow(2))
    fun cylinder(radius: Double, height: Double) = VolumeResult(PI * radius.pow(2) * height, 2 * PI * radius * (radius + height))
    fun cone(radius: Double, height: Double) = VolumeResult((1.0/3.0) * PI * radius.pow(2) * height, PI * radius * (radius + sqrt(height.pow(2) + radius.pow(2))))
    fun box(l: Double, w: Double, h: Double) = VolumeResult(l * w * h, 2 * (l*w + w*h + h*l))
}

// Surface Area Calculator
class SurfaceAreaCalculator {
    fun cubeSA(side: Double) = 6 * side.pow(2)
    fun sphereSA(radius: Double) = 4 * PI * radius.pow(2)
    fun cylinderSA(radius: Double, height: Double) = 2 * PI * radius * (radius + height)
    fun coneSA(radius: Double, slantHeight: Double) = PI * radius * (radius + slantHeight)
}

// Aspect Ratio Calculator
data class AspectRatioResult(val ratio: String, val width: Double, val height: Double)
class AspectRatioCalculator {
    private fun gcd(a: Int, b: Int): Int = if (b == 0) a else gcd(b, a % b)
    fun calculate(width: Double, height: Double): AspectRatioResult {
        val g = gcd(width.toInt(), height.toInt())
        return AspectRatioResult("${(width/g).toInt()}:${(height/g).toInt()}", width, height)
    }
    fun scaleToWidth(originalW: Double, originalH: Double, newW: Double): AspectRatioResult {
        val scale = newW / originalW
        return AspectRatioResult("", newW, originalH * scale)
    }
}

// Fraction Calculator
data class FractionResult(val numerator: Int, val denominator: Int, val decimal: Double, val simplified: String)
class FractionCalculator {
    private fun gcd(a: Int, b: Int): Int = if (b == 0) abs(a) else gcd(b, abs(a) % abs(b))
    
    fun simplify(num: Int, den: Int): FractionResult {
        val g = gcd(num, den)
        val n = num / g; val d = den / g
        return FractionResult(n, d, num.toDouble() / den, "$n/$d")
    }
    fun add(n1: Int, d1: Int, n2: Int, d2: Int): FractionResult {
        val num = n1 * d2 + n2 * d1; val den = d1 * d2
        return simplify(num, den)
    }
    fun multiply(n1: Int, d1: Int, n2: Int, d2: Int) = simplify(n1 * n2, d1 * d2)
    fun divide(n1: Int, d1: Int, n2: Int, d2: Int) = simplify(n1 * d2, d1 * n2)
}

// Permutation & Combination
class PermCombCalculator {
    private fun factorial(n: Int): Double { var r = 1.0; for (i in 2..n) r *= i; return r }
    fun permutation(n: Int, r: Int): Double = factorial(n) / factorial(n - r)
    fun combination(n: Int, r: Int): Double = factorial(n) / (factorial(r) * factorial(n - r))
}
