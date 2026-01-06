import Foundation

// NEW CONVERTERS

// Temperature Converter
struct TemperatureResult { let celsius, fahrenheit, kelvin: Double }
class TemperatureConverter {
    func fromCelsius(_ c: Double) -> TemperatureResult { TemperatureResult(celsius: c, fahrenheit: c * 9/5 + 32, kelvin: c + 273.15) }
    func fromFahrenheit(_ f: Double) -> TemperatureResult { let c = (f - 32) * 5/9; return TemperatureResult(celsius: c, fahrenheit: f, kelvin: c + 273.15) }
    func fromKelvin(_ k: Double) -> TemperatureResult { let c = k - 273.15; return TemperatureResult(celsius: c, fahrenheit: c * 9/5 + 32, kelvin: k) }
}

// Length Converter
class LengthConverter {
    private let toMeters: [String: Double] = ["Millimeters": 0.001, "Centimeters": 0.01, "Meters": 1.0, "Kilometers": 1000.0, "Inches": 0.0254, "Feet": 0.3048, "Yards": 0.9144, "Miles": 1609.344, "Nautical Miles": 1852.0]
    func convert(_ value: Double, from: String, to: String) -> Double { value * (toMeters[from] ?? 1.0) / (toMeters[to] ?? 1.0) }
    func getUnits() -> [String] { Array(toMeters.keys).sorted() }
}

// Weight Converter
class WeightConverter {
    private let toKg: [String: Double] = ["Milligrams": 0.000001, "Grams": 0.001, "Kilograms": 1.0, "Metric Tons": 1000.0, "Ounces": 0.0283495, "Pounds": 0.453592, "Stones": 6.35029, "US Tons": 907.185]
    func convert(_ value: Double, from: String, to: String) -> Double { value * (toKg[from] ?? 1.0) / (toKg[to] ?? 1.0) }
    func getUnits() -> [String] { Array(toKg.keys).sorted() }
}

// Volume Converter
class VolumeConverter {
    private let toLiters: [String: Double] = ["Milliliters": 0.001, "Liters": 1.0, "Cubic Meters": 1000.0, "Teaspoons": 0.00492892, "Tablespoons": 0.0147868, "Fluid Ounces (US)": 0.0295735, "Cups (US)": 0.236588, "Pints (US)": 0.473176, "Quarts (US)": 0.946353, "Gallons (US)": 3.78541, "Gallons (UK)": 4.54609]
    func convert(_ value: Double, from: String, to: String) -> Double { value * (toLiters[from] ?? 1.0) / (toLiters[to] ?? 1.0) }
    func getUnits() -> [String] { Array(toLiters.keys).sorted() }
}
