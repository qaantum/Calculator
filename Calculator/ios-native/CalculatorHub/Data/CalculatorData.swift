import Foundation

struct CalculatorData {
    static let allCalculators: [CalculatorItem] = [
        // Standard
        CalculatorItem(title: "Standard", iconName: "calculator", route: "/standard", category: "Standard"),
        CalculatorItem(title: "Scientific", iconName: "flask", route: "/scientific", category: "Scientific"),

        // Finance
        CalculatorItem(title: "Compound Interest", iconName: "chart_line", route: "/finance/interest/compound", category: "Finance"),
        CalculatorItem(title: "Simple Interest", iconName: "percent", route: "/finance/interest/simple", category: "Finance"),
        CalculatorItem(title: "Loan", iconName: "money_bill_wave", route: "/finance/loan", category: "Finance"),
        CalculatorItem(title: "Mortgage", iconName: "house", route: "/finance/mortgage", category: "Finance"),
        CalculatorItem(title: "Tip", iconName: "receipt", route: "/finance/tip", category: "Finance"),
        CalculatorItem(title: "Discount", iconName: "tags", route: "/finance/discount", category: "Finance"),
        CalculatorItem(title: "Investment", iconName: "money_bill_trend_up", route: "/finance/investment", category: "Finance"),
        CalculatorItem(title: "Savings Goal", iconName: "piggy_bank", route: "/finance/savings", category: "Finance"),
        CalculatorItem(title: "ROI", iconName: "chart_pie", route: "/finance/roi", category: "Finance"),
        CalculatorItem(title: "CAGR", iconName: "arrow_trend_up", route: "/finance/cagr", category: "Finance"),
        CalculatorItem(title: "Retirement", iconName: "umbrella_beach", route: "/finance/retirement", category: "Finance"),
        CalculatorItem(title: "Auto Loan", iconName: "car", route: "/finance/auto-loan", category: "Finance"),
        CalculatorItem(title: "Commission", iconName: "hand_holding_dollar", route: "/finance/commission", category: "Finance"),
        CalculatorItem(title: "Sales Tax", iconName: "receipt", route: "/finance/sales-tax", category: "Finance"),
        CalculatorItem(title: "Salary", iconName: "briefcase", route: "/finance/salary", category: "Finance"),
        CalculatorItem(title: "Loan Affordability", iconName: "hand_holding_dollar", route: "/finance/loan-affordability", category: "Finance"),
        CalculatorItem(title: "Refinance", iconName: "rotate", route: "/finance/refinance", category: "Finance"),
        CalculatorItem(title: "Rental Property", iconName: "house_user", route: "/finance/rental", category: "Finance"),
        CalculatorItem(title: "NPV Calculator", iconName: "chart_line", route: "/finance/npv", category: "Finance"),
        CalculatorItem(title: "IRR Calculator", iconName: "chart_pie", route: "/finance/irr", category: "Finance"),
        CalculatorItem(title: "Down Payment", iconName: "house", route: "/finance/down-payment", category: "Finance"),
        CalculatorItem(title: "Paycheck", iconName: "money_bill", route: "/finance/paycheck", category: "Finance"),
        CalculatorItem(title: "CD Calculator", iconName: "piggy_bank", route: "/finance/cd", category: "Finance"),
        CalculatorItem(title: "Tip Split", iconName: "receipt", route: "/finance/tip-split", category: "Finance"),

        // Health
        CalculatorItem(title: "BMI", iconName: "weight_scale", route: "/health/bmi", category: "Health"),
        CalculatorItem(title: "BMR", iconName: "fire", route: "/health/bmr", category: "Health"),
        CalculatorItem(title: "Calories", iconName: "utensils", route: "/health/calories", category: "Health"),
        CalculatorItem(title: "Body Fat", iconName: "person", route: "/health/body-fat", category: "Health"),
        CalculatorItem(title: "Ideal Weight", iconName: "weight_scale", route: "/health/ideal-weight", category: "Health"),
        CalculatorItem(title: "Macro", iconName: "utensils", route: "/health/macro", category: "Health"),
        CalculatorItem(title: "Water Intake", iconName: "glass_water", route: "/health/water", category: "Health"),
        CalculatorItem(title: "Target Heart Rate", iconName: "heart_pulse", route: "/health/heart-rate", category: "Health"),
        CalculatorItem(title: "Sleep Calculator", iconName: "bed", route: "/health/sleep", category: "Health"),
        CalculatorItem(title: "Pace", iconName: "person_running", route: "/health/pace", category: "Health"),
        CalculatorItem(title: "One Rep Max", iconName: "dumbbell", route: "/health/one-rep-max", category: "Health"),
        CalculatorItem(title: "Ovulation", iconName: "calendar_check", route: "/health/ovulation", category: "Health"),
        CalculatorItem(title: "Child Height", iconName: "child", route: "/health/child-height", category: "Health"),
        CalculatorItem(title: "Smoking Cost", iconName: "ban_smoking", route: "/health/smoking-cost", category: "Health"),
        CalculatorItem(title: "Blood Sugar", iconName: "droplet", route: "/health/blood-sugar", category: "Health"),
        CalculatorItem(title: "VO₂ Max", iconName: "heart_pulse", route: "/health/vo2-max", category: "Health"),
        CalculatorItem(title: "Medication Dosage", iconName: "prescription", route: "/health/medication-dosage", category: "Health"),

        // Math
        CalculatorItem(title: "Percentage", iconName: "percent", route: "/math/percentage", category: "Math"),
        CalculatorItem(title: "Quadratic Solver", iconName: "xmarks_lines", route: "/math/quadratic", category: "Math"),
        CalculatorItem(title: "GCD / LCM", iconName: "calculator", route: "/math/gcd-lcm", category: "Math"),
        CalculatorItem(title: "Factorial", iconName: "exclamation", route: "/math/factorial", category: "Math"),
        CalculatorItem(title: "Random Number", iconName: "shuffle", route: "/math/random", category: "Math"),
        CalculatorItem(title: "Standard Deviation", iconName: "chart_bar", route: "/math/statistics", category: "Math"),
        CalculatorItem(title: "Binary Converter", iconName: "zero", route: "/math/binary", category: "Math"),
        CalculatorItem(title: "Roman Numerals", iconName: "i_cursor", route: "/math/roman", category: "Math"),
        CalculatorItem(title: "Matrix Determinant", iconName: "table_cells", route: "/math/matrix", category: "Math"),
        CalculatorItem(title: "Logarithm", iconName: "calculator", route: "/math/logarithm", category: "Math"),
        CalculatorItem(title: "Statistics", iconName: "chart_bar", route: "/math/stats", category: "Math"),
        CalculatorItem(title: "Summation", iconName: "sigma", route: "/math/summation", category: "Math"),

        // Electronics
        CalculatorItem(title: "Ohm's Law", iconName: "bolt", route: "/electronics/ohms-law", category: "Electronics"),
        CalculatorItem(title: "LED Resistor", iconName: "lightbulb", route: "/electronics/led-resistor", category: "Electronics"),

        // Converters
        CalculatorItem(title: "Unit Converter", iconName: "right_left", route: "/converter/unit", category: "Converters"),
        CalculatorItem(title: "Currency", iconName: "arrow_right_arrow_left", route: "/converter/currency", category: "Converters"),
        CalculatorItem(title: "Temperature", iconName: "thermometer", route: "/converter/temperature", category: "Converters"),
        CalculatorItem(title: "Length", iconName: "ruler", route: "/converter/length", category: "Converters"),
        CalculatorItem(title: "Weight", iconName: "weight_scale", route: "/converter/weight", category: "Converters"),
        CalculatorItem(title: "Volume", iconName: "beaker", route: "/converter/volume", category: "Converters"),

        // Science
        CalculatorItem(title: "Kinematic", iconName: "gauge_high", route: "/science/kinematic", category: "Science"),
        CalculatorItem(title: "Force", iconName: "weight_hanging", route: "/science/force", category: "Science"),
        CalculatorItem(title: "pH Calculator", iconName: "flask", route: "/science/ph", category: "Science"),

        // Text Tools
        CalculatorItem(title: "Word Count", iconName: "align_left", route: "/text/word-count", category: "Text Tools"),
        CalculatorItem(title: "Base64 Converter", iconName: "code", route: "/text/base64", category: "Text Tools"),

        // Other
        CalculatorItem(title: "Age", iconName: "cake_candles", route: "/other/age", category: "Other"),
        CalculatorItem(title: "Work Hours", iconName: "briefcase", route: "/other/work-hours", category: "Other"),
        CalculatorItem(title: "Fuel Cost", iconName: "gas_pump", route: "/other/fuel", category: "Other"),
        CalculatorItem(title: "Password Gen", iconName: "key", route: "/other/password", category: "Other"),
        CalculatorItem(title: "Grade Calculator", iconName: "a", route: "/other/grade", category: "Other"),
        CalculatorItem(title: "Color Converter", iconName: "palette", route: "/other/color", category: "Other"),
        CalculatorItem(title: "Moon Phase", iconName: "moon", route: "/other/moon-phase", category: "Other"),
        CalculatorItem(title: "Dice Roller", iconName: "dice", route: "/other/dice", category: "Other"),
        CalculatorItem(title: "Hash Generator", iconName: "lock", route: "/other/hash", category: "Other")
    ]

    static let categories = [
        "Standard", "Scientific", "Finance", "Health", "Math",
        "Electronics", "Converters", "Science", "Text Tools", "Other"
    ]

    static func getCalculatorsByCategory(category: String) -> [CalculatorItem] {
        return allCalculators.filter { $0.category == category }
    }
}
