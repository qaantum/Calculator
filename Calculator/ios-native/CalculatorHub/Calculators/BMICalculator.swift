import Foundation

struct BMIResult {
    let bmi: Double
    let category: String
}

class BMICalculator {
    func calculate(height: Double, weight: Double, isMetric: Bool) -> BMIResult {
        let bmi: Double
        
        if isMetric {
            // Metric: kg / (m^2)
            let heightInMeters = height / 100.0 // cm to m
            bmi = weight / pow(heightInMeters, 2)
        } else {
            // Imperial: 703 * lbs / (in^2)
            bmi = weight * 703.0 / pow(height, 2)
        }
        
        let category: String
        if bmi < 18.5 {
            category = "Underweight"
        } else if bmi < 25 {
            category = "Normal"
        } else if bmi < 30 {
            category = "Overweight"
        } else {
            category = "Obese"
        }
        
        return BMIResult(bmi: bmi, category: category)
    }
    
    func calculateImperial(feet: Double, inches: Double, weight: Double) -> BMIResult {
        let totalInches = (feet * 12) + inches
        return calculate(height: totalInches, weight: weight, isMetric: false)
    }
}

