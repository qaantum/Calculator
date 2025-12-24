import Foundation

// Age Calculator
struct AgeResult { let years: Int; let months: Int; let days: Int }
class AgeCalculator {
    func calculate(birthYear: Int, birthMonth: Int, birthDay: Int) -> AgeResult {
        let calendar = Calendar.current
        guard let birth = calendar.date(from: DateComponents(year: birthYear, month: birthMonth, day: birthDay)) else { return AgeResult(years: 0, months: 0, days: 0) }
        let components = calendar.dateComponents([.year, .month, .day], from: birth, to: Date())
        return AgeResult(years: components.year ?? 0, months: components.month ?? 0, days: components.day ?? 0)
    }
}

// Date Difference Calculator
struct DateDiffResult { let days: Int; let weeks: Int; let months: Int; let years: Int }
class DateDiffCalculator {
    func calculate(y1: Int, m1: Int, d1: Int, y2: Int, m2: Int, d2: Int) -> DateDiffResult {
        let calendar = Calendar.current
        guard let date1 = calendar.date(from: DateComponents(year: y1, month: m1, day: d1)),
              let date2 = calendar.date(from: DateComponents(year: y2, month: m2, day: d2)) else { return DateDiffResult(days: 0, weeks: 0, months: 0, years: 0) }
        let days = abs(calendar.dateComponents([.day], from: date1, to: date2).day ?? 0)
        return DateDiffResult(days: days, weeks: days / 7, months: days / 30, years: days / 365)
    }
}

// Time Calculator
struct TimeCalcResult { let hours: Int; let minutes: Int; let seconds: Int; let totalSeconds: Int }
class TimeCalculator {
    func add(h1: Int, m1: Int, s1: Int, h2: Int, m2: Int, s2: Int) -> TimeCalcResult {
        let total = (h1 * 3600 + m1 * 60 + s1) + (h2 * 3600 + m2 * 60 + s2)
        return TimeCalcResult(hours: total / 3600, minutes: (total % 3600) / 60, seconds: total % 60, totalSeconds: total)
    }
    func diff(h1: Int, m1: Int, s1: Int, h2: Int, m2: Int, s2: Int) -> TimeCalcResult {
        let total = abs((h1 * 3600 + m1 * 60 + s1) - (h2 * 3600 + m2 * 60 + s2))
        return TimeCalcResult(hours: total / 3600, minutes: (total % 3600) / 60, seconds: total % 60, totalSeconds: total)
    }
}

// Work Hours Calculator
struct WorkHoursResult { let regularHours: Double; let overtimeHours: Double; let totalPay: Double }
class WorkHoursCalculator {
    func calculate(hoursWorked: Double, hourlyRate: Double, overtimeThreshold: Double = 40, overtimeMultiplier: Double = 1.5) -> WorkHoursResult {
        let regular = min(hoursWorked, overtimeThreshold)
        let overtime = max(0, hoursWorked - overtimeThreshold)
        let pay = regular * hourlyRate + overtime * hourlyRate * overtimeMultiplier
        return WorkHoursResult(regularHours: regular, overtimeHours: overtime, totalPay: pay)
    }
}

// Fuel Cost Calculator
struct FuelCostResult { let fuelNeeded: Double; let totalCost: Double; let costPerMile: Double }
class FuelCostCalculator {
    func calculate(distance: Double, mpg: Double, pricePerGallon: Double) -> FuelCostResult {
        let fuel = distance / mpg
        let cost = fuel * pricePerGallon
        return FuelCostResult(fuelNeeded: fuel, totalCost: cost, costPerMile: cost / distance)
    }
}

// Password Generator
class PasswordGenerator {
    func generate(length: Int, useUpper: Bool = true, useLower: Bool = true, useNumbers: Bool = true, useSymbols: Bool = true) -> String {
        var chars = ""
        if useUpper { chars += "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
        if useLower { chars += "abcdefghijklmnopqrstuvwxyz" }
        if useNumbers { chars += "0123456789" }
        if useSymbols { chars += "!@#$%^&*()_+-=[]{}|;:,.<>?" }
        guard !chars.isEmpty else { return "" }
        return String((0..<length).map { _ in chars.randomElement()! })
    }
}
