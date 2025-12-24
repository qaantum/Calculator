import SwiftUI

struct MatrixDeterminantView: View {
    @State private var a = "", b = "", c = "", d = ""
    @State private var result = "---"
    private let calc = MatrixDeterminantCalculator()
    
    var body: some View {
        Form {
            Section(header: Text("2×2 Matrix")) {
                HStack { TextField("a", text: $a).keyboardType(.decimalPad).onChange(of: a) { _ in calculate() }; TextField("b", text: $b).keyboardType(.decimalPad).onChange(of: b) { _ in calculate() } }
                HStack { TextField("c", text: $c).keyboardType(.decimalPad).onChange(of: c) { _ in calculate() }; TextField("d", text: $d).keyboardType(.decimalPad).onChange(of: d) { _ in calculate() } }
            }
            Section { VStack { Text("Determinant").font(.subheadline); Text(result).font(.largeTitle).bold() }.frame(maxWidth: .infinity) }
        }.navigationTitle("Matrix Determinant").navigationBarTitleDisplayMode(.inline)
    }
    
    private func calculate() {
        guard let av = Double(a), let bv = Double(b), let cv = Double(c), let dv = Double(d) else { return }
        result = String(format: "%.4f", calc.det2x2(av, bv, cv, dv))
    }
}

struct ColorConverterView: View {
    @State private var r = "255", g = "128", b = "0"
    private let conv = ColorConverter()
    
    var rgb: (Int, Int, Int) { (Int(r) ?? 0, Int(g) ?? 0, Int(b) ?? 0) }
    var hexResult: String { conv.rgbToHex(rgb.0, rgb.1, rgb.2) }
    var hsl: (Int, Int, Int) { conv.rgbToHsl(rgb.0, rgb.1, rgb.2) }
    
    var body: some View {
        Form {
            Section { Rectangle().fill(Color(red: Double(rgb.0)/255, green: Double(rgb.1)/255, blue: Double(rgb.2)/255)).frame(height: 60) }
            Section(header: Text("RGB Values")) {
                HStack { TextField("R", text: $r).keyboardType(.numberPad); TextField("G", text: $g).keyboardType(.numberPad); TextField("B", text: $b).keyboardType(.numberPad) }
            }
            Section {
                HStack { Text("HEX"); Spacer(); Text(hexResult).font(.title2).bold() }
                HStack { Text("HSL"); Spacer(); Text("\(hsl.0)°, \(hsl.1)%, \(hsl.2)%").bold() }
            }
        }.navigationTitle("Color Converter").navigationBarTitleDisplayMode(.inline)
    }
}

struct LoanAffordabilityView: View {
    @State private var income = "", dti = "36", rate = "", term = "360"
    @State private var result: LoanAffordabilityResult?
    private let calc = LoanAffordabilityCalculator()
    
    var body: some View {
        Form {
            HStack { Text("$"); TextField("Monthly Income", text: $income).keyboardType(.decimalPad) }
            HStack { TextField("Max DTI Ratio", text: $dti).keyboardType(.numberPad); Text("%") }
            HStack { TextField("Interest Rate", text: $rate).keyboardType(.decimalPad); Text("%") }
            TextField("Term (months)", text: $term).keyboardType(.numberPad)
            Button("Calculate") { guard let i = Double(income), let r = Double(rate) else { return }; result = calc.calculate(monthlyIncome: i, debtToIncomeRatio: Double(dti) ?? 36, rate: r, termMonths: Int(term) ?? 360) }
            if let res = result { Section { VStack { Text("Maximum Loan").font(.subheadline); Text(fmt(res.maxLoan)).font(.largeTitle).bold(); Text("Max Payment: \(fmt(res.monthlyPayment))") }.frame(maxWidth: .infinity) } }
        }.navigationTitle("Loan Affordability").navigationBarTitleDisplayMode(.inline)
    }
    private func fmt(_ v: Double) -> String { let f = NumberFormatter(); f.numberStyle = .currency; return f.string(from: NSNumber(value: v)) ?? "$0" }
}

