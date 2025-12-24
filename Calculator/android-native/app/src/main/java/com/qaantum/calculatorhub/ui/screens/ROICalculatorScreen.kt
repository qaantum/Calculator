package com.qaantum.calculatorhub.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Build
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.qaantum.calculatorhub.calculators.ROICalculator
import com.qaantum.calculatorhub.calculators.ROIResult
import com.qaantum.calculatorhub.customcalculator.ForkCalculator
import com.qaantum.calculatorhub.customcalculator.CustomCalculatorService
import java.text.NumberFormat
import java.util.Locale

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ROICalculatorScreen() {
    var investment by remember { mutableStateOf("") }
    var finalValue by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<ROIResult?>(null) }
    var showCustomizeSheet by remember { mutableStateOf(false) }

    val calculator = remember { ROICalculator() }
    val currencyFormat = remember { NumberFormat.getCurrencyInstance(Locale.US) }
    val context = LocalContext.current

    fun calculate() {
        val i = investment.toDoubleOrNull() ?: return
        val f = finalValue.toDoubleOrNull() ?: return
        result = calculator.calculate(i, f)
    }

    if (showCustomizeSheet) {
        val forkedCalc = remember { ForkCalculator.createFork("/finance/roi") }
        forkedCalc?.let { calc ->
            AlertDialog(
                onDismissRequest = { showCustomizeSheet = false },
                title = { Text("Customize This Calculator") },
                text = { 
                    Column {
                        Text("Create your own version of the ROI Calculator.")
                        Spacer(modifier = Modifier.height(8.dp))
                        Text("Formula: ${calc.formula}", style = MaterialTheme.typography.bodySmall)
                    }
                },
                confirmButton = {
                    Button(onClick = {
                        CustomCalculatorService(context).saveCalculator(calc)
                        showCustomizeSheet = false
                    }) { Text("Create My Version") }
                },
                dismissButton = { TextButton(onClick = { showCustomizeSheet = false }) { Text("Cancel") } }
            )
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Return on Investment (ROI)") },
                actions = {
                    IconButton(onClick = { showCustomizeSheet = true }) {
                        Icon(Icons.Default.Build, contentDescription = "Customize")
                    }
                }
            )
        }
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
                value = investment,
                onValueChange = { investment = it; calculate() },
                label = { Text("Initial Investment") },
                prefix = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )
            OutlinedTextField(
                value = finalValue,
                onValueChange = { finalValue = it; calculate() },
                label = { Text("Final Value") },
                prefix = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )

            result?.let { res ->
                Card(modifier = Modifier.fillMaxWidth()) {
                    Column(
                        modifier = Modifier.padding(24.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text("Total Return", style = MaterialTheme.typography.titleMedium)
                        Text(
                            currencyFormat.format(res.returnAmount),
                            style = MaterialTheme.typography.headlineSmall,
                            fontWeight = FontWeight.Bold,
                            color = if (res.returnAmount >= 0) Color(0xFF4CAF50) else Color(0xFFF44336)
                        )
                        Spacer(modifier = Modifier.height(16.dp))
                        Text("ROI", style = MaterialTheme.typography.titleMedium)
                        Text(
                            String.format("%.2f%%", res.roiPercentage),
                            style = MaterialTheme.typography.displayMedium,
                            fontWeight = FontWeight.Bold,
                            color = MaterialTheme.colorScheme.primary
                        )
                    }
                }
            }
        }
    }
}
