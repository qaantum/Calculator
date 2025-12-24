package com.qaantum.calculatorhub.customcalculator

object CalculatorTemplates {
    
    val templates: List<CustomCalculator> = listOf(
        // ===== FINANCE =====
        CustomCalculator(
            title = "BMI Calculator",
            iconName = "weight_scale",
            inputs = listOf(
                CalculatorVariable(name = "weight", unitLabel = "kg", min = 0.0, description = "Body weight"),
                CalculatorVariable(name = "height", unitLabel = "m", min = 0.0, description = "Height in meters")
            ),
            formula = "weight / (height ^ 2)"
        ),
        
        CustomCalculator(
            title = "Compound Interest",
            iconName = "trending_up",
            inputs = listOf(
                CalculatorVariable(name = "principal", unitLabel = "$", min = 0.0, description = "Initial amount"),
                CalculatorVariable(name = "rate", unitLabel = "%", min = 0.0, description = "Annual interest rate"),
                CalculatorVariable(name = "years", unitLabel = "yr", min = 0.0, description = "Number of years"),
                CalculatorVariable(name = "n", unitLabel = "", min = 1.0, description = "Compounds per year (12=monthly)")
            ),
            formula = "principal * (1 + rate/100/n) ^ (n * years)"
        ),
        
        CustomCalculator(
            title = "Mortgage Payment",
            iconName = "house",
            inputs = listOf(
                CalculatorVariable(name = "P", unitLabel = "$", min = 0.0, description = "Loan amount (principal)"),
                CalculatorVariable(name = "r", unitLabel = "%", min = 0.0, description = "Annual interest rate"),
                CalculatorVariable(name = "n", unitLabel = "yr", min = 1.0, description = "Loan term in years")
            ),
            formula = "(P * (r/1200) * (1 + r/1200)^(n*12)) / ((1 + r/1200)^(n*12) - 1)"
        ),
        
        CustomCalculator(
            title = "Tip Calculator",
            iconName = "restaurant",
            inputs = listOf(
                CalculatorVariable(name = "bill", unitLabel = "$", min = 0.0, description = "Bill amount"),
                CalculatorVariable(name = "tip", unitLabel = "%", min = 0.0, description = "Tip percentage"),
                CalculatorVariable(name = "people", unitLabel = "", min = 1.0, type = VariableType.INTEGER, description = "Split between")
            ),
            formula = "(bill * (1 + tip/100)) / people"
        ),
        
        CustomCalculator(
            title = "ROI Calculator",
            iconName = "chart_line",
            inputs = listOf(
                CalculatorVariable(name = "gain", unitLabel = "$", description = "Final value"),
                CalculatorVariable(name = "cost", unitLabel = "$", min = 0.0, description = "Initial investment")
            ),
            formula = "((gain - cost) / cost) * 100"
        ),
        
        CustomCalculator(
            title = "Rule of 72",
            iconName = "timer",
            inputs = listOf(
                CalculatorVariable(name = "rate", unitLabel = "%", min = 0.0, description = "Annual growth rate")
            ),
            formula = "72 / rate"
        ),
        
        // ===== PHYSICS & SCIENCE =====
        CustomCalculator(
            title = "Force (F = ma)",
            iconName = "science",
            inputs = listOf(
                CalculatorVariable(name = "m", unitLabel = "kg", min = 0.0, description = "Mass"),
                CalculatorVariable(name = "a", unitLabel = "m/s²", description = "Acceleration")
            ),
            formula = "m * a"
        ),
        
        CustomCalculator(
            title = "Kinetic Energy",
            iconName = "bolt",
            inputs = listOf(
                CalculatorVariable(name = "m", unitLabel = "kg", min = 0.0, description = "Mass"),
                CalculatorVariable(name = "v", unitLabel = "m/s", description = "Velocity")
            ),
            formula = "0.5 * m * v^2"
        ),
        
        CustomCalculator(
            title = "Gravitational Force",
            iconName = "public",
            inputs = listOf(
                CalculatorVariable(name = "m1", unitLabel = "kg", min = 0.0, description = "Mass 1"),
                CalculatorVariable(name = "m2", unitLabel = "kg", min = 0.0, description = "Mass 2"),
                CalculatorVariable(name = "r", unitLabel = "m", min = 0.0, description = "Distance between centers")
            ),
            formula = "6.674e-11 * m1 * m2 / r^2"
        ),
        
        CustomCalculator(
            title = "Ohm's Law (V = IR)",
            iconName = "electrical_services",
            inputs = listOf(
                CalculatorVariable(name = "I", unitLabel = "A", description = "Current"),
                CalculatorVariable(name = "R", unitLabel = "Ω", min = 0.0, description = "Resistance")
            ),
            formula = "I * R"
        ),
        
        CustomCalculator(
            title = "Projectile Range",
            iconName = "sports_baseball",
            inputs = listOf(
                CalculatorVariable(name = "v", unitLabel = "m/s", min = 0.0, description = "Initial velocity"),
                CalculatorVariable(name = "theta", unitLabel = "°", min = 0.0, max = 90.0, description = "Launch angle")
            ),
            formula = "(v^2 * sin(2 * theta * pi / 180)) / 9.81"
        ),
        
        CustomCalculator(
            title = "Wave Frequency",
            iconName = "waves",
            inputs = listOf(
                CalculatorVariable(name = "v", unitLabel = "m/s", min = 0.0, description = "Wave velocity"),
                CalculatorVariable(name = "lambda", unitLabel = "m", min = 0.0, description = "Wavelength")
            ),
            formula = "v / lambda"
        ),
        
        // ===== MATH =====
        CustomCalculator(
            title = "Quadratic Formula",
            iconName = "functions",
            inputs = listOf(
                CalculatorVariable(name = "a", unitLabel = "", description = "Coefficient a"),
                CalculatorVariable(name = "b", unitLabel = "", description = "Coefficient b"),
                CalculatorVariable(name = "c", unitLabel = "", description = "Coefficient c")
            ),
            formula = "(-b + sqrt(b^2 - 4*a*c)) / (2*a)"
        ),
        
        CustomCalculator(
            title = "Circle Area",
            iconName = "circle",
            inputs = listOf(
                CalculatorVariable(name = "r", unitLabel = "m", min = 0.0, description = "Radius")
            ),
            formula = "pi * r^2"
        ),
        
        CustomCalculator(
            title = "Sphere Volume",
            iconName = "sports_baseball",
            inputs = listOf(
                CalculatorVariable(name = "r", unitLabel = "m", min = 0.0, description = "Radius")
            ),
            formula = "(4/3) * pi * r^3"
        ),
        
        CustomCalculator(
            title = "Pythagorean Theorem",
            iconName = "square_foot",
            inputs = listOf(
                CalculatorVariable(name = "a", unitLabel = "", min = 0.0, description = "Side a"),
                CalculatorVariable(name = "b", unitLabel = "", min = 0.0, description = "Side b")
            ),
            formula = "sqrt(a^2 + b^2)"
        ),
        
        CustomCalculator(
            title = "Distance Formula",
            iconName = "straighten",
            inputs = listOf(
                CalculatorVariable(name = "x1", unitLabel = "", description = "Point 1 X"),
                CalculatorVariable(name = "y1", unitLabel = "", description = "Point 1 Y"),
                CalculatorVariable(name = "x2", unitLabel = "", description = "Point 2 X"),
                CalculatorVariable(name = "y2", unitLabel = "", description = "Point 2 Y")
            ),
            formula = "sqrt((x2-x1)^2 + (y2-y1)^2)"
        ),
        
        // ===== HEALTH =====
        CustomCalculator(
            title = "BMR (Mifflin-St Jeor)",
            iconName = "local_fire_department",
            inputs = listOf(
                CalculatorVariable(name = "weight", unitLabel = "kg", min = 0.0, description = "Weight"),
                CalculatorVariable(name = "height", unitLabel = "cm", min = 0.0, description = "Height"),
                CalculatorVariable(name = "age", unitLabel = "yr", min = 0.0, description = "Age"),
                CalculatorVariable(name = "s", unitLabel = "", description = "+5 for male, -161 for female")
            ),
            formula = "10*weight + 6.25*height - 5*age + s"
        ),
        
        CustomCalculator(
            title = "Target Heart Rate",
            iconName = "favorite",
            inputs = listOf(
                CalculatorVariable(name = "age", unitLabel = "yr", min = 0.0, description = "Age"),
                CalculatorVariable(name = "resting", unitLabel = "bpm", min = 0.0, description = "Resting heart rate"),
                CalculatorVariable(name = "intensity", unitLabel = "%", min = 50.0, max = 100.0, description = "Intensity")
            ),
            formula = "((220 - age) - resting) * (intensity/100) + resting"
        ),
        
        CustomCalculator(
            title = "Water Intake",
            iconName = "water_drop",
            inputs = listOf(
                CalculatorVariable(name = "weight", unitLabel = "kg", min = 0.0, description = "Body weight")
            ),
            formula = "weight * 35"
        ),
        
        // ===== CONVERSIONS =====
        CustomCalculator(
            title = "Celsius to Fahrenheit",
            iconName = "thermostat",
            inputs = listOf(
                CalculatorVariable(name = "C", unitLabel = "°C", description = "Temperature in Celsius")
            ),
            formula = "C * 9/5 + 32"
        ),
        
        CustomCalculator(
            title = "Fahrenheit to Celsius",
            iconName = "thermostat",
            inputs = listOf(
                CalculatorVariable(name = "F", unitLabel = "°F", description = "Temperature in Fahrenheit")
            ),
            formula = "(F - 32) * 5/9"
        ),
        
        CustomCalculator(
            title = "Km to Miles",
            iconName = "directions_car",
            inputs = listOf(
                CalculatorVariable(name = "km", unitLabel = "km", min = 0.0, description = "Distance in kilometers")
            ),
            formula = "km * 0.621371"
        ),
        
        CustomCalculator(
            title = "Kg to Pounds",
            iconName = "fitness_center",
            inputs = listOf(
                CalculatorVariable(name = "kg", unitLabel = "kg", min = 0.0, description = "Weight in kilograms")
            ),
            formula = "kg * 2.20462"
        ),
        
        // ===== ADVANCED MATH =====
        CustomCalculator(
            title = "Definite Integral ∫x² dx",
            iconName = "functions",
            inputs = listOf(
                CalculatorVariable(name = "a", unitLabel = "", description = "Lower bound"),
                CalculatorVariable(name = "b", unitLabel = "", description = "Upper bound")
            ),
            formula = "integrate(x^2, x, a, b)"
        ),
        
        CustomCalculator(
            title = "Derivative at Point",
            iconName = "show_chart",
            inputs = listOf(
                CalculatorVariable(name = "x", unitLabel = "", description = "Point to evaluate")
            ),
            formula = "deriv(x^3, x, x)"
        ),
        
        CustomCalculator(
            title = "Logarithm (any base)",
            iconName = "functions",
            inputs = listOf(
                CalculatorVariable(name = "x", unitLabel = "", min = 0.0, description = "Value"),
                CalculatorVariable(name = "base", unitLabel = "", min = 0.0, description = "Base")
            ),
            formula = "log(x, base)"
        ),
        
        CustomCalculator(
            title = "Trigonometry",
            iconName = "change_history",
            inputs = listOf(
                CalculatorVariable(name = "angle", unitLabel = "rad", description = "Angle in radians")
            ),
            formula = "sin(angle)^2 + cos(angle)^2"
        ),
        
        // ===== DATE & TIME =====
        CustomCalculator(
            title = "Days Between Dates",
            iconName = "event",
            inputs = listOf(
                CalculatorVariable(name = "start", unitLabel = "", type = VariableType.DATE, description = "Start date"),
                CalculatorVariable(name = "end", unitLabel = "", type = VariableType.DATE, description = "End date")
            ),
            formula = "daysBetween(start, end)"
        ),
        
        CustomCalculator(
            title = "Age Calculator",
            iconName = "cake",
            inputs = listOf(
                CalculatorVariable(name = "birthdate", unitLabel = "", type = VariableType.DATE, description = "Date of birth")
            ),
            formula = "floor(age(birthdate))"
        )
    )
    
    // Mapping from existing calculator routes to template formulas for "Fork" feature
    val routeToTemplate: Map<String, CustomCalculator> by lazy {
        mapOf(
            "/health/bmi" to templates.first { it.title == "BMI Calculator" },
            "/finance/interest/compound" to templates.first { it.title == "Compound Interest" },
            "/finance/mortgage" to templates.first { it.title == "Mortgage Payment" },
            "/finance/tip" to templates.first { it.title == "Tip Calculator" },
            "/finance/roi" to templates.first { it.title == "ROI Calculator" },
            "/electronics/ohms-law" to templates.first { it.title == "Ohm's Law (V = IR)" },
            "/math/quadratic" to templates.first { it.title == "Quadratic Formula" },
            "/health/bmr" to templates.first { it.title == "BMR (Mifflin-St Jeor)" },
            "/health/heart-rate" to templates.first { it.title == "Target Heart Rate" },
            "/other/age" to templates.first { it.title == "Age Calculator" }
        )
    }
    
    fun getTemplateForRoute(route: String): CustomCalculator? {
        return routeToTemplate[route]
    }
}
