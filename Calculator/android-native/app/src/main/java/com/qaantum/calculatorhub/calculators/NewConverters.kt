package com.qaantum.calculatorhub.calculators

// NEW CONVERTERS

// Temperature Converter
data class TemperatureResult(val celsius: Double, val fahrenheit: Double, val kelvin: Double)
class TemperatureConverter {
    fun fromCelsius(c: Double) = TemperatureResult(c, c * 9/5 + 32, c + 273.15)
    fun fromFahrenheit(f: Double): TemperatureResult { val c = (f - 32) * 5/9; return TemperatureResult(c, f, c + 273.15) }
    fun fromKelvin(k: Double): TemperatureResult { val c = k - 273.15; return TemperatureResult(c, c * 9/5 + 32, k) }
}

// Length Converter
class LengthConverter {
    private val toMeters = mapOf(
        "Millimeters" to 0.001, "Centimeters" to 0.01, "Meters" to 1.0, "Kilometers" to 1000.0,
        "Inches" to 0.0254, "Feet" to 0.3048, "Yards" to 0.9144, "Miles" to 1609.344, "Nautical Miles" to 1852.0
    )
    
    fun convert(value: Double, from: String, to: String): Double {
        val meters = value * (toMeters[from] ?: 1.0)
        return meters / (toMeters[to] ?: 1.0)
    }
    
    fun getUnits() = toMeters.keys.toList()
}

// Weight Converter
class WeightConverter {
    private val toKg = mapOf(
        "Milligrams" to 0.000001, "Grams" to 0.001, "Kilograms" to 1.0, "Metric Tons" to 1000.0,
        "Ounces" to 0.0283495, "Pounds" to 0.453592, "Stones" to 6.35029, "US Tons" to 907.185
    )
    
    fun convert(value: Double, from: String, to: String): Double {
        val kg = value * (toKg[from] ?: 1.0)
        return kg / (toKg[to] ?: 1.0)
    }
    
    fun getUnits() = toKg.keys.toList()
}

// Volume Converter
class VolumeConverter {
    private val toLiters = mapOf(
        "Milliliters" to 0.001, "Liters" to 1.0, "Cubic Meters" to 1000.0,
        "Teaspoons" to 0.00492892, "Tablespoons" to 0.0147868, "Fluid Ounces (US)" to 0.0295735,
        "Cups (US)" to 0.236588, "Pints (US)" to 0.473176, "Quarts (US)" to 0.946353,
        "Gallons (US)" to 3.78541, "Gallons (UK)" to 4.54609
    )
    
    fun convert(value: Double, from: String, to: String): Double {
        val liters = value * (toLiters[from] ?: 1.0)
        return liters / (toLiters[to] ?: 1.0)
    }
    
    fun getUnits() = toLiters.keys.toList()
}
