package com.qaantum.calculatorhub.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Build
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.qaantum.calculatorhub.calculators.TipCalculator
import com.qaantum.calculatorhub.calculators.TipResult
import com.qaantum.calculatorhub.customcalculator.ForkCalculator
import com.qaantum.calculatorhub.customcalculator.CustomCalculatorService
import java.text.NumberFormat
import java.util.Locale

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TipCalculatorScreen() {
    var billAmount by remember { mutableStateOf("") }
    var tipPercentage by remember { mutableFloatStateOf(15f) }
    var splitCount by remember { mutableIntStateOf(1) }
    var result by remember { mutableStateOf<TipResult?>(null) }
    var showCustomizeSheet by remember { mutableStateOf(false) }

    val calculator = remember { TipCalculator() }
    val currencyFormat = remember { NumberFormat.getCurrencyInstance(Locale.US) }
    val context = LocalContext.current

    fun calculate() {
        val bill = billAmount.toDoubleOrNull() ?: return
        result = calculator.calculate(bill, tipPercentage.toDouble(), splitCount)
    }

    // Customize Dialog
    if (showCustomizeSheet) {
        val forkedCalc = remember { ForkCalculator.createFork("/finance/tip") }
        forkedCalc?.let { calc ->
            AlertDialog(
                onDismissRequest = { showCustomizeSheet = false },
                title = { Text("Customize This Calculator") },
                text = { 
                    Column {
                        Text("Create your own version of the Tip Calculator with custom variables and formulas.")
                        Spacer(modifier = Modifier.height(8.dp))
                        Text("Formula: ${calc.formula}", style = MaterialTheme.typography.bodySmall)
                    }
                },
                confirmButton = {
                    Button(onClick = {
                        val service = CustomCalculatorService(context)
                        service.saveCalculator(calc)
                        showCustomizeSheet = false
                    }) {
                        Text("Create My Version")
                    }
                },
                dismissButton = {
                    TextButton(onClick = { showCustomizeSheet = false }) {
                        Text("Cancel")
                    }
                }
            )
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Tip Calculator") },
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
                value = billAmount,
                onValueChange = { 
                    billAmount = it
                    calculate()
                },
                label = { Text("Bill Amount") },
                prefix = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )

            Text(
                "Tip Percentage: ${tipPercentage.toInt()}%",
                style = MaterialTheme.typography.titleMedium
            )
            Slider(
                value = tipPercentage,
                onValueChange = { 
                    tipPercentage = it
                    calculate()
                },
                valueRange = 0f..50f,
                steps = 49
            )

            Text(
                "Split: $splitCount Person${if (splitCount > 1) "s" else ""}",
                style = MaterialTheme.typography.titleMedium
            )
            Slider(
                value = splitCount.toFloat(),
                onValueChange = { 
                    splitCount = it.toInt()
                    calculate()
                },
                valueRange = 1f..20f,
                steps = 18
            )

            result?.let { res ->
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.tertiaryContainer
                    )
                ) {
                    Column(
                        modifier = Modifier.padding(24.dp)
                    ) {
                        TipResultRow("Tip Amount", currencyFormat.format(res.tipAmount))
                        HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))
                        TipResultRow("Total Bill", currencyFormat.format(res.totalBill))
                        HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))
                        TipResultRow(
                            "Per Person",
                            currencyFormat.format(res.amountPerPerson),
                            isBold = true
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun TipResultRow(label: String, value: String, isBold: Boolean = false) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(label, style = MaterialTheme.typography.bodyLarge)
        Text(
            value,
            style = MaterialTheme.typography.titleLarge,
            fontWeight = if (isBold) FontWeight.Bold else FontWeight.Normal
        )
    }
}
