import SwiftUI

struct CAGRCalculatorView: View {
    @State private var startValue = ""
    @State private var endValue = ""
    @State private var years = ""
    @State private var result: CAGRResult?
    
    private let calculator = CAGRCalculator()
    
    var body: some View {
        Form {
            Section {
                HStack { Text("$"); TextField("Beginning Value", text: $startValue).keyboardType(.decimalPad).onChange(of: startValue) { _ in calculate() } }
                HStack { Text("$"); TextField("Ending Value", text: $endValue).keyboardType(.decimalPad).onChange(of: endValue) { _ in calculate() } }
                TextField("Number of Years", text: $years).keyboardType(.decimalPad).onChange(of: years) { _ in calculate() }
            }
            
            Section(footer: Text("Results update automatically")) {
                HStack {
                    Text("CAGR").font(.headline)
                    Spacer()
                    Text(result.map { String(format: "%.2f%%", $0.cagr) } ?? "---")
                        .font(.title2).fontWeight(.bold)
                }
                HStack {
                    Text("Total Growth")
                    Spacer()
                    Text(result.map { String(format: "%.2f%%", $0.totalGrowth) } ?? "---")
                        .font(.title2)
                }
            }
        }
        .navigationTitle("CAGR Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func calculate() {
        guard let s = Double(startValue), let e = Double(endValue), let y = Double(years) else { result = nil; return }
        result = calculator.calculate(startValue: s, endValue: e, years: y)
    }
}
