package com.qaantum.calculatorhub.data

import com.qaantum.calculatorhub.models.CalculatorItem

object CalculatorData {
    val allCalculators = listOf(
        // Standard & Scientific -> Moved to Math
        CalculatorItem("Standard", "calculator", "/standard", "Math"),
        CalculatorItem("Scientific", "flask", "/scientific", "Math"),

        // Finance
        CalculatorItem("Compound Interest", "chart_line", "/finance/interest/compound", "Finance"),
        CalculatorItem("Simple Interest", "percent", "/finance/interest/simple", "Finance"),
        CalculatorItem("Loan", "money_bill_wave", "/finance/loan", "Finance"),
        CalculatorItem("Mortgage", "house", "/finance/mortgage", "Finance"),
        CalculatorItem("Tip", "receipt", "/finance/tip", "Finance"),
        CalculatorItem("Discount", "tags", "/finance/discount", "Finance"),
        CalculatorItem("Investment", "money_bill_trend_up", "/finance/investment", "Finance"),
        CalculatorItem("Savings Goal", "piggy_bank", "/finance/savings", "Finance"),
        CalculatorItem("ROI", "chart_pie", "/finance/roi", "Finance"),
        CalculatorItem("CAGR", "arrow_trend_up", "/finance/cagr", "Finance"),
        CalculatorItem("Retirement", "umbrella_beach", "/finance/retirement", "Finance"),
        CalculatorItem("Auto Loan", "car", "/finance/auto-loan", "Finance"),
        CalculatorItem("Commission", "hand_holding_dollar", "/finance/commission", "Finance"),
        CalculatorItem("Sales Tax", "receipt", "/finance/sales-tax", "Finance"),
        CalculatorItem("Salary", "briefcase", "/finance/salary", "Finance"),
        CalculatorItem("Loan Affordability", "hand_holding_dollar", "/finance/loan-affordability", "Finance"),
        CalculatorItem("Refinance", "rotate", "/finance/refinance", "Finance"),
        CalculatorItem("Rental Property", "house_user", "/finance/rental", "Finance"),
        CalculatorItem("NPV Calculator", "chart_line", "/finance/npv", "Finance"),
        CalculatorItem("IRR Calculator", "chart_pie", "/finance/irr", "Finance"),
        CalculatorItem("Down Payment", "house", "/finance/down-payment", "Finance"),
        CalculatorItem("Paycheck", "money_bill", "/finance/paycheck", "Finance"),
        CalculatorItem("CD Calculator", "piggy_bank", "/finance/cd", "Finance"),
        CalculatorItem("Tip Split", "receipt", "/finance/tip-split", "Finance"),

        // Health
        CalculatorItem("BMI", "weight_scale", "/health/bmi", "Health"),
        CalculatorItem("BMR", "fire", "/health/bmr", "Health"),
        CalculatorItem("Calories", "utensils", "/health/calories", "Health"),
        CalculatorItem("Body Fat", "person", "/health/body-fat", "Health"),
        CalculatorItem("Ideal Weight", "weight_scale", "/health/ideal-weight", "Health"),
        CalculatorItem("Macro", "utensils", "/health/macro", "Health"),
        CalculatorItem("Water Intake", "glass_water", "/health/water", "Health"),
        CalculatorItem("Target Heart Rate", "heart_pulse", "/health/heart-rate", "Health"),
        CalculatorItem("Sleep Calculator", "bed", "/health/sleep", "Health"),
        CalculatorItem("Pace", "person_running", "/health/pace", "Health"),
        CalculatorItem("One Rep Max", "dumbbell", "/health/one-rep-max", "Health"),
        CalculatorItem("Ovulation", "calendar_check", "/health/ovulation", "Health"),
        CalculatorItem("Child Height", "child", "/health/child-height", "Health"),
        CalculatorItem("Smoking Cost", "ban_smoking", "/health/smoking-cost", "Health"),
        CalculatorItem("Blood Sugar", "droplet", "/health/blood-sugar", "Health"),
        CalculatorItem("VO₂ Max", "heart_pulse", "/health/vo2-max", "Health"),
        CalculatorItem("Medication Dosage", "prescription", "/health/medication-dosage", "Health"),

        // Math (Includes Standard/Scientific)
        CalculatorItem("Percentage", "percent", "/math/percentage", "Math"),
        CalculatorItem("Quadratic Solver", "xmarks_lines", "/math/quadratic", "Math"),
        CalculatorItem("GCD / LCM", "calculator", "/math/gcd-lcm", "Math"),
        CalculatorItem("Factorial", "exclamation", "/math/factorial", "Math"),
        CalculatorItem("Random Number", "shuffle", "/math/random", "Math"),
        CalculatorItem("Standard Deviation", "chart_bar", "/math/statistics", "Math"),
        CalculatorItem("Binary Converter", "zero", "/math/binary", "Math"),
        CalculatorItem("Roman Numerals", "i_cursor", "/math/roman", "Math"),
        CalculatorItem("Matrix Determinant", "table_cells", "/math/matrix", "Math"),
        CalculatorItem("Logarithm", "calculator", "/math/logarithm", "Math"),
        CalculatorItem("Statistics", "chart_bar", "/math/stats", "Math"),
        CalculatorItem("Summation", "sigma", "/math/summation", "Math"),

        // Science (Includes Electronics)
        CalculatorItem("Ohm's Law", "bolt", "/electronics/ohms-law", "Science"),
        CalculatorItem("LED Resistor", "lightbulb", "/electronics/led-resistor", "Science"),
        CalculatorItem("Kinematic", "gauge_high", "/science/kinematic", "Science"),
        CalculatorItem("Force", "weight_hanging", "/science/force", "Science"),
        CalculatorItem("pH Calculator", "flask", "/science/ph", "Science"),

        // Converters
        CalculatorItem("Unit Converter", "right_left", "/converter/unit", "Converters"),
        CalculatorItem("Currency", "arrow_right_arrow_left", "/converter/currency", "Converters"),
        CalculatorItem("Temperature", "thermometer", "/converter/temperature", "Converters"),
        CalculatorItem("Length", "ruler", "/converter/length", "Converters"),
        CalculatorItem("Weight", "weight_scale", "/converter/weight", "Converters"),
        CalculatorItem("Volume", "beaker", "/converter/volume", "Converters"),

        // Other (Includes Text Tools)
        CalculatorItem("Word Count", "align_left", "/text/word-count", "Other"),
        CalculatorItem("Base64 Converter", "code", "/text/base64", "Other"),
        CalculatorItem("Age", "cake_candles", "/other/age", "Other"),
        CalculatorItem("Work Hours", "briefcase", "/other/work-hours", "Other"),
        CalculatorItem("Fuel Cost", "gas_pump", "/other/fuel", "Other"),
        CalculatorItem("Password Gen", "key", "/other/password", "Other"),
        CalculatorItem("Grade Calculator", "a", "/other/grade", "Other"),
        CalculatorItem("Color Converter", "palette", "/other/color", "Other"),
        CalculatorItem("Moon Phase", "moon", "/other/moon-phase", "Other"),
        CalculatorItem("Dice Roller", "dice", "/other/dice", "Other"),
        CalculatorItem("Hash Generator", "lock", "/other/hash", "Other")
    )

    fun getCalculatorsByCategory(category: String): List<CalculatorItem> {
        return allCalculators.filter { it.category == category }
    }

    // Consolidated Category List (6 items)
    val categories = listOf(
        "Finance", "Math", "Health",
        "Converters", "Science", "Other"
    )
}
