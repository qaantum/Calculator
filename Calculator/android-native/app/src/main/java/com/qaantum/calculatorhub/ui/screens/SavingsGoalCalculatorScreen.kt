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
import com.qaantum.calculatorhub.calculators.SavingsGoalCalculator
import java.text.NumberFormat
import java.util.Locale

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SavingsGoalCalculatorScreen() {
    var goal by remember { mutableStateOf("") }
    var initial by remember { mutableStateOf("0") }
    var rate by remember { mutableStateOf("") }
    var years by remember { mutableStateOf("") }
    var monthlyContribution by remember { mutableStateOf<Double?>(null) }

    val calculator = remember { SavingsGoalCalculator() }
    val currencyFormat = remember { NumberFormat.getCurrencyInstance(Locale.US) }

    Scaffold(
        topBar = { TopAppBar(title = { Text("Savings Goal") }) }
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
                value = goal,
                onValueChange = { goal = it },
                label = { Text("Savings Goal Amount") },
                prefix = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )
            OutlinedTextField(
                value = initial,
                onValueChange = { initial = it },
                label = { Text("Initial Savings") },
                prefix = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )
            OutlinedTextField(
                value = rate,
                onValueChange = { rate = it },
                label = { Text("Annual Interest Rate") },
                suffix = { Text("%") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )
            OutlinedTextField(
                value = years,
                onValueChange = { years = it },
                label = { Text("Time Period (Years)") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )

            Button(
                onClick = {
                    val g = goal.toDoubleOrNull() ?: return@Button
                    val i = initial.toDoubleOrNull() ?: 0.0
                    val r = rate.toDoubleOrNull() ?: return@Button
                    val y = years.toDoubleOrNull() ?: return@Button
                    monthlyContribution = calculator.calculate(g, i, r, y).monthlyContribution
                },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("Calculate Required Contribution", modifier = Modifier.padding(8.dp))
            }

            monthlyContribution?.let { amount ->
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.tertiaryContainer)
                ) {
                    Column(
                        modifier = Modifier.padding(24.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text("Required Monthly Savings", style = MaterialTheme.typography.titleMedium)
                        Text(
                            currencyFormat.format(amount),
                            style = MaterialTheme.typography.displayMedium,
                            fontWeight = FontWeight.Bold
                        )
                    }
                }
            }
        }
    }
}
