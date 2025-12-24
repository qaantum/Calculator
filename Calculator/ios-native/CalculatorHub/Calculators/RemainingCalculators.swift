import Foundation

// Currency Converter (with static fallback rates)
struct CurrencyConversionResult { let amount: Double; let fromCurrency: String; let toCurrency: String; let result: Double; let rate: Double }
class CurrencyConverter {
    private let rates: [String: Double] = [
        "USD": 1.0, "EUR": 0.92, "GBP": 0.79, "JPY": 149.50,
        "CAD": 1.36, "AUD": 1.53, "CHF": 0.88, "CNY": 7.24,
        "INR": 83.12, "MXN": 17.15, "BRL": 4.97, "KRW": 1320.0,
        "SGD": 1.34, "HKD": 7.82, "NZD": 1.64, "SEK": 10.42
    ]
    
    var currencies: [String] { Array(rates.keys).sorted() }
    
    func convert(amount: Double, from: String, to: String) -> CurrencyConversionResult {
        let fromRate = rates[from] ?? 1.0
        let toRate = rates[to] ?? 1.0
        let amountInUSD = amount / fromRate
        let result = amountInUSD * toRate
        return CurrencyConversionResult(amount: amount, fromCurrency: from, toCurrency: to, result: result, rate: toRate / fromRate)
    }
}

// Ovulation Calculator
struct OvulationResult { let ovulationDate: String; let fertileWindowStart: String; let fertileWindowEnd: String; let nextPeriodDate: String }
class OvulationCalculator {
    func calculate(lastPeriodYear: Int, lastPeriodMonth: Int, lastPeriodDay: Int, cycleLength: Int) -> OvulationResult? {
        let calendar = Calendar.current
        guard let lmp = calendar.date(from: DateComponents(year: lastPeriodYear, month: lastPeriodMonth, day: lastPeriodDay)),
              let nextPeriod = calendar.date(byAdding: .day, value: cycleLength, to: lmp),
              let ovulation = calendar.date(byAdding: .day, value: -14, to: nextPeriod),
              let fertileStart = calendar.date(byAdding: .day, value: -5, to: ovulation) else { return nil }
        
        let formatter = DateFormatter(); formatter.dateFormat = "MMM d, yyyy"
        return OvulationResult(
            ovulationDate: formatter.string(from: ovulation),
            fertileWindowStart: formatter.string(from: fertileStart),
            fertileWindowEnd: formatter.string(from: ovulation),
            nextPeriodDate: formatter.string(from: nextPeriod)
        )
    }
}

// Child Height Predictor (Mid-Parental Method)
struct ChildHeightResult { let predictedHeightCm: Double; let predictedHeightFtIn: String; let rangeCm: String }
class ChildHeightPredictor {
    func predict(fatherHeightCm: Double, motherHeightCm: Double, isBoy: Bool) -> ChildHeightResult {
        let predicted = isBoy ? (fatherHeightCm + motherHeightCm + 13) / 2 : (fatherHeightCm + motherHeightCm - 13) / 2
        let totalInches = predicted / 2.54
        let feet = Int(totalInches / 12)
        let inches = totalInches.truncatingRemainder(dividingBy: 12)
        return ChildHeightResult(
            predictedHeightCm: predicted,
            predictedHeightFtIn: "\(feet)' \(String(format: "%.1f", inches))\"",
            rangeCm: "\(String(format: "%.1f", predicted - 5)) - \(String(format: "%.1f", predicted + 5)) cm"
        )
    }
    
    func feetInchesToCm(feet: Double, inches: Double) -> Double { (feet * 12 + inches) * 2.54 }
}

// Smoking Cost Calculator
struct SmokingCostResult { let dailyCost: Double; let weeklyCost: Double; let monthlyCost: Double; let yearlyCost: Double; let lifetimeCost: Double }
class SmokingCostCalculator {
    func calculate(packsPerDay: Double, costPerPack: Double, yearsSmoked: Double) -> SmokingCostResult {
        let daily = packsPerDay * costPerPack
        let weekly = daily * 7
        let monthly = daily * 30.44
        let yearly = daily * 365.25
        let lifetime = yearly * yearsSmoked
        return SmokingCostResult(dailyCost: daily, weeklyCost: weekly, monthlyCost: monthly, yearlyCost: yearly, lifetimeCost: lifetime)
    }
}
