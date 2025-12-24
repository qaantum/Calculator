import SwiftUI

struct LoanCalculatorView: View {
    @State private var amount = ""
    @State private var rate = ""
    @State private var term = ""
    @State private var result: LoanResult?
    
    private let calculator = LoanCalculator()
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("$")
                    TextField("Loan Amount", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                HStack {
                    TextField("Interest Rate", text: $rate)
                        .keyboardType(.decimalPad)
                    Text("%")
                }
                
                TextField("Loan Term (Months)", text: $term)
                    .keyboardType(.numberPad)
            }
            
            Section {
                Button("Calculate") {
                    calculate()
                }
            }
            
            if let res = result {
                Section {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Monthly Payment")
                            .font(.subheadline)
                        Text(formatCurrency(res.monthlyPayment))
                            .font(.system(size: 36, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                
                Section {
                    HStack {
                        Text("Total Interest")
                        Spacer()
                        Text(formatCurrency(res.totalInterest))
                            .fontWeight(.semibold)
                    }
                    HStack {
                        Text("Total Cost")
                        Spacer()
                        Text(formatCurrency(res.totalCost))
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .navigationTitle("Loan Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func calculate() {
        guard let amountVal = Double(amount),
              let rateVal = Double(rate),
              let termVal = Int(term) else {
            return
        }
        result = calculator.calculate(principal: amountVal, annualRate: rateVal, termMonths: termVal)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}

struct LoanCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoanCalculatorView()
        }
    }
}
