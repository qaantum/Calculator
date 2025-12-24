import SwiftUI

struct TipCalculatorView: View {
    @State private var billAmount = ""
    @State private var tipPercentage = 15.0
    @State private var splitCount = 1.0
    @State private var result: TipResult?
    @State private var showCustomizeAlert = false
    @State private var showCustomizeSheet = false
    
    private let calculator = TipCalculator()
    private let service = CustomCalculatorService()
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("$")
                    TextField("Bill Amount", text: $billAmount)
                        .keyboardType(.decimalPad)
                        .onChange(of: billAmount) { _ in calculate() }
                }
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Tip Percentage: \(Int(tipPercentage))%")
                        .font(.headline)
                    Slider(value: $tipPercentage, in: 0...50, step: 1)
                        .onChange(of: tipPercentage) { _ in calculate() }
                }
                
                VStack(alignment: .leading) {
                    Text("Split: \(Int(splitCount)) Person\(splitCount > 1 ? "s" : "")")
                        .font(.headline)
                    Slider(value: $splitCount, in: 1...20, step: 1)
                        .onChange(of: splitCount) { _ in calculate() }
                }
            }
            
            if let res = result {
                Section {
                    VStack(spacing: 16) {
                        TipResultRow(label: "Tip Amount", value: res.tipAmount)
                        Divider()
                        TipResultRow(label: "Total Bill", value: res.totalBill)
                        Divider()
                        TipResultRow(label: "Per Person", value: res.amountPerPerson, isBold: true)
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle("Tip Calculator")
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
                if let forked = ForkCalculator.createFork("/finance/tip") {
                    service.saveCalculator(forked)
                    showCustomizeSheet = true
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Create your own version of the Tip Calculator with custom variables and formulas.")
        }
        .sheet(isPresented: $showCustomizeSheet) {
            CustomCalculatorListView()
        }
    }
    
    private func calculate() {
        guard let bill = Double(billAmount) else {
            result = nil
            return
        }
        result = calculator.calculate(billAmount: bill, tipPercentage: tipPercentage, splitCount: Int(splitCount))
    }
}

struct TipResultRow: View {
    let label: String
    let value: Double
    var isBold: Bool = false
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
            Spacer()
            Text(formatCurrency(value))
                .font(.title2)
                .fontWeight(isBold ? .bold : .regular)
        }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}

struct TipCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TipCalculatorView()
        }
    }
}
