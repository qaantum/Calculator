import Foundation

// MARK: - Data Models

enum VariableType: Int, Codable {
    case number = 0
    case integer = 1
    case date = 2
}

struct CalculatorVariable: Codable, Identifiable {
    var id: String { name }
    let name: String
    var defaultValue: String = "0"
    var description: String?
    var unitLabel: String?
    var min: Double?
    var max: Double?
    var type: VariableType = .number
}

struct CustomCalculator: Codable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var iconName: String = "function"
    var inputs: [CalculatorVariable]
    var formula: String
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    var pinned: Bool = false
    var version: Int = 1
    var sourceRoute: String? = nil // If forked from existing calculator
}

// MARK: - Enhanced Math Engine

enum MathResult {
    case success(Double)
    case error(String)
}

class MathEngine {
    
    // Supported functions documentation
    static let supportedFunctions = [
        "Basic: +, -, *, /, ^, (, )",
        "Trigonometry: sin, cos, tan, asin, acos, atan",
        "Hyperbolic: sinh, cosh, tanh",
        "Logarithmic: ln, log(x), log(x, base)",
        "Exponential: exp, sqrt, cbrt, root(x, n)",
        "Rounding: abs, ceil, floor, round",
        "Statistical: min(a,b), max(a,b)",
        "Calculus: deriv(expr, var, point), integrate(expr, var, a, b)",
        "Date: daysBetween(t1, t2), age(birthdate)",
        "Constants: pi, e, phi (golden ratio)"
    ]
    
    static func evaluate(formula: String, variables: [String: Double]) -> MathResult {
        guard !formula.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .error("Formula is empty")
        }
        guard formula.count <= 2000 else {
            return .error("Formula too long")
        }
        
        var processedFormula = formula.trimmingCharacters(in: .whitespaces).lowercased()
        
        // Pre-process all custom functions
        processedFormula = processAdvancedFunctions(processedFormula, variables: variables)
        
        // Replace constants
        processedFormula = processedFormula.replacingOccurrences(of: "phi", with: "1.6180339887")
        processedFormula = processedFormula.replacingOccurrences(of: "(?<![a-zA-Z])pi(?![a-zA-Z])", with: String(Double.pi), options: .regularExpression)
        processedFormula = processedFormula.replacingOccurrences(of: "(?<![a-zA-Z])e(?![a-zA-Z])", with: String(M_E), options: .regularExpression)
        
        // Replace variables (longest names first)
        for key in variables.keys.sorted(by: { $0.count > $1.count }) {
            processedFormula = processedFormula.replacingOccurrences(of: key.lowercased(), with: String(variables[key]!))
        }
        
