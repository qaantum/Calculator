import Foundation

struct CalculatorData {
    static let allCalculators: [CalculatorItem] = [
        // Standard
        CalculatorItem(title: "Standard", iconName: "calculator", route: "/standard", category: "Standard"),
        CalculatorItem(title: "Scientific", iconName: "flask", route: "/scientific", category: "Scientific"),

        // Finance
        CalculatorItem(title: "Amortization", iconName: "table_list", route: "/finance/amortization", category: "Finance"),
        CalculatorItem(title: "Auto Loan", iconName: "car", route: "/finance/car", category: "Finance"),
        CalculatorItem(title: "Break-Even", iconName: "scale_balanced", route: "/finance/breakeven", category: "Finance"),
        CalculatorItem(title: "CAGR", iconName: "arrow_trend_up", route: "/finance/cagr", category: "Finance"),
        CalculatorItem(title: "Currency", iconName: "arrow_right_arrow_left", route: "/finance/currency", category: "Finance"),
        CalculatorItem(title: "Discount", iconName: "tags", route: "/finance/discount", category: "Finance"),
        CalculatorItem(title: "Effective Rate", iconName: "chart_line", route: "/finance/effectiverate", category: "Finance"),
        CalculatorItem(title: "Electricity", iconName: "bolt", route: "/finance/electricity", category: "Finance"),
        CalculatorItem(title: "Inflation", iconName: "arrow_trend_up", route: "/finance/inflation", category: "Finance"),
        CalculatorItem(title: "Compound Interest", iconName: "chart_line", route: "/finance/interest/compound", category: "Finance"),
        CalculatorItem(title: "Credit Card Payoff", iconName: "credit_card", route: "/finance/creditcard", category: "Finance"),
        CalculatorItem(title: "Investment", iconName: "money_bill_trend_up", route: "/finance/investment", category: "Finance"),
        CalculatorItem(title: "Loan", iconName: "money_bill_wave", route: "/finance/loan", category: "Finance"),
        CalculatorItem(title: "Loan Affordability", iconName: "hand_holding_dollar", route: "/finance/affordability", category: "Finance"),
        CalculatorItem(title: "Margin", iconName: "shop", route: "/finance/margin", category: "Finance"),
        CalculatorItem(title: "Mortgage", iconName: "house", route: "/finance/mortgage", category: "Finance"),
        CalculatorItem(title: "Refinance", iconName: "rotate", route: "/finance/refinance", category: "Finance"),
        CalculatorItem(title: "Rental Property", iconName: "house_user", route: "/finance/rental", category: "Finance"),
        CalculatorItem(title: "Retirement", iconName: "umbrella_beach", route: "/finance/retirement", category: "Finance"),
        CalculatorItem(title: "ROI", iconName: "chart_pie", route: "/finance/roi", category: "Finance"),
        CalculatorItem(title: "Rule of 72", iconName: "hourglass_half", route: "/finance/rule72", category: "Finance"),
        CalculatorItem(title: "Salary", iconName: "briefcase", route: "/finance/salary", category: "Finance"),
        CalculatorItem(title: "Savings Goal", iconName: "piggy_bank", route: "/finance/savings", category: "Finance"),
        CalculatorItem(title: "Sales Tax", iconName: "receipt", route: "/finance/salestax", category: "Finance"),
        CalculatorItem(title: "Simple Interest", iconName: "percent", route: "/finance/interest", category: "Finance"),
        CalculatorItem(title: "Tax", iconName: "calculator", route: "/finance/tax", category: "Finance"),
        CalculatorItem(title: "TVM Calculator", iconName: "money_bill_trend_up", route: "/finance/tvm", category: "Finance"),
        CalculatorItem(title: "Unit Price", iconName: "tag", route: "/finance/unitprice", category: "Finance"),
        CalculatorItem(title: "Stock Profit", iconName: "arrow_trend_up", route: "/finance/stock", category: "Finance"),
        CalculatorItem(title: "Commission", iconName: "hand_holding_dollar", route: "/finance/commission", category: "Finance"),
        CalculatorItem(title: "Debt Snowball", iconName: "snowflake", route: "/finance/debtsnowball", category: "Finance"),

        // Health
        CalculatorItem(title: "BAC", iconName: "wine_glass", route: "/health/bac", category: "Health"),
        CalculatorItem(title: "BMI", iconName: "weight_scale", route: "/health/bmi", category: "Health"),
        CalculatorItem(title: "BMR", iconName: "fire", route: "/health/bmr", category: "Health"),
        CalculatorItem(title: "Body Fat", iconName: "person", route: "/health/bodyfat", category: "Health"),
        CalculatorItem(title: "Calories", iconName: "utensils", route: "/health/calories", category: "Health"),
        CalculatorItem(title: "Child Height", iconName: "child", route: "/health/childheight", category: "Health"),
        CalculatorItem(title: "Ideal Weight", iconName: "weight_scale", route: "/health/idealweight", category: "Health"),
        CalculatorItem(title: "One Rep Max", iconName: "dumbbell", route: "/health/onerepmax", category: "Health"),
        CalculatorItem(title: "Ovulation", iconName: "calendar_check", route: "/health/ovulation", category: "Health"),
        CalculatorItem(title: "Pace", iconName: "person_running", route: "/health/pace", category: "Health"),
        CalculatorItem(title: "Pregnancy Due Date", iconName: "baby", route: "/health/duedate", category: "Health"),
        CalculatorItem(title: "Protein Intake", iconName: "drumstick_bite", route: "/health/protein", category: "Health"),
        CalculatorItem(title: "Sleep Calculator", iconName: "bed", route: "/health/sleep", category: "Health"),
        CalculatorItem(title: "Target Heart Rate", iconName: "heart_pulse", route: "/health/heartrate", category: "Health"),
        CalculatorItem(title: "Water Intake", iconName: "glass_water", route: "/health/water", category: "Health"),
        CalculatorItem(title: "Smoking Cost", iconName: "ban_smoking", route: "/health/smoking", category: "Health"),
        CalculatorItem(title: "Macro", iconName: "utensils", route: "/health/macro", category: "Health"),

        // Math
        CalculatorItem(title: "Aspect Ratio", iconName: "expand", route: "/math/aspectratio", category: "Math"),
        CalculatorItem(title: "Binary Converter", iconName: "zero", route: "/math/binary", category: "Math"),
        CalculatorItem(title: "Factorial", iconName: "exclamation", route: "/math/factorial", category: "Math"),
        CalculatorItem(title: "Fibonacci", iconName: "arrow_up_right_dots", route: "/math/fibonacci", category: "Math"),
        CalculatorItem(title: "GCD / LCM", iconName: "calculator", route: "/math/gcdlcm", category: "Math"),
        CalculatorItem(title: "Geometry", iconName: "shapes", route: "/math/geometry", category: "Math"),
        CalculatorItem(title: "Hex Converter", iconName: "f", route: "/math/hex", category: "Math"),
        CalculatorItem(title: "Matrix Determinant", iconName: "table_cells", route: "/math/matrix", category: "Math"),
        CalculatorItem(title: "Percentage", iconName: "percent", route: "/math/percentage", category: "Math"),
        CalculatorItem(title: "Permutation & Comb", iconName: "arrow_down_up_across_line", route: "/math/permcomb", category: "Math"),
        CalculatorItem(title: "Prime Factorization", iconName: "hashtag", route: "/math/prime", category: "Math"),
        CalculatorItem(title: "Quadratic Solver", iconName: "xmarks_lines", route: "/math/quadratic", category: "Math"),
        CalculatorItem(title: "Random Number", iconName: "shuffle", route: "/math/random", category: "Math"),
        CalculatorItem(title: "Roman Numerals", iconName: "i_cursor", route: "/math/roman", category: "Math"),
        CalculatorItem(title: "Standard Deviation", iconName: "chart_bar", route: "/math/stddev", category: "Math"),
        CalculatorItem(title: "Surface Area", iconName: "layer_group", route: "/math/surfacearea", category: "Math"),
        CalculatorItem(title: "Volume", iconName: "cube", route: "/math/volume", category: "Math"),
        CalculatorItem(title: "Circle Properties", iconName: "circle", route: "/math/circle", category: "Math"),
        CalculatorItem(title: "Slope", iconName: "arrow_trend_up", route: "/math/slope", category: "Math"),
        CalculatorItem(title: "Fraction", iconName: "divide", route: "/math/fraction", category: "Math"),

        // Electronics
        CalculatorItem(title: "Battery Life", iconName: "battery_full", route: "/electronics/battery", category: "Electronics"),
        CalculatorItem(title: "Ohm's Law", iconName: "bolt", route: "/electronics/ohms", category: "Electronics"),
        CalculatorItem(title: "Resistor Color Code", iconName: "palette", route: "/electronics/resistor", category: "Electronics"),
        CalculatorItem(title: "Voltage Divider", iconName: "plug", route: "/electronics/voltage", category: "Electronics"),
        CalculatorItem(title: "LED Resistor", iconName: "lightbulb", route: "/electronics/led", category: "Electronics"),
        CalculatorItem(title: "Capacitor Energy", iconName: "bolt", route: "/electronics/capacitor", category: "Electronics"),

        // Converters
        CalculatorItem(title: "Angle", iconName: "compass", route: "/converters/angle", category: "Converters"),
        CalculatorItem(title: "Area", iconName: "vector_square", route: "/converters/area", category: "Converters"),
        CalculatorItem(title: "Cooking", iconName: "utensils", route: "/converters/cooking", category: "Converters"),
        CalculatorItem(title: "Data Storage", iconName: "hard_drive", route: "/converters/storage", category: "Converters"),
        CalculatorItem(title: "Fuel Consumption", iconName: "gas_pump", route: "/converters/fuelconsumption", category: "Converters"),
        CalculatorItem(title: "Power", iconName: "bolt", route: "/converters/power", category: "Converters"),
        CalculatorItem(title: "Pressure", iconName: "gauge", route: "/converters/pressure", category: "Converters"),
        CalculatorItem(title: "Speed", iconName: "gauge_high", route: "/converters/speed", category: "Converters"),
        CalculatorItem(title: "Torque", iconName: "wrench", route: "/converters/torque", category: "Converters"),
        CalculatorItem(title: "Unit Converter", iconName: "right_left", route: "/converters/unit", category: "Converters"),
        CalculatorItem(title: "Shoe Size", iconName: "shoe_prints", route: "/converters/shoesize", category: "Converters"),

        // Photography
        CalculatorItem(title: "Depth of Field", iconName: "camera", route: "/lifestyle/dof", category: "Lifestyle"),
        CalculatorItem(title: "Exposure Value", iconName: "sun", route: "/lifestyle/ev", category: "Lifestyle"),

        // Physics / Science
        CalculatorItem(title: "Acceleration", iconName: "gauge_high", route: "/science/acceleration", category: "Science"),
        CalculatorItem(title: "Density", iconName: "cubes", route: "/science/density", category: "Science"),
        CalculatorItem(title: "Force", iconName: "weight_hanging", route: "/science/force", category: "Science"),
        CalculatorItem(title: "Kinetic Energy", iconName: "person_running", route: "/science/kinetic", category: "Science"),
        CalculatorItem(title: "Power", iconName: "bolt", route: "/science/power", category: "Science"),
        CalculatorItem(title: "Projectile Motion", iconName: "share", route: "/science/projectile", category: "Science"),

        // Chemistry
        CalculatorItem(title: "Dilution", iconName: "flask", route: "/science/dilution", category: "Science"),
        CalculatorItem(title: "Ideal Gas Law", iconName: "cloud", route: "/science/idealgas", category: "Science"),

        // Gardening
        CalculatorItem(title: "Plant Spacing", iconName: "ruler_horizontal", route: "/lifestyle/spacing", category: "Lifestyle"),
        CalculatorItem(title: "Soil / Mulch", iconName: "trowel", route: "/lifestyle/soil", category: "Lifestyle"),

        // Sports / Lifestyle
        CalculatorItem(title: "Pizza Party", iconName: "pizza_slice", route: "/lifestyle/pizza", category: "Lifestyle"),
        CalculatorItem(title: "Cricket Run Rate", iconName: "baseball_bat_ball", route: "/lifestyle/cricket", category: "Lifestyle"),
        CalculatorItem(title: "Tennis Score", iconName: "table_tennis_paddle_ball", route: "/lifestyle/tennis", category: "Lifestyle"),

        // Text Tools
        CalculatorItem(title: "Base64 Converter", iconName: "code", route: "/text/base64", category: "Text Tools"),
        CalculatorItem(title: "Case Converter", iconName: "font", route: "/text/case", category: "Text Tools"),
        CalculatorItem(title: "Lorem Ipsum", iconName: "paragraph", route: "/text/lorem", category: "Text Tools"),
        CalculatorItem(title: "Reverse Text", iconName: "left_right", route: "/text/reverse", category: "Text Tools"),
        CalculatorItem(title: "Word Count", iconName: "align_left", route: "/text/wordcount", category: "Text Tools"),
        CalculatorItem(title: "JSON Formatter", iconName: "file_code", route: "/text/json", category: "Text Tools"),

        // Other
        CalculatorItem(title: "Age", iconName: "cake_candles", route: "/other/age", category: "Other"),
        CalculatorItem(title: "Construction", iconName: "trowel", route: "/other/construction", category: "Other"),
        CalculatorItem(title: "Date Calculator", iconName: "calendar_days", route: "/other/date", category: "Other"),
        CalculatorItem(title: "Flooring", iconName: "rug", route: "/other/flooring", category: "Other"),
        CalculatorItem(title: "Fuel Cost", iconName: "gas_pump", route: "/other/fuel", category: "Other"),
        CalculatorItem(title: "GPA Calculator", iconName: "graduation_cap", route: "/other/gpa", category: "Other"),
        CalculatorItem(title: "Grade Calculator", iconName: "a", route: "/other/grade", category: "Other"),
        CalculatorItem(title: "IP Subnet", iconName: "network_wired", route: "/other/ipsubnet", category: "Other"),
        CalculatorItem(title: "Password Gen", iconName: "key", route: "/other/password", category: "Other"),
        CalculatorItem(title: "Time Calculator", iconName: "clock", route: "/other/time", category: "Other"),
        CalculatorItem(title: "TV Size", iconName: "tv", route: "/other/tvsize", category: "Other"),
        CalculatorItem(title: "Work Hours", iconName: "briefcase", route: "/other/workhours", category: "Other")
    ]

    static let categories = [
        "Standard", "Scientific", "Finance", "Health", "Math",
        "Electronics", "Converters", "Lifestyle", "Science", "Text Tools", "Other"
    ]

    static func getCalculatorsByCategory(category: String) -> [CalculatorItem] {
        return allCalculators.filter { $0.category == category }
    }
}

