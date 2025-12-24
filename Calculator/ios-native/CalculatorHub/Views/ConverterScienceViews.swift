import SwiftUI

struct UnitConverterView: View {
    @State private var input = ""
    @State private var category = "Length"
    private let conv = UnitConverter()
    let categories = ["Length", "Weight", "Temperature", "Volume", "Speed"]
    
    var body: some View {
        Form {
            Picker("Category", selection: $category) { ForEach(categories, id: \.self) { Text($0) } }
            TextField("Value", text: $input).keyboardType(.decimalPad)
            
            if let v = Double(input) {
                switch category {
                case "Length":
                    Section { ForEach([("Meters", v), ("Feet", conv.metersToFeet(v)), ("Km", v/1000), ("Miles", conv.kmToMiles(v/1000))], id: \.0) { HStack { Text($0.0); Spacer(); Text(String(format: "%.4f", $0.1)).bold() } } }
                case "Weight":
                    Section { ForEach([("Kg", v), ("Lbs", conv.kgToLbs(v)), ("Grams", v*1000)], id: \.0) { HStack { Text($0.0); Spacer(); Text(String(format: "%.4f", $0.1)).bold() } } }
                case "Temperature":
                    Section { ForEach([("Celsius", v), ("Fahrenheit", conv.celsiusToFahrenheit(v)), ("Kelvin", conv.celsiusToKelvin(v))], id: \.0) { HStack { Text($0.0); Spacer(); Text(String(format: "%.2f", $0.1)).bold() } } }
                case "Volume":
                    Section { ForEach([("Liters", v), ("Gallons", conv.litersToGallons(v)), ("mL", v*1000)], id: \.0) { HStack { Text($0.0); Spacer(); Text(String(format: "%.4f", $0.1)).bold() } } }
                case "Speed":
                    Section { ForEach([("km/h", v), ("mph", conv.kphToMph(v))], id: \.0) { HStack { Text($0.0); Spacer(); Text(String(format: "%.4f", $0.1)).bold() } } }
                default: EmptyView()
                }
            }
        }.navigationTitle("Unit Converter").navigationBarTitleDisplayMode(.inline)
    }
}

struct KinematicCalculatorView: View {
    @State private var initial = "", acceleration = "", time = ""
    @State private var finalV = "---", displacement = "---"
    private let calc = KinematicCalculator()
    
    var body: some View {
        Form {
            TextField("Initial Velocity (m/s)", text: $initial).keyboardType(.decimalPad).onChange(of: initial) { _ in calculate() }
            TextField("Acceleration (m/s²)", text: $acceleration).keyboardType(.decimalPad).onChange(of: acceleration) { _ in calculate() }
            TextField("Time (s)", text: $time).keyboardType(.decimalPad).onChange(of: time) { _ in calculate() }
            Section {
                HStack { Text("Final Velocity"); Spacer(); Text(finalV).bold() }
                HStack { Text("Displacement"); Spacer(); Text(displacement).bold() }
            }
        }.navigationTitle("Kinematic").navigationBarTitleDisplayMode(.inline)
    }
    
    private func calculate() {
        guard let u = Double(initial), let a = Double(acceleration), let t = Double(time) else { return }
        finalV = String(format: "%.4f m/s", calc.finalVelocity(initial: u, acceleration: a, time: t))
        displacement = String(format: "%.4f m", calc.displacement(initial: u, acceleration: a, time: t))
    }
}

struct ForceCalculatorView: View {
    @State private var mass = "", acceleration = "", force = "---"
    private let calc = ForceCalculator()
    
    var body: some View {
        Form {
            Section(footer: Text("F = m × a")) {
                TextField("Mass (kg)", text: $mass).keyboardType(.decimalPad)
                TextField("Acceleration (m/s²)", text: $acceleration).keyboardType(.decimalPad)
            }
            Button("Calculate Force") { guard let m = Double(mass), let a = Double(acceleration) else { return }; force = String(format: "%.4f N", calc.forceFromMassAccel(mass: m, acceleration: a)) }
            Section { VStack { Text("Force").font(.subheadline); Text(force).font(.largeTitle).bold() }.frame(maxWidth: .infinity) }
        }.navigationTitle("Force Calculator").navigationBarTitleDisplayMode(.inline)
    }
}

struct PHCalculatorView: View {
    @State private var input = "", mode = "pH"
    @State private var result: PHResult?
    private let calc = PHCalculator()
    
    var body: some View {
        Form {
            Picker("Mode", selection: $mode) { Text("From pH").tag("pH"); Text("From [H+]").tag("H+") }.pickerStyle(.segmented)
            TextField(mode == "pH" ? "pH Value" : "[H+] Concentration", text: $input).keyboardType(.decimalPad)
            Button("Calculate") { guard let v = Double(input) else { return }; result = mode == "pH" ? calc.fromPH(v) : calc.fromHConcentration(v) }
            if let r = result { Section {
                HStack { Text("pH"); Spacer(); Text(String(format: "%.2f", r.pH)).bold() }
                HStack { Text("pOH"); Spacer(); Text(String(format: "%.2f", r.pOH)).bold() }
                HStack { Text("[H+]"); Spacer(); Text(String(format: "%.2e", r.hConc)).bold() }
                HStack { Text("[OH-]"); Spacer(); Text(String(format: "%.2e", r.ohConc)).bold() }
            }}
        }.navigationTitle("pH Calculator").navigationBarTitleDisplayMode(.inline)
    }
}

struct StatisticsCalculatorView: View {
    @State private var input = ""
    @State private var result: StatsResult?
    private let calc = StandardDeviationCalculator()
    
    var body: some View {
        Form {
            Section(header: Text("Enter numbers (comma separated)")) { TextEditor(text: $input).frame(height: 100) }
            Button("Calculate") { let nums = input.components(separatedBy: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }; if !nums.isEmpty { result = calc.calculate(nums) } }
            if let r = result { Section {
                HStack { Text("Mean"); Spacer(); Text(String(format: "%.4f", r.mean)).bold() }
                HStack { Text("Variance"); Spacer(); Text(String(format: "%.4f", r.variance)).bold() }
                HStack { Text("Std Dev"); Spacer(); Text(String(format: "%.4f", r.stdDev)).bold() }
                HStack { Text("Count"); Spacer(); Text("\(r.count)").bold() }
            }}
        }.navigationTitle("Statistics").navigationBarTitleDisplayMode(.inline)
    }
}
