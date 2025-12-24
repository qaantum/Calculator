import SwiftUI

struct AutoLoanCalculatorView: View {
    @State private var price = ""; @State private var downPayment = "0"; @State private var tradeIn = "0"
    @State private var rate = ""; @State private var term = "60"; @State private var tax = "0"
    @State private var result: AutoLoanResult?
    private let calculator = AutoLoanCalculator()
    var body: some View {
        Form {
            Section { HStack { Text("$"); TextField("Vehicle Price", text: $price).keyboardType(.decimalPad) } }
            Section { HStack { Text("$"); TextField("Down Payment", text: $downPayment).keyboardType(.decimalPad) }; HStack { Text("$"); TextField("Trade-in", text: $tradeIn).keyboardType(.decimalPad) } }
            Section { HStack { TextField("Interest Rate", text: $rate).keyboardType(.decimalPad); Text("%") }; TextField("Term (Months)", text: $term).keyboardType(.numberPad); HStack { TextField("Sales Tax", text: $tax).keyboardType(.decimalPad); Text("%") } }
            Button("Calculate") { result = calculator.calculate(price: Double(price) ?? 0, downPayment: Double(downPayment) ?? 0, tradeIn: Double(tradeIn) ?? 0, rate: Double(rate) ?? 0, termMonths: Int(term) ?? 60, taxRate: Double(tax) ?? 0) }
            if let r = result { Section { VStack { Text("Monthly Payment").font(.subheadline); Text(fmt(r.monthlyPayment)).font(.largeTitle).bold(); Divider(); HStack { Text("Interest"); Spacer(); Text(fmt(r.totalInterest)).bold() }; HStack { Text("Total"); Spacer(); Text(fmt(r.totalCost)).bold() } }.padding() } }
        }.navigationTitle("Auto Loan").navigationBarTitleDisplayMode(.inline)
    }
    private func fmt(_ v: Double) -> String { let f = NumberFormatter(); f.numberStyle = .currency; return f.string(from: NSNumber(value: v)) ?? "$0" }
}

struct CommissionCalculatorView: View {
    @State private var salePrice = ""; @State private var rate = ""; @State private var result: CommissionResult?
    private let calculator = CommissionCalculator()
    var body: some View {
        Form {
            HStack { Text("$"); TextField("Sale Price", text: $salePrice).keyboardType(.decimalPad).onChange(of: salePrice) { _ in calc() } }
            HStack { TextField("Commission Rate", text: $rate).keyboardType(.decimalPad).onChange(of: rate) { _ in calc() }; Text("%") }
            if let r = result { Section { VStack { Text("Commission").font(.subheadline); Text(fmt(r.commission)).font(.title).bold().foregroundColor(.blue); Divider(); Text("Net Proceeds").font(.subheadline); Text(fmt(r.netProceeds)).font(.title2).bold() }.frame(maxWidth: .infinity).padding() } }
        }.navigationTitle("Commission").navigationBarTitleDisplayMode(.inline)
    }
    private func calc() { guard let p = Double(salePrice), let r = Double(rate) else { return }; result = calculator.calculate(salePrice: p, commissionRate: r) }
    private func fmt(_ v: Double) -> String { let f = NumberFormatter(); f.numberStyle = .currency; return f.string(from: NSNumber(value: v)) ?? "$0" }
}

struct SalesTaxCalculatorView: View {
    @State private var amount = ""; @State private var taxRate = ""; @State private var isReverse = false; @State private var result: SalesTaxResult?
    private let calculator = SalesTaxCalculator()
    var body: some View {
        Form {
            Picker("Mode", selection: $isReverse) { Text("Add Tax").tag(false); Text("Reverse Tax").tag(true) }.pickerStyle(.segmented).onChange(of: isReverse) { _ in calc() }
            HStack { Text("$"); TextField(isReverse ? "Total (Inc. Tax)" : "Net (Excl. Tax)", text: $amount).keyboardType(.decimalPad).onChange(of: amount) { _ in calc() } }
            HStack { TextField("Tax Rate", text: $taxRate).keyboardType(.decimalPad).onChange(of: taxRate) { _ in calc() }; Text("%") }
            if let r = result { Section { VStack(spacing: 8) { HStack { Text("Net"); Spacer(); Text(fmt(r.netAmount)).bold() }; Divider(); HStack { Text("Tax"); Spacer(); Text(fmt(r.taxAmount)).bold() }; Divider(); HStack { Text("Total").bold(); Spacer(); Text(fmt(r.totalAmount)).font(.title2).bold() } }.padding() } }
        }.navigationTitle("Sales Tax").navigationBarTitleDisplayMode(.inline)
    }
    private func calc() { guard let a = Double(amount), let r = Double(taxRate) else { return }; result = calculator.calculate(amount: a, taxRate: r, isReverse: isReverse) }
    private func fmt(_ v: Double) -> String { let f = NumberFormatter(); f.numberStyle = .currency; return f.string(from: NSNumber(value: v)) ?? "$0" }
}

struct SalaryCalculatorView: View {
    @State private var amount = ""; @State private var frequency = "Annual"; @State private var hours = "40"; @State private var days = "5"
    @State private var result: SalaryResult?
    private let calculator = SalaryCalculator()
    let frequencies = ["Annual", "Monthly", "Bi-Weekly", "Weekly", "Daily", "Hourly"]
    var body: some View {
        Form {
            HStack { Text("$"); TextField("Amount", text: $amount).keyboardType(.decimalPad).onChange(of: amount) { _ in calc() } }
            Picker("Per", selection: $frequency) { ForEach(frequencies, id: \.self) { Text($0) } }.onChange(of: frequency) { _ in calc() }
            HStack { TextField("Hours/Week", text: $hours).keyboardType(.decimalPad).onChange(of: hours) { _ in calc() }; TextField("Days/Week", text: $days).keyboardType(.decimalPad).onChange(of: days) { _ in calc() } }
            if let r = result { Section { VStack { ForEach([("Annual", r.annual), ("Monthly", r.monthly), ("Bi-Weekly", r.biWeekly), ("Weekly", r.weekly), ("Daily", r.daily), ("Hourly", r.hourly)], id: \.0) { HStack { Text($0.0); Spacer(); Text(fmt($0.1)).bold() }; Divider() } }.padding() } }
        }.navigationTitle("Salary Calculator").navigationBarTitleDisplayMode(.inline)
    }
    private func calc() { guard let a = Double(amount) else { return }; result = calculator.calculate(amount: a, frequency: frequency, hoursPerWeek: Double(hours) ?? 40, daysPerWeek: Double(days) ?? 5) }
    private func fmt(_ v: Double) -> String { let f = NumberFormatter(); f.numberStyle = .currency; return f.string(from: NSNumber(value: v)) ?? "$0" }
}
