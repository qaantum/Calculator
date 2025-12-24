package com.qaantum.calculatorhub.calculators

data class TipResult(
    val tipAmount: Double,
    val totalBill: Double,
    val amountPerPerson: Double
)

class TipCalculator {
    fun calculate(
        billAmount: Double,
        tipPercentage: Double,
        splitCount: Int = 1
    ): TipResult {
        val tip = billAmount * (tipPercentage / 100.0)
        val total = billAmount + tip
        val perPerson = total / splitCount
        
        return TipResult(
            tipAmount = tip,
            totalBill = total,
            amountPerPerson = perPerson
        )
    }
}
