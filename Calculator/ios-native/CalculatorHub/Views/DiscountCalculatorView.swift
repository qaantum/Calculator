import SwiftUI

struct DiscountCalculatorView: View {
    @State private var originalPrice = ""
    @State private var discountPercent = ""
    @State private var result: DiscountResult?
    
    private let calculator = DiscountCalculator()
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("$")
                    TextField("Original Price", text: $originalPrice)
                        .keyboardType(.decimalPad)
                        .onChange(of: originalPrice) { _ in calculate() }
                }
                
                HStack {
                    TextField("Discount (%)", text: $discountPercent)
                        .keyboardType(.decimalPad)
                        .onChange(of: discountPercent) { _ in calculate() }
                    Text("%")
                }
            }
            
            if let res = result {
                Section {
                    VStack(alignment: .center, spacing: 16) {
                        VStack(spacing: 4) {
                            Text("You Save")
                                .font(.subheadline)
                            Text(formatCurrency(res.savedAmount))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        
                        Divider()
                        
                        VStack(spacing: 4) {
                            Text("Final Price")
                                .font(.subheadline)
                            Text(formatCurrency(res.finalPrice))
                                .font(.system(size: 36, weight: .bold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
        }
        .navigationTitle("Discount Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func calculate() {
        guard let price = Double(originalPrice),
              let discount = Double(discountPercent) else {
            result = nil
            return
        }
        result = calculator.calculate(originalPrice: price, discountPercentage: discount)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}

struct DiscountCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DiscountCalculatorView()
        }
    }
}
