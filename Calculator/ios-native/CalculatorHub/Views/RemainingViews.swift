import SwiftUI

struct CurrencyConverterView: View {
    @State private var amount = ""
    @State private var fromCurrency = "USD"
    @State private var toCurrency = "EUR"
    @State private var result: CurrencyConversionResult?
    private let conv = CurrencyConverter()
    
    var body: some View {
        Form {
            TextField("Amount", text: $amount).keyboardType(.decimalPad).onChange(of: amount) { _ in calc() }
            Picker("From", selection: $fromCurrency) { ForEach(conv.currencies, id: \.self) { Text($0) } }.onChange(of: fromCurrency) { _ in calc() }
            Picker("To", selection: $toCurrency) { ForEach(conv.currencies, id: \.self) { Text($0) } }.onChange(of: toCurrency) { _ in calc() }
            if let r = result { Section { VStack {
                Text("\(String(format: "%.2f", r.amount)) \(r.fromCurrency) =").font(.subheadline)
                Text("\(String(format: "%.2f", r.result)) \(r.toCurrency)").font(.largeTitle).bold()
                Text("Rate: 1 \(r.fromCurrency) = \(String(format: "%.4f", r.rate)) \(r.toCurrency)").font(.caption)
            }.frame(maxWidth: .infinity) }}
        }.navigationTitle("Currency Converter").navigationBarTitleDisplayMode(.inline)
    }
    
    private func calc() { guard let a = Double(amount) else { return }; result = conv.convert(amount: a, from: fromCurrency, to: toCurrency) }
}

struct OvulationCalculatorView: View {
    @State private var year = "", month = "", day = "", cycleLength = "28"
    @State private var result: OvulationResult?
    private let calc = OvulationCalculator()
    
    var body: some View {
        Form {
            Section(header: Text("First Day of Last Period")) {
                HStack { TextField("Year", text: $year).keyboardType(.numberPad); TextField("Month", text: $month).keyboardType(.numberPad); TextField("Day", text: $day).keyboardType(.numberPad) }
            }
            TextField("Cycle Length (days)", text: $cycleLength).keyboardType(.numberPad)
            Button("Calculate") { guard let y = Int(year), let m = Int(month), let d = Int(day) else { return }; result = calc.calculate(lastPeriodYear: y, lastPeriodMonth: m, lastPeriodDay: d, cycleLength: Int(cycleLength) ?? 28) }
            if let r = result { Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ovulation").font(.subheadline); Text(r.ovulationDate).font(.title2).bold().foregroundColor(.pink)
                    Divider()
                    Text("Fertile Window").font(.subheadline); Text("\(r.fertileWindowStart) - \(r.fertileWindowEnd)").font(.title3).bold()
                    Divider()
                    Text("Next Period").font(.subheadline); Text(r.nextPeriodDate).font(.title3).bold()
                }
            }}
            Section { Text("Note: This is an estimation and should not be used for contraception.").font(.caption) }
        }.navigationTitle("Ovulation").navigationBarTitleDisplayMode(.inline)
    }
}

struct ChildHeightPredictorView: View {
    @State private var fatherH = "", motherH = ""
    @State private var isBoy = true
    @State private var result: ChildHeightResult?
    private let pred = ChildHeightPredictor()
    
    var body: some View {
        Form {
            Picker("Child", selection: $isBoy) { Text("Boy").tag(true); Text("Girl").tag(false) }.pickerStyle(.segmented)
            TextField("Father's Height (cm)", text: $fatherH).keyboardType(.decimalPad)
            TextField("Mother's Height (cm)", text: $motherH).keyboardType(.decimalPad)
            Button("Predict Height") { guard let f = Double(fatherH), let m = Double(motherH) else { return }; result = pred.predict(fatherHeightCm: f, motherHeightCm: m, isBoy: isBoy) }
            if let r = result { Section { VStack {
                Text("Predicted Adult Height").font(.subheadline)
                Text(String(format: "%.1f cm", r.predictedHeightCm)).font(.largeTitle).bold()
                Text(r.predictedHeightFtIn).font(.title2)
                Text("Range: \(r.rangeCm)").font(.caption)
            }.frame(maxWidth: .infinity) }}
        }.navigationTitle("Child Height").navigationBarTitleDisplayMode(.inline)
    }
}

struct SmokingCostCalculatorView: View {
    @State private var packs = "", cost = "", years = ""
    @State private var result: SmokingCostResult?
    private let calc = SmokingCostCalculator()
    
    var body: some View {
        Form {
            Section(footer: Text("See how much you could save by quitting")) {
                TextField("Packs per Day", text: $packs).keyboardType(.decimalPad)
                HStack { Text("$"); TextField("Cost per Pack", text: $cost).keyboardType(.decimalPad) }
                TextField("Years Smoking", text: $years).keyboardType(.decimalPad)
            }
            Button("Calculate Cost") { guard let p = Double(packs), let c = Double(cost) else { return }; result = calc.calculate(packsPerDay: p, costPerPack: c, yearsSmoked: Double(years) ?? 1) }
            if let r = result { Section {
                ForEach([("Weekly", r.weeklyCost), ("Monthly", r.monthlyCost), ("Yearly", r.yearlyCost), ("Lifetime", r.lifetimeCost)], id: \.0) { item in
                    HStack { Text(item.0).fontWeight(item.0 == "Lifetime" ? .bold : .regular); Spacer(); Text(fmt(item.1)).bold().foregroundColor(item.0 == "Lifetime" ? .red : .primary) }
                }
            }}
        }.navigationTitle("Smoking Cost").navigationBarTitleDisplayMode(.inline)
    }
    
    private func fmt(_ v: Double) -> String { let f = NumberFormatter(); f.numberStyle = .currency; return f.string(from: NSNumber(value: v)) ?? "$0" }
}
