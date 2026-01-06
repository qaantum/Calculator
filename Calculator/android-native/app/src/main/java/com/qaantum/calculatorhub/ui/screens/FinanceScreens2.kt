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
fun AutoLoanCalculatorScreen(navController: androidx.navigation.NavController) {
    var price by remember { mutableStateOf("") }
    var downPayment by remember { mutableStateOf("0") }
    var tradeIn by remember { mutableStateOf("0") }
    var rate by remember { mutableStateOf("") }
    var term by remember { mutableStateOf("60") }
    var tax by remember { mutableStateOf("0") }
    var result by remember { mutableStateOf<AutoLoanResult?>(null) }
    val calculator = remember { AutoLoanCalculator() }
    val fmt = remember { NumberFormat.getCurrencyInstance(Locale.US) }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Auto Loan Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            OutlinedTextField(price, { price = it }, Modifier.fillMaxWidth(), label = { Text("Vehicle Price") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(downPayment, { downPayment = it }, Modifier.weight(1f), label = { Text("Down Payment") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
                OutlinedTextField(tradeIn, { tradeIn = it }, Modifier.weight(1f), label = { Text("Trade-in") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            }
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(rate, { rate = it }, Modifier.weight(1f), label = { Text("Interest Rate") }, suffix = { Text("%") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
                OutlinedTextField(term, { term = it }, Modifier.weight(1f), label = { Text("Term (Months)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            }
            OutlinedTextField(tax, { tax = it }, Modifier.fillMaxWidth(), label = { Text("Sales Tax") }, suffix = { Text("%") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Button({ result = calculator.calculate(price.toDoubleOrNull() ?: 0.0, downPayment.toDoubleOrNull() ?: 0.0, tradeIn.toDoubleOrNull() ?: 0.0, rate.toDoubleOrNull() ?: 0.0, term.toIntOrNull() ?: 0, tax.toDoubleOrNull() ?: 0.0) }, Modifier.fillMaxWidth()) { Text("Calculate", Modifier.padding(8.dp)) }
            result?.let { Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("Monthly Payment", style = MaterialTheme.typography.titleMedium)
                    Text(fmt.format(it.monthlyPayment), style = MaterialTheme.typography.displayMedium, fontWeight = FontWeight.Bold)
                    Divider(Modifier.padding(vertical = 16.dp))
                    Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Total Interest"); Text(fmt.format(it.totalInterest), fontWeight = FontWeight.Bold) }
                    Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Total Cost"); Text(fmt.format(it.totalCost), fontWeight = FontWeight.Bold) }
                }
            }}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CommissionCalculatorScreen(navController: androidx.navigation.NavController) {
    var salePrice by remember { mutableStateOf("") }
    var commissionRate by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<CommissionResult?>(null) }
    val calculator = remember { CommissionCalculator() }
    fun calc() { val p = salePrice.toDoubleOrNull() ?: return; val r = commissionRate.toDoubleOrNull() ?: return; result = calculator.calculate(p, r) }
    val fmt = remember { NumberFormat.getCurrencyInstance(Locale.US) }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Commission Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(salePrice, { salePrice = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Sale Price") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(commissionRate, { commissionRate = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Commission Rate") }, suffix = { Text("%") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            result?.let { Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                Text("Commission Amount", style = MaterialTheme.typography.titleMedium)
                Text(fmt.format(it.commission), style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary)
                Spacer(Modifier.height(16.dp))
                Text("Net Proceeds", style = MaterialTheme.typography.titleMedium)
                Text(fmt.format(it.netProceeds), style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)
            }}}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SalesTaxCalculatorScreen(navController: androidx.navigation.NavController) {
    var amount by remember { mutableStateOf("") }
    var taxRate by remember { mutableStateOf("") }
    var isReverse by remember { mutableStateOf(false) }
    var result by remember { mutableStateOf<SalesTaxResult?>(null) }
    val calculator = remember { SalesTaxCalculator() }
    val fmt = remember { NumberFormat.getCurrencyInstance(Locale.US) }
    fun calc() { val a = amount.toDoubleOrNull() ?: return; val r = taxRate.toDoubleOrNull() ?: return; result = calculator.calculate(a, r, isReverse) }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Sales Tax Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                FilterChip(!isReverse, { isReverse = false; calc() }, { Text("Add Tax") }, Modifier.weight(1f))
                FilterChip(isReverse, { isReverse = true; calc() }, { Text("Reverse Tax") }, Modifier.weight(1f))
            }
            OutlinedTextField(amount, { amount = it; calc() }, Modifier.fillMaxWidth(), label = { Text(if (isReverse) "Total Amount (Inc. Tax)" else "Net Amount (Excl. Tax)") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(taxRate, { taxRate = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Tax Rate") }, suffix = { Text("%") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            result?.let { Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.secondaryContainer)) { Column(Modifier.padding(24.dp)) {
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Net Amount"); Text(fmt.format(it.netAmount), fontWeight = FontWeight.Bold) }
                Divider(Modifier.padding(vertical = 8.dp))
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Tax Amount"); Text(fmt.format(it.taxAmount), fontWeight = FontWeight.Bold) }
                Divider(Modifier.padding(vertical = 8.dp))
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Total Amount", fontWeight = FontWeight.Bold); Text(fmt.format(it.totalAmount), fontWeight = FontWeight.Bold, style = MaterialTheme.typography.titleLarge) }
            }}}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SalaryCalculatorScreen(navController: androidx.navigation.NavController) {
    var amount by remember { mutableStateOf("") }
    var frequency by remember { mutableStateOf("Annual") }
    var hours by remember { mutableStateOf("40") }
    var days by remember { mutableStateOf("5") }
    var result by remember { mutableStateOf<SalaryResult?>(null) }
    val calculator = remember { SalaryCalculator() }
    val fmt = remember { NumberFormat.getCurrencyInstance(Locale.US) }
    val frequencies = listOf("Annual", "Monthly", "Bi-Weekly", "Weekly", "Daily", "Hourly")
    fun calc() { val a = amount.toDoubleOrNull() ?: return; result = calculator.calculate(a, frequency, hours.toDoubleOrNull() ?: 40.0, days.toDoubleOrNull() ?: 5.0) }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Salary Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(amount, { amount = it; calc() }, Modifier.weight(2f), label = { Text("Amount") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
                var expanded by remember { mutableStateOf(false) }
                ExposedDropdownMenuBox(expanded, { expanded = !expanded }, Modifier.weight(1f)) {
                    OutlinedTextField(frequency, {}, Modifier.menuAnchor(), readOnly = true, label = { Text("Per") }, trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded) })
                    ExposedDropdownMenu(expanded, { expanded = false }) { frequencies.forEach { freq -> DropdownMenuItem({ Text(freq) }, { frequency = freq; expanded = false; calc() }) } }
                }
            }
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(hours, { hours = it; calc() }, Modifier.weight(1f), label = { Text("Hours/Week") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
                OutlinedTextField(days, { days = it; calc() }, Modifier.weight(1f), label = { Text("Days/Week") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            }
            result?.let { Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) {
                listOf("Annual" to it.annual, "Monthly" to it.monthly, "Bi-Weekly" to it.biWeekly, "Weekly" to it.weekly, "Daily" to it.daily, "Hourly" to it.hourly).forEach { (l, v) ->
                    Row(Modifier.fillMaxWidth().padding(vertical = 4.dp), horizontalArrangement = Arrangement.SpaceBetween) { Text(l); Text(fmt.format(v), fontWeight = FontWeight.Bold) }
                    Divider()
                }
            }}}
        }
    }
}
