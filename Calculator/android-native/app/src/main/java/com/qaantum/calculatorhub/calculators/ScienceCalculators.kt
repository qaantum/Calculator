package com.qaantum.calculatorhub.calculators

import kotlin.math.*

// Kinematic Calculator (Physics)
data class KinematicResult(val displacement: Double?, val velocity: Double?, val acceleration: Double?, val time: Double?)
class KinematicCalculator {
    // v = u + at
    fun finalVelocity(initial: Double, acceleration: Double, time: Double) = initial + acceleration * time
    // s = ut + 0.5at^2
    fun displacement(initial: Double, acceleration: Double, time: Double) = initial * time + 0.5 * acceleration * time * time
    // v^2 = u^2 + 2as
    fun finalVelocityFromDisplacement(initial: Double, acceleration: Double, displacement: Double) = sqrt(initial * initial + 2 * acceleration * displacement)
}

// Force Calculator (F = ma)
data class ForceResult(val force: Double?, val mass: Double?, val acceleration: Double?)
class ForceCalculator {
    fun forceFromMassAccel(mass: Double, acceleration: Double) = mass * acceleration
    fun massFromForceAccel(force: Double, acceleration: Double) = force / acceleration
    fun accelFromForceMass(force: Double, mass: Double) = force / mass
}

// Momentum Calculator (p = mv)
data class MomentumResult(val momentum: Double, val impulse: Double?)
class MomentumCalculator {
    fun momentum(mass: Double, velocity: Double) = mass * velocity
    fun impulse(force: Double, time: Double) = force * time
    fun finalVelocity(mass: Double, initialV: Double, impulse: Double) = initialV + impulse / mass
}

// Work Energy Calculator
data class WorkEnergyResult(val work: Double?, val kineticEnergy: Double?, val potentialEnergy: Double?)
class WorkEnergyCalculator {
    fun work(force: Double, displacement: Double, angleRadians: Double = 0.0) = force * displacement * cos(angleRadians)
    fun kineticEnergy(mass: Double, velocity: Double) = 0.5 * mass * velocity * velocity
    fun potentialEnergy(mass: Double, height: Double, g: Double = 9.81) = mass * g * height
}

// Molar Mass Calculator (Chemistry)
data class MolarMassResult(val element: String, val atomicMass: Double)
class MolarMassCalculator {
    private val elements = mapOf(
        "H" to 1.008, "He" to 4.003, "Li" to 6.941, "Be" to 9.012, "B" to 10.81, "C" to 12.01,
        "N" to 14.01, "O" to 16.00, "F" to 19.00, "Ne" to 20.18, "Na" to 22.99, "Mg" to 24.31,
        "Al" to 26.98, "Si" to 28.09, "P" to 30.97, "S" to 32.07, "Cl" to 35.45, "Ar" to 39.95,
        "K" to 39.10, "Ca" to 40.08, "Fe" to 55.85, "Cu" to 63.55, "Zn" to 65.38, "Ag" to 107.87,
        "Au" to 196.97, "Pb" to 207.2
    )
    fun getMass(symbol: String): Double? = elements[symbol]
    fun calculateH2O() = 2 * (elements["H"] ?: 0.0) + (elements["O"] ?: 0.0) // 18.016
    fun calculateCO2() = (elements["C"] ?: 0.0) + 2 * (elements["O"] ?: 0.0) // 44.01
    fun calculateNaCl() = (elements["Na"] ?: 0.0) + (elements["Cl"] ?: 0.0) // 58.44
}

// pH Calculator (Chemistry)
data class PHResult(val pH: Double, val pOH: Double, val hConc: Double, val ohConc: Double)
class PHCalculator {
    fun fromHConcentration(hConc: Double): PHResult {
        val pH = -log10(hConc)
        val pOH = 14 - pH
        val ohConc = 10.0.pow(-pOH)
        return PHResult(pH, pOH, hConc, ohConc)
    }
    fun fromPH(pH: Double): PHResult {
        val hConc = 10.0.pow(-pH)
        val pOH = 14 - pH
        val ohConc = 10.0.pow(-pOH)
        return PHResult(pH, pOH, hConc, ohConc)
    }
}

// Standard Deviation Calculator
data class StatsResult(val mean: Double, val variance: Double, val stdDev: Double, val count: Int)
class StandardDeviationCalculator {
    fun calculate(numbers: List<Double>): StatsResult {
        val count = numbers.size
        val mean = numbers.sum() / count
        val variance = numbers.map { (it - mean).pow(2) }.sum() / count
        return StatsResult(mean, variance, sqrt(variance), count)
    }
}
