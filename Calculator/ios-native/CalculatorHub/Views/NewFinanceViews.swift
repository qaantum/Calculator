import SwiftUI

struct NPVCalculatorView: View {
    @State private var initialInvestment = ""; @State private var discountRate = "10"; @State private var cashFlows = [""]
    @State private var result: NPVResult?; private let calculator = NPVCalculator()
    var body: some View {
        Form {
            Section { HStack { Text("$"); TextField("Initial Investment", text: $initialInvestment).keyboardType(.decimalPad) } }
            Section { HStack { TextField("Discount Rate", text: $discountRate).keyboardType(.decimalPad); Text("%") } }
            Section(header: HStack { Text("Cash Flows"); Spacer(); Button(action: { cashFlows.append("") }) { Image(systemName: "plus.circle") } }) {
                ForEach(cashFlows.indices, id: \.self) { i in
                    HStack { Text("$"); TextField("Year \(i+1)", text: $cashFlows[i]).keyboardType(.decimalPad)
                        if cashFlows.count > 1 { Button(action: { cashFlows.remove(at: i) }) { Image(systemName: "minus.circle").foregroundColor(.red) } } }
                }
            }
            Button("Calculate") { let cfs = cashFlows.compactMap { Double($0) }; result = calculator.calculate(initialInvestment: Double(initialInvestment) ?? 0, cashFlows: cfs, discountRate: Double(discountRate) ?? 10) }
            if let r = result {
                Section { VStack { Text("Net Present Value").font(.subheadline); Text(fmt(r.npv)).font(.largeTitle).bold().foregroundColor(r.isProfitable ? .green : .red)
                    Text(r.isProfitable ? "Profitable" : "Unprofitable").foregroundColor(r.isProfitable ? .green : .red) }.frame(maxWidth: .infinity).padding() }
            }
        }.navigationTitle("NPV Calculator").navigationBarTitleDisplayMode(.inline)
    }
    private func fmt(_ v: Double) -> String { let f = NumberFormatter(); f.numberStyle = .currency; return f.string(from: NSNumber(value: v)) ?? "$0" }
}

struct IRRCalculatorView: View {
    @State private var initialInvestment = ""; @State private var cashFlows = [""]
    @State private var result: IRRResult?; private let calculator = IRRCalculator()
    var body: some View {
        Form {
            Section { HStack { Text("$"); TextField("Initial Investment", text: $initialInvestment).keyboardType(.decimalPad) } }
            Section(header: HStack { Text("Cash Flows"); Spacer(); Button(action: { cashFlows.append("") }) { Image(systemName: "plus.circle") } }) {
                ForEach(cashFlows.indices, id: \.self) { i in
                    HStack { Text("$"); TextField("Year \(i+1)", text: $cashFlows[i]).keyboardType(.decimalPad)
                        if cashFlows.count > 1 { Button(action: { cashFlows.remove(at: i) }) { Image(systemName: "minus.circle").foregroundColor(.red) } } }
                }
            }
            Button("Calculate") { let cfs = cashFlows.compactMap { Double($0) }; result = calculator.calculate(initialInvestment: Double(initialInvestment) ?? 0, cashFlows: cfs) }
            if let r = result { Section { VStack { Text("Internal Rate of Return").font(.subheadline); Text(String(format: "%.2f%%", r.irr)).font(.largeTitle).bold() }.frame(maxWidth: .infinity).padding() } }
        }.navigationTitle("IRR Calculator").navigationBarTitleDisplayMode(.inline)
    }
}

struct DownPaymentCalculatorView: View {
    @State private var price = ""; @State private var downPercent = "20"; @State private var rate = "7"; @State private var term = "30"
    @State private var result: DownPaymentResult?; private let calculator = DownPaymentCalculator()
    var body: some View {
        Form {
            Section { HStack { Text("$"); TextField("Purchase Price", text: $price).keyboardType(.decimalPad).onChange(of: price) { _ in calc() } } }
            Section { HStack { TextField("Down Payment", text: $downPercent).keyboardType(.decimalPad).onChange(of: downPercent) { _ in calc() }; Text("%") } }
            HStack { TextField("Rate", text: $rate).keyboardType(.decimalPad).onChange(of: rate) { _ in calc() }; Text("%") }
            HStack { TextField("Term", text: $term).keyboardType(.numberPad).onChange(of: term) { _ in calc() }; Text("years") }
            if let r = result { Section { VStack(spacing: 8) { HStack { Text("Down Payment"); Spacer(); Text(fmt(r.downPayment)).bold() }; Divider()
                HStack { Text("Loan Amount"); Spacer(); Text(fmt(r.loanAmount)).bold() }; Divider()
                VStack { Text("Monthly Payment").font(.subheadline); Text(fmt(r.monthlyPayment)).font(.title).bold() } }.padding() } }
        }.navigationTitle("Down Payment").navigationBarTitleDisplayMode(.inline)
    }
    private func calc() { result = calculator.calculate(purchasePrice: Double(price) ?? 0, downPaymentPercent: Double(downPercent) ?? 20, interestRate: Double(rate) ?? 7, loanTermYears: Int(term) ?? 30) }
    private func fmt(_ v: Double) -> String { let f = NumberFormatter(); f.numberStyle = .currency; return f.string(from: NSNumber(value: v)) ?? "$0" }
}

