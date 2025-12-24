package com.qaantum.calculatorhub.calculators

import kotlin.math.pow

// Remaining Finance Calculators

// Rule of 72 Calculator
class Rule72Calculator {
    fun yearsToDouble(rate: Double) = 72.0 / rate
    fun rateToDouble(years: Double) = 72.0 / years
}

// Break Even Calculator
data class BreakEvenResult(val units: Double, val revenue: Double)
class BreakEvenCalculator {
    fun calculate(fixedCosts: Double, pricePerUnit: Double, variableCostPerUnit: Double): BreakEvenResult {
        val units = fixedCosts / (pricePerUnit - variableCostPerUnit)
        return BreakEvenResult(units, units * pricePerUnit)
    }
}

// Margin/Markup Calculator
data class MarginResult(val margin: Double, val markup: Double, val cost: Double, val revenue: Double, val profit: Double)
class MarginMarkupCalculator {
    fun fromMargin(cost: Double, marginPercent: Double): MarginResult {
        val price = cost / (1 - marginPercent / 100)
        val profit = price - cost
        return MarginResult(marginPercent, profit / cost * 100, cost, price, profit)
    }
    fun fromMarkup(cost: Double, markupPercent: Double): MarginResult {
        val profit = cost * markupPercent / 100
        val price = cost + profit
        return MarginResult(profit / price * 100, markupPercent, cost, price, profit)
    }
}

// Stock Profit Calculator
data class StockProfitResult(val profit: Double, val percentGain: Double, val totalReturn: Double)
class StockProfitCalculator {
    fun calculate(buyPrice: Double, sellPrice: Double, shares: Double, buyCommission: Double = 0.0, sellCommission: Double = 0.0): StockProfitResult {
        val totalBuy = buyPrice * shares + buyCommission
        val totalSell = sellPrice * shares - sellCommission
        val profit = totalSell - totalBuy
        return StockProfitResult(profit, (profit / totalBuy) * 100, totalSell)
    }
}

// Net Worth Calculator
data class NetWorthResult(val totalAssets: Double, val totalLiabilities: Double, val netWorth: Double)
class NetWorthCalculator {
    fun calculate(assets: List<Double>, liabilities: List<Double>): NetWorthResult {
        val totalA = assets.sum()
        val totalL = liabilities.sum()
        return NetWorthResult(totalA, totalL, totalA - totalL)
    }
}

// Credit Card Payoff Calculator
data class CreditCardPayoffResult(val monthsToPayoff: Int, val totalInterest: Double, val totalPayment: Double)
class CreditCardPayoffCalculator {
    fun calculate(balance: Double, apr: Double, monthlyPayment: Double): CreditCardPayoffResult {
        val monthlyRate = apr / 100 / 12
        var remaining = balance
        var months = 0
        var totalInterest = 0.0
        
        while (remaining > 0 && months < 600) {
            val interest = remaining * monthlyRate
            totalInterest += interest
            remaining = remaining + interest - monthlyPayment
            months++
        }
        
        return CreditCardPayoffResult(months, totalInterest, balance + totalInterest)
    }
}

// Inflation Calculator
data class InflationResult(val futureValue: Double, val purchasingPower: Double)
class InflationCalculator {
    fun calculateFutureValue(presentValue: Double, inflationRate: Double, years: Int): InflationResult {
        val fv = presentValue * (1 + inflationRate / 100).pow(years)
        val pp = presentValue / (1 + inflationRate / 100).pow(years)
        return InflationResult(fv, pp)
    }
}

// Electricity Cost Calculator
data class ElectricityCostResult(val dailyCost: Double, val monthlyCost: Double, val yearlyCost: Double, val kwhUsed: Double)
class ElectricityCostCalculator {
    fun calculate(watts: Double, hoursPerDay: Double, pricePerKwh: Double): ElectricityCostResult {
        val kwh = watts / 1000 * hoursPerDay
        val daily = kwh * pricePerKwh
        return ElectricityCostResult(daily, daily * 30, daily * 365, kwh)
    }
}
