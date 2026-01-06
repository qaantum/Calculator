import Foundation

// NEW MATH CALCULATORS

// Logarithm Calculator
struct LogarithmResult { let result: Double; let formula: String }
class LogarithmCalculator {
    func naturalLog(_ value: Double) -> LogarithmResult { LogarithmResult(result: log(value), formula: "ln(\(value))") }
    func commonLog(_ value: Double) -> LogarithmResult { LogarithmResult(result: log10(value), formula: "log₁₀(\(value))") }
    func binaryLog(_ value: Double) -> LogarithmResult { LogarithmResult(result: log2(value), formula: "log₂(\(value))") }
    func customLog(_ value: Double, base: Double) -> LogarithmResult { LogarithmResult(result: log(value) / log(base), formula: "log\(Int(base))(\(value))") }
}

// Statistics Calculator
struct StatisticsResult { let mean, median: Double; let mode: [Double]?; let range: Double; let count: Int }
class StatisticsCalculator {
    func calculate(_ numbers: [Double]) -> StatisticsResult {
        guard !numbers.isEmpty else { return StatisticsResult(mean: 0, median: 0, mode: nil, range: 0, count: 0) }
        let sorted = numbers.sorted(); let count = numbers.count
        let mean = numbers.reduce(0, +) / Double(count)
        let median = count % 2 == 0 ? (sorted[count/2 - 1] + sorted[count/2]) / 2 : sorted[count/2]
        var freq: [Double: Int] = [:]; numbers.forEach { freq[$0, default: 0] += 1 }
        let maxFreq = freq.values.max() ?? 0
        let mode = maxFreq > 1 ? freq.filter { $0.value == maxFreq }.keys.sorted() : nil
        return StatisticsResult(mean: mean, median: median, mode: mode, range: sorted.last! - sorted.first!, count: count)
    }
}

// Summation Calculator
struct SummationResult { let sum, nthTerm: Double; let terms: [Double] }
class SummationCalculator {
    func arithmetic(firstTerm: Double, commonDiff: Double, numTerms: Int) -> SummationResult {
        let nthTerm = firstTerm + Double(numTerms - 1) * commonDiff
        let sum = Double(numTerms) / 2.0 * (2 * firstTerm + Double(numTerms - 1) * commonDiff)
        let terms = (0..<min(numTerms, 10)).map { firstTerm + Double($0) * commonDiff }
        return SummationResult(sum: sum, nthTerm: nthTerm, terms: terms)
    }
    func geometric(firstTerm: Double, commonRatio: Double, numTerms: Int) -> SummationResult {
        let nthTerm = firstTerm * pow(commonRatio, Double(numTerms - 1))
        let sum = commonRatio == 1 ? firstTerm * Double(numTerms) : firstTerm * (1 - pow(commonRatio, Double(numTerms))) / (1 - commonRatio)
        let terms = (0..<min(numTerms, 10)).map { firstTerm * pow(commonRatio, Double($0)) }
        return SummationResult(sum: sum, nthTerm: nthTerm, terms: terms)
    }
}
