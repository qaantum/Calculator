import Foundation

struct TipResult {
    let tipAmount: Double
    let totalBill: Double
    let amountPerPerson: Double
}

class TipCalculator {
    func calculate(billAmount: Double, tipPercentage: Double, splitCount: Int = 1) -> TipResult {
        let tip = billAmount * (tipPercentage / 100.0)
        let total = billAmount + tip
        let perPerson = total / Double(splitCount)
        
        return TipResult(
            tipAmount: tip,
            totalBill: total,
            amountPerPerson: perPerson
        )
    }
}
