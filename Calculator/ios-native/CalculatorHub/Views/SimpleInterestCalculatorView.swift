import SwiftUI

struct SimpleInterestCalculatorView: View {
    @State private var principal = ""
    @State private var rate = ""
    @State private var time = ""
    @State private var result: SimpleInterestResult?
    
    private let calculator = SimpleInterestCalculator()
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("$")
                    TextField("Principal Amount", text: $principal)
                        .keyboardType(.decimalPad)
                }
                
                HStack {
                    TextField("Annual Interest Rate", text: $rate)
                        .keyboardType(.decimalPad)
                    Text("%")
                }
                
                TextField("Time Period (Years)", text: $time)
                    .keyboardType(.decimalPad)
            }
            
            Section {
                Button("Calculate") {
                    calculate()
                }
            }
            
            if let res = result {
                Section {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Total Amount")
                            .font(.subheadline)
                        Text(formatCurrency(res.totalAmount))
                            .font(.system(size: 36, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                
                Section {
                    HStack {
                        Text("Total Interest Earned")
                        Spacer()
                        Text(formatCurrency(res.interest))
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .navigationTitle("Simple Interest")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func calculate() {
        guard let principalVal = Double(principal),
              let rateVal = Double(rate),
              let timeVal = Double(time) else {
            return
        }
        result = calculator.calculate(principal: principalVal, annualRate: rateVal, timeYears: timeVal)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}

struct SimpleInterestCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SimpleInterestCalculatorView()
        }
    }
}
