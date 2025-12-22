import Foundation

class StandardCalculator: ObservableObject {
    @Published var input: String = "0"
    @Published var result: String = ""
    @Published var expression: String = ""

    func onButtonPressed(_ buttonText: String) {
        switch buttonText {
        case "C":
            input = "0"
            result = ""
            expression = ""
        case "⌫":
            if input.count > 1 {
                input = String(input.dropLast())
            } else {
                input = "0"
            }
        case "=":
            calculate()
        default:
            if input == "0" && !isOperator(buttonText) {
                input = buttonText
            } else {
                input += buttonText
            }
        }
    }

    private func isOperator(_ x: String) -> Bool {
        return x == "/" || x == "*" || x == "-" || x == "+"
    }

    private func calculate() {
        do {
            var finalInput = input
            finalInput = finalInput.replacingOccurrences(of: "×", with: "*")
            finalInput = finalInput.replacingOccurrences(of: "÷", with: "/")

            let result = try evaluateExpression(finalInput)
            expression = input

            // Remove decimal if integer
            if result.truncatingRemainder(dividingBy: 1) == 0 {
                self.result = String(Int(result))
                input = self.result
            } else {
                self.result = String(result)
                input = self.result
            }
        } catch {
            result = "Error"
        }
    }

    private func evaluateExpression(_ expression: String) throws -> Double {
        let tokens = tokenize(expression)
        let postfix = try infixToPostfix(tokens)
        return try evaluatePostfix(postfix)
    }

    private func tokenize(_ expression: String) -> [String] {
        var tokens: [String] = []
        var i = expression.startIndex

        while i < expression.endIndex {
            if expression[i].isNumber || expression[i] == "." {
                var token = ""
                while i < expression.endIndex && (expression[i].isNumber || expression[i] == ".") {
                    token.append(expression[i])
                    i = expression.index(after: i)
                }
                tokens.append(token)
                if i < expression.endIndex {
                    i = expression.index(before: i)
                }
            } else if "+-*/".contains(expression[i]) {
                tokens.append(String(expression[i]))
            }
            i = expression.index(after: i)
        }
        return tokens
    }

    private func infixToPostfix(_ tokens: [String]) throws -> [String] {
        var output: [String] = []
        var operators: [String] = []

        for token in tokens {
            if Double(token) != nil {
                output.append(token)
            } else if token == "(" {
                operators.append(token)
            } else if token == ")" {
                while !operators.isEmpty && operators.last != "(" {
                    output.append(operators.removeLast())
                }
                if operators.isEmpty {
                    throw NSError(domain: "Invalid expression", code: 1)
                }
                operators.removeLast()
            } else {
                while !operators.isEmpty && precedence(operators.last!) >= precedence(token) {
                    output.append(operators.removeLast())
                }
                operators.append(token)
            }
        }

        while !operators.isEmpty {
            output.append(operators.removeLast())
        }

        return output
    }

    private func precedence(_ op: String) -> Int {
        switch op {
        case "+", "-": return 1
        case "*", "/": return 2
        default: return 0
        }
    }

    private func evaluatePostfix(_ postfix: [String]) throws -> Double {
        var stack: [Double] = []

        for token in postfix {
            if let number = Double(token) {
                stack.append(number)
            } else {
                guard stack.count >= 2 else {
                    throw NSError(domain: "Invalid expression", code: 1)
                }
                let b = stack.removeLast()
                let a = stack.removeLast()

                switch token {
                case "+": stack.append(a + b)
                case "-": stack.append(a - b)
                case "*": stack.append(a * b)
                case "/":
                    guard b != 0 else {
                        throw NSError(domain: "Division by zero", code: 1)
                    }
                    stack.append(a / b)
                default: throw NSError(domain: "Unknown operator", code: 1)
                }
            }
        }

        guard stack.count == 1 else {
            throw NSError(domain: "Invalid expression", code: 1)
        }

        return stack[0]
    }
}

