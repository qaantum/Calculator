import SwiftUI

struct InvestmentGrowthCalculatorView: View {
    @State private var initial = ""
    @State private var contribution = ""
    @State private var rate = ""
    @State private var years = ""
    @State private var result: InvestmentGrowthResult?
    
    private let calculator = InvestmentGrowthCalculator()
    
    var body: some View {
        Form {
            Section {
                HStack { Text("$"); TextField("Initial Amount", text: $initial).keyboardType(.decimalPad).onChange(of: initial) { _ in calculate() } }
                HStack { Text("$"); TextField("Monthly Contribution", text: $contribution).keyboardType(.decimalPad).onChange(of: contribution) { _ in calculate() } }
                HStack { TextField("Annual Return Rate", text: $rate).keyboardType(.decimalPad).onChange(of: rate) { _ in calculate() }; Text("%") }
                TextField("Years to Grow", text: $years).keyboardType(.decimalPad).onChange(of: years) { _ in calculate() }
            }
            
            if let res = result {
                Section {
                    VStack(spacing: 8) {
                        Text("Future Value").font(.subheadline)
                        Text(formatCurrency(res.totalValue)).font(.system(size: 36, weight: .bold))
                    }.frame(maxWidth: .infinity).padding()
                }
                Section {
                    HStack { Text("Total Contributed"); Spacer(); Text(formatCurrency(res.totalContributions)).fontWeight(.semibold) }
                    HStack { Text("Total Interest Earned"); Spacer(); Text(formatCurrency(res.totalInterest)).fontWeight(.semibold) }
                }
            }
        }
        .navigationTitle("Investment Growth")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func calculate() {
        let i = Double(initial) ?? 0
        let c = Double(contribution) ?? 0
        guard let r = Double(rate), let y = Double(years) else { return }
        result = calculator.calculate(initialAmount: i, monthlyContribution: c, annualRate: r, years: y)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter(); formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}
