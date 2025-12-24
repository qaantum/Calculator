import SwiftUI

struct MortgageCalculatorView: View {
    @State private var principal = ""
    @State private var rate = ""
    @State private var term = "30"
    @State private var tax = "0"
    @State private var insurance = "0"
    @State private var hoa = "0"
    @State private var result: MortgageResult?
    @State private var showCustomizeAlert = false
    @State private var showCustomizeSheet = false
    
    private let calculator = MortgageCalculator()
    private let service = CustomCalculatorService()
    
    var body: some View {
        Form {
            Section(header: Text("Loan Details")) {
                HStack {
                    Text("$")
                    TextField("Loan Amount", text: $principal)
                        .keyboardType(.decimalPad)
                }
                
                HStack {
                    TextField("Interest Rate", text: $rate)
                        .keyboardType(.decimalPad)
                    Text("%")
                }
                
                TextField("Term (Years)", text: $term)
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("Optional Expenses")) {
                HStack {
                    Text("$")
                    TextField("Property Tax / Year", text: $tax)
                        .keyboardType(.decimalPad)
                }
                
                HStack {
                    Text("$")
                    TextField("Insurance / Year", text: $insurance)
                        .keyboardType(.decimalPad)
                }
                
                HStack {
                    Text("$")
                    TextField("HOA Fees / Month", text: $hoa)
                        .keyboardType(.decimalPad)
                }
            }
            
            Section {
                Button("Calculate Payment") {
                    calculate()
                }
            }
            
            if let res = result {
                Section {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Total Monthly Payment")
                            .font(.subheadline)
                        Text(formatCurrency(res.totalMonthlyPayment))
                            .font(.system(size: 36, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                
                Section(header: Text("Breakdown")) {
                    MortgageResultRow(label: "Principal & Interest", value: res.monthlyPrincipalAndInterest)
                    MortgageResultRow(label: "Property Tax", value: res.monthlyTax)
                    MortgageResultRow(label: "Home Insurance", value: res.monthlyInsurance)
                    MortgageResultRow(label: "HOA Fees", value: res.monthlyHOA)
                }
            }
        }
        .navigationTitle("Mortgage Calculator")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showCustomizeAlert = true
                } label: {
                    Image(systemName: "wrench.and.screwdriver")
                }
            }
        }
        .alert("Customize This Calculator", isPresented: $showCustomizeAlert) {
            Button("Create My Version") {
                if let forked = ForkCalculator.createFork("/finance/mortgage") {
                    service.saveCalculator(forked)
                    showCustomizeSheet = true
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Create your own version with custom variables and formulas.")
        }
        .sheet(isPresented: $showCustomizeSheet) {
            CustomCalculatorListView()
        }
    }
    
    private func calculate() {
        guard let principalVal = Double(principal),
              let rateVal = Double(rate),
              let termVal = Int(term) else {
            return
        }
        let taxVal = Double(tax) ?? 0.0
        let insuranceVal = Double(insurance) ?? 0.0
        let hoaVal = Double(hoa) ?? 0.0
        
        result = calculator.calculate(
            principal: principalVal,
            annualRate: rateVal,
            termYears: termVal,
            annualPropertyTax: taxVal,
            annualInsurance: insuranceVal,
            monthlyHOA: hoaVal
        )
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}

struct MortgageResultRow: View {
    let label: String
    let value: Double
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(formatCurrency(value))
                .fontWeight(.semibold)
        }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}

struct MortgageCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MortgageCalculatorView()
        }
    }
}
