package com.qaantum.calculatorhub.calculators

import kotlin.math.ceil

// Ohm's Law Calculator: V = I * R
data class OhmsLawResult(val voltage: Double?, val current: Double?, val resistance: Double?, val power: Double?)
class OhmsLawCalculator {
    fun calculateVoltage(current: Double, resistance: Double) = OhmsLawResult(current * resistance, current, resistance, current * current * resistance)
    fun calculateCurrent(voltage: Double, resistance: Double) = OhmsLawResult(voltage, voltage / resistance, resistance, voltage * voltage / resistance)
    fun calculateResistance(voltage: Double, current: Double) = OhmsLawResult(voltage, current, voltage / current, voltage * current)
}

// LED Resistor Calculator
data class LEDResistorResult(val resistance: Double, val power: Double, val nearestStandard: Int)
class LEDResistorCalculator {
    private val standardValues = listOf(10, 22, 33, 47, 68, 100, 150, 220, 330, 470, 680, 1000, 1500, 2200, 3300, 4700)
    fun calculate(supplyVoltage: Double, ledVoltage: Double, ledCurrent: Double): LEDResistorResult {
        val v = supplyVoltage - ledVoltage
        val r = v / (ledCurrent / 1000) // current in mA
        val p = v * ledCurrent / 1000
        val nearest = standardValues.minByOrNull { kotlin.math.abs(it - r) } ?: r.toInt()
        return LEDResistorResult(r, p, nearest)
    }
}

// Voltage Divider Calculator
data class VoltageDividerResult(val outputVoltage: Double, val r1: Double?, val r2: Double?)
class VoltageDividerCalculator {
    fun calculateOutput(inputVoltage: Double, r1: Double, r2: Double) = VoltageDividerResult(inputVoltage * r2 / (r1 + r2), r1, r2)
    fun calculateR2(inputVoltage: Double, outputVoltage: Double, r1: Double): VoltageDividerResult {
        val r2 = outputVoltage * r1 / (inputVoltage - outputVoltage)
        return VoltageDividerResult(outputVoltage, r1, r2)
    }
}

// Battery Life Calculator
data class BatteryLifeResult(val hours: Double, val days: Double)
class BatteryLifeCalculator {
    fun calculate(capacityMah: Double, currentMa: Double): BatteryLifeResult {
        val hours = capacityMah / currentMa
        return BatteryLifeResult(hours, hours / 24)
    }
}

// Capacitor Energy Calculator: E = 0.5 * C * V^2
data class CapacitorEnergyResult(val joules: Double, val millijoules: Double)
class CapacitorEnergyCalculator {
    fun calculate(capacitanceMicroFarads: Double, voltage: Double): CapacitorEnergyResult {
        val c = capacitanceMicroFarads / 1_000_000 // Convert to Farads
        val energy = 0.5 * c * voltage * voltage
        return CapacitorEnergyResult(energy, energy * 1000)
    }
}

// Word Count Calculator
data class WordCountResult(val characters: Int, val words: Int, val sentences: Int, val paragraphs: Int, val lines: Int)
class WordCountCalculator {
    fun count(text: String): WordCountResult {
        val chars = text.length
        val words = text.trim().split(Regex("\\s+")).filter { it.isNotEmpty() }.size
        val sentences = text.split(Regex("[.!?]+")).filter { it.isNotBlank() }.size
        val paragraphs = text.split(Regex("\n\n+")).filter { it.isNotBlank() }.size
        val lines = text.split("\n").size
        return WordCountResult(chars, words, sentences, paragraphs, lines)
    }
}

// Case Converter
class CaseConverter {
    fun toUpperCase(text: String) = text.uppercase()
    fun toLowerCase(text: String) = text.lowercase()
    fun toTitleCase(text: String) = text.split(" ").joinToString(" ") { it.replaceFirstChar { c -> c.uppercase() } }
    fun toSentenceCase(text: String) = text.lowercase().replaceFirstChar { it.uppercase() }
    fun toCamelCase(text: String) = text.split(Regex("\\s+")).mapIndexed { i, w -> if (i == 0) w.lowercase() else w.lowercase().replaceFirstChar { it.uppercase() } }.joinToString("")
    fun toSnakeCase(text: String) = text.lowercase().replace(Regex("\\s+"), "_")
}

// Base64 Converter
class Base64Converter {
    fun encode(text: String): String = java.util.Base64.getEncoder().encodeToString(text.toByteArray())
    fun decode(base64: String): String = try { String(java.util.Base64.getDecoder().decode(base64)) } catch (e: Exception) { "Invalid Base64" }
}
