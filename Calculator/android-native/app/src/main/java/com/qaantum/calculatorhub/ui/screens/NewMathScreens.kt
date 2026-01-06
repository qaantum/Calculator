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

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LogarithmCalculatorScreen(navController: androidx.navigation.NavController) {
    var value by remember { mutableStateOf("") }
    var base by remember { mutableStateOf("10") }
    var logType by remember { mutableStateOf("Common (log₁₀)") }
    var result by remember { mutableStateOf<LogarithmResult?>(null) }
    val calculator = remember { LogarithmCalculator() }
    val types = listOf("Natural (ln)", "Common (log₁₀)", "Binary (log₂)", "Custom")

    fun calc() {
        val v = value.toDoubleOrNull() ?: return
        result = when (logType) {
            "Natural (ln)" -> calculator.naturalLog(v)
            "Common (log₁₀)" -> calculator.commonLog(v)
            "Binary (log₂)" -> calculator.binaryLog(v)
            else -> calculator.customLog(v, base.toDoubleOrNull() ?: 10.0)
        }
    }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Logarithm Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(value, { value = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Value") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            var expanded by remember { mutableStateOf(false) }
            ExposedDropdownMenuBox(expanded, { expanded = !expanded }) {
                OutlinedTextField(logType, {}, Modifier.fillMaxWidth().menuAnchor(), readOnly = true, label = { Text("Logarithm Type") }, trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded) })
                ExposedDropdownMenu(expanded, { expanded = false }) { types.forEach { DropdownMenuItem({ Text(it) }, { logType = it; expanded = false; calc() }) } }
            }
            if (logType == "Custom") {
                OutlinedTextField(base, { base = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Base") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            }
            result?.let {
                Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                    Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text(it.formula, style = MaterialTheme.typography.titleMedium)
                        Text(String.format("%.8f", it.result), style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold)
                    }
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun StatisticsCalculatorScreen(navController: androidx.navigation.NavController) {
    var data by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<StatisticsResult?>(null) }
    val calculator = remember { StatisticsCalculator() }

    fun calc() {
        val numbers = data.split(Regex("[,\\s\\n]+")).mapNotNull { it.trim().toDoubleOrNull() }
        if (numbers.isNotEmpty()) result = calculator.calculate(numbers)
    }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Statistics Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(data, { data = it; calc() }, Modifier.fillMaxWidth().height(120.dp), label = { Text("Enter Numbers") }, placeholder = { Text("Separate with commas, spaces, or newlines") }, maxLines = 5)
            Text("Example: 1, 2, 3, 4, 5 or 1 2 3 4 5", style = MaterialTheme.typography.bodySmall)
            result?.let {
                Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                    Column(Modifier.padding(24.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Count"); Text("${it.count} values", fontWeight = FontWeight.Bold) }
                        Divider()
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Mean (Average)"); Text(String.format("%.4f", it.mean), fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary) }
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Median"); Text(String.format("%.4f", it.median), fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary) }
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Mode"); Text(it.mode?.joinToString(", ") { m -> String.format("%.2f", m) } ?: "No mode", fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary) }
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Range"); Text(String.format("%.4f", it.range), fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary) }
                    }
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SummationCalculatorScreen(navController: androidx.navigation.NavController) {
    var firstTerm by remember { mutableStateOf("") }
    var commonDiff by remember { mutableStateOf("") }
    var numTerms by remember { mutableStateOf("") }
    var seriesType by remember { mutableStateOf("Arithmetic") }
    var result by remember { mutableStateOf<SummationResult?>(null) }
    val calculator = remember { SummationCalculator() }

    fun calc() {
        val a = firstTerm.toDoubleOrNull() ?: return
        val d = commonDiff.toDoubleOrNull() ?: return
        val n = numTerms.toIntOrNull() ?: return
        result = if (seriesType == "Arithmetic") calculator.arithmetic(a, d, n) else calculator.geometric(a, d, n)
    }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Summation Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(Modifier.fillMaxWidth()) {
                FilterChip(seriesType == "Arithmetic", { seriesType = "Arithmetic"; calc() }, { Text("Arithmetic") }, Modifier.weight(1f).padding(end = 4.dp))
                FilterChip(seriesType == "Geometric", { seriesType = "Geometric"; calc() }, { Text("Geometric") }, Modifier.weight(1f).padding(start = 4.dp))
            }
            OutlinedTextField(firstTerm, { firstTerm = it; calc() }, Modifier.fillMaxWidth(), label = { Text("First Term (a)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(commonDiff, { commonDiff = it; calc() }, Modifier.fillMaxWidth(), label = { Text(if (seriesType == "Arithmetic") "Common Difference (d)" else "Common Ratio (r)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(numTerms, { numTerms = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Number of Terms (n)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            result?.let {
                Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                    Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Sum of Series", style = MaterialTheme.typography.titleMedium)
                        Text(String.format("%.4f", it.sum), style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold)
                        Divider(Modifier.padding(vertical = 16.dp))
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Last Term"); Text(String.format("%.4f", it.nthTerm), fontWeight = FontWeight.Bold) }
                    }
                }
                Card(Modifier.fillMaxWidth()) {
                    Column(Modifier.padding(16.dp)) {
                        Text("First ${it.terms.size} terms:", style = MaterialTheme.typography.titleSmall)
                        Spacer(Modifier.height(8.dp))
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            it.terms.take(5).forEach { t -> AssistChip(onClick = {}, label = { Text(String.format("%.2f", t)) }) }
                        }
                    }
                }
            }
        }
    }
}
