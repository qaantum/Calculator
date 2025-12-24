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
fun MacroCalculatorScreen() {
    var calories by remember { mutableStateOf("2000") }
    var protein by remember { mutableStateOf("30") }; var carbs by remember { mutableStateOf("40") }; var fat by remember { mutableStateOf("30") }
    var result by remember { mutableStateOf<MacroResult?>(null) }
    val calc = remember { MacroCalculator() }
    
    Scaffold(topBar = { TopAppBar(title = { Text("Macro Calculator") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(calories, { calories = it }, Modifier.fillMaxWidth(), label = { Text("Target Calories") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(protein, { protein = it }, Modifier.weight(1f), label = { Text("Protein %") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                OutlinedTextField(carbs, { carbs = it }, Modifier.weight(1f), label = { Text("Carbs %") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                OutlinedTextField(fat, { fat = it }, Modifier.weight(1f), label = { Text("Fat %") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            }
            Button({ result = calc.calculate(calories.toIntOrNull() ?: 2000, protein.toIntOrNull() ?: 30, carbs.toIntOrNull() ?: 40, fat.toIntOrNull() ?: 30) }, Modifier.fillMaxWidth()) { Text("Calculate Macros") }
            result?.let { Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(24.dp)) {
                Text("Daily Macros", style = MaterialTheme.typography.titleMedium, modifier = Modifier.align(Alignment.CenterHorizontally))
                Spacer(Modifier.height(16.dp))
                listOf("Protein" to "${it.protein}g", "Carbs" to "${it.carbs}g", "Fat" to "${it.fat}g").forEach { (l, v) ->
                    Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text(l); Text(v, fontWeight = FontWeight.Bold, style = MaterialTheme.typography.titleLarge) }
                    HorizontalDivider(Modifier.padding(vertical = 8.dp))
                }
            }}}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun WaterIntakeCalculatorScreen() {
    var weight by remember { mutableStateOf("") }; var activity by remember { mutableStateOf("Normal") }
    var result by remember { mutableStateOf<WaterResult?>(null) }
    val calc = remember { WaterIntakeCalculator() }
    val activities = listOf("Sedentary", "Normal", "Active", "Athlete")
    
    Scaffold(topBar = { TopAppBar(title = { Text("Water Intake") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(weight, { weight = it }, Modifier.fillMaxWidth(), label = { Text("Weight (kg)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) { activities.forEach { FilterChip(activity == it, { activity = it }, { Text(it) }) } }
            Button({ result = calc.calculate(weight.toDoubleOrNull() ?: return@Button, activity) }, Modifier.fillMaxWidth()) { Text("Calculate") }
            result?.let { Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("Daily Water Intake", style = MaterialTheme.typography.titleMedium)
                    Text("%.1f liters".format(it.liters), style = MaterialTheme.typography.displayMedium, fontWeight = FontWeight.Bold)
                    Text("(${it.glasses} glasses)", style = MaterialTheme.typography.bodyLarge)
                }
            }}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TargetHeartRateScreen() {
    var age by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<TargetHRResult?>(null) }
    val calc = remember { TargetHeartRateCalculator() }
    
    Scaffold(topBar = { TopAppBar(title = { Text("Target Heart Rate") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(age, { age = it; age.toIntOrNull()?.let { a -> result = calc.calculate(a) } }, Modifier.fillMaxWidth(), label = { Text("Age") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            result?.let { res ->
                Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) {
                    Text("Max HR: ${res.maxHR} bpm", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold, modifier = Modifier.align(Alignment.CenterHorizontally))
                    HorizontalDivider(Modifier.padding(vertical = 8.dp))
                    listOf("Zone 1 (50-60%)" to res.zone1, "Zone 2 (60-70%)" to res.zone2, "Zone 3 (70-80%)" to res.zone3, "Zone 4 (80-90%)" to res.zone4, "Zone 5 (90-100%)" to res.zone5).forEach { (label, range) ->
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text(label); Text("${range.first}-${range.second} bpm", fontWeight = FontWeight.Bold) }
                    }
                }}
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SleepCalculatorScreen() {
    var hour by remember { mutableStateOf("22") }; var min by remember { mutableStateOf("00") }
    var result by remember { mutableStateOf<SleepResult?>(null) }
    val calc = remember { SleepCalculator() }
    
    Scaffold(topBar = { TopAppBar(title = { Text("Sleep Calculator") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Text("When do you want to go to bed?", style = MaterialTheme.typography.titleMedium)
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(hour, { hour = it }, Modifier.weight(1f), label = { Text("Hour (0-23)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                OutlinedTextField(min, { min = it }, Modifier.weight(1f), label = { Text("Minute") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            }
            Button({ result = calc.calculateWakeUp(hour.toIntOrNull() ?: 22, min.toIntOrNull() ?: 0) }, Modifier.fillMaxWidth()) { Text("Calculate Wake Times") }
            result?.let { Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(24.dp)) {
                Text("Optimal Wake Up Times", style = MaterialTheme.typography.titleMedium, modifier = Modifier.align(Alignment.CenterHorizontally))
                Text("(Based on 90-min sleep cycles)", style = MaterialTheme.typography.bodySmall, modifier = Modifier.align(Alignment.CenterHorizontally))
                Spacer(Modifier.height(16.dp))
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceEvenly) {
                    it.wakeUpTimes.forEachIndexed { i, time -> Text(time, style = MaterialTheme.typography.headlineSmall, fontWeight = if (i >= 2) FontWeight.Bold else FontWeight.Normal) }
                }
            }}}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PaceCalculatorScreen() {
    var distance by remember { mutableStateOf("") }; var hours by remember { mutableStateOf("0") }; var mins by remember { mutableStateOf("") }; var secs by remember { mutableStateOf("0") }
    var result by remember { mutableStateOf<PaceResult?>(null) }
    val calc = remember { PaceCalculator() }
    
    Scaffold(topBar = { TopAppBar(title = { Text("Pace Calculator") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(distance, { distance = it }, Modifier.fillMaxWidth(), label = { Text("Distance (km)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Text("Time", style = MaterialTheme.typography.titleMedium)
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(hours, { hours = it }, Modifier.weight(1f), label = { Text("Hours") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                OutlinedTextField(mins, { mins = it }, Modifier.weight(1f), label = { Text("Minutes") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                OutlinedTextField(secs, { secs = it }, Modifier.weight(1f), label = { Text("Seconds") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            }
            Button({ result = calc.calculate(distance.toDoubleOrNull() ?: return@Button, hours.toIntOrNull() ?: 0, mins.toIntOrNull() ?: 0, secs.toIntOrNull() ?: 0) }, Modifier.fillMaxWidth()) { Text("Calculate") }
            result?.let { Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(24.dp)) {
                listOf("Pace/km" to it.pacePerKm, "Pace/mile" to it.pacePerMile, "Speed" to "%.2f km/h".format(it.speed)).forEach { (l, v) ->
                    Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text(l); Text(v, fontWeight = FontWeight.Bold, style = MaterialTheme.typography.titleLarge) }
                    HorizontalDivider(Modifier.padding(vertical = 8.dp))
                }
            }}}
        }
    }
}
