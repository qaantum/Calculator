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
fun OhmsLawCalculatorScreen() {
    var voltage by remember { mutableStateOf("") }; var current by remember { mutableStateOf("") }; var resistance by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<OhmsLawResult?>(null) }
    var showCustomizeSheet by remember { mutableStateOf(false) }
    val calc = remember { OhmsLawCalculator() }
    val context = LocalContext.current
    
    if (showCustomizeSheet) {
        val forkedCalc = remember { ForkCalculator.createFork("/electronics/ohms-law") }
        forkedCalc?.let { fc ->
            AlertDialog(
                onDismissRequest = { showCustomizeSheet = false },
                title = { Text("Customize This Calculator") },
                text = { 
                    Column {
                        Text("Create your own version of the Ohm's Law Calculator.")
                        Spacer(modifier = Modifier.height(8.dp))
                        Text("Formula: ${fc.formula}", style = MaterialTheme.typography.bodySmall)
                    }
                },
                confirmButton = {
                    Button(onClick = {
                        CustomCalculatorService(context).saveCalculator(fc)
                        showCustomizeSheet = false
                    }) { Text("Create My Version") }
                },
                dismissButton = { TextButton(onClick = { showCustomizeSheet = false }) { Text("Cancel") } }
            )
        }
    }
    
    Scaffold(topBar = { 
        TopAppBar(
            title = { Text("Ohm's Law Calculator") },
            actions = {
                IconButton(onClick = { showCustomizeSheet = true }) {
                    Icon(Icons.Default.Build, contentDescription = "Customize")
                }
            }
        )
    }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Text("V = I × R", style = MaterialTheme.typography.titleMedium, modifier = Modifier.align(Alignment.CenterHorizontally))
            OutlinedTextField(voltage, { voltage = it }, Modifier.fillMaxWidth(), label = { Text("Voltage (V)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(current, { current = it }, Modifier.fillMaxWidth(), label = { Text("Current (A)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(resistance, { resistance = it }, Modifier.fillMaxWidth(), label = { Text("Resistance (Ω)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Button({ current.toDoubleOrNull()?.let { i -> resistance.toDoubleOrNull()?.let { r -> result = calc.calculateVoltage(i, r) } } }, Modifier.weight(1f)) { Text("Calc V") }
                Button({ voltage.toDoubleOrNull()?.let { v -> resistance.toDoubleOrNull()?.let { r -> result = calc.calculateCurrent(v, r) } } }, Modifier.weight(1f)) { Text("Calc I") }
                Button({ voltage.toDoubleOrNull()?.let { v -> current.toDoubleOrNull()?.let { i -> result = calc.calculateResistance(v, i) } } }, Modifier.weight(1f)) { Text("Calc R") }
            }
            result?.let { Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) {
                it.voltage?.let { v -> Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Voltage"); Text("%.4f V".format(v), fontWeight = FontWeight.Bold) } }
                it.current?.let { i -> Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Current"); Text("%.4f A".format(i), fontWeight = FontWeight.Bold) } }
                it.resistance?.let { r -> Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Resistance"); Text("%.4f Ω".format(r), fontWeight = FontWeight.Bold) } }
                it.power?.let { pw -> HorizontalDivider(Modifier.padding(vertical = 8.dp)); Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Power"); Text("%.4f W".format(pw), fontWeight = FontWeight.Bold) } }
            }}}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LEDResistorCalculatorScreen() {
    var supply by remember { mutableStateOf("") }; var led by remember { mutableStateOf("") }; var current by remember { mutableStateOf("20") }
    var result by remember { mutableStateOf<LEDResistorResult?>(null) }
    val calc = remember { LEDResistorCalculator() }
    
    Scaffold(topBar = { TopAppBar(title = { Text("LED Resistor Calculator") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(supply, { supply = it }, Modifier.fillMaxWidth(), label = { Text("Supply Voltage (V)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(led, { led = it }, Modifier.fillMaxWidth(), label = { Text("LED Forward Voltage (V)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(current, { current = it }, Modifier.fillMaxWidth(), label = { Text("LED Current (mA)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Button({ result = calc.calculate(supply.toDoubleOrNull() ?: return@Button, led.toDoubleOrNull() ?: return@Button, current.toDoubleOrNull() ?: return@Button) }, Modifier.fillMaxWidth()) { Text("Calculate") }
            result?.let { Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.secondaryContainer)) { Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                Text("Required Resistor", style = MaterialTheme.typography.titleMedium)
                Text("%.0f Ω".format(it.resistance), style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold)
                Text("Nearest Standard: ${it.nearestStandard} Ω", style = MaterialTheme.typography.bodyLarge)
                Text("Power: %.3f W".format(it.power), style = MaterialTheme.typography.bodyMedium)
            }}}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun WordCountCalculatorScreen() {
    var text by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<WordCountResult?>(null) }
    val calc = remember { WordCountCalculator() }
    
    Scaffold(topBar = { TopAppBar(title = { Text("Word Count") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(text, { text = it; result = calc.count(it) }, Modifier.fillMaxWidth().height(200.dp), label = { Text("Enter text...") })
            result?.let { Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) {
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Characters"); Text("${it.characters}", fontWeight = FontWeight.Bold) }
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Words"); Text("${it.words}", fontWeight = FontWeight.Bold) }
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Sentences"); Text("${it.sentences}", fontWeight = FontWeight.Bold) }
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Paragraphs"); Text("${it.paragraphs}", fontWeight = FontWeight.Bold) }
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("Lines"); Text("${it.lines}", fontWeight = FontWeight.Bold) }
            }}}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun Base64ConverterScreen() {
    var input by remember { mutableStateOf("") }; var output by remember { mutableStateOf("") }
    val conv = remember { Base64Converter() }
    
    Scaffold(topBar = { TopAppBar(title = { Text("Base64 Converter") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(input, { input = it }, Modifier.fillMaxWidth().height(120.dp), label = { Text("Input") })
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Button({ output = conv.encode(input) }, Modifier.weight(1f)) { Text("Encode →") }
                Button({ output = conv.decode(input) }, Modifier.weight(1f)) { Text("Decode ←") }
            }
            OutlinedTextField(output, {}, Modifier.fillMaxWidth().height(120.dp), label = { Text("Output") }, readOnly = true)
        }
    }
}
