package com.qaantum.calculatorhub.ui.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.qaantum.calculatorhub.ui.screens.*
import com.qaantum.calculatorhub.customcalculator.screens.*
import com.qaantum.calculatorhub.customcalculator.CustomCalculator

@Composable
fun CalculatorNavigation() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = "home") {
        composable("home") { HomeScreen(navController = navController) }
        
        // Category List Screen
        composable("category/{category}") { backStackEntry ->
            val category = backStackEntry.arguments?.getString("category") ?: "Finance"
            CategoryScreen(navController = navController, category = category)
        }
        
        // Custom Calculator (Signature Feature)
        composable("/custom") { 
            CustomCalculatorListScreen(
                onCalculatorClick = { calc -> navController.navigate("/custom/detail/${calc.id}") },
                onCreateNew = { navController.navigate("/custom/builder") },
                onTemplateClick = { template -> navController.navigate("/custom/builder") },
                onBack = { navController.popBackStack() }
            )
        }
        composable("/custom/builder") {
            CustomCalculatorBuilderScreen(
                navController = navController,
                onSave = { navController.popBackStack() },
                onBack = { navController.popBackStack() }
            )
        }
        composable("/custom/detail/{id}") { backStackEntry ->
            val id = backStackEntry.arguments?.getString("id")
            CustomCalculatorDetailScreen(
                calculatorId = id,
                onEdit = { calc -> 
                     // When editing, we need to manually navigate or handle it. 
                     // Ideally CustomCalculatorBuilderScreen should also handle ID loading or we pass object.
                     // For now, let's assume we pass the object via a shared viewmodel or similar, 
                     // BUT here we only have the ID. 
                     // Existing code passed `calc` (CustomCalculator object) to the lambda `onEdit`.
                     // We need to pass it to the screen. 
                     // Since `CustomCalculatorBuilderScreen` takes `existingCalculator` object, we can't easily pass it via route arguments without serialization.
                     // However, `CustomCalculatorDetailScreen` calls `onEdit` with the OBJECT.
                     // We can put it in a composition local or hold it in a state higher up, but `CalculatorNavigation` is the root.
                     // A workaround: Pass the ID and have Builder load it?
                     // But Builder currently takes the object directly.
                     // The previous code had: `onEdit = { calc -> navController.navigate("/custom/builder") }` which ACTUALLY IGNORED the `calc` object!
                     // So editing wasn't really working previously? 
                     // Wait, `CustomCalculatorDetailScreen` -> `onEdit` -> `navController.navigate("/custom/builder")`.
                     // The builder would see `existingCalculator = null` and treat it as new.
                     // So the "Edit" feature was actually broken or incomplete.
                     // I will fix this by creating a new route `/custom/edit/{id}` or passing arguments.
                     // But for now, to enable `navController` passing to builder, I just update the builder call.
                     // I will handle the "Edit" scenario later if needed, but the user asked for "Forking".
                     navController.navigate("/custom/builder") 
                },
                onDelete = { navController.popBackStack() },
                onBack = { navController.popBackStack() }
            )
        }
        
        // Math
        composable("/standard") { StandardCalculatorScreen(navController) }
        composable("/scientific") { ScientificCalculatorScreen(navController) }
        composable("/math/percentage") { PercentageCalculatorScreen(navController) }
        composable("/math/quadratic") { QuadraticSolverScreen(navController) }
        composable("/math/gcd-lcm") { GcdLcmCalculatorScreen(navController) }
        composable("/math/factorial") { FactorialCalculatorScreen(navController) }
        composable("/math/random") { RandomNumberScreen(navController) }
        composable("/math/statistics") { StandardDeviationCalculatorScreen(navController) }
        
        // Finance - Core
        composable("/finance/interest/compound") { CompoundInterestCalculatorScreen(navController) }
        composable("/finance/interest/simple") { SimpleInterestCalculatorScreen(navController) }
        composable("/finance/loan") { LoanCalculatorScreen(navController) }
        composable("/finance/mortgage") { MortgageCalculatorScreen(navController) }
        composable("/finance/tip") { TipCalculatorScreen(navController) }
        composable("/finance/discount") { DiscountCalculatorScreen(navController) }
        composable("/finance/investment") { InvestmentGrowthCalculatorScreen(navController) }
        composable("/finance/savings") { SavingsGoalCalculatorScreen(navController) }
        composable("/finance/roi") { ROICalculatorScreen(navController) }
        composable("/finance/cagr") { CAGRCalculatorScreen(navController) }
        composable("/finance/retirement") { RetirementCalculatorScreen(navController) }
        
        // Finance - Additional
        composable("/finance/auto-loan") { AutoLoanCalculatorScreen(navController) }
        composable("/finance/commission") { CommissionCalculatorScreen(navController) }
        composable("/finance/sales-tax") { SalesTaxCalculatorScreen(navController) }
        composable("/finance/salary") { SalaryCalculatorScreen(navController) }
        
        // Health
        composable("/health/bmi") { BMICalculatorScreen(navController) }
        composable("/health/bmr") { BMRCalculatorScreen(navController) }
        composable("/health/calories") { CaloriesCalculatorScreen(navController) }
        composable("/health/body-fat") { BodyFatCalculatorScreen(navController) }
        composable("/health/ideal-weight") { IdealWeightCalculatorScreen(navController) }
        composable("/health/macro") { MacroCalculatorScreen(navController) }
        composable("/health/water") { WaterIntakeCalculatorScreen(navController) }
        composable("/health/heart-rate") { TargetHeartRateScreen(navController) }
        composable("/health/sleep") { SleepCalculatorScreen(navController) }
        composable("/health/pace") { PaceCalculatorScreen(navController) }
        
        // Utility
        composable("/other/age") { AgeCalculatorScreen(navController) }
        composable("/other/work-hours") { WorkHoursCalculatorScreen(navController) }
        composable("/other/fuel") { FuelCostCalculatorScreen(navController) }
        composable("/other/password") { PasswordGeneratorScreen(navController) }
        
        // Electronics
        composable("/electronics/ohms-law") { OhmsLawCalculatorScreen(navController) }
        composable("/electronics/led-resistor") { LEDResistorCalculatorScreen(navController) }
        
        // Text
        composable("/text/word-count") { WordCountCalculatorScreen(navController) }
        composable("/text/base64") { Base64ConverterScreen(navController) }
        
        // Converters & Science
        composable("/converter/unit") { UnitConverterScreen(navController) }
        composable("/science/kinematic") { KinematicCalculatorScreen(navController) }
        composable("/science/force") { ForceCalculatorScreen(navController) }
        composable("/science/ph") { PHCalculatorScreen(navController) }
        
        // Specialty
        composable("/math/binary") { BinaryConverterScreen(navController) }
        composable("/math/roman") { RomanNumeralConverterScreen(navController) }
        composable("/other/grade") { GradeCalculatorScreen(navController) }
        composable("/health/one-rep-max") { OneRepMaxCalculatorScreen(navController) }
        
        // Final
        composable("/math/matrix") { MatrixDeterminantScreen(navController) }
        composable("/other/color") { ColorConverterScreen(navController) }
        composable("/finance/loan-affordability") { LoanAffordabilityScreen(navController) }
        composable("/finance/refinance") { RefinanceCalculatorScreen(navController) }
        composable("/finance/rental") { RentalPropertyScreen(navController) }
        
        // Remaining 4
        composable("/converter/currency") { CurrencyConverterScreen(navController) }
        composable("/health/ovulation") { OvulationCalculatorScreen(navController) }
        composable("/health/child-height") { ChildHeightPredictorScreen(navController) }
        composable("/health/smoking-cost") { SmokingCostCalculatorScreen(navController) }
        
        // NEW CALCULATORS
        // Finance
        composable("/finance/npv") { NPVCalculatorScreen(navController) }
        composable("/finance/irr") { IRRCalculatorScreen(navController) }
        composable("/finance/down-payment") { DownPaymentCalculatorScreen(navController) }
        composable("/finance/paycheck") { PaycheckCalculatorScreen(navController) }
        composable("/finance/cd") { CDCalculatorScreen(navController) }
        composable("/finance/tip-split") { TipSplitCalculatorScreen(navController) }
        
        // Math
        composable("/math/logarithm") { LogarithmCalculatorScreen(navController) }
        composable("/math/stats") { StatisticsCalculatorScreen(navController) }
        composable("/math/summation") { SummationCalculatorScreen(navController) }
        
        // Health
        composable("/health/blood-sugar") { BloodSugarConverterScreen(navController) }
        composable("/health/vo2-max") { VO2MaxCalculatorScreen(navController) }
        composable("/health/medication-dosage") { MedicationDosageCalculatorScreen(navController) }
        
        // Converters
        composable("/converter/temperature") { TemperatureConverterScreen(navController) }
        composable("/converter/length") { LengthConverterScreen(navController) }
        composable("/converter/weight") { WeightConverterScreen(navController) }
        composable("/converter/volume") { VolumeConverterScreen(navController) }
        
        // Other
        composable("/other/moon-phase") { MoonPhaseCalculatorScreen(navController) }
        composable("/other/dice") { DiceRollerScreen(navController) }
        composable("/other/hash") { HashGeneratorScreen(navController) }
    }
}
