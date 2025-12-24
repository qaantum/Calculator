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
import com.qaantum.calculatorhub.calculators.RetirementCalculator
import com.qaantum.calculatorhub.calculators.RetirementResult
import java.text.NumberFormat
import java.util.Locale

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RetirementCalculatorScreen() {
    var currentAge by remember { mutableStateOf("") }
    var retireAge by remember { mutableStateOf("65") }
    var savings by remember { mutableStateOf("0") }
    var contribution by remember { mutableStateOf("") }
    var rate by remember { mutableStateOf("7") }
    var result by remember { mutableStateOf<RetirementResult?>(null) }

    val calculator = remember { RetirementCalculator() }
    val currencyFormat = remember { NumberFormat.getCurrencyInstance(Locale.US) }

    Scaffold(
        topBar = { TopAppBar(title = { Text("Retirement Calculator") }) }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(16.dp)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(
                    value = currentAge,
                    onValueChange = { currentAge = it },
                    label = { Text("Current Age") },
                    modifier = Modifier.weight(1f),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number)
                )
                OutlinedTextField(
                    value = retireAge,
                    onValueChange = { retireAge = it },
                    label = { Text("Retirement Age") },
                    modifier = Modifier.weight(1f),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number)
                )
            }
            OutlinedTextField(
                value = savings,
                onValueChange = { savings = it },
                label = { Text("Current Savings") },
                prefix = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )
            OutlinedTextField(
                value = contribution,
                onValueChange = { contribution = it },
                label = { Text("Monthly Contribution") },
                prefix = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )
            OutlinedTextField(
                value = rate,
                onValueChange = { rate = it },
                label = { Text("Expected Annual Return") },
                suffix = { Text("%") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )

            Button(
                onClick = {
                    val ca = currentAge.toIntOrNull() ?: return@Button
                    val ra = retireAge.toIntOrNull() ?: return@Button
                    val s = savings.toDoubleOrNull() ?: 0.0
                    val c = contribution.toDoubleOrNull() ?: return@Button
                    val r = rate.toDoubleOrNull() ?: 7.0
                    result = calculator.calculate(ca, ra, s, c, r)
                },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("Calculate", modifier = Modifier.padding(8.dp))
            }

            result?.let { res ->
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)
                ) {
                    Column(
                        modifier = Modifier.padding(24.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text("Total at Retirement", style = MaterialTheme.typography.titleMedium)
                        Text(
                            currencyFormat.format(res.totalSavings),
                            style = MaterialTheme.typography.displayMedium,
                            fontWeight = FontWeight.Bold
                        )
                        HorizontalDivider(modifier = Modifier.padding(vertical = 16.dp))
                        Text("Est. Monthly Income (4% Rule)", style = MaterialTheme.typography.titleSmall)
                        Text(
                            currencyFormat.format(res.monthlyIncome),
                            style = MaterialTheme.typography.headlineSmall,
                            fontWeight = FontWeight.Bold
                        )
                    }
                }
            }
        }
    }
}
