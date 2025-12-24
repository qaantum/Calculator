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
                onSave = { navController.popBackStack() },
                onBack = { navController.popBackStack() }
            )
        }
        composable("/custom/detail/{id}") { backStackEntry ->
            val id = backStackEntry.arguments?.getString("id")
            CustomCalculatorDetailScreen(
                calculatorId = id,
                onEdit = { calc -> navController.navigate("/custom/builder") },
                onDelete = { navController.popBackStack() },
                onBack = { navController.popBackStack() }
            )
        }
        
        // Math
        composable("/standard") { StandardCalculatorScreen() }
        composable("/scientific") { ScientificCalculatorScreen() }
        composable("/math/percentage") { PercentageCalculatorScreen() }
        composable("/math/quadratic") { QuadraticSolverScreen() }
        composable("/math/gcd-lcm") { GcdLcmCalculatorScreen() }
        composable("/math/factorial") { FactorialCalculatorScreen() }
        composable("/math/random") { RandomNumberScreen() }
        composable("/math/statistics") { StandardDeviationCalculatorScreen() }
        
        // Finance - Core
        composable("/finance/interest/compound") { CompoundInterestCalculatorScreen() }
        composable("/finance/interest/simple") { SimpleInterestCalculatorScreen() }
        composable("/finance/loan") { LoanCalculatorScreen() }
        composable("/finance/mortgage") { MortgageCalculatorScreen() }
        composable("/finance/tip") { TipCalculatorScreen() }
        composable("/finance/discount") { DiscountCalculatorScreen() }
        composable("/finance/investment") { InvestmentGrowthCalculatorScreen() }
        composable("/finance/savings") { SavingsGoalCalculatorScreen() }
        composable("/finance/roi") { ROICalculatorScreen() }
        composable("/finance/cagr") { CAGRCalculatorScreen() }
        composable("/finance/retirement") { RetirementCalculatorScreen() }
        
        // Finance - Additional
        composable("/finance/auto-loan") { AutoLoanCalculatorScreen() }
        composable("/finance/commission") { CommissionCalculatorScreen() }
        composable("/finance/sales-tax") { SalesTaxCalculatorScreen() }
        composable("/finance/salary") { SalaryCalculatorScreen() }
        
        // Health
        composable("/health/bmi") { BMICalculatorScreen() }
        composable("/health/bmr") { BMRCalculatorScreen() }
        composable("/health/calories") { CaloriesCalculatorScreen() }
        composable("/health/body-fat") { BodyFatCalculatorScreen() }
        composable("/health/ideal-weight") { IdealWeightCalculatorScreen() }
        composable("/health/macro") { MacroCalculatorScreen() }
        composable("/health/water") { WaterIntakeCalculatorScreen() }
        composable("/health/heart-rate") { TargetHeartRateScreen() }
        composable("/health/sleep") { SleepCalculatorScreen() }
        composable("/health/pace") { PaceCalculatorScreen() }
        
        // Utility
        composable("/other/age") { AgeCalculatorScreen() }
        composable("/other/work-hours") { WorkHoursCalculatorScreen() }
        composable("/other/fuel") { FuelCostCalculatorScreen() }
        composable("/other/password") { PasswordGeneratorScreen() }
        
        // Electronics
        composable("/electronics/ohms-law") { OhmsLawCalculatorScreen() }
        composable("/electronics/led-resistor") { LEDResistorCalculatorScreen() }
        
        // Text
        composable("/text/word-count") { WordCountCalculatorScreen() }
        composable("/text/base64") { Base64ConverterScreen() }
        
        // Converters & Science
        composable("/converter/unit") { UnitConverterScreen() }
        composable("/science/kinematic") { KinematicCalculatorScreen() }
        composable("/science/force") { ForceCalculatorScreen() }
        composable("/science/ph") { PHCalculatorScreen() }
        
        // Specialty
        composable("/math/binary") { BinaryConverterScreen() }
        composable("/math/roman") { RomanNumeralConverterScreen() }
        composable("/other/grade") { GradeCalculatorScreen() }
        composable("/health/one-rep-max") { OneRepMaxCalculatorScreen() }
        
        // Final
        composable("/math/matrix") { MatrixDeterminantScreen() }
        composable("/other/color") { ColorConverterScreen() }
        composable("/finance/loan-affordability") { LoanAffordabilityScreen() }
        composable("/finance/refinance") { RefinanceCalculatorScreen() }
        composable("/finance/rental") { RentalPropertyScreen() }
        
        // Remaining 4
        composable("/converter/currency") { CurrencyConverterScreen() }
        composable("/health/ovulation") { OvulationCalculatorScreen() }
        composable("/health/child-height") { ChildHeightPredictorScreen() }
        composable("/health/smoking-cost") { SmokingCostCalculatorScreen() }
    }
}
