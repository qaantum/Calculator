package com.qaantum.calculatorhub.data

import com.qaantum.calculatorhub.models.CalculatorItem

object CalculatorData {
    val allCalculators = listOf(
        // Standard
        CalculatorItem("Standard", "calculator", "/standard", "Standard"),
        CalculatorItem("Scientific", "flask", "/scientific", "Scientific"),

        // Finance
        CalculatorItem("Amortization", "table_list", "/finance/amortization", "Finance"),
        CalculatorItem("Auto Loan", "car", "/finance/car", "Finance"),
        CalculatorItem("Break-Even", "scale_balanced", "/finance/breakeven", "Finance"),
        CalculatorItem("CAGR", "arrow_trend_up", "/finance/cagr", "Finance"),
        CalculatorItem("Currency", "arrow_right_arrow_left", "/finance/currency", "Finance"),
        CalculatorItem("Discount", "tags", "/finance/discount", "Finance"),
        CalculatorItem("Effective Rate", "chart_line", "/finance/effectiverate", "Finance"),
        CalculatorItem("Electricity", "bolt", "/finance/electricity", "Finance"),
        CalculatorItem("Inflation", "arrow_trend_up", "/finance/inflation", "Finance"),
        CalculatorItem("Compound Interest", "chart_line", "/finance/interest/compound", "Finance"),
        CalculatorItem("Credit Card Payoff", "credit_card", "/finance/creditcard", "Finance"),
        CalculatorItem("Investment", "money_bill_trend_up", "/finance/investment", "Finance"),
        CalculatorItem("Loan", "money_bill_wave", "/finance/loan", "Finance"),
        CalculatorItem("Loan Affordability", "hand_holding_dollar", "/finance/affordability", "Finance"),
        CalculatorItem("Margin", "shop", "/finance/margin", "Finance"),
        CalculatorItem("Mortgage", "house", "/finance/mortgage", "Finance"),
        CalculatorItem("Refinance", "rotate", "/finance/refinance", "Finance"),
        CalculatorItem("Rental Property", "house_user", "/finance/rental", "Finance"),
        CalculatorItem("Retirement", "umbrella_beach", "/finance/retirement", "Finance"),
        CalculatorItem("ROI", "chart_pie", "/finance/roi", "Finance"),
        CalculatorItem("Rule of 72", "hourglass_half", "/finance/rule72", "Finance"),
        CalculatorItem("Salary", "briefcase", "/finance/salary", "Finance"),
        CalculatorItem("Savings Goal", "piggy_bank", "/finance/savings", "Finance"),
        CalculatorItem("Sales Tax", "receipt", "/finance/salestax", "Finance"),
        CalculatorItem("Simple Interest", "percent", "/finance/interest", "Finance"),
        CalculatorItem("Tax", "calculator", "/finance/tax", "Finance"),
        CalculatorItem("TVM Calculator", "money_bill_trend_up", "/finance/tvm", "Finance"),
        CalculatorItem("Unit Price", "tag", "/finance/unitprice", "Finance"),
        CalculatorItem("Stock Profit", "arrow_trend_up", "/finance/stock", "Finance"),
        CalculatorItem("Commission", "hand_holding_dollar", "/finance/commission", "Finance"),
        CalculatorItem("Debt Snowball", "snowflake", "/finance/debtsnowball", "Finance"),

        // Health
        CalculatorItem("BAC", "wine_glass", "/health/bac", "Health"),
        CalculatorItem("BMI", "weight_scale", "/health/bmi", "Health"),
        CalculatorItem("BMR", "fire", "/health/bmr", "Health"),
        CalculatorItem("Body Fat", "person", "/health/bodyfat", "Health"),
        CalculatorItem("Calories", "utensils", "/health/calories", "Health"),
        CalculatorItem("Child Height", "child", "/health/childheight", "Health"),
        CalculatorItem("Ideal Weight", "weight_scale", "/health/idealweight", "Health"),
        CalculatorItem("One Rep Max", "dumbbell", "/health/onerepmax", "Health"),
        CalculatorItem("Ovulation", "calendar_check", "/health/ovulation", "Health"),
        CalculatorItem("Pace", "person_running", "/health/pace", "Health"),
        CalculatorItem("Pregnancy Due Date", "baby", "/health/duedate", "Health"),
        CalculatorItem("Protein Intake", "drumstick_bite", "/health/protein", "Health"),
        CalculatorItem("Sleep Calculator", "bed", "/health/sleep", "Health"),
        CalculatorItem("Target Heart Rate", "heart_pulse", "/health/heartrate", "Health"),
        CalculatorItem("Water Intake", "glass_water", "/health/water", "Health"),
        CalculatorItem("Smoking Cost", "ban_smoking", "/health/smoking", "Health"),
        CalculatorItem("Macro", "utensils", "/health/macro", "Health"),

        // Math
        CalculatorItem("Aspect Ratio", "expand", "/math/aspectratio", "Math"),
        CalculatorItem("Binary Converter", "zero", "/math/binary", "Math"),
        CalculatorItem("Factorial", "exclamation", "/math/factorial", "Math"),
        CalculatorItem("Fibonacci", "arrow_up_right_dots", "/math/fibonacci", "Math"),
        CalculatorItem("GCD / LCM", "calculator", "/math/gcdlcm", "Math"),
        CalculatorItem("Geometry", "shapes", "/math/geometry", "Math"),
        CalculatorItem("Hex Converter", "f", "/math/hex", "Math"),
        CalculatorItem("Matrix Determinant", "table_cells", "/math/matrix", "Math"),
        CalculatorItem("Percentage", "percent", "/math/percentage", "Math"),
        CalculatorItem("Permutation & Comb", "arrow_down_up_across_line", "/math/permcomb", "Math"),
        CalculatorItem("Prime Factorization", "hashtag", "/math/prime", "Math"),
        CalculatorItem("Quadratic Solver", "xmarks_lines", "/math/quadratic", "Math"),
        CalculatorItem("Random Number", "shuffle", "/math/random", "Math"),
        CalculatorItem("Roman Numerals", "i_cursor", "/math/roman", "Math"),
        CalculatorItem("Standard Deviation", "chart_bar", "/math/stddev", "Math"),
        CalculatorItem("Surface Area", "layer_group", "/math/surfacearea", "Math"),
        CalculatorItem("Volume", "cube", "/math/volume", "Math"),
        CalculatorItem("Circle Properties", "circle", "/math/circle", "Math"),
        CalculatorItem("Slope", "arrow_trend_up", "/math/slope", "Math"),
        CalculatorItem("Fraction", "divide", "/math/fraction", "Math"),

        // Electronics
        CalculatorItem("Battery Life", "battery_full", "/electronics/battery", "Electronics"),
        CalculatorItem("Ohm's Law", "bolt", "/electronics/ohms", "Electronics"),
        CalculatorItem("Resistor Color Code", "palette", "/electronics/resistor", "Electronics"),
        CalculatorItem("Voltage Divider", "plug", "/electronics/voltage", "Electronics"),
        CalculatorItem("LED Resistor", "lightbulb", "/electronics/led", "Electronics"),
        CalculatorItem("Capacitor Energy", "bolt", "/electronics/capacitor", "Electronics"),

        // Converters
        CalculatorItem("Angle", "compass", "/converters/angle", "Converters"),
        CalculatorItem("Area", "vector_square", "/converters/area", "Converters"),
        CalculatorItem("Cooking", "utensils", "/converters/cooking", "Converters"),
        CalculatorItem("Data Storage", "hard_drive", "/converters/storage", "Converters"),
        CalculatorItem("Fuel Consumption", "gas_pump", "/converters/fuelconsumption", "Converters"),
        CalculatorItem("Power", "bolt", "/converters/power", "Converters"),
        CalculatorItem("Pressure", "gauge", "/converters/pressure", "Converters"),
        CalculatorItem("Speed", "gauge_high", "/converters/speed", "Converters"),
        CalculatorItem("Torque", "wrench", "/converters/torque", "Converters"),
        CalculatorItem("Unit Converter", "right_left", "/converters/unit", "Converters"),
        CalculatorItem("Shoe Size", "shoe_prints", "/converters/shoesize", "Converters"),

        // Photography
        CalculatorItem("Depth of Field", "camera", "/lifestyle/dof", "Lifestyle"),
        CalculatorItem("Exposure Value", "sun", "/lifestyle/ev", "Lifestyle"),

        // Physics / Science
        CalculatorItem("Acceleration", "gauge_high", "/science/acceleration", "Science"),
        CalculatorItem("Density", "cubes", "/science/density", "Science"),
        CalculatorItem("Force", "weight_hanging", "/science/force", "Science"),
        CalculatorItem("Kinetic Energy", "person_running", "/science/kinetic", "Science"),
        CalculatorItem("Power", "bolt", "/science/power", "Science"),
        CalculatorItem("Projectile Motion", "share", "/science/projectile", "Science"),

        // Chemistry
        CalculatorItem("Dilution", "flask", "/science/dilution", "Science"),
        CalculatorItem("Ideal Gas Law", "cloud", "/science/idealgas", "Science"),

        // Gardening
        CalculatorItem("Plant Spacing", "ruler_horizontal", "/lifestyle/spacing", "Lifestyle"),
        CalculatorItem("Soil / Mulch", "trowel", "/lifestyle/soil", "Lifestyle"),

        // Sports / Lifestyle
        CalculatorItem("Pizza Party", "pizza_slice", "/lifestyle/pizza", "Lifestyle"),
        CalculatorItem("Cricket Run Rate", "baseball_bat_ball", "/lifestyle/cricket", "Lifestyle"),
        CalculatorItem("Tennis Score", "table_tennis_paddle_ball", "/lifestyle/tennis", "Lifestyle"),

        // Text Tools
        CalculatorItem("Base64 Converter", "code", "/text/base64", "Text Tools"),
        CalculatorItem("Case Converter", "font", "/text/case", "Text Tools"),
        CalculatorItem("Lorem Ipsum", "paragraph", "/text/lorem", "Text Tools"),
        CalculatorItem("Reverse Text", "left_right", "/text/reverse", "Text Tools"),
        CalculatorItem("Word Count", "align_left", "/text/wordcount", "Text Tools"),
        CalculatorItem("JSON Formatter", "file_code", "/text/json", "Text Tools"),

        // Other
        CalculatorItem("Age", "cake_candles", "/other/age", "Other"),
        CalculatorItem("Construction", "trowel", "/other/construction", "Other"),
        CalculatorItem("Date Calculator", "calendar_days", "/other/date", "Other"),
        CalculatorItem("Flooring", "rug", "/other/flooring", "Other"),
        CalculatorItem("Fuel Cost", "gas_pump", "/other/fuel", "Other"),
        CalculatorItem("GPA Calculator", "graduation_cap", "/other/gpa", "Other"),
        CalculatorItem("Grade Calculator", "a", "/other/grade", "Other"),
        CalculatorItem("IP Subnet", "network_wired", "/other/ipsubnet", "Other"),
        CalculatorItem("Password Gen", "key", "/other/password", "Other"),
        CalculatorItem("Time Calculator", "clock", "/other/time", "Other"),
        CalculatorItem("TV Size", "tv", "/other/tvsize", "Other"),
        CalculatorItem("Work Hours", "briefcase", "/other/workhours", "Other")
    )

    fun getCalculatorsByCategory(category: String): List<CalculatorItem> {
        return allCalculators.filter { it.category == category }
    }

    val categories = listOf(
        "Standard", "Scientific", "Finance", "Health", "Math",
        "Electronics", "Converters", "Lifestyle", "Science", "Text Tools", "Other"
    )
}

