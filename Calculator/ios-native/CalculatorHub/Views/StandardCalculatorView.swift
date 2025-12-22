import SwiftUI

struct StandardCalculatorView: View {
    @StateObject private var calculator = StandardCalculator()

    let buttons: [[String]] = [
        ["C", "⌫", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["%", "0", ".", "="]
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Display area
            VStack(alignment: .trailing, spacing: 8) {
                if !calculator.expression.isEmpty {
                    Text(calculator.expression)
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                Text(calculator.input)
                    .font(.system(size: 64, weight: .bold))
                    .lineLimit(1)
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
        .navigationTitle("Standard Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CalculatorButton: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(buttonColor)
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(backgroundColor)
                .cornerRadius(12)
        }
    }

    private var backgroundColor: Color {
        switch text {
        case "C", "⌫", "%":
            return Color.secondary.opacity(0.2)
        case "÷", "×", "-", "+", "=":
            return Color.blue
        default:
            return Color.gray.opacity(0.2)
        }
    }

    private var buttonColor: Color {
        switch text {
        case "÷", "×", "-", "+", "=":
            return .white
        default:
            return .primary
        }
    }
}

struct StandardCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StandardCalculatorView()
        }
    }
}

