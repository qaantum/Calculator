import SwiftUI

struct OhmsLawCalculatorView: View {
    @State private var voltage = "", current = "", resistance = ""
    @State private var result: OhmsLawResult?
    private let calc = OhmsLawCalculator()
    var body: some View {
        Form {
            Section(footer: Text("V = I × R")) {
                TextField("Voltage (V)", text: $voltage).keyboardType(.decimalPad)
                TextField("Current (A)", text: $current).keyboardType(.decimalPad)
                TextField("Resistance (Ω)", text: $resistance).keyboardType(.decimalPad)
            }
            Section { HStack {
                Button("Calc V") { guard let i = Double(current), let r = Double(resistance) else { return }; result = calc.calculateVoltage(current: i, resistance: r) }
                Button("Calc I") { guard let v = Double(voltage), let r = Double(resistance) else { return }; result = calc.calculateCurrent(voltage: v, resistance: r) }
                Button("Calc R") { guard let v = Double(voltage), let i = Double(current) else { return }; result = calc.calculateResistance(voltage: v, current: i) }
            }}
            if let r = result { Section {
                if let v = r.voltage { HStack { Text("Voltage"); Spacer(); Text(String(format: "%.4f V", v)).bold() } }
                if let i = r.current { HStack { Text("Current"); Spacer(); Text(String(format: "%.4f A", i)).bold() } }
                if let res = r.resistance { HStack { Text("Resistance"); Spacer(); Text(String(format: "%.4f Ω", res)).bold() } }
                if let p = r.power { HStack { Text("Power"); Spacer(); Text(String(format: "%.4f W", p)).bold() } }
            }}
        }.navigationTitle("Ohm's Law").navigationBarTitleDisplayMode(.inline)
    }
}

struct LEDResistorCalculatorView: View {
    @State private var supply = "", led = "", current = "20"
    @State private var result: LEDResistorResult?
    private let calc = LEDResistorCalculator()
    var body: some View {
        Form {
            TextField("Supply Voltage (V)", text: $supply).keyboardType(.decimalPad)
            TextField("LED Forward Voltage (V)", text: $led).keyboardType(.decimalPad)
            TextField("LED Current (mA)", text: $current).keyboardType(.decimalPad)
            Button("Calculate") { guard let s = Double(supply), let l = Double(led), let c = Double(current) else { return }; result = calc.calculate(supplyVoltage: s, ledVoltage: l, ledCurrent: c) }
            if let r = result { Section { VStack { Text("Required Resistor").font(.subheadline); Text(String(format: "%.0f Ω", r.resistance)).font(.largeTitle).bold(); Text("Nearest: \(r.nearestStandard) Ω"); Text(String(format: "Power: %.3f W", r.power)) }.frame(maxWidth: .infinity) } }
        }.navigationTitle("LED Resistor").navigationBarTitleDisplayMode(.inline)
    }
}

struct WordCountCalculatorView: View {
    @State private var text = ""
    @State private var result: WordCountResult?
    private let calc = WordCountCalculator()
    var body: some View {
        Form {
            TextEditor(text: $text).frame(height: 150).onChange(of: text) { _ in result = calc.count(text: text) }
            if let r = result { Section {
                HStack { Text("Characters"); Spacer(); Text("\(r.characters)").bold() }
                HStack { Text("Words"); Spacer(); Text("\(r.words)").bold() }
                HStack { Text("Sentences"); Spacer(); Text("\(r.sentences)").bold() }
                HStack { Text("Paragraphs"); Spacer(); Text("\(r.paragraphs)").bold() }
                HStack { Text("Lines"); Spacer(); Text("\(r.lines)").bold() }
            }}
        }.navigationTitle("Word Count").navigationBarTitleDisplayMode(.inline)
    }
}

struct Base64ConverterView: View {
    @State private var input = "", output = ""
    private let conv = Base64Converter()
    var body: some View {
        Form {
            Section(header: Text("Input")) { TextEditor(text: $input).frame(height: 100) }
            HStack { Button("Encode →") { output = conv.encode(input) }; Button("Decode ←") { output = conv.decode(input) } }
            Section(header: Text("Output")) { Text(output).frame(minHeight: 100) }
        }.navigationTitle("Base64").navigationBarTitleDisplayMode(.inline)
    }
}
