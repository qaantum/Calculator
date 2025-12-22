package com.qaantum.calculatorhub.ui.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.qaantum.calculatorhub.ui.screens.HomeScreen
import com.qaantum.calculatorhub.ui.screens.StandardCalculatorScreen
import com.qaantum.calculatorhub.ui.screens.ScientificCalculatorScreen
import com.qaantum.calculatorhub.ui.screens.BMICalculatorScreen
import com.qaantum.calculatorhub.ui.screens.CompoundInterestCalculatorScreen

@Composable
fun CalculatorNavigation() {
    val navController = rememberNavController()

    NavHost(
        navController = navController,
        startDestination = "home"
    ) {
        composable("home") {
            HomeScreen(navController = navController)
        }
        composable("/standard") {
            StandardCalculatorScreen()
        }
        composable("/scientific") {
            ScientificCalculatorScreen()
        }
        composable("/health/bmi") {
            BMICalculatorScreen()
        }
        composable("/finance/interest/compound") {
            CompoundInterestCalculatorScreen()
        }
        // Add more routes as we migrate calculators
    }
}

