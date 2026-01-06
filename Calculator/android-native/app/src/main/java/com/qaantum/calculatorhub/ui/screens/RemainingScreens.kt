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
import com.qaantum.calculatorhub.calculators.*
import java.text.NumberFormat
import java.util.Locale

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CurrencyConverterScreen(navController: androidx.navigation.NavController) {
    var amount by remember { mutableStateOf("") }
    var fromCurrency by remember { mutableStateOf("USD") }
    var toCurrency by remember { mutableStateOf("EUR") }
    var result by remember { mutableStateOf<CurrencyConversionResult?>(null) }
    val conv = remember { CurrencyConverter() }
    
    fun calc() { amount.toDoubleOrNull()?.let { result = conv.convert(it, fromCurrency, toCurrency) } }
    
    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Currency Converter",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(amount, { amount = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Amount") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(16.dp), verticalAlignment = Alignment.CenterVertically) {
                var fromExpanded by remember { mutableStateOf(false) }
                ExposedDropdownMenuBox(fromExpanded, { fromExpanded = !fromExpanded }, Modifier.weight(1f)) {
                    OutlinedTextField(fromCurrency, {}, Modifier.menuAnchor(), readOnly = true, label = { Text("From") }, trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(fromExpanded) })
                    ExposedDropdownMenu(fromExpanded, { fromExpanded = false }) { conv.currencies.forEach { DropdownMenuItem({ Text(it) }, { fromCurrency = it; fromExpanded = false; calc() }) } }
                }
                Text("→", style = MaterialTheme.typography.headlineMedium)
                var toExpanded by remember { mutableStateOf(false) }
                ExposedDropdownMenuBox(toExpanded, { toExpanded = !toExpanded }, Modifier.weight(1f)) {
                    OutlinedTextField(toCurrency, {}, Modifier.menuAnchor(), readOnly = true, label = { Text("To") }, trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(toExpanded) })
                    ExposedDropdownMenu(toExpanded, { toExpanded = false }) { conv.currencies.forEach { DropdownMenuItem({ Text(it) }, { toCurrency = it; toExpanded = false; calc() }) } }
                }
            }
            result?.let { Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.tertiaryContainer)) {
                Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("${it.amount} ${it.fromCurrency} =", style = MaterialTheme.typography.titleMedium)
                    Text("${"%.2f".format(it.result)} ${it.toCurrency}", style = MaterialTheme.typography.displayMedium, fontWeight = FontWeight.Bold)
                    Text("Rate: 1 ${it.fromCurrency} = ${"%.4f".format(it.rate)} ${it.toCurrency}", style = MaterialTheme.typography.bodySmall)
                }
            }}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun OvulationCalculatorScreen(navController: androidx.navigation.NavController) {
    var year by remember { mutableStateOf("") }; var month by remember { mutableStateOf("") }; var day by remember { mutableStateOf("") }
    var cycleLength by remember { mutableStateOf("28") }
    var result by remember { mutableStateOf<OvulationResult?>(null) }
    val calc = remember { OvulationCalculator() }
    
    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Ovulation Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Text("Estimate your fertile window and ovulation date.", style = MaterialTheme.typography.bodyMedium)
            Text("First Day of Last Period", style = MaterialTheme.typography.titleMedium)
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(year, { year = it }, Modifier.weight(1f), label = { Text("Year") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                OutlinedTextField(month, { month = it }, Modifier.weight(1f), label = { Text("Month") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                OutlinedTextField(day, { day = it }, Modifier.weight(1f), label = { Text("Day") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            }
            OutlinedTextField(cycleLength, { cycleLength = it }, Modifier.fillMaxWidth(), label = { Text("Cycle Length (days)") }, supportingText = { Text("Usually 28 days") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            Button({ result = calc.calculate(year.toIntOrNull() ?: return@Button, month.toIntOrNull() ?: return@Button, day.toIntOrNull() ?: return@Button, cycleLength.toIntOrNull() ?: 28) }, Modifier.fillMaxWidth()) { Text("Calculate") }
            result?.let { Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                Column(Modifier.padding(24.dp)) {
                    Text("Estimated Ovulation", style = MaterialTheme.typography.titleSmall)
                    Text(it.ovulationDate, style = MaterialTheme.typography.headlineSmall, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary)
                    Divider(Modifier.padding(vertical = 12.dp))
                    Text("Fertile Window", style = MaterialTheme.typography.titleSmall)
                    Text("${it.fertileWindowStart} - ${it.fertileWindowEnd}", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
                    Divider(Modifier.padding(vertical = 12.dp))
                    Text("Next Period", style = MaterialTheme.typography.titleSmall)
                    Text(it.nextPeriodDate, style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
                }
            }}
            Text("Note: This is an estimation and should not be used for contraception.", style = MaterialTheme.typography.bodySmall)
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ChildHeightPredictorScreen(navController: androidx.navigation.NavController) {
    var fatherH by remember { mutableStateOf("") }; var motherH by remember { mutableStateOf("") }
    var isBoy by remember { mutableStateOf(true) }
    var result by remember { mutableStateOf<ChildHeightResult?>(null) }
    val pred = remember { ChildHeightPredictor() }
    
    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Child Height Predictor",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Text("Predict adult height based on parents' height (Mid-Parental Method)", style = MaterialTheme.typography.bodyMedium)
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                FilterChip(isBoy, { isBoy = true }, { Text("Boy") }, Modifier.weight(1f))
                FilterChip(!isBoy, { isBoy = false }, { Text("Girl") }, Modifier.weight(1f))
            }
            OutlinedTextField(fatherH, { fatherH = it }, Modifier.fillMaxWidth(), label = { Text("Father's Height (cm)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(motherH, { motherH = it }, Modifier.fillMaxWidth(), label = { Text("Mother's Height (cm)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Button({ result = pred.predict(fatherH.toDoubleOrNull() ?: return@Button, motherH.toDoubleOrNull() ?: return@Button, isBoy) }, Modifier.fillMaxWidth()) { Text("Predict Height") }
            result?.let { Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("Predicted Adult Height", style = MaterialTheme.typography.titleMedium)
                    Text("${"%.1f".format(it.predictedHeightCm)} cm", style = MaterialTheme.typography.displayMedium, fontWeight = FontWeight.Bold)
                    Text(it.predictedHeightFtIn, style = MaterialTheme.typography.titleLarge)
                    Text("Range: ${it.rangeCm}", style = MaterialTheme.typography.bodySmall)
                }
            }}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SmokingCostCalculatorScreen(navController: androidx.navigation.NavController) {
    var packs by remember { mutableStateOf("") }; var cost by remember { mutableStateOf("") }; var years by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<SmokingCostResult?>(null) }
    val calc = remember { SmokingCostCalculator() }
    val fmt = remember { NumberFormat.getCurrencyInstance(Locale.US) }
    
    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Smoking Cost Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Text("See how much money you could save by quitting.", style = MaterialTheme.typography.bodyMedium)
            OutlinedTextField(packs, { packs = it }, Modifier.fillMaxWidth(), label = { Text("Packs per Day") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(cost, { cost = it }, Modifier.fillMaxWidth(), label = { Text("Cost per Pack") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(years, { years = it }, Modifier.fillMaxWidth(), label = { Text("Years Smoking") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Button({ result = calc.calculate(packs.toDoubleOrNull() ?: return@Button, cost.toDoubleOrNull() ?: return@Button, years.toDoubleOrNull() ?: 1.0) }, Modifier.fillMaxWidth()) { Text("Calculate Cost") }
            result?.let { Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.errorContainer)) {
                Column(Modifier.padding(24.dp)) {
                    listOf("Weekly" to it.weeklyCost, "Monthly" to it.monthlyCost, "Yearly" to it.yearlyCost, "Lifetime" to it.lifetimeCost).forEach { (label, value) ->
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                            Text(label, fontWeight = if (label == "Lifetime") FontWeight.Bold else FontWeight.Normal)
                            Text(fmt.format(value), fontWeight = FontWeight.Bold, color = if (label == "Lifetime") MaterialTheme.colorScheme.error else MaterialTheme.colorScheme.onErrorContainer)
                        }
                        Divider(Modifier.padding(vertical = 4.dp))
                    }
                }
            }}
        }
    }
}
