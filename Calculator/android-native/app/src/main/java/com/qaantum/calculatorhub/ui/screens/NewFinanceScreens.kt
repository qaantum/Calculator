package com.qaantum.calculatorhub.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Remove
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
fun NPVCalculatorScreen(navController: androidx.navigation.NavController) {
    var initialInvestment by remember { mutableStateOf("") }
    var discountRate by remember { mutableStateOf("10") }
    var cashFlows by remember { mutableStateOf(listOf("")) }
    var result by remember { mutableStateOf<NPVResult?>(null) }
    val calculator = remember { NPVCalculator() }
    val fmt = remember { NumberFormat.getCurrencyInstance(Locale.US) }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "NPV Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            OutlinedTextField(initialInvestment, { initialInvestment = it }, Modifier.fillMaxWidth(), label = { Text("Initial Investment") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(discountRate, { discountRate = it }, Modifier.fillMaxWidth(), label = { Text("Discount Rate") }, suffix = { Text("%") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween, verticalAlignment = Alignment.CenterVertically) {
                Text("Cash Flows", style = MaterialTheme.typography.titleMedium)
                IconButton(onClick = { cashFlows = cashFlows + "" }) { Icon(Icons.Default.Add, "Add") }
            }
            cashFlows.forEachIndexed { i, cf ->
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    OutlinedTextField(cf, { cashFlows = cashFlows.toMutableList().also { list -> list[i] = it } }, Modifier.weight(1f), label = { Text("Year ${i + 1}") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
                    if (cashFlows.size > 1) IconButton(onClick = { cashFlows = cashFlows.filterIndexed { idx, _ -> idx != i } }) { Icon(Icons.Default.Remove, "Remove", tint = Color.Red) }
                }
            }
            Button({
                val cfs = cashFlows.mapNotNull { it.toDoubleOrNull() }
                if (cfs.isNotEmpty()) result = calculator.calculate(initialInvestment.toDoubleOrNull() ?: 0.0, cfs, discountRate.toDoubleOrNull() ?: 10.0)
            }, Modifier.fillMaxWidth()) { Text("Calculate") }
            result?.let {
                Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = if (it.isProfitable) Color(0xFF4CAF50).copy(alpha = 0.1f) else Color(0xFFF44336).copy(alpha = 0.1f))) {
                    Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Net Present Value", style = MaterialTheme.typography.titleMedium)
                        Text(fmt.format(it.npv), style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold, color = if (it.isProfitable) Color(0xFF4CAF50) else Color(0xFFF44336))
                        Text(if (it.isProfitable) "Profitable Investment" else "Unprofitable Investment", color = if (it.isProfitable) Color(0xFF4CAF50) else Color(0xFFF44336))
                    }
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun IRRCalculatorScreen(navController: androidx.navigation.NavController) {
    var initialInvestment by remember { mutableStateOf("") }
    var cashFlows by remember { mutableStateOf(listOf("")) }
    var result by remember { mutableStateOf<IRRResult?>(null) }
    val calculator = remember { IRRCalculator() }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "IRR Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            OutlinedTextField(initialInvestment, { initialInvestment = it }, Modifier.fillMaxWidth(), label = { Text("Initial Investment") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween, verticalAlignment = Alignment.CenterVertically) {
                Text("Cash Flows", style = MaterialTheme.typography.titleMedium)
                IconButton(onClick = { cashFlows = cashFlows + "" }) { Icon(Icons.Default.Add, "Add") }
            }
            cashFlows.forEachIndexed { i, cf ->
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    OutlinedTextField(cf, { cashFlows = cashFlows.toMutableList().also { list -> list[i] = it } }, Modifier.weight(1f), label = { Text("Year ${i + 1}") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
                    if (cashFlows.size > 1) IconButton(onClick = { cashFlows = cashFlows.filterIndexed { idx, _ -> idx != i } }) { Icon(Icons.Default.Remove, "Remove", tint = Color.Red) }
                }
            }
            Button({
                val cfs = cashFlows.mapNotNull { it.toDoubleOrNull() }
                if (cfs.isNotEmpty()) result = calculator.calculate(initialInvestment.toDoubleOrNull() ?: 0.0, cfs)
            }, Modifier.fillMaxWidth()) { Text("Calculate") }
            result?.let {
                Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                    Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Internal Rate of Return", style = MaterialTheme.typography.titleMedium)
                        Text("${String.format("%.2f", it.irr)}%", style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold)
                        Text("Annual return rate where NPV = 0", style = MaterialTheme.typography.bodySmall)
                    }
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DownPaymentCalculatorScreen(navController: androidx.navigation.NavController) {
    var price by remember { mutableStateOf("") }
    var downPercent by remember { mutableStateOf("20") }
    var rate by remember { mutableStateOf("7") }
    var term by remember { mutableStateOf("30") }
    var result by remember { mutableStateOf<DownPaymentResult?>(null) }
    val calculator = remember { DownPaymentCalculator() }
    val fmt = remember { NumberFormat.getCurrencyInstance(Locale.US) }
    fun calc() { result = calculator.calculate(price.toDoubleOrNull() ?: 0.0, downPercent.toDoubleOrNull() ?: 20.0, rate.toDoubleOrNull() ?: 7.0, term.toIntOrNull() ?: 30) }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Down Payment Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            OutlinedTextField(price, { price = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Purchase Price") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(downPercent, { downPercent = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Down Payment") }, suffix = { Text("%") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(rate, { rate = it; calc() }, Modifier.weight(1f), label = { Text("Interest Rate") }, suffix = { Text("%") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
                OutlinedTextField(term, { term = it; calc() }, Modifier.weight(1f), label = { Text("Loan Term") }, suffix = { Text("years") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            }
            result?.let {
                Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                    Column(Modifier.padding(24.dp)) {
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Down Payment"); Text(fmt.format(it.downPayment), fontWeight = FontWeight.Bold) }
                        Divider(Modifier.padding(vertical = 8.dp))
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Loan Amount"); Text(fmt.format(it.loanAmount), fontWeight = FontWeight.Bold) }
                        Divider(Modifier.padding(vertical = 8.dp))
                        Column(Modifier.fillMaxWidth(), horizontalAlignment = Alignment.CenterHorizontally) {
                            Text("Monthly Payment", style = MaterialTheme.typography.titleMedium)
                            Text(fmt.format(it.monthlyPayment), style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold)
                        }
                    }
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PaycheckCalculatorScreen(navController: androidx.navigation.NavController) {
    var salary by remember { mutableStateOf("") }
    var payPeriod by remember { mutableStateOf("Biweekly") }
    var federal by remember { mutableStateOf("22") }
    var state by remember { mutableStateOf("5") }
    var result by remember { mutableStateOf<PaycheckResult?>(null) }
    val calculator = remember { PaycheckCalculator() }
    val fmt = remember { NumberFormat.getCurrencyInstance(Locale.US) }
    val periods = listOf("Weekly", "Biweekly", "Semi-Monthly", "Monthly", "Annual")
    fun calc() { result = calculator.calculate(salary.toDoubleOrNull() ?: 0.0, payPeriod, federal.toDoubleOrNull() ?: 22.0, state.toDoubleOrNull() ?: 5.0) }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Paycheck Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            OutlinedTextField(salary, { salary = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Annual Gross Salary") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            var expanded by remember { mutableStateOf(false) }
            ExposedDropdownMenuBox(expanded, { expanded = !expanded }) {
                OutlinedTextField(payPeriod, {}, Modifier.fillMaxWidth().menuAnchor(), readOnly = true, label = { Text("Pay Period") }, trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded) })
                ExposedDropdownMenu(expanded, { expanded = false }) { periods.forEach { DropdownMenuItem({ Text(it) }, { payPeriod = it; expanded = false; calc() }) } }
            }
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(federal, { federal = it; calc() }, Modifier.weight(1f), label = { Text("Federal Tax") }, suffix = { Text("%") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
                OutlinedTextField(state, { state = it; calc() }, Modifier.weight(1f), label = { Text("State Tax") }, suffix = { Text("%") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            }
            result?.let {
                Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                    Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("$payPeriod Take-Home Pay", style = MaterialTheme.typography.titleMedium)
                        Text(fmt.format(it.netPay), style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold, color = Color(0xFF4CAF50))
                        Divider(Modifier.padding(vertical = 16.dp))
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Gross Pay"); Text(fmt.format(it.grossPay), fontWeight = FontWeight.Bold) }
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Total Deductions"); Text("-${fmt.format(it.totalDeductions)}", fontWeight = FontWeight.Bold, color = Color.Red) }
                    }
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CDCalculatorScreen(navController: androidx.navigation.NavController) {
    var deposit by remember { mutableStateOf("") }
    var apy by remember { mutableStateOf("5") }
    var term by remember { mutableStateOf("12") }
    var result by remember { mutableStateOf<CDResult?>(null) }
    val calculator = remember { CDCalculator() }
    val fmt = remember { NumberFormat.getCurrencyInstance(Locale.US) }
    fun calc() { result = calculator.calculate(deposit.toDoubleOrNull() ?: 0.0, apy.toDoubleOrNull() ?: 5.0, term.toIntOrNull() ?: 12) }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "CD Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(deposit, { deposit = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Initial Deposit") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(apy, { apy = it; calc() }, Modifier.fillMaxWidth(), label = { Text("APY") }, suffix = { Text("%") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(term, { term = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Term") }, suffix = { Text("months") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            result?.let {
                Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                    Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Total Value at Maturity", style = MaterialTheme.typography.titleMedium)
                        Text(fmt.format(it.totalValue), style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold)
                        Divider(Modifier.padding(vertical = 16.dp))
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Interest Earned"); Text(fmt.format(it.interestEarned), fontWeight = FontWeight.Bold, color = Color(0xFF4CAF50)) }
                    }
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TipSplitCalculatorScreen(navController: androidx.navigation.NavController) {
    var bill by remember { mutableStateOf("") }
    var tipPercent by remember { mutableStateOf("18") }
    var people by remember { mutableStateOf(2) }
    var result by remember { mutableStateOf<TipSplitResult?>(null) }
    val calculator = remember { TipSplitCalculator() }
    val fmt = remember { NumberFormat.getCurrencyInstance(Locale.US) }
    fun calc() { result = calculator.calculate(bill.toDoubleOrNull() ?: 0.0, tipPercent.toDoubleOrNull() ?: 18.0, people) }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Tip Split Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(bill, { bill = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Bill Amount") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(tipPercent, { tipPercent = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Tip Percentage") }, suffix = { Text("%") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Row(Modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
                listOf(10, 15, 18, 20, 25).forEach { FilterChip(tipPercent == it.toString(), { tipPercent = it.toString(); calc() }, { Text("$it%") }, Modifier.padding(end = 4.dp)) }
            }
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween, verticalAlignment = Alignment.CenterVertically) {
                Text("Number of People", style = MaterialTheme.typography.titleMedium)
                Row(verticalAlignment = Alignment.CenterVertically) {
                    FilledIconButton(onClick = { if (people > 1) { people--; calc() } }) { Icon(Icons.Default.Remove, "Decrease") }
                    Text("$people", Modifier.padding(horizontal = 16.dp), style = MaterialTheme.typography.headlineSmall, fontWeight = FontWeight.Bold)
                    FilledIconButton(onClick = { people++; calc() }) { Icon(Icons.Default.Add, "Increase") }
                }
            }
            result?.let {
                Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                    Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Each Person Pays", style = MaterialTheme.typography.titleMedium)
                        Text(fmt.format(it.perPersonAmount), style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold)
                        Text("(includes ${fmt.format(it.perPersonTip)} tip)", style = MaterialTheme.typography.bodySmall)
                    }
                }
                Card(Modifier.fillMaxWidth()) {
                    Column(Modifier.padding(16.dp)) {
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Subtotal"); Text(fmt.format(bill.toDoubleOrNull() ?: 0.0), fontWeight = FontWeight.Bold) }
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Total Tip"); Text(fmt.format(it.tipAmount), fontWeight = FontWeight.Bold, color = Color(0xFF4CAF50)) }
                        Divider(Modifier.padding(vertical = 8.dp))
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Grand Total"); Text(fmt.format(it.totalWithTip), fontWeight = FontWeight.Bold) }
                    }
                }
            }
        }
    }
}
