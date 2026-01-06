import SwiftUI

struct BloodSugarConverterView: View {
    @State private var mgdl = ""; @State private var mmol = ""
    @State private var result: BloodSugarResult?; private let converter = BloodSugarConverter()
    var body: some View {
        Form {
            Section { HStack { TextField("mg/dL", text: $mgdl).keyboardType(.decimalPad).onChange(of: mgdl) { _ in if let v = Double(mgdl) { result = converter.fromMgdl(v); mmol = String(format: "%.2f", result!.mmol) } }; Text("mg/dL") } }
            Section { HStack { TextField("mmol/L", text: $mmol).keyboardType(.decimalPad).onChange(of: mmol) { _ in if let v = Double(mmol) { result = converter.fromMmol(v); mgdl = String(format: "%.1f", result!.mgdl) } }; Text("mmol/L") } }
            if let r = result { Section { VStack { Text("Classification").font(.subheadline); Text(r.category).font(.title2).bold().foregroundColor(color(r.categoryColor)) }.frame(maxWidth: .infinity).padding() } }
            Section { VStack(alignment: .leading, spacing: 8) { HStack { Circle().fill(Color.green).frame(width: 12, height: 12); Text("Normal: 70-99 mg/dL") }
                HStack { Circle().fill(Color.orange).frame(width: 12, height: 12); Text("Prediabetes: 100-125 mg/dL") }
                HStack { Circle().fill(Color.red).frame(width: 12, height: 12); Text("Diabetes: ≥126 mg/dL") } } } header: { Text("Reference (Fasting)") }
        }.navigationTitle("Blood Sugar").navigationBarTitleDisplayMode(.inline)
    }
    private func color(_ c: String) -> Color { switch c { case "green": return .green; case "orange": return .orange; case "amber": return .yellow; default: return .red } }
}

struct VO2MaxCalculatorView: View {
    @State private var method = "Cooper Test"; @State private var distance = ""; @State private var maxHR = ""; @State private var restingHR = ""
    @State private var result: VO2MaxResult?; private let calculator = VO2MaxCalculator()
    var body: some View {
        Form {
            Section { Picker("Method", selection: $method) { Text("Cooper Test").tag("Cooper Test"); Text("Heart Rate").tag("Heart Rate") }.pickerStyle(.segmented) }
            if method == "Cooper Test" { Section { TextField("Distance (meters)", text: $distance).keyboardType(.decimalPad).onChange(of: distance) { _ in if let v = Double(distance) { result = calculator.cooperTest(distanceMeters: v) } } } footer: { Text("Run as far as you can in 12 minutes") } }
            else { Section { TextField("Max Heart Rate (bpm)", text: $maxHR).keyboardType(.decimalPad).onChange(of: maxHR) { _ in calc() }
                TextField("Resting Heart Rate (bpm)", text: $restingHR).keyboardType(.decimalPad).onChange(of: restingHR) { _ in calc() } } footer: { Text("Max HR estimate: 220 - age") } }
            if let r = result { Section { VStack { Text("Estimated VO₂ Max").font(.subheadline); Text("\(String(format: "%.1f", r.vo2max)) mL/kg/min").font(.largeTitle).bold()
                Text(r.fitnessLevel).font(.headline).foregroundColor(.blue).padding(.horizontal, 16).padding(.vertical, 4).background(Color.blue.opacity(0.1)).cornerRadius(12) }.frame(maxWidth: .infinity).padding() } }
        }.navigationTitle("VO₂ Max").navigationBarTitleDisplayMode(.inline)
    }
    private func calc() { guard let m = Double(maxHR), let r = Double(restingHR) else { return }; result = calculator.heartRateMethod(maxHR: m, restingHR: r) }
}

struct MedicationDosageCalculatorView: View {
    @State private var weight = ""; @State private var weightUnit = "kg"; @State private var dosePerKg = ""; @State private var concentration = ""
    @State private var result: MedicationDosageResult?; private let calculator = MedicationDosageCalculator()
    var body: some View {
        Form {
            Section { HStack { Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.yellow); Text("For educational purposes only. Consult a healthcare provider.").font(.caption) } }
            Section { HStack { TextField("Body Weight", text: $weight).keyboardType(.decimalPad); Picker("", selection: $weightUnit) { Text("kg").tag("kg"); Text("lb").tag("lb") }.pickerStyle(.segmented).frame(width: 100) }
                TextField("Dose per kg (mg/kg)", text: $dosePerKg).keyboardType(.decimalPad)
                TextField("Concentration (mg/mL) - Optional", text: $concentration).keyboardType(.decimalPad) }
            Button("Calculate") { var w = Double(weight) ?? 0; if weightUnit == "lb" { w = calculator.convertLbToKg(w) }; result = calculator.calculate(weightKg: w, dosePerKg: Double(dosePerKg) ?? 0, concentration: Double(concentration)) }
            if let r = result { Section { VStack { Text("Single Dose").font(.subheadline); Text("\(String(format: "%.2f", r.singleDose)) mg").font(.largeTitle).bold()
                if let v = r.volumePerDose { Text("= \(String(format: "%.2f", v)) mL").font(.title2).foregroundColor(.blue) }
                Divider(); HStack { Text("Daily Total"); Spacer(); Text("\(String(format: "%.2f", r.dailyDose)) mg").bold() } }.padding() } }
        }.navigationTitle("Medication Dosage").navigationBarTitleDisplayMode(.inline)
    }
}
