package com.qaantum.calculatorhub.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.qaantum.calculatorhub.calculators.LoanCalculator
import com.qaantum.calculatorhub.calculators.LoanResult
import java.text.NumberFormat
import java.util.Locale

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LoanCalculatorScreen(navController: androidx.navigation.NavController) {
    var amount by remember { mutableStateOf("") }
    var rate by remember { mutableStateOf("") }
    var term by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<LoanResult?>(null) }

    val calculator = remember { LoanCalculator() }
    val currencyFormat = remember { NumberFormat.getCurrencyInstance(Locale.US) }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Loan Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(16.dp)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            OutlinedTextField(
                value = amount,
                onValueChange = { amount = it },
                label = { Text("Loan Amount") },
                prefix = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )

            OutlinedTextField(
                value = rate,
                onValueChange = { rate = it },
                label = { Text("Interest Rate") },
                suffix = { Text("%") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )

            OutlinedTextField(
                value = term,
                onValueChange = { term = it },
                label = { Text("Loan Term (Months)") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number)
            )

            Button(
                onClick = {
                    try {
                        val amountVal = amount.toDouble()
                        val rateVal = rate.toDouble()
                        val termVal = term.toInt()
                        result = calculator.calculate(amountVal, rateVal, termVal)
                    } catch (e: Exception) {
                        // Handle error
                    }
                },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("Calculate", modifier = Modifier.padding(8.dp))
            }

            result?.let { res ->
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.secondaryContainer
                    )
                ) {
                    Column(
                        modifier = Modifier.padding(24.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text(
                            "Monthly Payment",
                            style = MaterialTheme.typography.titleMedium
                        )
                        Text(
                            currencyFormat.format(res.monthlyPayment),
                            style = MaterialTheme.typography.displayMedium,
                            fontWeight = FontWeight.Bold,
                            color = MaterialTheme.colorScheme.onSecondaryContainer
                        )
                        Divider(modifier = Modifier.padding(vertical = 16.dp))
                        ResultRow("Total Interest", currencyFormat.format(res.totalInterest))
                        ResultRow("Total Cost", currencyFormat.format(res.totalCost))
                    }
                }
            }
        }
    }
}

@Composable
private fun ResultRow(label: String, value: String) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(label)
        Text(value, fontWeight = FontWeight.Bold)
    }
}
