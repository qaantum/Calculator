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
import com.qaantum.calculatorhub.calculators.*
import com.qaantum.calculatorhub.customcalculator.ForkCalculator
import com.qaantum.calculatorhub.customcalculator.CustomCalculatorService

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PercentageCalculatorScreen(navController: androidx.navigation.NavController) {
    var c1x by remember { mutableStateOf("") }; var c1y by remember { mutableStateOf("") }; var c1r by remember { mutableStateOf("") }
    var c2x by remember { mutableStateOf("") }; var c2y by remember { mutableStateOf("") }; var c2r by remember { mutableStateOf("") }
    var c3x by remember { mutableStateOf("") }; var c3y by remember { mutableStateOf("") }; var c3r by remember { mutableStateOf("") }
    val calc = remember { PercentageCalculator() }
    
    fun calc1() { c1r = calc.whatIsXPercentOfY(c1x.toDoubleOrNull() ?: return, c1y.toDoubleOrNull() ?: return).value.let { "%.2f".format(it) } }
    fun calc2() { c2r = "%.2f%%".format(calc.xIsWhatPercentOfY(c2x.toDoubleOrNull() ?: return, c2y.toDoubleOrNull() ?: return).value) }
    fun calc3() { c3r = calc.percentageChange(c3x.toDoubleOrNull() ?: return, c3y.toDoubleOrNull() ?: return).value.let { "%+.2f%%".format(it) } }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Percentage Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            PercentageCard("What is X% of Y?", c1x, { c1x = it; calc1() }, "X (%)", c1y, { c1y = it; calc1() }, "Y", c1r)
            PercentageCard("X is what % of Y?", c2x, { c2x = it; calc2() }, "X", c2y, { c2y = it; calc2() }, "Y (Total)", c2r)
            PercentageCard("Percentage Change", c3x, { c3x = it; calc3() }, "From", c3y, { c3y = it; calc3() }, "To", c3r)
        }
    }
}

@Composable
private fun PercentageCard(title: String, v1: String, o1: (String) -> Unit, l1: String, v2: String, o2: (String) -> Unit, l2: String, result: String) {
    Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) {
        Text(title, style = MaterialTheme.typography.titleMedium)
        Spacer(Modifier.height(12.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            OutlinedTextField(v1, o1, Modifier.weight(1f), label = { Text(l1) }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(v2, o2, Modifier.weight(1f), label = { Text(l2) }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
        }
        if (result.isNotEmpty()) { Text(result, Modifier.align(Alignment.End).padding(top = 12.dp), style = MaterialTheme.typography.headlineSmall, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary) }
    }}
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun QuadraticSolverScreen(navController: androidx.navigation.NavController) {
    var a by remember { mutableStateOf("") }; var b by remember { mutableStateOf("") }; var c by remember { mutableStateOf("") }
    var result by remember { mutableStateOf("---") }
    val solver = remember { QuadraticSolver() }
    
    fun calc() {
        val aV = a.toDoubleOrNull() ?: return; val bV = b.toDoubleOrNull() ?: return; val cV = c.toDoubleOrNull() ?: return
        result = when (val r = solver.solve(aV, bV, cV)) {
            is QuadraticResult.TwoRealRoots -> "Two Real Roots:\nx₁ = %.4f\nx₂ = %.4f".format(r.x1, r.x2)
            is QuadraticResult.OneRealRoot -> "One Real Root:\nx = %.4f".format(r.x)
            is QuadraticResult.ComplexRoots -> "Complex Roots:\nx₁ = %.2f + %.2fi\nx₂ = %.2f - %.2fi".format(r.real, r.imaginary, r.real, r.imaginary)
            QuadraticResult.NotQuadratic -> "Not quadratic (a=0)"
        }
    }
    
    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Quadratic Solver",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Text("Solves ax² + bx + c = 0", style = MaterialTheme.typography.titleMedium, modifier = Modifier.align(Alignment.CenterHorizontally))
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(a, { a = it; calc() }, Modifier.weight(1f), label = { Text("a") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
                OutlinedTextField(b, { b = it; calc() }, Modifier.weight(1f), label = { Text("b") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
                OutlinedTextField(c, { c = it; calc() }, Modifier.weight(1f), label = { Text("c") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            }
            Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("Roots", style = MaterialTheme.typography.titleSmall); Text(result, style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GcdLcmCalculatorScreen(navController: androidx.navigation.NavController) {
    var a by remember { mutableStateOf("") }; var b by remember { mutableStateOf("") }
    var gcd by remember { mutableStateOf("---") }; var lcm by remember { mutableStateOf("---") }
    val calc = remember { GcdLcmCalculator() }
    fun calc() { val r = calc.calculate(a.toLongOrNull() ?: return, b.toLongOrNull() ?: return); gcd = r.gcd.toString(); lcm = r.lcm.toString() }
    
    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "GCD / LCM Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(a, { a = it; calc() }, Modifier.weight(1f), label = { Text("Number A") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                OutlinedTextField(b, { b = it; calc() }, Modifier.weight(1f), label = { Text("Number B") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            }
            Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(24.dp)) {
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("GCD", style = MaterialTheme.typography.titleMedium); Text(gcd, style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold) }
                Divider(Modifier.padding(vertical = 16.dp))
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("LCM", style = MaterialTheme.typography.titleMedium); Text(lcm, style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold) }
            }}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FactorialCalculatorScreen(navController: androidx.navigation.NavController) {
    var n by remember { mutableStateOf("") }; var result by remember { mutableStateOf("---") }
    val calc = remember { FactorialCalculator() }
    
    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Factorial Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(n, { n = it; result = calc.calculate(it.toIntOrNull() ?: 0) }, Modifier.fillMaxWidth(), label = { Text("Enter n") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.secondaryContainer)) {
                Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("n! =", style = MaterialTheme.typography.titleMedium); Text(result, style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RandomNumberScreen(navController: androidx.navigation.NavController) {
    var min by remember { mutableStateOf("1") }; var max by remember { mutableStateOf("100") }; var count by remember { mutableStateOf("1") }
    var results by remember { mutableStateOf(listOf<Int>()) }
    val gen = remember { RandomNumberGenerator() }
    
    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Random Number",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(min, { min = it }, Modifier.weight(1f), label = { Text("Min") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                OutlinedTextField(max, { max = it }, Modifier.weight(1f), label = { Text("Max") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                OutlinedTextField(count, { count = it }, Modifier.weight(1f), label = { Text("Count") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            }
            Button({ results = gen.generate(min.toIntOrNull() ?: 1, max.toIntOrNull() ?: 100, count.toIntOrNull() ?: 1) }, Modifier.fillMaxWidth()) { Text("Generate", Modifier.padding(8.dp)) }
            if (results.isNotEmpty()) Card(Modifier.fillMaxWidth()) { Text(results.joinToString(", "), Modifier.padding(24.dp), style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold) }
        }
    }
}
