import Foundation

// Percentage Calculator
struct PercentageResult { let value: Double }
class PercentageCalculator {
    func whatIsXPercentOfY(x: Double, y: Double) -> Double { (x / 100) * y }
    func xIsWhatPercentOfY(x: Double, y: Double) -> Double { y != 0 ? (x / y) * 100 : 0 }
    func percentageChange(from: Double, to: Double) -> Double { from != 0 ? ((to - from) / from) * 100 : 0 }
}

// Quadratic Solver
enum QuadraticResult {
    case twoRealRoots(x1: Double, x2: Double)
    case oneRealRoot(x: Double)
    case complexRoots(real: Double, imaginary: Double)
    case notQuadratic
}
class QuadraticSolver {
    func solve(a: Double, b: Double, c: Double) -> QuadraticResult {
        guard a != 0 else { return .notQuadratic }
        let d = b * b - 4 * a * c
        if d > 0 { return .twoRealRoots(x1: (-b + sqrt(d)) / (2 * a), x2: (-b - sqrt(d)) / (2 * a)) }
        if d == 0 { return .oneRealRoot(x: -b / (2 * a)) }
        return .complexRoots(real: -b / (2 * a), imaginary: sqrt(-d) / (2 * a))
    }
}

// GCD/LCM Calculator
struct GcdLcmResult { let gcd: Int; let lcm: Int }
class GcdLcmCalculator {
    private func gcd(_ a: Int, _ b: Int) -> Int { b == 0 ? abs(a) : gcd(b, a % b) }
    func calculate(_ a: Int, _ b: Int) -> GcdLcmResult {
        let g = gcd(a, b)
        let l = g != 0 ? abs(a * b) / g : 0
        return GcdLcmResult(gcd: g, lcm: l)
    }
}

// Factorial Calculator
class FactorialCalculator {
    func calculate(_ n: Int) -> String {
        guard n >= 0 else { return "Error" }
        guard n <= 170 else { return "Too large" }
        var result: Double = 1
        for i in 2...max(n, 1) { result *= Double(i) }
        return n <= 20 ? String(Int(result)) : String(format: "%.4e", result)
    }
}

// Fibonacci Generator
class FibonacciGenerator {
    func generate(count: Int) -> [Int] {
        guard count > 0 else { return [] }
        var seq = [0, 1]
        for i in 2..<count { seq.append(seq[i-1] + seq[i-2]) }
        return Array(seq.prefix(count))
    }
}

// Prime Factorization
class PrimeFactorizationCalculator {
    func factorize(_ n: Int) -> [Int] {
        guard n > 1 else { return [] }
        var factors: [Int] = []; var num = n; var d = 2
        while d * d <= num { while num % d == 0 { factors.append(d); num /= d }; d += 1 }
        if num > 1 { factors.append(num) }
        return factors
    }
}

// Random Number Generator
class RandomNumberGenerator {
    func generate(min: Int, max: Int, count: Int = 1) -> [Int] {
        guard min <= max else { return [] }
        return (0..<count).map { _ in Int.random(in: min...max) }
    }
}
