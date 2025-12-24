import Foundation

// Macro Calculator
struct MacroResult { let calories: Int; let protein: Int; let carbs: Int; let fat: Int }
class MacroCalculator {
    func calculate(targetCalories: Int, proteinPercent: Int, carbsPercent: Int, fatPercent: Int) -> MacroResult {
        let protein = (targetCalories * proteinPercent / 100) / 4
        let carbs = (targetCalories * carbsPercent / 100) / 4
        let fat = (targetCalories * fatPercent / 100) / 9
        return MacroResult(calories: targetCalories, protein: protein, carbs: carbs, fat: fat)
    }
}

// Protein Intake Calculator
struct ProteinResult { let minGrams: Double; let maxGrams: Double; let recommendedGrams: Double }
class ProteinIntakeCalculator {
    func calculate(weightKg: Double, activityLevel: String) -> ProteinResult {
        let mult: (Double, Double) = activityLevel == "Athlete" ? (1.6, 2.0) : activityLevel == "Active" ? (1.2, 1.4) : (0.8, 1.0)
        return ProteinResult(minGrams: weightKg * mult.0, maxGrams: weightKg * mult.1, recommendedGrams: weightKg * (mult.0 + mult.1) / 2)
    }
}

// Water Intake Calculator
struct WaterResult { let liters: Double; let glasses: Int }
class WaterIntakeCalculator {
    func calculate(weightKg: Double, activityLevel: String) -> WaterResult {
        let base = weightKg * 0.033; let extra = activityLevel == "Athlete" ? 1.0 : activityLevel == "Active" ? 0.5 : 0.0
        return WaterResult(liters: base + extra, glasses: Int((base + extra) / 0.25))
    }
}

// Target Heart Rate Calculator
struct TargetHRResult { let maxHR: Int; let zones: [(String, Int, Int)] }
class TargetHeartRateCalculator {
    func calculate(age: Int) -> TargetHRResult {
        let max = 220 - age
        return TargetHRResult(maxHR: max, zones: [
            ("Zone 1", Int(Double(max) * 0.5), Int(Double(max) * 0.6)),
            ("Zone 2", Int(Double(max) * 0.6), Int(Double(max) * 0.7)),
            ("Zone 3", Int(Double(max) * 0.7), Int(Double(max) * 0.8)),
            ("Zone 4", Int(Double(max) * 0.8), Int(Double(max) * 0.9)),
            ("Zone 5", Int(Double(max) * 0.9), max)
        ])
    }
}

// BAC Calculator
struct BACResult { let bac: Double; let hoursToSober: Double }
class BACCalculator {
    func calculate(drinks: Double, weight: Double, hours: Double, isMale: Bool) -> BACResult {
        let r = isMale ? 0.68 : 0.55
        let bac = ((drinks * 14) / (weight * 453.592 * r)) * 100 - (0.015 * hours)
        return BACResult(bac: max(0, bac), hoursToSober: bac > 0 ? bac / 0.015 : 0)
    }
}

// Due Date Calculator
struct DueDateResult { let dueDate: Date; let weeksPregnant: Int; let daysRemaining: Int }
class DueDateCalculator {
    func calculate(lastPeriodYear: Int, lastPeriodMonth: Int, lastPeriodDay: Int) -> DueDateResult? {
        let calendar = Calendar.current
        guard let lmp = calendar.date(from: DateComponents(year: lastPeriodYear, month: lastPeriodMonth, day: lastPeriodDay)),
              let due = calendar.date(byAdding: .day, value: 280, to: lmp) else { return nil }
        let weeks = calendar.dateComponents([.weekOfYear], from: lmp, to: Date()).weekOfYear ?? 0
        let days = calendar.dateComponents([.day], from: Date(), to: due).day ?? 0
        return DueDateResult(dueDate: due, weeksPregnant: weeks, daysRemaining: days)
    }
}

// Sleep Calculator
struct SleepResult { let wakeUpTimes: [String]; let sleepTimes: [String] }
class SleepCalculator {
    func calculateWakeUp(bedtimeHour: Int, bedtimeMin: Int) -> SleepResult {
        var times: [String] = []
        for cycles in 4...6 {
            let mins = (bedtimeHour * 60 + bedtimeMin + 15 + cycles * 90) % (24 * 60)
            times.append(String(format: "%02d:%02d", mins / 60, mins % 60))
        }
        return SleepResult(wakeUpTimes: times, sleepTimes: [])
    }
}

// Pace Calculator
struct PaceResult { let pacePerKm: String; let pacePerMile: String; let speed: Double }
class PaceCalculator {
    func calculate(distanceKm: Double, hours: Int, minutes: Int, seconds: Int) -> PaceResult {
        let totalMins = Double(hours * 60 + minutes) + Double(seconds) / 60
        let paceKm = totalMins / distanceKm; let paceMile = paceKm * 1.60934
        let speed = distanceKm / (totalMins / 60)
        return PaceResult(pacePerKm: String(format: "%d:%02d", Int(paceKm), Int((paceKm.truncatingRemainder(dividingBy: 1)) * 60)),
            pacePerMile: String(format: "%d:%02d", Int(paceMile), Int((paceMile.truncatingRemainder(dividingBy: 1)) * 60)), speed: speed)
    }
}
