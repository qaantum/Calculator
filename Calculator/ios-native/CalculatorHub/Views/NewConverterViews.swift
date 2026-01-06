import SwiftUI

struct TemperatureConverterView: View {
    @State private var celsius = ""; @State private var fahrenheit = ""; @State private var kelvin = ""
    private let converter = TemperatureConverter()
    var body: some View {
        Form {
            Section { HStack { TextField("Celsius", text: $celsius).keyboardType(.decimalPad).onChange(of: celsius) { _ in update("C") }; Text("°C") } }
            Section { HStack { TextField("Fahrenheit", text: $fahrenheit).keyboardType(.decimalPad).onChange(of: fahrenheit) { _ in update("F") }; Text("°F") } }
            Section { HStack { TextField("Kelvin", text: $kelvin).keyboardType(.decimalPad).onChange(of: kelvin) { _ in update("K") }; Text("K") } }
            Section { VStack(alignment: .leading, spacing: 8) { Text("Water freezes: 0°C = 32°F = 273.15K"); Text("Water boils: 100°C = 212°F = 373.15K") } } header: { Text("Reference Points") }
        }.navigationTitle("Temperature").navigationBarTitleDisplayMode(.inline)
    }
    private func update(_ from: String) {
        guard let v = Double(from == "C" ? celsius : from == "F" ? fahrenheit : kelvin) else { return }
        let r = from == "C" ? converter.fromCelsius(v) : from == "F" ? converter.fromFahrenheit(v) : converter.fromKelvin(v)
        if from != "C" { celsius = String(format: "%.2f", r.celsius) }
        if from != "F" { fahrenheit = String(format: "%.2f", r.fahrenheit) }
        if from != "K" { kelvin = String(format: "%.2f", r.kelvin) }
    }
}

struct LengthConverterView: View {
    @State private var value = ""; @State private var fromUnit = "Meters"; @State private var toUnit = "Feet"; @State private var result: Double?
    private let converter = LengthConverter()
    var body: some View {
        Form {
            Section { TextField("Value", text: $value).keyboardType(.decimalPad).onChange(of: value) { _ in calc() } }
            Section { Picker("From", selection: $fromUnit) { ForEach(converter.getUnits(), id: \.self) { Text($0) } }.onChange(of: fromUnit) { _ in calc() }
                Picker("To", selection: $toUnit) { ForEach(converter.getUnits(), id: \.self) { Text($0) } }.onChange(of: toUnit) { _ in calc() } }
            if let r = result { Section { VStack { Text("Result").font(.subheadline); Text("\(String(format: "%.6f", r)) \(toUnit)").font(.largeTitle).bold() }.frame(maxWidth: .infinity).padding() } }
        }.navigationTitle("Length").navigationBarTitleDisplayMode(.inline)
    }
    private func calc() { result = converter.convert(Double(value) ?? 0, from: fromUnit, to: toUnit) }
}

struct WeightConverterView: View {
    @State private var value = ""; @State private var fromUnit = "Kilograms"; @State private var toUnit = "Pounds"; @State private var result: Double?
    private let converter = WeightConverter()
    var body: some View {
        Form {
            Section { TextField("Value", text: $value).keyboardType(.decimalPad).onChange(of: value) { _ in calc() } }
            Section { Picker("From", selection: $fromUnit) { ForEach(converter.getUnits(), id: \.self) { Text($0) } }.onChange(of: fromUnit) { _ in calc() }
                Picker("To", selection: $toUnit) { ForEach(converter.getUnits(), id: \.self) { Text($0) } }.onChange(of: toUnit) { _ in calc() } }
            if let r = result { Section { VStack { Text("Result").font(.subheadline); Text("\(String(format: "%.6f", r)) \(toUnit)").font(.largeTitle).bold() }.frame(maxWidth: .infinity).padding() } }
        }.navigationTitle("Weight").navigationBarTitleDisplayMode(.inline)
    }
    private func calc() { result = converter.convert(Double(value) ?? 0, from: fromUnit, to: toUnit) }
}

struct VolumeConverterView: View {
    @State private var value = ""; @State private var fromUnit = "Liters"; @State private var toUnit = "Gallons (US)"; @State private var result: Double?
    private let converter = VolumeConverter()
    var body: some View {
        Form {
            Section { TextField("Value", text: $value).keyboardType(.decimalPad).onChange(of: value) { _ in calc() } }
            Section { Picker("From", selection: $fromUnit) { ForEach(converter.getUnits(), id: \.self) { Text($0) } }.onChange(of: fromUnit) { _ in calc() }
                Picker("To", selection: $toUnit) { ForEach(converter.getUnits(), id: \.self) { Text($0) } }.onChange(of: toUnit) { _ in calc() } }
            if let r = result { Section { VStack { Text("Result").font(.subheadline); Text("\(String(format: "%.6f", r)) \(toUnit)").font(.largeTitle).bold() }.frame(maxWidth: .infinity).padding() } }
        }.navigationTitle("Volume").navigationBarTitleDisplayMode(.inline)
    }
    private func calc() { result = converter.convert(Double(value) ?? 0, from: fromUnit, to: toUnit) }
}
