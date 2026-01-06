package com.qaantum.calculatorhub.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.qaantum.calculatorhub.calculators.CAGRCalculator
import com.qaantum.calculatorhub.calculators.CAGRResult

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CAGRCalculatorScreen(navController: androidx.navigation.NavController) {
    var startValue by remember { mutableStateOf("") }
    var endValue by remember { mutableStateOf("") }
    var years by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<CAGRResult?>(null) }

    val calculator = remember { CAGRCalculator() }

    fun calculate() {
        val s = startValue.toDoubleOrNull() ?: return
        val e = endValue.toDoubleOrNull() ?: return
        val y = years.toDoubleOrNull() ?: return
        result = calculator.calculate(s, e, y)
    }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "CAGR Calculator",
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
                value = startValue,
                onValueChange = { startValue = it; calculate() },
                label = { Text("Beginning Value") },
                prefix = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )
            OutlinedTextField(
                value = endValue,
                onValueChange = { endValue = it; calculate() },
                label = { Text("Ending Value") },
                prefix = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )
            OutlinedTextField(
                value = years,
                onValueChange = { years = it; calculate() },
                label = { Text("Number of Years") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )

            Card(
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.tertiaryContainer)
            ) {
                Column(modifier = Modifier.padding(24.dp)) {
                    Text("Results update automatically",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    Spacer(modifier = Modifier.height(16.dp))
                    Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                        Text("CAGR", style = MaterialTheme.typography.bodyLarge)
                        Text(
                            result?.let { String.format("%.2f%%", it.cagr) } ?: "---",
                            style = MaterialTheme.typography.titleLarge,
                            fontWeight = FontWeight.Bold
                        )
                    }
                    Divider(modifier = Modifier.padding(vertical = 8.dp))
                    Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                        Text("Total Growth", style = MaterialTheme.typography.bodyLarge)
                        Text(
                            result?.let { String.format("%.2f%%", it.totalGrowth) } ?: "---",
                            style = MaterialTheme.typography.titleLarge
                        )
                    }
                }
            }
        }
    }
}
