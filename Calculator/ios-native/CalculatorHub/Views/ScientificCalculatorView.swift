import SwiftUI

struct ScientificCalculatorView: View {
    @StateObject private var calculator = ScientificCalculator()
    
    let buttons: [[String]] = [
        ["C", "(", ")", "⌫"],
        ["sin", "cos", "tan", "^"],
        ["ln", "log", "sqrt", "/"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["π", "0", ".", "="]
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Display area
            VStack(alignment: .trailing, spacing: 8) {
                Text(calculator.input)
                    .font(.system(size: 48, weight: .bold))
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(24)
            .frame(height: 200)
            
            Divider()
            
            // Button grid
            VStack(spacing: 12) {
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            CalculatorButton(
                                text: button,
                                action: { calculator.onButtonPressed(button) }
                            )
                        }
                    }
                }
            }
            .padding(16)
        }
        .navigationTitle("Scientific Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ScientificCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScientificCalculatorView()
        }
    }
}

