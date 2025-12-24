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
fun UnitConverterScreen() {
    var input by remember { mutableStateOf("") }
    var category by remember { mutableStateOf("Length") }
    var fromUnit by remember { mutableStateOf("Meters") }
    var result by remember { mutableStateOf("") }
    val conv = remember { UnitConverter() }

    val categories = listOf("Length", "Weight", "Temperature", "Volume", "Speed")
    
    Scaffold(topBar = { TopAppBar(title = { Text("Unit Converter") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            var expanded by remember { mutableStateOf(false) }
            ExposedDropdownMenuBox(expanded, { expanded = !expanded }) {
                OutlinedTextField(category, {}, Modifier.fillMaxWidth().menuAnchor(), readOnly = true, label = { Text("Category") }, trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded) })
                ExposedDropdownMenu(expanded, { expanded = false }) { categories.forEach { DropdownMenuItem({ Text(it) }, { category = it; expanded = false }) } }
            }
            OutlinedTextField(input, { input = it }, Modifier.fillMaxWidth(), label = { Text("Value") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            
            when (category) {
                "Length" -> {
                    val v = input.toDoubleOrNull() ?: 0.0
                    Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) {
                        listOf("Meters" to v, "Feet" to conv.metersToFeet(v), "Km" to v/1000, "Miles" to conv.kmToMiles(v/1000), "Cm" to v*100, "Inches" to conv.cmToInches(v*100))
                            .forEach { Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text(it.first); Text("%.4f".format(it.second), fontWeight = FontWeight.Bold) }; HorizontalDivider() }
                    }}
                }
                "Weight" -> {
                    val v = input.toDoubleOrNull() ?: 0.0
                    Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) {
                        listOf("Kg" to v, "Lbs" to conv.kgToLbs(v), "Grams" to v*1000, "Oz" to conv.gramsToOz(v*1000))
                            .forEach { Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text(it.first); Text("%.4f".format(it.second), fontWeight = FontWeight.Bold) }; HorizontalDivider() }
                    }}
                }
                "Temperature" -> {
                    val v = input.toDoubleOrNull() ?: 0.0
                    Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) {
                        listOf("Celsius" to v, "Fahrenheit" to conv.celsiusToFahrenheit(v), "Kelvin" to conv.celsiusToKelvin(v))
                            .forEach { Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text(it.first); Text("%.2f".format(it.second), fontWeight = FontWeight.Bold) }; HorizontalDivider() }
                    }}
                }
                "Volume" -> {
                    val v = input.toDoubleOrNull() ?: 0.0
                    Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) {
                        listOf("Liters" to v, "Gallons" to conv.litersToGallons(v), "mL" to v*1000, "Fl Oz" to conv.mlToFlOz(v*1000))
                            .forEach { Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text(it.first); Text("%.4f".format(it.second), fontWeight = FontWeight.Bold) }; HorizontalDivider() }
                    }}
                }
                "Speed" -> {
                    val v = input.toDoubleOrNull() ?: 0.0
                    Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) {
                        listOf("km/h" to v, "mph" to conv.kphToMph(v), "m/s" to conv.kphToMs(v))
                            .forEach { Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text(it.first); Text("%.4f".format(it.second), fontWeight = FontWeight.Bold) }; HorizontalDivider() }
                    }}
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun KinematicCalculatorScreen() {
    var initial by remember { mutableStateOf("") }; var acceleration by remember { mutableStateOf("") }; var time by remember { mutableStateOf("") }
    var finalV by remember { mutableStateOf("---") }; var displacement by remember { mutableStateOf("---") }
    val calc = remember { KinematicCalculator() }
    
    fun calc() {
        val u = initial.toDoubleOrNull() ?: return; val a = acceleration.toDoubleOrNull() ?: return; val t = time.toDoubleOrNull() ?: return
        finalV = "%.4f m/s".format(calc.finalVelocity(u, a, t))
        displacement = "%.4f m".format(calc.displacement(u, a, t))
    }
    
    Scaffold(topBar = { TopAppBar(title = { Text("Kinematic Calculator") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(initial, { initial = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Initial Velocity (m/s)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(acceleration, { acceleration = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Acceleration (m/s²)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(time, { time = it; calc() }, Modifier.fillMaxWidth(), label = { Text("Time (s)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(24.dp)) {
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Final Velocity (v)"); Text(finalV, fontWeight = FontWeight.Bold) }
                HorizontalDivider(Modifier.padding(vertical = 8.dp))
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Displacement (s)"); Text(displacement, fontWeight = FontWeight.Bold) }
            }}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ForceCalculatorScreen() {
    var mass by remember { mutableStateOf("") }; var acceleration by remember { mutableStateOf("") }
    var force by remember { mutableStateOf("---") }
    val calc = remember { ForceCalculator() }
    
    Scaffold(topBar = { TopAppBar(title = { Text("Force Calculator (F = ma)") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(mass, { mass = it }, Modifier.fillMaxWidth(), label = { Text("Mass (kg)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(acceleration, { acceleration = it }, Modifier.fillMaxWidth(), label = { Text("Acceleration (m/s²)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Button({ mass.toDoubleOrNull()?.let { m -> acceleration.toDoubleOrNull()?.let { a -> force = "%.4f N".format(calc.forceFromMassAccel(m, a)) } } }, Modifier.fillMaxWidth()) { Text("Calculate Force") }
            Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("Force", style = MaterialTheme.typography.titleMedium)
                    Text(force, style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold)
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PHCalculatorScreen() {
    var input by remember { mutableStateOf("") }
    var mode by remember { mutableStateOf("pH") }
    var result by remember { mutableStateOf<PHResult?>(null) }
    val calc = remember { PHCalculator() }
    
    Scaffold(topBar = { TopAppBar(title = { Text("pH Calculator") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                FilterChip(mode == "pH", { mode = "pH" }, { Text("From pH") }, Modifier.weight(1f))
                FilterChip(mode == "H+", { mode = "H+" }, { Text("From [H+]") }, Modifier.weight(1f))
            }
            OutlinedTextField(input, { input = it }, Modifier.fillMaxWidth(), label = { Text(if (mode == "pH") "pH Value" else "[H+] Concentration (M)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Button({ input.toDoubleOrNull()?.let { v -> result = if (mode == "pH") calc.fromPH(v) else calc.fromHConcentration(v) } }, Modifier.fillMaxWidth()) { Text("Calculate") }
            result?.let { Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) {
                listOf("pH" to it.pH, "pOH" to it.pOH, "[H+]" to it.hConc, "[OH-]" to it.ohConc).forEach { (label, value) ->
                    Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text(label); Text("%.6e".format(value).let { if (label.startsWith("p")) "%.2f".format(value) else it }, fontWeight = FontWeight.Bold) }
                    HorizontalDivider()
                }
            }}}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun StandardDeviationCalculatorScreen() {
    var input by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<StatsResult?>(null) }
    val calc = remember { StandardDeviationCalculator() }
    
    Scaffold(topBar = { TopAppBar(title = { Text("Statistics Calculator") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(input, { input = it }, Modifier.fillMaxWidth().height(120.dp), label = { Text("Enter numbers (comma separated)") })
            Button({ 
                val nums = input.split(",").mapNotNull { it.trim().toDoubleOrNull() }
                if (nums.isNotEmpty()) result = calc.calculate(nums)
            }, Modifier.fillMaxWidth()) { Text("Calculate") }
            result?.let { Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(24.dp)) {
                listOf("Mean" to it.mean, "Variance" to it.variance, "Std Dev" to it.stdDev, "Count" to it.count.toDouble()).forEach { (l, v) ->
                    Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text(l); Text("%.4f".format(v), fontWeight = FontWeight.Bold) }
                    HorizontalDivider()
                }
            }}}
        }
    }
}
