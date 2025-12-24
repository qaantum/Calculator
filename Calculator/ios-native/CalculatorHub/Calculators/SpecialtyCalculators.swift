import Foundation
import CryptoKit

// Binary Converter
class BinaryConverter {
    func decimalToBinary(_ decimal: Int) -> String { String(decimal, radix: 2) }
    func binaryToDecimal(_ binary: String) -> Int { Int(binary, radix: 2) ?? 0 }
    func decimalToHex(_ decimal: Int) -> String { String(decimal, radix: 16).uppercased() }
    func hexToDecimal(_ hex: String) -> Int { Int(hex, radix: 16) ?? 0 }
    func decimalToOctal(_ decimal: Int) -> String { String(decimal, radix: 8) }
    func octalToDecimal(_ octal: String) -> Int { Int(octal, radix: 8) ?? 0 }
    func binaryToHex(_ binary: String) -> String { decimalToHex(binaryToDecimal(binary)) }
    func hexToBinary(_ hex: String) -> String { decimalToBinary(hexToDecimal(hex)) }
}

// Roman Numeral Converter
class RomanNumeralConverter {
    private let romanMap: [(Int, String)] = [
        (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"),
        (100, "C"), (90, "XC"), (50, "L"), (40, "XL"),
        (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")
    ]
    
    func toRoman(_ num: Int) -> String {
        guard num > 0, num <= 3999 else { return "Invalid (1-3999)" }
        var n = num; var result = ""
        for (value, symbol) in romanMap {
            while n >= value { result += symbol; n -= value }
        }
        return result
    }
    
    func fromRoman(_ roman: String) -> Int {
        let romanValues: [Character: Int] = ["I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000]
        var result = 0; var prevValue = 0
        for c in roman.uppercased().reversed() {
            let value = romanValues[c] ?? 0
            result += value < prevValue ? -value : value
            prevValue = value
        }
        return result
    }
}

// Hash Generator
class HashGenerator {
    func md5Hash(_ input: String) -> String {
        let data = Data(input.utf8)
        let hash = Insecure.MD5.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    func sha256Hash(_ input: String) -> String {
        let data = Data(input.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

// Grade Calculator
struct GradeResult { let average: Double; let letterGrade: String; let gpa: Double }
class GradeCalculator {
    func calculate(grades: [Double], weights: [Double]? = nil) -> GradeResult {
        var avg: Double
        if let w = weights, w.count == grades.count {
            avg = zip(grades, w).reduce(0) { $0 + $1.0 * $1.1 } / w.reduce(0, +)
        } else {
            avg = grades.reduce(0, +) / Double(grades.count)
        }
        let letter: String
        switch avg {
        case 90...: letter = "A"
        case 80..<90: letter = "B"
        case 70..<80: letter = "C"
        case 60..<70: letter = "D"
        default: letter = "F"
        }
        let gpa: Double
        switch avg {
        case 93...: gpa = 4.0
        case 90..<93: gpa = 3.7
        case 87..<90: gpa = 3.3
        case 83..<87: gpa = 3.0
        case 80..<83: gpa = 2.7
        case 77..<80: gpa = 2.3
        case 73..<77: gpa = 2.0
        case 70..<73: gpa = 1.7
        default: gpa = 0.0
        }
        return GradeResult(average: avg, letterGrade: letter, gpa: gpa)
    }
}

// Time Zone Converter
class TimeZoneConverter {
    func convert(hour: Int, fromOffset: Int, toOffset: Int) -> Int {
        var result = hour - fromOffset + toOffset
        if result < 0 { result += 24 }
        if result >= 24 { result -= 24 }
        return result
    }
}

// One Rep Max Calculator
struct OneRepMaxResult { let oneRepMax: Double; let estimatedReps: [(Int, Double)] }
class OneRepMaxCalculator {
    func calculate(weight: Double, reps: Int) -> OneRepMaxResult {
        let oneRM = weight * (36.0 / Double(37 - reps))
        let estimates = (1...12).map { r in (r, oneRM * Double(37 - r) / 36) }
        return OneRepMaxResult(oneRepMax: oneRM, estimatedReps: estimates)
    }
}
