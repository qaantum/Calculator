import SwiftUI

struct ROICalculatorView: View {
    @State private var investment = ""
    @State private var finalValue = ""
    @State private var result: ROIResult?
    @State private var showCustomizeAlert = false
    @State private var showCustomizeSheet = false
    
    private let calculator = ROICalculator()
    private let service = CustomCalculatorService()
    
    var body: some View {
        Form {
            Section {
                HStack { Text("$"); TextField("Initial Investment", text: $investment).keyboardType(.decimalPad).onChange(of: investment) { _ in calculate() } }
                HStack { Text("$"); TextField("Final Value", text: $finalValue).keyboardType(.decimalPad).onChange(of: finalValue) { _ in calculate() } }
            }
            
            if let res = result {
                Section {
                    VStack(spacing: 16) {
                        VStack(spacing: 4) {
                            Text("Total Return").font(.subheadline)
                            Text(formatCurrency(res.returnAmount))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(res.returnAmount >= 0 ? .green : .red)
                        }
                        VStack(spacing: 4) {
                            Text("ROI").font(.subheadline)
                            Text(String(format: "%.2f%%", res.roiPercentage))
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.blue)
                        }
                    }.frame(maxWidth: .infinity).padding()
                }
            }
        }
        .navigationTitle("ROI Calculator")
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
                if let forked = ForkCalculator.createFork("/finance/roi") {
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
        guard let i = Double(investment), let f = Double(finalValue) else { result = nil; return }
        result = calculator.calculate(initialInvestment: i, finalValue: f)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter(); formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}
