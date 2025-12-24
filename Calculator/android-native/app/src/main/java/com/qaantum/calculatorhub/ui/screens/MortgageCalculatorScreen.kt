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
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.qaantum.calculatorhub.calculators.MortgageCalculator
import com.qaantum.calculatorhub.calculators.MortgageResult
import com.qaantum.calculatorhub.customcalculator.ForkCalculator
import com.qaantum.calculatorhub.customcalculator.CustomCalculatorService
import java.text.NumberFormat
import java.util.Locale

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MortgageCalculatorScreen() {
    var principal by remember { mutableStateOf("") }
    var rate by remember { mutableStateOf("") }
    var term by remember { mutableStateOf("30") }
    var tax by remember { mutableStateOf("0") }
    var insurance by remember { mutableStateOf("0") }
    var hoa by remember { mutableStateOf("0") }
    var result by remember { mutableStateOf<MortgageResult?>(null) }
    var showCustomizeSheet by remember { mutableStateOf(false) }

    val calculator = remember { MortgageCalculator() }
    val currencyFormat = remember { NumberFormat.getCurrencyInstance(Locale.US) }
    val context = LocalContext.current

    if (showCustomizeSheet) {
        val forkedCalc = remember { ForkCalculator.createFork("/finance/mortgage") }
        forkedCalc?.let { calc ->
            AlertDialog(
                onDismissRequest = { showCustomizeSheet = false },
                title = { Text("Customize This Calculator") },
                text = { 
                    Column {
                        Text("Create your own version of the Mortgage Calculator.")
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
                title = { Text("Mortgage Calculator") },
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
                value = principal,
                onValueChange = { principal = it },
                label = { Text("Loan Amount") },
                prefix = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                OutlinedTextField(
                    value = rate,
                    onValueChange = { rate = it },
                    label = { Text("Interest Rate") },
                    suffix = { Text("%") },
                    modifier = Modifier.weight(1f),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
                )
                OutlinedTextField(
                    value = term,
                    onValueChange = { term = it },
                    label = { Text("Term (Years)") },
                    modifier = Modifier.weight(1f),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number)
                )
            }

            Text(
                "Optional Expenses",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                OutlinedTextField(
                    value = tax,
                    onValueChange = { tax = it },
                    label = { Text("Property Tax/Year") },
                    prefix = { Text("$") },
                    modifier = Modifier.weight(1f),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
                )
                OutlinedTextField(
                    value = insurance,
                    onValueChange = { insurance = it },
                    label = { Text("Insurance/Year") },
                    prefix = { Text("$") },
                    modifier = Modifier.weight(1f),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
                )
            }

            OutlinedTextField(
                value = hoa,
                onValueChange = { hoa = it },
                label = { Text("HOA Fees/Month") },
                prefix = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )

            Button(
                onClick = {
                    try {
                        val principalVal = principal.toDouble()
                        val rateVal = rate.toDouble()
                        val termVal = term.toInt()
                        val taxVal = tax.toDoubleOrNull() ?: 0.0
                        val insuranceVal = insurance.toDoubleOrNull() ?: 0.0
                        val hoaVal = hoa.toDoubleOrNull() ?: 0.0
                        result = calculator.calculate(
                            principalVal, rateVal, termVal,
                            taxVal, insuranceVal, hoaVal
                        )
                    } catch (e: Exception) {
                        // Handle error
                    }
                },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("Calculate Payment", modifier = Modifier.padding(8.dp))
            }

            result?.let { res ->
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.primaryContainer
                    )
                ) {
                    Column(
                        modifier = Modifier.padding(24.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text(
                            "Total Monthly Payment",
                            style = MaterialTheme.typography.titleMedium
                        )
                        Text(
                            currencyFormat.format(res.totalMonthlyPayment),
                            style = MaterialTheme.typography.displayMedium,
                            fontWeight = FontWeight.Bold,
                            color = MaterialTheme.colorScheme.onPrimaryContainer
                        )
                        HorizontalDivider(modifier = Modifier.padding(vertical = 16.dp))
                        MortgageResultRow("Principal & Interest", currencyFormat.format(res.monthlyPrincipalAndInterest))
                        MortgageResultRow("Property Tax", currencyFormat.format(res.monthlyTax))
                        MortgageResultRow("Home Insurance", currencyFormat.format(res.monthlyInsurance))
                        MortgageResultRow("HOA Fees", currencyFormat.format(res.monthlyHOA))
                    }
                }
            }
        }
    }
}

@Composable
private fun MortgageResultRow(label: String, value: String) {
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
