import SwiftUI

struct CompoundInterestCalculatorView: View {
    @State private var principal = ""
    @State private var rate = ""
    @State private var years = ""
    @State private var contribution = "0"
    @State private var frequency = "12"
    @State private var result: CompoundInterestResult?
    @State private var showCustomizeAlert = false
    @State private var showCustomizeSheet = false
    
    private let calculator = CompoundInterestCalculator()
    private let service = CustomCalculatorService()
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var body: some View {
        Form {
            Section {
                TextField("Initial Investment", text: $principal)
                    .keyboardType(.decimalPad)
                
                TextField("Annual Interest Rate (%)", text: $rate)
                    .keyboardType(.decimalPad)
                
                TextField("Time Period (Years)", text: $years)
                    .keyboardType(.decimalPad)
                
                TextField("Monthly Contribution (Optional)", text: $contribution)
                    .keyboardType(.decimalPad)
                
                TextField("Compounds Per Year", text: $frequency)
                    .keyboardType(.numberPad)
            }
            
            Section {
                Button("Calculate") {
                    calculate()
                }
            }
            
            if let result = result {
                Section("Results") {
                    ResultRow(label: "Future Value", value: currencyFormatter.string(from: NSNumber(value: result.futureValue)) ?? "")
                    ResultRow(label: "Total Contributions", value: currencyFormatter.string(from: NSNumber(value: result.totalContributions)) ?? "")
                    ResultRow(label: "Total Interest", value: currencyFormatter.string(from: NSNumber(value: result.totalInterest)) ?? "")
                }
            }
        }
        .navigationTitle("Compound Interest")
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
                if let forked = ForkCalculator.createFork("/finance/interest/compound") {
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
        guard let principalValue = Double(principal),
              let rateValue = Double(rate),
              let yearsValue = Double(years) else {
            return
        }
        
        let contributionValue = Double(contribution) ?? 0.0
        let frequencyValue = Double(frequency) ?? 12.0
        
        self.result = calculator.calculate(
            principal: principalValue,
            annualRate: rateValue,
            years: yearsValue,
            contribution: contributionValue,
            compoundsPerYear: frequencyValue
        )
    }
}

struct ResultRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .fontWeight(.bold)
        }
    }
}

struct CompoundInterestCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CompoundInterestCalculatorView()
        }
    }
}

