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
fun AgeCalculatorScreen() {
    var year by remember { mutableStateOf("") }; var month by remember { mutableStateOf("") }; var day by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<AgeResult?>(null) }
    val calc = remember { AgeCalculator() }
    Scaffold(topBar = { TopAppBar(title = { Text("Age Calculator") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(year, { year = it }, Modifier.weight(1f), label = { Text("Year") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                OutlinedTextField(month, { month = it }, Modifier.weight(1f), label = { Text("Month") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                OutlinedTextField(day, { day = it }, Modifier.weight(1f), label = { Text("Day") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            }
            Button({ result = calc.calculate(year.toIntOrNull() ?: return@Button, month.toIntOrNull() ?: return@Button, day.toIntOrNull() ?: return@Button) }, Modifier.fillMaxWidth()) { Text("Calculate Age") }
            result?.let { Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("${it.years} years, ${it.months} months, ${it.days} days", style = MaterialTheme.typography.headlineSmall, fontWeight = FontWeight.Bold)
                }
            }}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun WorkHoursCalculatorScreen() {
    var hours by remember { mutableStateOf("") }; var rate by remember { mutableStateOf("") }
    var threshold by remember { mutableStateOf("40") }; var mult by remember { mutableStateOf("1.5") }
    var result by remember { mutableStateOf<WorkHoursResult?>(null) }
    val calc = remember { WorkHoursCalculator() }
    val fmt = remember { NumberFormat.getCurrencyInstance(Locale.US) }
    
    Scaffold(topBar = { TopAppBar(title = { Text("Work Hours Calculator") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(hours, { hours = it }, Modifier.fillMaxWidth(), label = { Text("Hours Worked") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(rate, { rate = it }, Modifier.fillMaxWidth(), label = { Text("Hourly Rate") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(threshold, { threshold = it }, Modifier.weight(1f), label = { Text("OT Threshold") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
                OutlinedTextField(mult, { mult = it }, Modifier.weight(1f), label = { Text("OT Multiplier") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            }
            Button({ result = calc.calculate(hours.toDoubleOrNull() ?: return@Button, rate.toDoubleOrNull() ?: return@Button, threshold.toDoubleOrNull() ?: 40.0, mult.toDoubleOrNull() ?: 1.5) }, Modifier.fillMaxWidth()) { Text("Calculate") }
            result?.let { Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(24.dp)) {
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Regular Hours"); Text("%.1f".format(it.regularHours), fontWeight = FontWeight.Bold) }
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Overtime Hours"); Text("%.1f".format(it.overtimeHours), fontWeight = FontWeight.Bold) }
                HorizontalDivider(Modifier.padding(vertical = 8.dp))
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Total Pay", fontWeight = FontWeight.Bold); Text(fmt.format(it.totalPay), style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold) }
            }}}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FuelCostCalculatorScreen() {
    var distance by remember { mutableStateOf("") }; var mpg by remember { mutableStateOf("") }; var price by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<FuelCostResult?>(null) }
    val calc = remember { FuelCostCalculator() }
    val fmt = remember { NumberFormat.getCurrencyInstance(Locale.US) }
    
    Scaffold(topBar = { TopAppBar(title = { Text("Fuel Cost Calculator") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(distance, { distance = it }, Modifier.fillMaxWidth(), label = { Text("Distance (miles)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(mpg, { mpg = it }, Modifier.fillMaxWidth(), label = { Text("Fuel Efficiency (MPG)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(price, { price = it }, Modifier.fillMaxWidth(), label = { Text("Price per Gallon") }, prefix = { Text("$") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Button({ result = calc.calculate(distance.toDoubleOrNull() ?: return@Button, mpg.toDoubleOrNull() ?: return@Button, price.toDoubleOrNull() ?: return@Button) }, Modifier.fillMaxWidth()) { Text("Calculate") }
            result?.let { Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(24.dp)) {
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Fuel Needed"); Text("%.2f gal".format(it.fuelNeeded), fontWeight = FontWeight.Bold) }
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Total Cost"); Text(fmt.format(it.totalCost), fontWeight = FontWeight.Bold) }
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Cost per Mile"); Text(fmt.format(it.costPerMile), fontWeight = FontWeight.Bold) }
            }}}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PasswordGeneratorScreen() {
    var length by remember { mutableStateOf("16") }
    var upper by remember { mutableStateOf(true) }; var lower by remember { mutableStateOf(true) }
    var numbers by remember { mutableStateOf(true) }; var symbols by remember { mutableStateOf(true) }
    var password by remember { mutableStateOf("") }
    val gen = remember { PasswordGenerator() }
    
    Scaffold(topBar = { TopAppBar(title = { Text("Password Generator") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(length, { length = it }, Modifier.fillMaxWidth(), label = { Text("Length") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceEvenly) {
                FilterChip(upper, { upper = it }, { Text("ABC") })
                FilterChip(lower, { lower = it }, { Text("abc") })
                FilterChip(numbers, { numbers = it }, { Text("123") })
                FilterChip(symbols, { symbols = it }, { Text("!@#") })
            }
            Button({ password = gen.generate(length.toIntOrNull() ?: 16, upper, lower, numbers, symbols) }, Modifier.fillMaxWidth()) { Text("Generate") }
            if (password.isNotEmpty()) Card(Modifier.fillMaxWidth()) { Text(password, Modifier.padding(24.dp), style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold) }
        }
    }
}
