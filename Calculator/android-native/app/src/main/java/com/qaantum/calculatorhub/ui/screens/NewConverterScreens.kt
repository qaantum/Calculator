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
fun TemperatureConverterScreen(navController: androidx.navigation.NavController) {
    var celsius by remember { mutableStateOf("") }
    var fahrenheit by remember { mutableStateOf("") }
    var kelvin by remember { mutableStateOf("") }
    val converter = remember { TemperatureConverter() }

    fun update(from: String, value: String) {
        val v = value.toDoubleOrNull() ?: return
        val r = when (from) { "C" -> converter.fromCelsius(v); "F" -> converter.fromFahrenheit(v); else -> converter.fromKelvin(v) }
        if (from != "C") celsius = String.format("%.2f", r.celsius)
        if (from != "F") fahrenheit = String.format("%.2f", r.fahrenheit)
        if (from != "K") kelvin = String.format("%.2f", r.kelvin)
    }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Temperature Converter",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(celsius, { celsius = it; update("C", it) }, Modifier.fillMaxWidth(), label = { Text("Celsius") }, suffix = { Text("°C") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(fahrenheit, { fahrenheit = it; update("F", it) }, Modifier.fillMaxWidth(), label = { Text("Fahrenheit") }, suffix = { Text("°F") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(kelvin, { kelvin = it; update("K", it) }, Modifier.fillMaxWidth(), label = { Text("Kelvin") }, suffix = { Text("K") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) { Text("Reference Points", style = MaterialTheme.typography.titleMedium); Spacer(Modifier.height(8.dp)); Text("Water freezes: 0°C = 32°F = 273.15K"); Text("Water boils: 100°C = 212°F = 373.15K") } }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LengthConverterScreen(navController: androidx.navigation.NavController) {
    var value by remember { mutableStateOf("") }
    var fromUnit by remember { mutableStateOf("Meters") }
    var toUnit by remember { mutableStateOf("Feet") }
    var result by remember { mutableStateOf<Double?>(null) }
    val converter = remember { LengthConverter() }
    val units = converter.getUnits()

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Length Converter",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(value, { value = it; result = converter.convert(it.toDoubleOrNull() ?: 0.0, fromUnit, toUnit) }, Modifier.fillMaxWidth(), label = { Text("Value") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                var exp1 by remember { mutableStateOf(false) }; var exp2 by remember { mutableStateOf(false) }
                ExposedDropdownMenuBox(exp1, { exp1 = !exp1 }, Modifier.weight(1f)) {
                    OutlinedTextField(fromUnit, {}, Modifier.menuAnchor(), readOnly = true, label = { Text("From") }, trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(exp1) })
                    ExposedDropdownMenu(exp1, { exp1 = false }) { units.forEach { DropdownMenuItem({ Text(it) }, { fromUnit = it; exp1 = false; result = converter.convert(value.toDoubleOrNull() ?: 0.0, fromUnit, toUnit) }) } }
                }
                ExposedDropdownMenuBox(exp2, { exp2 = !exp2 }, Modifier.weight(1f)) {
                    OutlinedTextField(toUnit, {}, Modifier.menuAnchor(), readOnly = true, label = { Text("To") }, trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(exp2) })
                    ExposedDropdownMenu(exp2, { exp2 = false }) { units.forEach { DropdownMenuItem({ Text(it) }, { toUnit = it; exp2 = false; result = converter.convert(value.toDoubleOrNull() ?: 0.0, fromUnit, toUnit) }) } }
                }
            }
            result?.let { Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) { Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) { Text("Result", style = MaterialTheme.typography.titleMedium); Text(String.format("%.6f", it) + " $toUnit", style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold) } } }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun WeightConverterScreen(navController: androidx.navigation.NavController) {
    var value by remember { mutableStateOf("") }
    var fromUnit by remember { mutableStateOf("Kilograms") }
    var toUnit by remember { mutableStateOf("Pounds") }
    var result by remember { mutableStateOf<Double?>(null) }
    val converter = remember { WeightConverter() }
    val units = converter.getUnits()

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Weight Converter",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(value, { value = it; result = converter.convert(it.toDoubleOrNull() ?: 0.0, fromUnit, toUnit) }, Modifier.fillMaxWidth(), label = { Text("Value") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                var exp1 by remember { mutableStateOf(false) }; var exp2 by remember { mutableStateOf(false) }
                ExposedDropdownMenuBox(exp1, { exp1 = !exp1 }, Modifier.weight(1f)) {
                    OutlinedTextField(fromUnit, {}, Modifier.menuAnchor(), readOnly = true, label = { Text("From") }, trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(exp1) })
                    ExposedDropdownMenu(exp1, { exp1 = false }) { units.forEach { DropdownMenuItem({ Text(it) }, { fromUnit = it; exp1 = false; result = converter.convert(value.toDoubleOrNull() ?: 0.0, fromUnit, toUnit) }) } }
                }
                ExposedDropdownMenuBox(exp2, { exp2 = !exp2 }, Modifier.weight(1f)) {
                    OutlinedTextField(toUnit, {}, Modifier.menuAnchor(), readOnly = true, label = { Text("To") }, trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(exp2) })
                    ExposedDropdownMenu(exp2, { exp2 = false }) { units.forEach { DropdownMenuItem({ Text(it) }, { toUnit = it; exp2 = false; result = converter.convert(value.toDoubleOrNull() ?: 0.0, fromUnit, toUnit) }) } }
                }
            }
            result?.let { Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) { Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) { Text("Result", style = MaterialTheme.typography.titleMedium); Text(String.format("%.6f", it) + " $toUnit", style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold) } } }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun VolumeConverterScreen(navController: androidx.navigation.NavController) {
    var value by remember { mutableStateOf("") }
    var fromUnit by remember { mutableStateOf("Liters") }
    var toUnit by remember { mutableStateOf("Gallons (US)") }
    var result by remember { mutableStateOf<Double?>(null) }
    val converter = remember { VolumeConverter() }
    val units = converter.getUnits()

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Volume Converter",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(value, { value = it; result = converter.convert(it.toDoubleOrNull() ?: 0.0, fromUnit, toUnit) }, Modifier.fillMaxWidth(), label = { Text("Value") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                var exp1 by remember { mutableStateOf(false) }; var exp2 by remember { mutableStateOf(false) }
                ExposedDropdownMenuBox(exp1, { exp1 = !exp1 }, Modifier.weight(1f)) {
                    OutlinedTextField(fromUnit, {}, Modifier.menuAnchor(), readOnly = true, label = { Text("From") }, trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(exp1) })
                    ExposedDropdownMenu(exp1, { exp1 = false }) { units.forEach { DropdownMenuItem({ Text(it) }, { fromUnit = it; exp1 = false; result = converter.convert(value.toDoubleOrNull() ?: 0.0, fromUnit, toUnit) }) } }
                }
                ExposedDropdownMenuBox(exp2, { exp2 = !exp2 }, Modifier.weight(1f)) {
                    OutlinedTextField(toUnit, {}, Modifier.menuAnchor(), readOnly = true, label = { Text("To") }, trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(exp2) })
                    ExposedDropdownMenu(exp2, { exp2 = false }) { units.forEach { DropdownMenuItem({ Text(it) }, { toUnit = it; exp2 = false; result = converter.convert(value.toDoubleOrNull() ?: 0.0, fromUnit, toUnit) }) } }
                }
            }
            result?.let { Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) { Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) { Text("Result", style = MaterialTheme.typography.titleMedium); Text(String.format("%.6f", it) + " $toUnit", style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold) } } }
        }
    }
}
