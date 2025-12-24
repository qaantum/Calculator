import Foundation

struct BMRResult { let bmr: Double }
struct CaloriesResult { let tdee: Double }
struct BodyFatResult { let bodyFatPercentage: Double }
struct IdealWeightResult { let idealWeight: Double; let minWeight: Double; let maxWeight: Double }

class BMRCalculator {
    func calculate(gender: String, age: Int, heightCm: Double, weightKg: Double) -> BMRResult {
        let bmr: Double
        if gender == "Male" {
            bmr = (10 * weightKg) + (6.25 * heightCm) - Double(5 * age) + 5
        } else {
            bmr = (10 * weightKg) + (6.25 * heightCm) - Double(5 * age) - 161
        }
        return BMRResult(bmr: bmr)
    }
}

class CaloriesCalculator {
    func calculate(gender: String, age: Int, heightCm: Double, weightKg: Double, activityLevel: Double) -> CaloriesResult {
        let bmr: Double
        if gender == "Male" {
            bmr = (10 * weightKg) + (6.25 * heightCm) - Double(5 * age) + 5
        } else {
            bmr = (10 * weightKg) + (6.25 * heightCm) - Double(5 * age) - 161
        }
        return CaloriesResult(tdee: bmr * activityLevel)
    }
}

class BodyFatCalculator {
    func calculate(gender: String, heightCm: Double, waistCm: Double, neckCm: Double, hipCm: Double = 0) -> BodyFatResult {
        let bodyFat: Double
        if gender == "Male" {
            bodyFat = 495 / (1.0324 - 0.19077 * log10(waistCm - neckCm) + 0.15456 * log10(heightCm)) - 450
        } else {
            bodyFat = 495 / (1.29579 - 0.35004 * log10(waistCm + hipCm - neckCm) + 0.22100 * log10(heightCm)) - 450
        }
        return BodyFatResult(bodyFatPercentage: bodyFat)
    }
}

class IdealWeightCalculator {
    func calculate(gender: String, heightCm: Double) -> IdealWeightResult {
        let heightInches = heightCm / 2.54
        let baseHeight = 60.0
        
        let ideal: Double
        if gender == "Male" {
            ideal = 50 + 2.3 * (heightInches - baseHeight)
        } else {
            ideal = 45.5 + 2.3 * (heightInches - baseHeight)
        }
        
        let heightM = heightCm / 100.0
        let minWeight = 18.5 * heightM * heightM
        let maxWeight = 24.9 * heightM * heightM
        
        return IdealWeightResult(idealWeight: max(ideal, 0), minWeight: minWeight, maxWeight: maxWeight)
    }
}
