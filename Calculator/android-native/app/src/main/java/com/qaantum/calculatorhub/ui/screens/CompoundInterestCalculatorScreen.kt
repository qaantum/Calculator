package com.qaantum.calculatorhub.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Build
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.qaantum.calculatorhub.calculators.CompoundInterestCalculator
import com.qaantum.calculatorhub.calculators.CompoundInterestResult
import com.qaantum.calculatorhub.customcalculator.ForkCalculator
import com.qaantum.calculatorhub.customcalculator.CustomCalculatorService
import java.text.NumberFormat

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CompoundInterestCalculatorScreen(navController: androidx.navigation.NavController) {
    var principal by remember { mutableStateOf("") }
    var rate by remember { mutableStateOf("") }
    var years by remember { mutableStateOf("") }
    var contribution by remember { mutableStateOf("0") }
    var frequency by remember { mutableStateOf("12") }
    var result by remember { mutableStateOf<CompoundInterestResult?>(null) }
    var showCustomizeSheet by remember { mutableStateOf(false) }
    
    val calculator = remember { CompoundInterestCalculator() }
    val currencyFormat = remember { NumberFormat.getCurrencyInstance() }
    val context = LocalContext.current

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Compound Interest",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            OutlinedTextField(
                value = principal,
                onValueChange = { principal = it },
                label = { Text("Initial Investment") },
                leadingIcon = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
                    keyboardType = androidx.compose.ui.text.input.KeyboardType.Number
                )
            )

            OutlinedTextField(
                value = rate,
                onValueChange = { rate = it },
                label = { Text("Annual Interest Rate (%)") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
                    keyboardType = androidx.compose.ui.text.input.KeyboardType.Number
                )
            )

            OutlinedTextField(
                value = years,
                onValueChange = { years = it },
                label = { Text("Time Period (Years)") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
                    keyboardType = androidx.compose.ui.text.input.KeyboardType.Number
                )
            )

            OutlinedTextField(
                value = contribution,
                onValueChange = { contribution = it },
                label = { Text("Monthly Contribution (Optional)") },
                leadingIcon = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
                    keyboardType = androidx.compose.ui.text.input.KeyboardType.Number
                )
            )

            OutlinedTextField(
                value = frequency,
                onValueChange = { frequency = it },
                label = { Text("Compounds Per Year") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
                    keyboardType = androidx.compose.ui.text.input.KeyboardType.Number
                )
            )

            Button(
                onClick = {
                    try {
                        val principalValue = principal.toDouble()
                        val rateValue = rate.toDouble()
                        val yearsValue = years.toDouble()
                        val contributionValue = contribution.toDoubleOrNull() ?: 0.0
                        val frequencyValue = frequency.toDoubleOrNull() ?: 12.0

                        result = calculator.calculate(
                            principal = principalValue,
                            annualRate = rateValue,
                            years = yearsValue,
                            contribution = contributionValue,
                            compoundsPerYear = frequencyValue
                        )
                    } catch (e: Exception) {
                        // Handle error
                    }
                },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("Calculate")
            }

            result?.let { res ->
                Column(
                    modifier = Modifier.fillMaxWidth(),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    ResultCard("Future Value", currencyFormat.format(res.futureValue))
                    ResultCard("Total Contributions", currencyFormat.format(res.totalContributions))
                    ResultCard("Total Interest", currencyFormat.format(res.totalInterest))
                }
            }
        }
    }
}

@Composable
fun ResultCard(label: String, value: String) {
    Card(
        modifier = Modifier.fillMaxWidth()
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(
                text = label,
                style = MaterialTheme.typography.bodyLarge
            )
            Text(
                text = value,
                style = MaterialTheme.typography.bodyLarge,
                fontWeight = FontWeight.Bold
            )
        }
    }
}