struct RefinanceCalculatorView: View {
    @State private var balance = "", oldRate = "", newRate = "", term = "360", costs = ""
    @State private var result: RefinanceResult?
    private let calc = RefinanceCalculator()
    
    var body: some View {
        Form {
            HStack { Text("$"); TextField("Loan Balance", text: $balance).keyboardType(.decimalPad) }
            HStack { TextField("Current Rate", text: $oldRate).keyboardType(.decimalPad); Text("%"); TextField("New Rate", text: $newRate).keyboardType(.decimalPad); Text("%") }
            TextField("Term (months)", text: $term).keyboardType(.numberPad)
            HStack { Text("$"); TextField("Closing Costs", text: $costs).keyboardType(.decimalPad) }
            Button("Compare") { guard let b = Double(balance), let o = Double(oldRate), let n = Double(newRate) else { return }; result = calc.calculate(loanBalance: b, oldRate: o, newRate: n, termMonths: Int(term) ?? 360, closingCosts: Double(costs) ?? 0) }
            if let res = result { Section {
                HStack { Text("Old Payment"); Spacer(); Text(fmt(res.oldPayment)).bold() }
                HStack { Text("New Payment"); Spacer(); Text(fmt(res.newPayment)).bold() }
                HStack { Text("Monthly Savings").bold(); Spacer(); Text(fmt(res.monthlySavings)).font(.title2).bold().foregroundColor(res.monthlySavings > 0 ? .green : .red) }
                Text("Break-even: \(res.breakEvenMonths) months").font(.caption)
            }}
        }.navigationTitle("Refinance").navigationBarTitleDisplayMode(.inline)
    }
    private func fmt(_ v: Double) -> String { let f = NumberFormatter(); f.numberStyle = .currency; return f.string(from: NSNumber(value: v)) ?? "$0" }
}

struct RentalPropertyView: View {
    @State private var price = "", down = "", rent = "", expenses = "", mortgage = ""
    @State private var result: RentalResult?
    private let calc = RentalPropertyCalculator()
    
    var body: some View {
        Form {
            HStack { Text("$"); TextField("Purchase Price", text: $price).keyboardType(.decimalPad) }
            HStack { Text("$"); TextField("Down Payment", text: $down).keyboardType(.decimalPad) }
            HStack { Text("$"); TextField("Monthly Rent", text: $rent).keyboardType(.decimalPad) }
            HStack { Text("$"); TextField("Monthly Expenses", text: $expenses).keyboardType(.decimalPad) }
            HStack { Text("$"); TextField("Mortgage Payment", text: $mortgage).keyboardType(.decimalPad) }
            Button("Analyze") { guard let p = Double(price), let d = Double(down), let r = Double(rent) else { return }; result = calc.calculate(purchasePrice: p, downPayment: d, monthlyRent: r, monthlyExpenses: Double(expenses) ?? 0, mortgagePayment: Double(mortgage) ?? 0) }
            if let res = result { Section {
                HStack { Text("Annual Cash Flow"); Spacer(); Text(fmt(res.annualCashFlow)).bold() }
                HStack { Text("Cap Rate"); Spacer(); Text(String(format: "%.2f%%", res.capRate)).bold() }
                HStack { Text("ROI"); Spacer(); Text(String(format: "%.2f%%", res.roi)).bold() }
                HStack { Text("Cash-on-Cash"); Spacer(); Text(String(format: "%.2f%%", res.cashOnCash)).bold() }
            }}
        }.navigationTitle("Rental Property").navigationBarTitleDisplayMode(.inline)
    }
    private func fmt(_ v: Double) -> String { let f = NumberFormatter(); f.numberStyle = .currency; return f.string(from: NSNumber(value: v)) ?? "$0" }
}
