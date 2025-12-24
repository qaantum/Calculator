import SwiftUI

struct RetirementCalculatorView: View {
    @State private var currentAge = ""
    @State private var retireAge = "65"
    @State private var savings = "0"
    @State private var contribution = ""
    @State private var rate = "7"
    @State private var result: RetirementResult?
    
    private let calculator = RetirementCalculator()
    
    var body: some View {
        Form {
            Section {
                HStack {
                    TextField("Current Age", text: $currentAge).keyboardType(.numberPad)
                    TextField("Retirement Age", text: $retireAge).keyboardType(.numberPad)
                }
            }
            Section {
                HStack { Text("$"); TextField("Current Savings", text: $savings).keyboardType(.decimalPad) }
                HStack { Text("$"); TextField("Monthly Contribution", text: $contribution).keyboardType(.decimalPad) }
                HStack { TextField("Expected Annual Return", text: $rate).keyboardType(.decimalPad); Text("%") }
            }
            Section {
                Button("Calculate") { calculate() }
            }
            
            if let res = result {
                Section {
                    VStack(spacing: 8) {
                        Text("Total at Retirement").font(.subheadline)
                        Text(formatCurrency(res.totalSavings)).font(.system(size: 32, weight: .bold))
                    }.frame(maxWidth: .infinity).padding()
                }
                Section {
                    VStack(spacing: 4) {
                        Text("Est. Monthly Income (4% Rule)").font(.subheadline)
                        Text(formatCurrency(res.monthlyIncome)).font(.title).fontWeight(.bold)
                    }.frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Retirement Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func calculate() {
        guard let ca = Int(currentAge), let ra = Int(retireAge), let c = Double(contribution) else { return }
        let s = Double(savings) ?? 0
        let r = Double(rate) ?? 7
        result = calculator.calculate(currentAge: ca, retirementAge: ra, currentSavings: s, monthlyContribution: c, annualRate: r)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter(); formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}
