import Foundation

// Ohm's Law Calculator
struct OhmsLawResult { let voltage: Double?; let current: Double?; let resistance: Double?; let power: Double? }
class OhmsLawCalculator {
    func calculateVoltage(current: Double, resistance: Double) -> OhmsLawResult { OhmsLawResult(voltage: current * resistance, current: current, resistance: resistance, power: current * current * resistance) }
    func calculateCurrent(voltage: Double, resistance: Double) -> OhmsLawResult { OhmsLawResult(voltage: voltage, current: voltage / resistance, resistance: resistance, power: voltage * voltage / resistance) }
    func calculateResistance(voltage: Double, current: Double) -> OhmsLawResult { OhmsLawResult(voltage: voltage, current: current, resistance: voltage / current, power: voltage * current) }
}

// LED Resistor Calculator
struct LEDResistorResult { let resistance: Double; let power: Double; let nearestStandard: Int }
class LEDResistorCalculator {
    private let standardValues = [10, 22, 33, 47, 68, 100, 150, 220, 330, 470, 680, 1000, 1500, 2200, 3300, 4700]
    func calculate(supplyVoltage: Double, ledVoltage: Double, ledCurrent: Double) -> LEDResistorResult {
        let r = (supplyVoltage - ledVoltage) / (ledCurrent / 1000)
        let p = (supplyVoltage - ledVoltage) * ledCurrent / 1000
        let nearest = standardValues.min(by: { abs($0 - Int(r)) < abs($1 - Int(r)) }) ?? Int(r)
        return LEDResistorResult(resistance: r, power: p, nearestStandard: nearest)
    }
}

// Voltage Divider Calculator
struct VoltageDividerResult { let outputVoltage: Double; let r1: Double?; let r2: Double? }
class VoltageDividerCalculator {
    func calculateOutput(inputVoltage: Double, r1: Double, r2: Double) -> VoltageDividerResult { VoltageDividerResult(outputVoltage: inputVoltage * r2 / (r1 + r2), r1: r1, r2: r2) }
    func calculateR2(inputVoltage: Double, outputVoltage: Double, r1: Double) -> VoltageDividerResult { VoltageDividerResult(outputVoltage: outputVoltage, r1: r1, r2: outputVoltage * r1 / (inputVoltage - outputVoltage)) }
}

// Battery Life Calculator
struct BatteryLifeResult { let hours: Double; let days: Double }
class BatteryLifeCalculator {
    func calculate(capacityMah: Double, currentMa: Double) -> BatteryLifeResult { let h = capacityMah / currentMa; return BatteryLifeResult(hours: h, days: h / 24) }
}

// Capacitor Energy Calculator
struct CapacitorEnergyResult { let joules: Double; let millijoules: Double }
class CapacitorEnergyCalculator {
    func calculate(capacitanceMicroFarads: Double, voltage: Double) -> CapacitorEnergyResult {
        let c = capacitanceMicroFarads / 1_000_000; let e = 0.5 * c * voltage * voltage
        return CapacitorEnergyResult(joules: e, millijoules: e * 1000)
    }
}

// Word Count Calculator
struct WordCountResult { let characters: Int; let words: Int; let sentences: Int; let paragraphs: Int; let lines: Int }
class WordCountCalculator {
    func count(text: String) -> WordCountResult {
        let chars = text.count
        let words = text.trimmingCharacters(in: .whitespaces).components(separatedBy: .whitespaces).filter { !$0.isEmpty }.count
        let sentences = text.components(separatedBy: CharacterSet(charactersIn: ".!?")).filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.count
        let paragraphs = text.components(separatedBy: "\n\n").filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.count
        let lines = text.components(separatedBy: "\n").count
        return WordCountResult(characters: chars, words: words, sentences: sentences, paragraphs: paragraphs, lines: lines)
    }
}

// Case Converter
class CaseConverter {
    func toUpperCase(_ text: String) -> String { text.uppercased() }
    func toLowerCase(_ text: String) -> String { text.lowercased() }
    func toTitleCase(_ text: String) -> String { text.capitalized }
    func toSentenceCase(_ text: String) -> String { text.prefix(1).uppercased() + text.dropFirst().lowercased() }
    func toCamelCase(_ text: String) -> String { text.components(separatedBy: .whitespaces).enumerated().map { $0.offset == 0 ? $0.element.lowercased() : $0.element.capitalized }.joined() }
    func toSnakeCase(_ text: String) -> String { text.lowercased().replacingOccurrences(of: " ", with: "_") }
}

// Base64 Converter
class Base64Converter {
    func encode(_ text: String) -> String { Data(text.utf8).base64EncodedString() }
    func decode(_ base64: String) -> String { guard let data = Data(base64Encoded: base64), let str = String(data: data, encoding: .utf8) else { return "Invalid Base64" }; return str }
}
