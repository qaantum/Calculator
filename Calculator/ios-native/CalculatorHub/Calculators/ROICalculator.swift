import Foundation

struct ROIResult {
    let returnAmount: Double
    let roiPercentage: Double
}

class ROICalculator {
    func calculate(initialInvestment: Double, finalValue: Double) -> ROIResult? {
        guard initialInvestment != 0 else { return nil }
        
        let gain = finalValue - initialInvestment
        let roi = (gain / initialInvestment) * 100.0

        return ROIResult(returnAmount: gain, roiPercentage: roi)
    }
}
