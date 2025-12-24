import SwiftUI

struct PercentageCalculatorView: View {
    @State private var c1x = "", c1y = "", c1r = ""
    @State private var c2x = "", c2y = "", c2r = ""
    @State private var c3x = "", c3y = "", c3r = ""
    private let calc = PercentageCalculator()
    
    var body: some View {
        Form {
            Section(header: Text("What is X% of Y?")) {
                HStack { TextField("X (%)", text: $c1x).keyboardType(.decimalPad).onChange(of: c1x) { _ in calc1() }; TextField("Y", text: $c1y).keyboardType(.decimalPad).onChange(of: c1y) { _ in calc1() } }
                if !c1r.isEmpty { Text(c1r).font(.title2).bold().foregroundColor(.blue).frame(maxWidth: .infinity, alignment: .trailing) }
            }
            Section(header: Text("X is what % of Y?")) {
                HStack { TextField("X", text: $c2x).keyboardType(.decimalPad).onChange(of: c2x) { _ in calc2() }; TextField("Y (Total)", text: $c2y).keyboardType(.decimalPad).onChange(of: c2y) { _ in calc2() } }
                if !c2r.isEmpty { Text(c2r).font(.title2).bold().foregroundColor(.blue).frame(maxWidth: .infinity, alignment: .trailing) }
            }
            Section(header: Text("Percentage Change")) {
                HStack { TextField("From", text: $c3x).keyboardType(.decimalPad).onChange(of: c3x) { _ in calc3() }; TextField("To", text: $c3y).keyboardType(.decimalPad).onChange(of: c3y) { _ in calc3() } }
                if !c3r.isEmpty { Text(c3r).font(.title2).bold().foregroundColor(c3r.hasPrefix("-") ? .red : .green).frame(maxWidth: .infinity, alignment: .trailing) }
            }
        }.navigationTitle("Percentage").navigationBarTitleDisplayMode(.inline)
    }
    private func calc1() { guard let x = Double(c1x), let y = Double(c1y) else { return }; c1r = String(format: "%.2f", calc.whatIsXPercentOfY(x: x, y: y)) }
    private func calc2() { guard let x = Double(c2x), let y = Double(c2y) else { return }; c2r = String(format: "%.2f%%", calc.xIsWhatPercentOfY(x: x, y: y)) }
    private func calc3() { guard let x = Double(c3x), let y = Double(c3y) else { return }; c3r = String(format: "%+.2f%%", calc.percentageChange(from: x, to: y)) }
}

struct QuadraticSolverView: View {
    @State private var a = "", b = "", c = "", result = "---"
    private let solver = QuadraticSolver()
    var body: some View {
        Form {
            Section(footer: Text("Solves ax² + bx + c = 0")) {
                HStack { TextField("a", text: $a).keyboardType(.decimalPad).onChange(of: a) { _ in calc() }; TextField("b", text: $b).keyboardType(.decimalPad).onChange(of: b) { _ in calc() }; TextField("c", text: $c).keyboardType(.decimalPad).onChange(of: c) { _ in calc() } }
            }
            Section { VStack { Text("Roots").font(.subheadline); Text(result).font(.title2).bold() }.frame(maxWidth: .infinity).padding() }
        }.navigationTitle("Quadratic Solver").navigationBarTitleDisplayMode(.inline)
    }
    private func calc() {
        guard let aV = Double(a), let bV = Double(b), let cV = Double(c) else { return }
        switch solver.solve(a: aV, b: bV, c: cV) {
        case .twoRealRoots(let x1, let x2): result = "x₁ = \(String(format: "%.4f", x1))\nx₂ = \(String(format: "%.4f", x2))"
        case .oneRealRoot(let x): result = "x = \(String(format: "%.4f", x))"
        case .complexRoots(let r, let i): result = "x₁ = \(String(format: "%.2f", r)) + \(String(format: "%.2f", i))i\nx₂ = \(String(format: "%.2f", r)) - \(String(format: "%.2f", i))i"
        case .notQuadratic: result = "Not quadratic (a=0)"
        }
    }
}

struct GcdLcmCalculatorView: View {
    @State private var a = "", b = "", gcd = "---", lcm = "---"
    private let calc = GcdLcmCalculator()
    var body: some View {
        Form {
            HStack { TextField("Number A", text: $a).keyboardType(.numberPad).onChange(of: a) { _ in calculate() }; TextField("Number B", text: $b).keyboardType(.numberPad).onChange(of: b) { _ in calculate() } }
            Section { HStack { Text("GCD"); Spacer(); Text(gcd).font(.title).bold() }; HStack { Text("LCM"); Spacer(); Text(lcm).font(.title).bold() } }
        }.navigationTitle("GCD / LCM").navigationBarTitleDisplayMode(.inline)
    }
    private func calculate() { guard let aV = Int(a), let bV = Int(b) else { return }; let r = calc.calculate(aV, bV); gcd = "\(r.gcd)"; lcm = "\(r.lcm)" }
}

struct FactorialCalculatorView: View {
    @State private var n = "", result = "---"
    private let calc = FactorialCalculator()
    var body: some View {
        Form {
            TextField("Enter n", text: $n).keyboardType(.numberPad).onChange(of: n) { _ in result = calc.calculate(Int(n) ?? 0) }
            Section { VStack { Text("n! =").font(.subheadline); Text(result).font(.title).bold() }.frame(maxWidth: .infinity).padding() }
        }.navigationTitle("Factorial").navigationBarTitleDisplayMode(.inline)
    }
}

struct RandomNumberView: View {
    @State private var min = "1", max = "100", count = "1", results = ""
    private let gen = RandomNumberGenerator()
    var body: some View {
        Form {
            HStack { TextField("Min", text: $min).keyboardType(.numberPad); TextField("Max", text: $max).keyboardType(.numberPad); TextField("Count", text: $count).keyboardType(.numberPad) }
            Button("Generate") { results = gen.generate(min: Int(min) ?? 1, max: Int(max) ?? 100, count: Int(count) ?? 1).map(String.init).joined(separator: ", ") }
            if !results.isEmpty { Section { Text(results).font(.title2).bold() } }
        }.navigationTitle("Random Number").navigationBarTitleDisplayMode(.inline)
    }
}
