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

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BloodSugarConverterScreen(navController: androidx.navigation.NavController) {
    var mgdl by remember { mutableStateOf("") }
    var mmol by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<BloodSugarResult?>(null) }
    val converter = remember { BloodSugarConverter() }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Blood Sugar Converter",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(mgdl, {
                mgdl = it
                it.toDoubleOrNull()?.let { v -> result = converter.fromMgdl(v); mmol = String.format("%.2f", result!!.mmol) }
            }, Modifier.fillMaxWidth(), label = { Text("mg/dL") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(mmol, {
                mmol = it
                it.toDoubleOrNull()?.let { v -> result = converter.fromMmol(v); mgdl = String.format("%.1f", result!!.mgdl) }
            }, Modifier.fillMaxWidth(), label = { Text("mmol/L") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            result?.let {
                val color = when (it.categoryColor) { "green" -> Color(0xFF4CAF50); "orange" -> Color(0xFFFF9800); else -> Color(0xFFF44336) }
                Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = color.copy(alpha = 0.1f))) {
                    Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Classification", style = MaterialTheme.typography.titleMedium)
                        Text(it.category, style = MaterialTheme.typography.headlineSmall, fontWeight = FontWeight.Bold, color = color)
                    }
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun VO2MaxCalculatorScreen(navController: androidx.navigation.NavController) {
    var method by remember { mutableStateOf("Cooper Test") }
    var distance by remember { mutableStateOf("") }
    var maxHR by remember { mutableStateOf("") }
    var restingHR by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<VO2MaxResult?>(null) }
    val calculator = remember { VO2MaxCalculator() }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "VO₂ Max Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row { FilterChip(method == "Cooper Test", { method = "Cooper Test" }, { Text("Cooper Test") }, Modifier.weight(1f)); FilterChip(method == "Heart Rate", { method = "Heart Rate" }, { Text("Heart Rate") }, Modifier.weight(1f)) }
            if (method == "Cooper Test") {
                OutlinedTextField(distance, { distance = it; distance.toDoubleOrNull()?.let { v -> result = calculator.cooperTest(v) } }, Modifier.fillMaxWidth(), label = { Text("Distance (meters)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            } else {
                OutlinedTextField(maxHR, { maxHR = it }, Modifier.fillMaxWidth(), label = { Text("Max Heart Rate (bpm)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
                OutlinedTextField(restingHR, { restingHR = it; val m = maxHR.toDoubleOrNull(); val r = restingHR.toDoubleOrNull(); if (m != null && r != null) result = calculator.heartRateMethod(m, r) }, Modifier.fillMaxWidth(), label = { Text("Resting Heart Rate (bpm)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            }
            result?.let {
                Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                    Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Estimated VO₂ Max", style = MaterialTheme.typography.titleMedium)
                        Text("${String.format("%.1f", it.vo2max)} mL/kg/min", style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold)
                        Text(it.fitnessLevel, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary)
                    }
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MedicationDosageCalculatorScreen(navController: androidx.navigation.NavController) {
    var weight by remember { mutableStateOf("") }
    var weightUnit by remember { mutableStateOf("kg") }
    var dosePerKg by remember { mutableStateOf("") }
    var concentration by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<MedicationDosageResult?>(null) }
    val calculator = remember { MedicationDosageCalculator() }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Medication Dosage",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Card(colors = CardDefaults.cardColors(containerColor = Color(0xFFFFC107).copy(alpha = 0.1f))) { Text("⚠️ For educational purposes only. Consult a healthcare provider.", Modifier.padding(12.dp)) }
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(weight, { weight = it }, Modifier.weight(2f), label = { Text("Body Weight") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
                Row { FilterChip(weightUnit == "kg", { weightUnit = "kg" }, { Text("kg") }); FilterChip(weightUnit == "lb", { weightUnit = "lb" }, { Text("lb") }) }
            }
            OutlinedTextField(dosePerKg, { dosePerKg = it }, Modifier.fillMaxWidth(), label = { Text("Dose per kg (mg/kg)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(concentration, { concentration = it }, Modifier.fillMaxWidth(), label = { Text("Concentration (mg/mL) - Optional") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Button({
                var w = weight.toDoubleOrNull() ?: return@Button
                if (weightUnit == "lb") w = calculator.convertLbToKg(w)
                val dose = dosePerKg.toDoubleOrNull() ?: return@Button
                result = calculator.calculate(w, dose, concentration.toDoubleOrNull())
            }, Modifier.fillMaxWidth()) { Text("Calculate") }
            result?.let {
                Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                    Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Single Dose", style = MaterialTheme.typography.titleMedium)
                        Text("${String.format("%.2f", it.singleDose)} mg", style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold)
                        it.volumePerDose?.let { v -> Text("= ${String.format("%.2f", v)} mL", style = MaterialTheme.typography.titleLarge) }
                    }
                }
            }
        }
    }
}
