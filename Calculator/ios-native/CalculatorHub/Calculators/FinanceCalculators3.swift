import Foundation

// Remaining Finance Calculators

// Rule of 72 Calculator
class Rule72Calculator {
    func yearsToDouble(rate: Double) -> Double { 72.0 / rate }
    func rateToDouble(years: Double) -> Double { 72.0 / years }
}

// Break Even Calculator
struct BreakEvenResult { let units: Double; let revenue: Double }
class BreakEvenCalculator {
    func calculate(fixedCosts: Double, pricePerUnit: Double, variableCostPerUnit: Double) -> BreakEvenResult {
        let units = fixedCosts / (pricePerUnit - variableCostPerUnit)
        return BreakEvenResult(units: units, revenue: units * pricePerUnit)
    }
}

// Margin/Markup Calculator
struct MarginResult { let margin: Double; let markup: Double; let cost: Double; let revenue: Double; let profit: Double }
class MarginMarkupCalculator {
    func fromMargin(cost: Double, marginPercent: Double) -> MarginResult {
        let price = cost / (1 - marginPercent / 100); let profit = price - cost
        return MarginResult(margin: marginPercent, markup: profit / cost * 100, cost: cost, revenue: price, profit: profit)
    }
    func fromMarkup(cost: Double, markupPercent: Double) -> MarginResult {
        let profit = cost * markupPercent / 100; let price = cost + profit
        return MarginResult(margin: profit / price * 100, markup: markupPercent, cost: cost, revenue: price, profit: profit)
    }
}

// Stock Profit Calculator
struct StockProfitResult { let profit: Double; let percentGain: Double; let totalReturn: Double }
class StockProfitCalculator {
    func calculate(buyPrice: Double, sellPrice: Double, shares: Double, buyCommission: Double = 0, sellCommission: Double = 0) -> StockProfitResult {
        let totalBuy = buyPrice * shares + buyCommission
        let totalSell = sellPrice * shares - sellCommission
        let profit = totalSell - totalBuy
        return StockProfitResult(profit: profit, percentGain: (profit / totalBuy) * 100, totalReturn: totalSell)
    }
}

// Net Worth Calculator
struct NetWorthResult { let totalAssets: Double; let totalLiabilities: Double; let netWorth: Double }
class NetWorthCalculator {
    func calculate(assets: [Double], liabilities: [Double]) -> NetWorthResult {
        let a = assets.reduce(0, +); let l = liabilities.reduce(0, +)
        return NetWorthResult(totalAssets: a, totalLiabilities: l, netWorth: a - l)
    }
}

// Credit Card Payoff Calculator
struct CreditCardPayoffResult { let monthsToPayoff: Int; let totalInterest: Double; let totalPayment: Double }
class CreditCardPayoffCalculator {
    func calculate(balance: Double, apr: Double, monthlyPayment: Double) -> CreditCardPayoffResult {
        let monthlyRate = apr / 100 / 12
        var remaining = balance; var months = 0; var totalInterest = 0.0
        while remaining > 0 && months < 600 {
            let interest = remaining * monthlyRate
            totalInterest += interest
            remaining = remaining + interest - monthlyPayment
            months += 1
        }
        return CreditCardPayoffResult(monthsToPayoff: months, totalInterest: totalInterest, totalPayment: balance + totalInterest)
    }
}

// Inflation Calculator
struct InflationResult { let futureValue: Double; let purchasingPower: Double }
class InflationCalculator {
    func calculateFutureValue(presentValue: Double, inflationRate: Double, years: Int) -> InflationResult {
        let fv = presentValue * pow(1 + inflationRate / 100, Double(years))
        let pp = presentValue / pow(1 + inflationRate / 100, Double(years))
        return InflationResult(futureValue: fv, purchasingPower: pp)
    }
}

// Electricity Cost Calculator
struct ElectricityCostResult { let dailyCost: Double; let monthlyCost: Double; let yearlyCost: Double; let kwhUsed: Double }
class ElectricityCostCalculator {
    func calculate(watts: Double, hoursPerDay: Double, pricePerKwh: Double) -> ElectricityCostResult {
        let kwh = watts / 1000 * hoursPerDay; let daily = kwh * pricePerKwh
        return ElectricityCostResult(dailyCost: daily, monthlyCost: daily * 30, yearlyCost: daily * 365, kwhUsed: kwh)
    }
}
