import SwiftUI

struct SavingsGoalCalculatorView: View {
    @State private var goal = ""
    @State private var initial = "0"
    @State private var rate = ""
    @State private var years = ""
    @State private var monthlyContribution: Double?
    
    private let calculator = SavingsGoalCalculator()
    
    var body: some View {
        Form {
            Section {
                HStack { Text("$"); TextField("Savings Goal Amount", text: $goal).keyboardType(.decimalPad) }
                HStack { Text("$"); TextField("Initial Savings", text: $initial).keyboardType(.decimalPad) }
                HStack { TextField("Annual Interest Rate", text: $rate).keyboardType(.decimalPad); Text("%") }
                TextField("Time Period (Years)", text: $years).keyboardType(.decimalPad)
            }
            
            Section {
                Button("Calculate Required Contribution") { calculate() }
            }
            
            if let amount = monthlyContribution {
                Section {
                    VStack(spacing: 8) {
                        Text("Required Monthly Savings").font(.subheadline)
                        Text(formatCurrency(amount)).font(.system(size: 36, weight: .bold))
                    }.frame(maxWidth: .infinity).padding()
                }
            }
        }
        .navigationTitle("Savings Goal")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func calculate() {
        guard let g = Double(goal), let r = Double(rate), let y = Double(years) else { return }
        let i = Double(initial) ?? 0
        monthlyContribution = calculator.calculate(goalAmount: g, initialSavings: i, annualRate: r, years: y).monthlyContribution
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter(); formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}
