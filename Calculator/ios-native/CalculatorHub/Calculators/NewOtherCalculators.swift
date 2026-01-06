import Foundation
import CryptoKit

// NEW OTHER CALCULATORS

// Moon Phase Calculator
struct MoonPhaseResult { let phaseName: String; let illumination, phaseDay: Double }
class MoonPhaseCalculator {
    func calculate(year: Int, month: Int, day: Int) -> MoonPhaseResult {
        var y = year; var m = month
        if m < 3 { y -= 1; m += 12 }
        let a = y / 100; let b = a / 4; let c = 2 - a + b
        let e = Int(365.25 * Double(y + 4716)); let f = Int(30.6001 * Double(m + 1))
        let jd = Double(c + day + e + f) - 1524.5
        let daysSinceNew = jd - 2451549.5
        let lunation = daysSinceNew / 29.53059
        let phase = (lunation - floor(lunation)) * 29.53059
        let illumination = (1 - cos(2 * .pi * phase / 29.53)) / 2 * 100
        return MoonPhaseResult(phaseName: getPhaseName(phase), illumination: illumination, phaseDay: phase)
    }
    private func getPhaseName(_ phase: Double) -> String {
        switch phase { case ..<1.85: return "New Moon"; case 1.85..<5.53: return "Waxing Crescent"; case 5.53..<9.22: return "First Quarter"; case 9.22..<12.91: return "Waxing Gibbous"; case 12.91..<16.61: return "Full Moon"; case 16.61..<20.30: return "Waning Gibbous"; case 20.30..<23.99: return "Last Quarter"; case 23.99..<27.68: return "Waning Crescent"; default: return "New Moon" }
    }
}

// Dice Roller
struct DiceRollResult { let rolls: [Int]; let total, min, max: Int }
class DiceRoller {
    func roll(sides: Int, count: Int) -> DiceRollResult {
        let rolls = (0..<count).map { _ in Int.random(in: 1...sides) }
        return DiceRollResult(rolls: rolls, total: rolls.reduce(0, +), min: count, max: count * sides)
    }
}

// Hash Generator
struct HashResult { let md5, sha1, sha256, sha512: String }
class HashGenerator {
    func generate(_ input: String) -> HashResult {
        let data = Data(input.utf8)
        return HashResult(
            md5: Insecure.MD5.hash(data: data).map { String(format: "%02x", $0) }.joined(),
            sha1: Insecure.SHA1.hash(data: data).map { String(format: "%02x", $0) }.joined(),
            sha256: SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined(),
            sha512: SHA512.hash(data: data).map { String(format: "%02x", $0) }.joined()
        )
    }
}