struct PaycheckCalculatorView: View {
    @State private var salary = ""; @State private var payPeriod = "Biweekly"; @State private var federal = "22"; @State private var state = "5"
    @State private var result: PaycheckResult?; private let calculator = PaycheckCalculator()
    let periods = ["Weekly", "Biweekly", "Semi-Monthly", "Monthly", "Annual"]
    var body: some View {
        Form {
            Section { HStack { Text("$"); TextField("Annual Salary", text: $salary).keyboardType(.decimalPad).onChange(of: salary) { _ in calc() } }
                Picker("Pay Period", selection: $payPeriod) { ForEach(periods, id: \.self) { Text($0) } }.onChange(of: payPeriod) { _ in calc() } }
            Section { HStack { TextField("Federal Tax", text: $federal).keyboardType(.decimalPad).onChange(of: federal) { _ in calc() }; Text("%") }
                HStack { TextField("State Tax", text: $state).keyboardType(.decimalPad).onChange(of: state) { _ in calc() }; Text("%") } }
            if let r = result { Section { VStack { Text("\(payPeriod) Take-Home Pay").font(.subheadline); Text(fmt(r.netPay)).font(.largeTitle).bold().foregroundColor(.green)
                Divider(); HStack { Text("Gross"); Spacer(); Text(fmt(r.grossPay)).bold() }
                HStack { Text("Deductions"); Spacer(); Text("-\(fmt(r.totalDeductions))").bold().foregroundColor(.red) } }.padding() } }
        }.navigationTitle("Paycheck Calculator").navigationBarTitleDisplayMode(.inline)
    }
    private func calc() { result = calculator.calculate(annualSalary: Double(salary) ?? 0, payPeriod: payPeriod, federalRate: Double(federal) ?? 22, stateRate: Double(state) ?? 5) }
    private func fmt(_ v: Double) -> String { let f = NumberFormatter(); f.numberStyle = .currency; return f.string(from: NSNumber(value: v)) ?? "$0" }
}

struct CDCalculatorView: View {
    @State private var deposit = ""; @State private var apy = "5"; @State private var term = "12"
    @State private var result: CDResult?; private let calculator = CDCalculator()
    var body: some View {
        Form {
            Section { HStack { Text("$"); TextField("Initial Deposit", text: $deposit).keyboardType(.decimalPad).onChange(of: deposit) { _ in calc() } }
                HStack { TextField("APY", text: $apy).keyboardType(.decimalPad).onChange(of: apy) { _ in calc() }; Text("%") }
                HStack { TextField("Term", text: $term).keyboardType(.numberPad).onChange(of: term) { _ in calc() }; Text("months") } }
            if let r = result { Section { VStack { Text("Total at Maturity").font(.subheadline); Text(fmt(r.totalValue)).font(.largeTitle).bold()
                Divider(); HStack { Text("Interest Earned"); Spacer(); Text(fmt(r.interestEarned)).bold().foregroundColor(.green) } }.padding() } }
        }.navigationTitle("CD Calculator").navigationBarTitleDisplayMode(.inline)
    }
    private func calc() { result = calculator.calculate(deposit: Double(deposit) ?? 0, apy: Double(apy) ?? 5, termMonths: Int(term) ?? 12) }
    private func fmt(_ v: Double) -> String { let f = NumberFormatter(); f.numberStyle = .currency; return f.string(from: NSNumber(value: v)) ?? "$0" }
}

struct TipSplitCalculatorView: View {
    @State private var bill = ""; @State private var tipPercent = "18"; @State private var people = 2
    @State private var result: TipSplitResult?; private let calculator = TipSplitCalculator()
    var body: some View {
        Form {
            Section { HStack { Text("$"); TextField("Bill Amount", text: $bill).keyboardType(.decimalPad).onChange(of: bill) { _ in calc() } }
                HStack { TextField("Tip %", text: $tipPercent).keyboardType(.decimalPad).onChange(of: tipPercent) { _ in calc() }; Text("%") } }
            Section { HStack { ForEach([10, 15, 18, 20, 25], id: \.self) { t in Button("\(t)%") { tipPercent = "\(t)"; calc() }.buttonStyle(.bordered).tint(tipPercent == "\(t)" ? .blue : .gray) } } }
            Section { Stepper("People: \(people)", value: $people, in: 1...99).onChange(of: people) { _ in calc() } }
            if let r = result { Section { VStack { Text("Each Person Pays").font(.subheadline); Text(fmt(r.perPersonAmount)).font(.largeTitle).bold()
                Text("(includes \(fmt(r.perPersonTip)) tip)").font(.caption) }.frame(maxWidth: .infinity).padding() }
                Section { HStack { Text("Total Tip"); Spacer(); Text(fmt(r.tipAmount)).bold().foregroundColor(.green) }
                    HStack { Text("Grand Total"); Spacer(); Text(fmt(r.totalWithTip)).bold() } } }
        }.navigationTitle("Tip Split").navigationBarTitleDisplayMode(.inline)
    }
    private func calc() { result = calculator.calculate(billAmount: Double(bill) ?? 0, tipPercent: Double(tipPercent) ?? 18, numberOfPeople: people) }
    private func fmt(_ v: Double) -> String { let f = NumberFormatter(); f.numberStyle = .currency; return f.string(from: NSNumber(value: v)) ?? "$0" }
}
