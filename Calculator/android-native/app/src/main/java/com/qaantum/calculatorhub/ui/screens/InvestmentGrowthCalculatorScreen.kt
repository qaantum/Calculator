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
import com.qaantum.calculatorhub.calculators.InvestmentGrowthCalculator
import com.qaantum.calculatorhub.calculators.InvestmentGrowthResult
import java.text.NumberFormat
import java.util.Locale

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun InvestmentGrowthCalculatorScreen() {
    var initial by remember { mutableStateOf("") }
    var contribution by remember { mutableStateOf("") }
    var rate by remember { mutableStateOf("") }
    var years by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<InvestmentGrowthResult?>(null) }

    val calculator = remember { InvestmentGrowthCalculator() }
    val currencyFormat = remember { NumberFormat.getCurrencyInstance(Locale.US) }

    fun calculate() {
        val i = initial.toDoubleOrNull() ?: 0.0
        val c = contribution.toDoubleOrNull() ?: 0.0
        val r = rate.toDoubleOrNull() ?: return
        val y = years.toDoubleOrNull() ?: return
        result = calculator.calculate(i, c, r, y)
    }

    Scaffold(
        topBar = { TopAppBar(title = { Text("Investment Growth") }) }
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
                value = initial,
                onValueChange = { initial = it; calculate() },
                label = { Text("Initial Amount") },
                prefix = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )
            OutlinedTextField(
                value = contribution,
                onValueChange = { contribution = it; calculate() },
                label = { Text("Monthly Contribution") },
                prefix = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )
            OutlinedTextField(
                value = rate,
                onValueChange = { rate = it; calculate() },
                label = { Text("Annual Return Rate (%)") },
                suffix = { Text("%") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )
            OutlinedTextField(
                value = years,
                onValueChange = { years = it; calculate() },
                label = { Text("Years to Grow") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )

            result?.let { res ->
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)
                ) {
                    Column(
                        modifier = Modifier.padding(24.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text("Future Value", style = MaterialTheme.typography.titleMedium)
                        Text(
                            currencyFormat.format(res.totalValue),
                            style = MaterialTheme.typography.displaySmall,
                            fontWeight = FontWeight.Bold
                        )
                        HorizontalDivider(modifier = Modifier.padding(vertical = 16.dp))
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                            Text("Total Contributed")
                            Text(currencyFormat.format(res.totalContributions), fontWeight = FontWeight.Bold)
                        }
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                            Text("Total Interest Earned")
                            Text(currencyFormat.format(res.totalInterest), fontWeight = FontWeight.Bold)
                        }
                    }
                }
            }
        }
    }
}
