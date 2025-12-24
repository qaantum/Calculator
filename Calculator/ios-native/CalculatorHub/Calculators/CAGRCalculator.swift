import Foundation

struct CAGRResult {
    let cagr: Double
    let totalGrowth: Double
}

class CAGRCalculator {
    func calculate(startValue: Double, endValue: Double, years: Double) -> CAGRResult? {
        guard startValue != 0, years != 0 else { return nil }

        let cagrVal = pow(endValue / startValue, 1.0 / years) - 1
        let totalGrowthVal = (endValue - startValue) / startValue

        return CAGRResult(cagr: cagrVal * 100.0, totalGrowth: totalGrowthVal * 100.0)
    }
}
