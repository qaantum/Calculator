package com.qaantum.calculatorhub.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.qaantum.calculatorhub.calculators.*
import java.text.NumberFormat
import java.util.Locale

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MatrixDeterminantScreen(navController: androidx.navigation.NavController) {
    var a by remember { mutableStateOf("") }; var b by remember { mutableStateOf("") }
    var c by remember { mutableStateOf("") }; var d by remember { mutableStateOf("") }
    var result by remember { mutableStateOf("---") }
    val calc = remember { MatrixDeterminantCalculator() }
    
    fun calc() {
        val av = a.toDoubleOrNull() ?: return; val bv = b.toDoubleOrNull() ?: return
        val cv = c.toDoubleOrNull() ?: return; val dv = d.toDoubleOrNull() ?: return
        result = "%.4f".format(calc.det2x2(av, bv, cv, dv))
    }
    
    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Matrix Determinant (2×2)",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Text("| a  b |", style = MaterialTheme.typography.titleMedium)
            Text("| c  d |", style = MaterialTheme.typography.titleMedium)
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(a, { a = it; calc() }, Modifier.weight(1f), label = { Text("a") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
                OutlinedTextField(b, { b = it; calc() }, Modifier.weight(1f), label = { Text("b") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            }
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(c, { c = it; calc() }, Modifier.weight(1f), label = { Text("c") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
                OutlinedTextField(d, { d = it; calc() }, Modifier.weight(1f), label = { Text("d") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            }
            Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("Determinant", style = MaterialTheme.typography.titleMedium)
                    Text(result, style = MaterialTheme.typography.displayMedium, fontWeight = FontWeight.Bold)
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ColorConverterScreen(navController: androidx.navigation.NavController) {
    var r by remember { mutableStateOf("255") }; var g by remember { mutableStateOf("128") }; var b by remember { mutableStateOf("0") }
    var hex by remember { mutableStateOf("#FF8000") }
    val conv = remember { ColorConverter() }
    
    val rgb = Triple(r.toIntOrNull() ?: 0, g.toIntOrNull() ?: 0, b.toIntOrNull() ?: 0)
    val hsl = conv.rgbToHsl(rgb.first, rgb.second, rgb.third)
    val hexResult = conv.rgbToHex(rgb.first, rgb.second, rgb.third)
    
    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Color Converter",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Card(Modifier.fillMaxWidth().height(80.dp), colors = CardDefaults.cardColors(containerColor = Color(rgb.first, rgb.second, rgb.third))) {}
            Text("RGB Values", style = MaterialTheme.typography.titleMedium)
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(r, { r = it }, Modifier.weight(1f), label = { Text("R") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                OutlinedTextField(g, { g = it }, Modifier.weight(1f), label = { Text("G") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                OutlinedTextField(b, { b = it }, Modifier.weight(1f), label = { Text("B") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            }
            Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) {
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("HEX"); Text(hexResult, fontWeight = FontWeight.Bold, style = MaterialTheme.typography.titleLarge) }
                Divider(Modifier.padding(vertical = 8.dp))
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("HSL"); Text("${hsl.first}°, ${hsl.second}%, ${hsl.third}%", fontWeight = FontWeight.Bold) }
            }}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LoanAffordabilityScreen(navController: androidx.navigation.NavController) {
    var income by remember { mutableStateOf("") }; var dti by remember { mutableStateOf("36") }
    var rate by remember { mutableStateOf("") }; var term by remember { mutableStateOf("360") }
    var result by remember { mutableStateOf<LoanAffordabilityResult?>(null) }
    val calc = remember { LoanAffordabilityCalculator() }
    val fmt = remember { NumberFormat.getCurrencyInstance(Locale.US) }
    
    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Loan Affordability",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(income, { income = it }, Modifier.fillMaxWidth(), label = { Text("Monthly Income") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(dti, { dti = it }, Modifier.fillMaxWidth(), label = { Text("Max Debt-to-Income Ratio") }, suffix = { Text("%") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            OutlinedTextField(rate, { rate = it }, Modifier.fillMaxWidth(), label = { Text("Interest Rate") }, suffix = { Text("%") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(term, { term = it }, Modifier.fillMaxWidth(), label = { Text("Term (months)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            Button({ result = calc.calculate(income.toDoubleOrNull() ?: return@Button, dti.toDoubleOrNull() ?: 36.0, rate.toDoubleOrNull() ?: return@Button, term.toIntOrNull() ?: 360) }, Modifier.fillMaxWidth()) { Text("Calculate") }
            result?.let { Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("Maximum Loan", style = MaterialTheme.typography.titleMedium)
                    Text(fmt.format(it.maxLoan), style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold)
                    Spacer(Modifier.height(8.dp))
                    Text("Max Monthly Payment: ${fmt.format(it.monthlyPayment)}")
                }
            }}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RefinanceCalculatorScreen(navController: androidx.navigation.NavController) {
    var balance by remember { mutableStateOf("") }; var oldRate by remember { mutableStateOf("") }
    var newRate by remember { mutableStateOf("") }; var term by remember { mutableStateOf("360") }; var costs by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<RefinanceResult?>(null) }
    val calc = remember { RefinanceCalculator() }
    val fmt = remember { NumberFormat.getCurrencyInstance(Locale.US) }
    
    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Refinance Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            OutlinedTextField(balance, { balance = it }, Modifier.fillMaxWidth(), label = { Text("Loan Balance") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(oldRate, { oldRate = it }, Modifier.weight(1f), label = { Text("Current Rate") }, suffix = { Text("%") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
                OutlinedTextField(newRate, { newRate = it }, Modifier.weight(1f), label = { Text("New Rate") }, suffix = { Text("%") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            }
            OutlinedTextField(term, { term = it }, Modifier.fillMaxWidth(), label = { Text("Term (months)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            OutlinedTextField(costs, { costs = it }, Modifier.fillMaxWidth(), label = { Text("Closing Costs") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Button({ result = calc.calculate(balance.toDoubleOrNull() ?: return@Button, oldRate.toDoubleOrNull() ?: return@Button, newRate.toDoubleOrNull() ?: return@Button, term.toIntOrNull() ?: 360, costs.toDoubleOrNull() ?: 0.0) }, Modifier.fillMaxWidth()) { Text("Compare") }
            result?.let { Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(24.dp)) {
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Old Payment"); Text(fmt.format(it.oldPayment), fontWeight = FontWeight.Bold) }
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("New Payment"); Text(fmt.format(it.newPayment), fontWeight = FontWeight.Bold) }
                Divider(Modifier.padding(vertical = 8.dp))
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Monthly Savings", fontWeight = FontWeight.Bold); Text(fmt.format(it.monthlySavings), style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold, color = if (it.monthlySavings > 0) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.error) }
                Text("Break-even: ${it.breakEvenMonths} months", style = MaterialTheme.typography.bodySmall)
            }}}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RentalPropertyScreen(navController: androidx.navigation.NavController) {
    var price by remember { mutableStateOf("") }; var down by remember { mutableStateOf("") }
    var rent by remember { mutableStateOf("") }; var expenses by remember { mutableStateOf("") }; var mortgage by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<RentalResult?>(null) }
    val calc = remember { RentalPropertyCalculator() }
    val fmt = remember { NumberFormat.getCurrencyInstance(Locale.US) }
    
    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Rental Property",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            OutlinedTextField(price, { price = it }, Modifier.fillMaxWidth(), label = { Text("Purchase Price") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(down, { down = it }, Modifier.fillMaxWidth(), label = { Text("Down Payment") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(rent, { rent = it }, Modifier.fillMaxWidth(), label = { Text("Monthly Rent") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(expenses, { expenses = it }, Modifier.fillMaxWidth(), label = { Text("Monthly Expenses") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(mortgage, { mortgage = it }, Modifier.fillMaxWidth(), label = { Text("Mortgage Payment") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Button({ result = calc.calculate(price.toDoubleOrNull() ?: return@Button, down.toDoubleOrNull() ?: return@Button, rent.toDoubleOrNull() ?: return@Button, expenses.toDoubleOrNull() ?: 0.0, mortgage.toDoubleOrNull() ?: 0.0) }, Modifier.fillMaxWidth()) { Text("Analyze") }
            result?.let { Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(24.dp)) {
                listOf("Annual Cash Flow" to fmt.format(it.cashFlow), "Cap Rate" to "%.2f%%".format(it.capRate), "ROI" to "%.2f%%".format(it.roi), "Cash-on-Cash" to "%.2f%%".format(it.cashOnCash)).forEach { (l, v) ->
                    Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text(l); Text(v, fontWeight = FontWeight.Bold) }
                    Divider(Modifier.padding(vertical = 4.dp))
                }
            }}}
        }
    }
}
