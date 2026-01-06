import Foundation

// NEW HEALTH CALCULATORS

// Blood Sugar Converter
struct BloodSugarResult { let mgdl, mmol: Double; let category, categoryColor: String }
class BloodSugarConverter {
    private let factor = 18.0182
    func fromMgdl(_ mgdl: Double) -> BloodSugarResult { BloodSugarResult(mgdl: mgdl, mmol: mgdl / factor, category: getCategory(mgdl), categoryColor: getColor(mgdl)) }
    func fromMmol(_ mmol: Double) -> BloodSugarResult { let mgdl = mmol * factor; return BloodSugarResult(mgdl: mgdl, mmol: mmol, category: getCategory(mgdl), categoryColor: getColor(mgdl)) }
    private func getCategory(_ mgdl: Double) -> String { switch mgdl { case ..<70: return "Low (Hypoglycemia)"; case 70..<100: return "Normal (Fasting)"; case 100..<126: return "Prediabetes (Fasting)"; default: return "Diabetes Range" } }
    private func getColor(_ mgdl: Double) -> String { switch mgdl { case ..<70: return "orange"; case 70..<100: return "green"; case 100..<126: return "amber"; default: return "red" } }
}

// VO2 Max Calculator
struct VO2MaxResult { let vo2max: Double; let fitnessLevel: String }
class VO2MaxCalculator {
    func cooperTest(distanceMeters: Double) -> VO2MaxResult { VO2MaxResult(vo2max: (distanceMeters - 504.9) / 44.73, fitnessLevel: getLevel((distanceMeters - 504.9) / 44.73)) }
    func heartRateMethod(maxHR: Double, restingHR: Double) -> VO2MaxResult { let v = 15.3 * (maxHR / restingHR); return VO2MaxResult(vo2max: v, fitnessLevel: getLevel(v)) }
    private func getLevel(_ v: Double) -> String { switch v { case 50...: return "Excellent"; case 40..<50: return "Good"; case 30..<40: return "Average"; case 20..<30: return "Below Average"; default: return "Poor" } }
}

// Medication Dosage Calculator
struct MedicationDosageResult { let singleDose: Double; let volumePerDose: Double?; let dailyDose: Double }
class MedicationDosageCalculator {
    func calculate(weightKg: Double, dosePerKg: Double, concentration: Double? = nil, dosesPerDay: Int = 1) -> MedicationDosageResult {
        let singleDose = weightKg * dosePerKg
        let volumePerDose = concentration.map { singleDose / $0 }
        return MedicationDosageResult(singleDose: singleDose, volumePerDose: volumePerDose, dailyDose: singleDose * Double(dosesPerDay))
    }
    func convertLbToKg(_ lb: Double) -> Double { lb * 0.453592 }
}