        // Evaluate
        do {
            let result = try evaluateExpression(processedFormula)
            if result.isNaN {
                return .error("Result is NaN (undefined)")
            }
            if result.isInfinite {
                return .error("Result is Infinite (division by zero?)")
            }
            return .success(result)
        } catch {
            return .error("Error: \(error.localizedDescription)")
        }
    }
    
    private static func processAdvancedFunctions(_ formula: String, variables: [String: Double]) -> String {
        var result = formula
        
        // ===== CALCULUS =====
        
        // integrate(expression, var, start, end)
        if let regex = try? NSRegularExpression(pattern: #"integrate\(([^,]+),\s*([^,]+),\s*([^,]+),\s*([^)]+)\)"#) {
            while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
                let nsString = result as NSString
                let expr = nsString.substring(with: match.range(at: 1)).trimmingCharacters(in: .whitespaces)
                let varName = nsString.substring(with: match.range(at: 2)).trimmingCharacters(in: .whitespaces)
                let startStr = nsString.substring(with: match.range(at: 3)).trimmingCharacters(in: .whitespaces)
                let endStr = nsString.substring(with: match.range(at: 4)).trimmingCharacters(in: .whitespaces)
                
                let start = evaluateSimple(startStr, variables: variables)
                let end = evaluateSimple(endStr, variables: variables)
                let integral = simpsonsRule(expr: expr, varName: varName, a: start, b: end, variables: variables)
                result = nsString.replacingCharacters(in: match.range, with: String(integral))
            }
        }
        
        // deriv(expression, var, point)
        if let regex = try? NSRegularExpression(pattern: #"deriv\(([^,]+),\s*([^,]+),\s*([^)]+)\)"#) {
            while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
                let nsString = result as NSString
                let expr = nsString.substring(with: match.range(at: 1)).trimmingCharacters(in: .whitespaces)
                let varName = nsString.substring(with: match.range(at: 2)).trimmingCharacters(in: .whitespaces)
                let pointStr = nsString.substring(with: match.range(at: 3)).trimmingCharacters(in: .whitespaces)
                
                let point = evaluateSimple(pointStr, variables: variables)
                let derivative = centralDifference(expr: expr, varName: varName, x: point, variables: variables)
                result = nsString.replacingCharacters(in: match.range, with: String(derivative))
            }
        }
        
        // ===== LOGARITHMIC =====
        
        // log(value, base)
        if let regex = try? NSRegularExpression(pattern: #"log\(([^,]+),\s*([^)]+)\)"#) {
            while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
                let nsString = result as NSString
                let value = evaluateSimple(nsString.substring(with: match.range(at: 1)), variables: variables)
                let base = evaluateSimple(nsString.substring(with: match.range(at: 2)), variables: variables)
                let logResult = value > 0 && base > 0 && base != 1 ? log(value) / log(base) : Double.nan
                result = nsString.replacingCharacters(in: match.range, with: String(logResult))
            }
        }
        
        // log(x) - base 10
        if let regex = try? NSRegularExpression(pattern: #"log\(([^,)]+)\)"#) {
            while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
                let nsString = result as NSString
                let value = evaluateSimple(nsString.substring(with: match.range(at: 1)), variables: variables)
                let logResult = value > 0 ? log10(value) : Double.nan
                result = nsString.replacingCharacters(in: match.range, with: String(logResult))
            }
        }
        
        // ln(x)
        if let regex = try? NSRegularExpression(pattern: #"ln\(([^)]+)\)"#) {
            while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
                let nsString = result as NSString
                let value = evaluateSimple(nsString.substring(with: match.range(at: 1)), variables: variables)
                let logResult = value > 0 ? log(value) : Double.nan
                result = nsString.replacingCharacters(in: match.range, with: String(logResult))
            }
        }
        
        // exp(x)
        if let regex = try? NSRegularExpression(pattern: #"exp\(([^)]+)\)"#) {
            while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
                let nsString = result as NSString
                let value = evaluateSimple(nsString.substring(with: match.range(at: 1)), variables: variables)
                result = nsString.replacingCharacters(in: match.range, with: String(exp(value)))
            }
        }
        
        // ===== ROOT FUNCTIONS =====
        
        // root(value, n)
        if let regex = try? NSRegularExpression(pattern: #"root\(([^,]+),\s*([^)]+)\)"#) {
            while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
                let nsString = result as NSString
                let value = evaluateSimple(nsString.substring(with: match.range(at: 1)), variables: variables)
                let n = evaluateSimple(nsString.substring(with: match.range(at: 2)), variables: variables)
                result = nsString.replacingCharacters(in: match.range, with: String(pow(value, 1.0 / n)))
            }
        }
        
        // sqrt(x)
        if let regex = try? NSRegularExpression(pattern: #"sqrt\(([^)]+)\)"#) {
            while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
                let nsString = result as NSString
                let value = evaluateSimple(nsString.substring(with: match.range(at: 1)), variables: variables)
                let sqrtResult = value >= 0 ? sqrt(value) : Double.nan
                result = nsString.replacingCharacters(in: match.range, with: String(sqrtResult))
            }
        }
        
        // cbrt(x)
        if let regex = try? NSRegularExpression(pattern: #"cbrt\(([^)]+)\)"#) {
            while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
                let nsString = result as NSString
                let value = evaluateSimple(nsString.substring(with: match.range(at: 1)), variables: variables)
                result = nsString.replacingCharacters(in: match.range, with: String(cbrt(value)))
            }
        }
        
        // ===== TRIGONOMETRIC =====
        
        // Inverse trig
        result = replaceSingleArgFunction(result, name: "asin", variables: variables) { asin($0) }
        result = replaceSingleArgFunction(result, name: "acos", variables: variables) { acos($0) }
        result = replaceSingleArgFunction(result, name: "atan", variables: variables) { atan($0) }
        
        // Standard trig
        result = replaceSingleArgFunction(result, name: "sin", variables: variables) { sin($0) }
        result = replaceSingleArgFunction(result, name: "cos", variables: variables) { cos($0) }
        result = replaceSingleArgFunction(result, name: "tan", variables: variables) { tan($0) }
        
        // Hyperbolic
        result = replaceSingleArgFunction(result, name: "sinh", variables: variables) { sinh($0) }
        result = replaceSingleArgFunction(result, name: "cosh", variables: variables) { cosh($0) }
        result = replaceSingleArgFunction(result, name: "tanh", variables: variables) { tanh($0) }
        
        // ===== ROUNDING & ABSOLUTE =====
        
        result = replaceSingleArgFunction(result, name: "abs", variables: variables) { abs($0) }
        result = replaceSingleArgFunction(result, name: "ceil", variables: variables) { ceil($0) }
        result = replaceSingleArgFunction(result, name: "floor", variables: variables) { floor($0) }
        result = replaceSingleArgFunction(result, name: "round", variables: variables) { round($0) }
        
        // ===== STATISTICAL =====
        
        // min(a, b)
        if let regex = try? NSRegularExpression(pattern: #"min\(([^,]+),\s*([^)]+)\)"#) {
            while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
                let nsString = result as NSString
                let a = evaluateSimple(nsString.substring(with: match.range(at: 1)), variables: variables)
                let b = evaluateSimple(nsString.substring(with: match.range(at: 2)), variables: variables)
                result = nsString.replacingCharacters(in: match.range, with: String(Swift.min(a, b)))
            }
        }
        
        // max(a, b)
        if let regex = try? NSRegularExpression(pattern: #"max\(([^,]+),\s*([^)]+)\)"#) {
            while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
                let nsString = result as NSString
                let a = evaluateSimple(nsString.substring(with: match.range(at: 1)), variables: variables)
                let b = evaluateSimple(nsString.substring(with: match.range(at: 2)), variables: variables)
                result = nsString.replacingCharacters(in: match.range, with: String(Swift.max(a, b)))
            }
        }
        
        // ===== DATE FUNCTIONS =====
        
        // daysBetween(t1, t2)
        if let regex = try? NSRegularExpression(pattern: #"daysbetween\(([^,]+),\s*([^)]+)\)"#) {
            while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
                let nsString = result as NSString
                let t1 = evaluateSimple(nsString.substring(with: match.range(at: 1)), variables: variables)
                let t2 = evaluateSimple(nsString.substring(with: match.range(at: 2)), variables: variables)
                result = nsString.replacingCharacters(in: match.range, with: String(abs(t1 - t2) / 86400))
            }
        }
        
        // age(birthdate)
        if let regex = try? NSRegularExpression(pattern: #"age\(([^)]+)\)"#) {
            while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
                let nsString = result as NSString
                let birthdate = evaluateSimple(nsString.substring(with: match.range(at: 1)), variables: variables)
                let now = Date().timeIntervalSince1970
                result = nsString.replacingCharacters(in: match.range, with: String((now - birthdate) / 31557600))
            }
        }
        
        // ===== SPECIAL FUNCTIONS =====
        
        // factorial(n)
        if let regex = try? NSRegularExpression(pattern: #"factorial\(([^)]+)\)"#) {
            while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
                let nsString = result as NSString
                let n = Int(evaluateSimple(nsString.substring(with: match.range(at: 1)), variables: variables))
                let factResult = (n >= 0 && n <= 20) ? String(factorial(n)) : "nan"
                result = nsString.replacingCharacters(in: match.range, with: factResult)
            }
        }
        
        // mod(a, b)
        if let regex = try? NSRegularExpression(pattern: #"mod\(([^,]+),\s*([^)]+)\)"#) {
            while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
                let nsString = result as NSString
                let a = evaluateSimple(nsString.substring(with: match.range(at: 1)), variables: variables)
                let b = evaluateSimple(nsString.substring(with: match.range(at: 2)), variables: variables)
                result = nsString.replacingCharacters(in: match.range, with: String(a.truncatingRemainder(dividingBy: b)))
            }
        }
        
        return result
    }
    
    private static func replaceSingleArgFunction(_ formula: String, name: String, variables: [String: Double], _ operation: (Double) -> Double) -> String {
        var result = formula
        if let regex = try? NSRegularExpression(pattern: "\(name)\\(([^)]+)\\)") {
            while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
                let nsString = result as NSString
                let value = evaluateSimple(nsString.substring(with: match.range(at: 1)), variables: variables)
                result = nsString.replacingCharacters(in: match.range, with: String(operation(value)))
            }
        }
        return result
    }
    
    private static func factorial(_ n: Int) -> Int {
        guard n > 1 else { return 1 }
        return (2...n).reduce(1, *)
    }
    
    private static func simpsonsRule(expr: String, varName: String, a: Double, b: Double, variables: [String: Double]) -> Double {
        let n = 100 // Number of intervals (must be even)
        let h = (b - a) / Double(n)
        
        func f(_ x: Double) -> Double {
            var localVars = variables
            localVars[varName] = x
            return evaluateSimple(expr, variables: localVars)
        }
        
        var sum = f(a) + f(b)
        for i in 1..<n {
            let x = a + Double(i) * h
            sum += (i % 2 == 0 ? 2 : 4) * f(x)
        }
        
        return (h / 3) * sum
    }
    
    private static func centralDifference(expr: String, varName: String, x: Double, variables: [String: Double]) -> Double {
        let h = 1e-5
        
        func f(_ value: Double) -> Double {
            var localVars = variables
            localVars[varName] = value
            return evaluateSimple(expr, variables: localVars)
        }
        
        return (f(x + h) - f(x - h)) / (2 * h)
    }
    
    private static func evaluateSimple(_ expr: String, variables: [String: Double]) -> Double {
        var processedExpr = expr.trimmingCharacters(in: .whitespaces).lowercased()
        processedExpr = processedExpr.replacingOccurrences(of: "phi", with: "1.6180339887")
        processedExpr = processedExpr.replacingOccurrences(of: "pi", with: String(Double.pi))
        for key in variables.keys.sorted(by: { $0.count > $1.count }) {
            processedExpr = processedExpr.replacingOccurrences(of: key.lowercased(), with: String(variables[key]!))
        }
        return (try? evaluateExpression(processedExpr)) ?? 0
    }
    
    private static func evaluateExpression(_ expression: String) throws -> Double {
        var expr = expression.replacingOccurrences(of: " ", with: "")
        
        // Handle ^ operator by converting to pow calls
        while let range = expr.range(of: "([0-9.]+)\\^([0-9.()]+)", options: .regularExpression) {
            let match = String(expr[range])
            if let caret = match.firstIndex(of: "^") {
                let base = String(match[match.startIndex..<caret])
                let exponent = String(match[match.index(after: caret)...])
                let replacement = "pow(\(base), \(exponent))"
                expr = expr.replacingCharacters(in: range, with: replacement)
            } else {
                break
            }
        }
        
        // Handle parenthetical bases: (...)^n
        while let range = expr.range(of: "\\([^)]+\\)\\^([0-9.()]+)", options: .regularExpression) {
            let match = String(expr[range])
            if let caret = match.range(of: "^") {
                let base = String(match[match.startIndex..<caret.lowerBound])
                let exponent = String(match[caret.upperBound...])
                let replacement = "pow(\(base), \(exponent))"
                expr = expr.replacingCharacters(in: range, with: replacement)
            } else {
                break
            }
        }
        
        // Use NSExpression
        let nsExpr = NSExpression(format: expr)
        guard let result = nsExpr.expressionValue(with: nil, context: nil) as? Double else {
            throw NSError(domain: "MathEngine", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not evaluate expression"])
        }
        return result
    }
}

