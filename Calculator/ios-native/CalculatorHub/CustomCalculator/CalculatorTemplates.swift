import Foundation

struct CalculatorTemplates {
    
    static let templates: [CustomCalculator] = [
        // ===== FINANCE =====
        CustomCalculator(
            title: "BMI Calculator",
            iconName: "scalemass",
            inputs: [
                CalculatorVariable(name: "weight", unitLabel: "kg", min: 0, description: "Body weight"),
                CalculatorVariable(name: "height", unitLabel: "m", min: 0, description: "Height in meters")
            ],
            formula: "weight / (height ^ 2)"
        ),
        
        CustomCalculator(
            title: "Compound Interest",
            iconName: "chart.line.uptrend.xyaxis",
            inputs: [
                CalculatorVariable(name: "principal", unitLabel: "$", min: 0, description: "Initial amount"),
                CalculatorVariable(name: "rate", unitLabel: "%", min: 0, description: "Annual interest rate"),
                CalculatorVariable(name: "years", unitLabel: "yr", min: 0, description: "Number of years"),
                CalculatorVariable(name: "n", unitLabel: "", min: 1, description: "Compounds per year (12=monthly)")
            ],
            formula: "principal * (1 + rate/100/n) ^ (n * years)"
        ),
        
        CustomCalculator(
            title: "Mortgage Payment",
            iconName: "house",
            inputs: [
                CalculatorVariable(name: "P", unitLabel: "$", min: 0, description: "Loan amount (principal)"),
                CalculatorVariable(name: "r", unitLabel: "%", min: 0, description: "Annual interest rate"),
                CalculatorVariable(name: "n", unitLabel: "yr", min: 1, description: "Loan term in years")
            ],
            formula: "(P * (r/1200) * (1 + r/1200)^(n*12)) / ((1 + r/1200)^(n*12) - 1)"
        ),
        
        CustomCalculator(
            title: "Tip Calculator",
            iconName: "fork.knife",
            inputs: [
                CalculatorVariable(name: "bill", unitLabel: "$", min: 0, description: "Bill amount"),
                CalculatorVariable(name: "tip", unitLabel: "%", min: 0, description: "Tip percentage"),
                CalculatorVariable(name: "people", unitLabel: "", min: 1, type: .integer, description: "Split between")
            ],
            formula: "(bill * (1 + tip/100)) / people"
        ),
        
        CustomCalculator(
            title: "ROI Calculator",
            iconName: "percent",
            inputs: [
                CalculatorVariable(name: "gain", unitLabel: "$", description: "Final value"),
                CalculatorVariable(name: "cost", unitLabel: "$", min: 0, description: "Initial investment")
            ],
            formula: "((gain - cost) / cost) * 100"
        ),
        
        CustomCalculator(
            title: "Rule of 72",
            iconName: "clock",
            inputs: [
                CalculatorVariable(name: "rate", unitLabel: "%", min: 0, description: "Annual growth rate")
            ],
            formula: "72 / rate"
        ),
        
        // ===== PHYSICS & SCIENCE =====
        CustomCalculator(
            title: "Force (F = ma)",
            iconName: "arrow.right.circle",
            inputs: [
                CalculatorVariable(name: "m", unitLabel: "kg", min: 0, description: "Mass"),
                CalculatorVariable(name: "a", unitLabel: "m/s²", description: "Acceleration")
            ],
            formula: "m * a"
        ),
        
        CustomCalculator(
            title: "Kinetic Energy",
            iconName: "bolt",
            inputs: [
                CalculatorVariable(name: "m", unitLabel: "kg", min: 0, description: "Mass"),
                CalculatorVariable(name: "v", unitLabel: "m/s", description: "Velocity")
            ],
            formula: "0.5 * m * v^2"
        ),
        
        CustomCalculator(
            title: "Gravitational Force",
            iconName: "globe",
            inputs: [
                CalculatorVariable(name: "m1", unitLabel: "kg", min: 0, description: "Mass 1"),
                CalculatorVariable(name: "m2", unitLabel: "kg", min: 0, description: "Mass 2"),
                CalculatorVariable(name: "r", unitLabel: "m", min: 0, description: "Distance between centers")
            ],
            formula: "6.674e-11 * m1 * m2 / r^2"
        ),
        
        CustomCalculator(
            title: "Ohm's Law (V = IR)",
            iconName: "bolt.horizontal",
            inputs: [
                CalculatorVariable(name: "I", unitLabel: "A", description: "Current"),
                CalculatorVariable(name: "R", unitLabel: "Ω", min: 0, description: "Resistance")
            ],
            formula: "I * R"
        ),
        
        CustomCalculator(
            title: "Projectile Range",
            iconName: "arrow.up.right",
            inputs: [
                CalculatorVariable(name: "v", unitLabel: "m/s", min: 0, description: "Initial velocity"),
                CalculatorVariable(name: "theta", unitLabel: "°", min: 0, max: 90, description: "Launch angle")
            ],
            formula: "(v^2 * sin(2 * theta * pi / 180)) / 9.81"
        ),
        
        CustomCalculator(
            title: "Wave Frequency",
            iconName: "waveform",
            inputs: [
                CalculatorVariable(name: "v", unitLabel: "m/s", min: 0, description: "Wave velocity"),
                CalculatorVariable(name: "lambda", unitLabel: "m", min: 0, description: "Wavelength")
            ],
            formula: "v / lambda"
        ),
        
        // ===== MATH =====
        CustomCalculator(
            title: "Quadratic Formula",
            iconName: "x.squareroot",
            inputs: [
                CalculatorVariable(name: "a", unitLabel: "", description: "Coefficient a"),
                CalculatorVariable(name: "b", unitLabel: "", description: "Coefficient b"),
                CalculatorVariable(name: "c", unitLabel: "", description: "Coefficient c")
            ],
            formula: "(-b + sqrt(b^2 - 4*a*c)) / (2*a)"
        ),
        
        CustomCalculator(
            title: "Circle Area",
            iconName: "circle",
            inputs: [
                CalculatorVariable(name: "r", unitLabel: "m", min: 0, description: "Radius")
            ],
            formula: "pi * r^2"
        ),
        
        CustomCalculator(
            title: "Sphere Volume",
            iconName: "circle.fill",
            inputs: [
                CalculatorVariable(name: "r", unitLabel: "m", min: 0, description: "Radius")
            ],
            formula: "(4/3) * pi * r^3"
        ),
        
        CustomCalculator(
            title: "Pythagorean Theorem",
            iconName: "triangle",
            inputs: [
                CalculatorVariable(name: "a", unitLabel: "", min: 0, description: "Side a"),
                CalculatorVariable(name: "b", unitLabel: "", min: 0, description: "Side b")
            ],
            formula: "sqrt(a^2 + b^2)"
        ),
        
        CustomCalculator(
            title: "Distance Formula",
            iconName: "ruler",
            inputs: [
                CalculatorVariable(name: "x1", unitLabel: "", description: "Point 1 X"),
                CalculatorVariable(name: "y1", unitLabel: "", description: "Point 1 Y"),
                CalculatorVariable(name: "x2", unitLabel: "", description: "Point 2 X"),
                CalculatorVariable(name: "y2", unitLabel: "", description: "Point 2 Y")
            ],
            formula: "sqrt((x2-x1)^2 + (y2-y1)^2)"
        ),
        
        // ===== HEALTH =====
        CustomCalculator(
            title: "BMR (Mifflin-St Jeor)",
            iconName: "flame",
            inputs: [
                CalculatorVariable(name: "weight", unitLabel: "kg", min: 0, description: "Weight"),
                CalculatorVariable(name: "height", unitLabel: "cm", min: 0, description: "Height"),
                CalculatorVariable(name: "age", unitLabel: "yr", min: 0, description: "Age"),
                CalculatorVariable(name: "s", unitLabel: "", description: "+5 for male, -161 for female")
            ],
            formula: "10*weight + 6.25*height - 5*age + s"
        ),
        
        CustomCalculator(
            title: "Target Heart Rate",
            iconName: "heart",
            inputs: [
                CalculatorVariable(name: "age", unitLabel: "yr", min: 0, description: "Age"),
                CalculatorVariable(name: "resting", unitLabel: "bpm", min: 0, description: "Resting heart rate"),
                CalculatorVariable(name: "intensity", unitLabel: "%", min: 50, max: 100, description: "Intensity")
            ],
            formula: "((220 - age) - resting) * (intensity/100) + resting"
        ),
        
        CustomCalculator(
            title: "Water Intake",
            iconName: "drop",
            inputs: [
                CalculatorVariable(name: "weight", unitLabel: "kg", min: 0, description: "Body weight")
            ],
            formula: "weight * 35"
        ),
        
        // ===== CONVERSIONS =====
        CustomCalculator(
            title: "Celsius to Fahrenheit",
            iconName: "thermometer",
            inputs: [
                CalculatorVariable(name: "C", unitLabel: "°C", description: "Temperature in Celsius")
            ],
            formula: "C * 9/5 + 32"
        ),
        
        CustomCalculator(
            title: "Fahrenheit to Celsius",
            iconName: "thermometer",
            inputs: [
                CalculatorVariable(name: "F", unitLabel: "°F", description: "Temperature in Fahrenheit")
            ],
            formula: "(F - 32) * 5/9"
        ),
        
        CustomCalculator(
            title: "Km to Miles",
            iconName: "car",
            inputs: [
                CalculatorVariable(name: "km", unitLabel: "km", min: 0, description: "Distance in kilometers")
            ],
            formula: "km * 0.621371"
        ),
        
        CustomCalculator(
            title: "Kg to Pounds",
            iconName: "scalemass",
            inputs: [
                CalculatorVariable(name: "kg", unitLabel: "kg", min: 0, description: "Weight in kilograms")
            ],
            formula: "kg * 2.20462"
        ),
        
        // ===== ADVANCED MATH =====
        CustomCalculator(
            title: "Definite Integral ∫x² dx",
            iconName: "function",
            inputs: [
                CalculatorVariable(name: "a", unitLabel: "", description: "Lower bound"),
                CalculatorVariable(name: "b", unitLabel: "", description: "Upper bound")
            ],
            formula: "integrate(x^2, x, a, b)"
        ),
        
        CustomCalculator(
            title: "Derivative at Point",
            iconName: "chart.xyaxis.line",
            inputs: [
                CalculatorVariable(name: "x", unitLabel: "", description: "Point to evaluate")
            ],
            formula: "deriv(x^3, x, x)"
        ),
        
        CustomCalculator(
            title: "Logarithm (any base)",
            iconName: "function",
            inputs: [
                CalculatorVariable(name: "x", unitLabel: "", min: 0, description: "Value"),
                CalculatorVariable(name: "base", unitLabel: "", min: 0, description: "Base")
            ],
            formula: "log(x, base)"
        ),
        
        CustomCalculator(
            title: "Trigonometry",
            iconName: "triangle.fill",
            inputs: [
                CalculatorVariable(name: "angle", unitLabel: "rad", description: "Angle in radians")
            ],
            formula: "sin(angle)^2 + cos(angle)^2"
        ),
        
        // ===== DATE & TIME =====
        CustomCalculator(
            title: "Days Between Dates",
            iconName: "calendar",
            inputs: [
                CalculatorVariable(name: "start", unitLabel: "", type: .date, description: "Start date"),
                CalculatorVariable(name: "end", unitLabel: "", type: .date, description: "End date")
            ],
            formula: "daysBetween(start, end)"
        ),
        
        CustomCalculator(
            title: "Age Calculator",
            iconName: "gift",
            inputs: [
                CalculatorVariable(name: "birthdate", unitLabel: "", type: .date, description: "Date of birth")
            ],
            formula: "floor(age(birthdate))"
        )
    ]
    
    // Mapping from existing calculator routes to template formulas for "Fork" feature
    static let routeToTemplate: [String: CustomCalculator] = {
        var map: [String: CustomCalculator] = [:]
        map["/health/bmi"] = templates.first { $0.title == "BMI Calculator" }
        map["/finance/interest/compound"] = templates.first { $0.title == "Compound Interest" }
        map["/finance/mortgage"] = templates.first { $0.title == "Mortgage Payment" }
        map["/finance/tip"] = templates.first { $0.title == "Tip Calculator" }
        map["/finance/roi"] = templates.first { $0.title == "ROI Calculator" }
        map["/electronics/ohms-law"] = templates.first { $0.title == "Ohm's Law (V = IR)" }
        map["/math/quadratic"] = templates.first { $0.title == "Quadratic Formula" }
        map["/health/bmr"] = templates.first { $0.title == "BMR (Mifflin-St Jeor)" }
        map["/health/heart-rate"] = templates.first { $0.title == "Target Heart Rate" }
        map["/other/age"] = templates.first { $0.title == "Age Calculator" }
        return map
    }()
    
    static func getTemplateForRoute(_ route: String) -> CustomCalculator? {
        return routeToTemplate[route]
    }
}
