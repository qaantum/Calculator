import SwiftUI

struct AgeCalculatorView: View {
    @State private var year = "", month = "", day = ""
    @State private var result: AgeResult?
    private let calc = AgeCalculator()
    var body: some View {
        Form {
            Section(header: Text("Birth Date")) {
                HStack { TextField("Year", text: $year).keyboardType(.numberPad); TextField("Month", text: $month).keyboardType(.numberPad); TextField("Day", text: $day).keyboardType(.numberPad) }
            }
            Button("Calculate Age") { guard let y = Int(year), let m = Int(month), let d = Int(day) else { return }; result = calc.calculate(birthYear: y, birthMonth: m, birthDay: d) }
            if let r = result { Section { Text("\(r.years) years, \(r.months) months, \(r.days) days").font(.title2).bold().frame(maxWidth: .infinity) } }
        }.navigationTitle("Age Calculator").navigationBarTitleDisplayMode(.inline)
    }
}

struct WorkHoursCalculatorView: View {
    @State private var hours = "", rate = "", threshold = "40", mult = "1.5"
    @State private var result: WorkHoursResult?
    private let calc = WorkHoursCalculator()
    var body: some View {
        Form {
            TextField("Hours Worked", text: $hours).keyboardType(.decimalPad)
            HStack { Text("$"); TextField("Hourly Rate", text: $rate).keyboardType(.decimalPad) }
            HStack { TextField("OT Threshold", text: $threshold).keyboardType(.decimalPad); TextField("OT Multiplier", text: $mult).keyboardType(.decimalPad) }
            Button("Calculate") { guard let h = Double(hours), let r = Double(rate) else { return }; result = calc.calculate(hoursWorked: h, hourlyRate: r, overtimeThreshold: Double(threshold) ?? 40, overtimeMultiplier: Double(mult) ?? 1.5) }
            if let r = result { Section {
                HStack { Text("Regular"); Spacer(); Text(String(format: "%.1f hrs", r.regularHours)).bold() }
                HStack { Text("Overtime"); Spacer(); Text(String(format: "%.1f hrs", r.overtimeHours)).bold() }
                HStack { Text("Total Pay").bold(); Spacer(); Text(fmt(r.totalPay)).font(.title2).bold() }
            }}
        }.navigationTitle("Work Hours").navigationBarTitleDisplayMode(.inline)
    }
    private func fmt(_ v: Double) -> String { let f = NumberFormatter(); f.numberStyle = .currency; return f.string(from: NSNumber(value: v)) ?? "$0" }
}

struct FuelCostCalculatorView: View {
    @State private var distance = "", mpg = "", price = ""
    @State private var result: FuelCostResult?
    private let calc = FuelCostCalculator()
    var body: some View {
        Form {
            TextField("Distance (miles)", text: $distance).keyboardType(.decimalPad)
            TextField("MPG", text: $mpg).keyboardType(.decimalPad)
            HStack { Text("$"); TextField("Price/Gallon", text: $price).keyboardType(.decimalPad) }
            Button("Calculate") { guard let d = Double(distance), let m = Double(mpg), let p = Double(price) else { return }; result = calc.calculate(distance: d, mpg: m, pricePerGallon: p) }
            if let r = result { Section {
                HStack { Text("Fuel Needed"); Spacer(); Text(String(format: "%.2f gal", r.fuelNeeded)).bold() }
                HStack { Text("Total Cost"); Spacer(); Text(fmt(r.totalCost)).bold() }
                HStack { Text("Cost/Mile"); Spacer(); Text(fmt(r.costPerMile)).bold() }
            }}
        }.navigationTitle("Fuel Cost").navigationBarTitleDisplayMode(.inline)
    }
    private func fmt(_ v: Double) -> String { let f = NumberFormatter(); f.numberStyle = .currency; return f.string(from: NSNumber(value: v)) ?? "$0" }
}

struct PasswordGeneratorView: View {
    @State private var length = "16"
    @State private var upper = true, lower = true, numbers = true, symbols = true
    @State private var password = ""
    private let gen = PasswordGenerator()
    var body: some View {
        Form {
            TextField("Length", text: $length).keyboardType(.numberPad)
            HStack {
                Toggle("ABC", isOn: $upper).toggleStyle(.button)
                Toggle("abc", isOn: $lower).toggleStyle(.button)
                Toggle("123", isOn: $numbers).toggleStyle(.button)
                Toggle("!@#", isOn: $symbols).toggleStyle(.button)
            }
            Button("Generate") { password = gen.generate(length: Int(length) ?? 16, useUpper: upper, useLower: lower, useNumbers: numbers, useSymbols: symbols) }
            if !password.isEmpty { Section { Text(password).font(.system(.body, design: .monospaced)).bold() } }
        }.navigationTitle("Password Generator").navigationBarTitleDisplayMode(.inline)
    }
}