// MARK: - Storage Service

class CustomCalculatorService {
    private let defaults = UserDefaults.standard
    private let calculatorsKey = "custom_calculators"
    private let valuesKeyPrefix = "custom_calculator_values_"
    
    func getCalculators() -> [CustomCalculator] {
        guard let data = defaults.data(forKey: calculatorsKey) else { return [] }
        return (try? JSONDecoder().decode([CustomCalculator].self, from: data)) ?? []
    }
    
    func getById(_ id: String) -> CustomCalculator? {
        return getCalculators().first { $0.id == id }
    }
    
    func saveCalculator(_ calculator: CustomCalculator) {
        var current = getCalculators()
        if let index = current.firstIndex(where: { $0.id == calculator.id }) {
            current[index] = calculator
        } else {
            current.append(calculator)
        }
        if let data = try? JSONEncoder().encode(current) {
            defaults.set(data, forKey: calculatorsKey)
        }
    }
    
    func deleteCalculator(_ id: String) {
        var current = getCalculators()
        current.removeAll { $0.id == id }
        if let data = try? JSONEncoder().encode(current) {
            defaults.set(data, forKey: calculatorsKey)
        }
        defaults.removeObject(forKey: "\(valuesKeyPrefix)\(id)")
    }
    
    func getLastValues(_ id: String) -> [String: Double] {
        guard let data = defaults.data(forKey: "\(valuesKeyPrefix)\(id)") else { return [:] }
        return (try? JSONDecoder().decode([String: Double].self, from: data)) ?? [:]
    }
    
    func saveLastValues(_ id: String, values: [String: Double]) {
        if let data = try? JSONEncoder().encode(values) {
            defaults.set(data, forKey: "\(valuesKeyPrefix)\(id)")
        }
    }
}
