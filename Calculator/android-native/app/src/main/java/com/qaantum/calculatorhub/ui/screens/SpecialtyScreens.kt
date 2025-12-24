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
fun BinaryConverterScreen() {
    var input by remember { mutableStateOf("") }
    var inputType by remember { mutableStateOf("Decimal") }
    val conv = remember { BinaryConverter() }
    val types = listOf("Decimal", "Binary", "Hex", "Octal")
    
    val decimal = when (inputType) {
        "Binary" -> conv.binaryToDecimal(input)
        "Hex" -> conv.hexToDecimal(input)
        "Octal" -> conv.octalToDecimal(input)
        else -> input.toIntOrNull() ?: 0
    }
    
    Scaffold(topBar = { TopAppBar(title = { Text("Number Base Converter") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            var expanded by remember { mutableStateOf(false) }
            ExposedDropdownMenuBox(expanded, { expanded = !expanded }) {
                OutlinedTextField(inputType, {}, Modifier.fillMaxWidth().menuAnchor(), readOnly = true, label = { Text("Input Type") }, trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded) })
                ExposedDropdownMenu(expanded, { expanded = false }) { types.forEach { DropdownMenuItem({ Text(it) }, { inputType = it; expanded = false }) } }
            }
            OutlinedTextField(input, { input = it }, Modifier.fillMaxWidth(), label = { Text("Value") }, keyboardOptions = KeyboardOptions(keyboardType = if (inputType == "Decimal") KeyboardType.Number else KeyboardType.Text))
            Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) {
                listOf("Decimal" to decimal.toString(), "Binary" to conv.decimalToBinary(decimal), "Hex" to conv.decimalToHex(decimal), "Octal" to conv.decimalToOctal(decimal)).forEach { (l, v) ->
                    Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text(l); Text(v, fontWeight = FontWeight.Bold, style = MaterialTheme.typography.bodyLarge) }
                    HorizontalDivider(Modifier.padding(vertical = 4.dp))
                }
            }}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RomanNumeralConverterScreen() {
    var decimal by remember { mutableStateOf("") }; var roman by remember { mutableStateOf("") }
    var romanResult by remember { mutableStateOf("---") }; var decimalResult by remember { mutableStateOf("---") }
    val conv = remember { RomanNumeralConverter() }
    
    Scaffold(topBar = { TopAppBar(title = { Text("Roman Numerals") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) {
                Text("Decimal → Roman", style = MaterialTheme.typography.titleMedium)
                OutlinedTextField(decimal, { decimal = it; romanResult = conv.toRoman(it.toIntOrNull() ?: 0) }, Modifier.fillMaxWidth(), label = { Text("Decimal (1-3999)") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                Text(romanResult, style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold, modifier = Modifier.align(Alignment.End))
            }}
            Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) {
                Text("Roman → Decimal", style = MaterialTheme.typography.titleMedium)
                OutlinedTextField(roman, { roman = it.uppercase(); decimalResult = conv.fromRoman(it).toString() }, Modifier.fillMaxWidth(), label = { Text("Roman Numeral") })
                Text(decimalResult, style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold, modifier = Modifier.align(Alignment.End))
            }}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GradeCalculatorScreen() {
    var gradesInput by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<GradeResult?>(null) }
    val calc = remember { GradeCalculator() }
    
    Scaffold(topBar = { TopAppBar(title = { Text("Grade Calculator") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(gradesInput, { gradesInput = it }, Modifier.fillMaxWidth().height(120.dp), label = { Text("Enter grades (comma separated)") })
            Button({ 
                val grades = gradesInput.split(",").mapNotNull { it.trim().toDoubleOrNull() }
                if (grades.isNotEmpty()) result = calc.calculate(grades)
            }, Modifier.fillMaxWidth()) { Text("Calculate") }
            result?.let { Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("Average: ${"%.1f".format(it.average)}%", style = MaterialTheme.typography.headlineSmall)
                    Text("Grade: ${it.letterGrade}", style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold)
                    Text("GPA: ${"%.2f".format(it.gpa)}", style = MaterialTheme.typography.headlineSmall)
                }
            }}
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun OneRepMaxCalculatorScreen() {
    var weight by remember { mutableStateOf("") }; var reps by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<OneRepMaxResult?>(null) }
    val calc = remember { OneRepMaxCalculator() }
    
    Scaffold(topBar = { TopAppBar(title = { Text("One Rep Max (1RM)") }) }) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(weight, { weight = it }, Modifier.fillMaxWidth(), label = { Text("Weight Lifted") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(reps, { reps = it }, Modifier.fillMaxWidth(), label = { Text("Reps Performed") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            Button({ result = calc.calculate(weight.toDoubleOrNull() ?: return@Button, reps.toIntOrNull() ?: return@Button) }, Modifier.fillMaxWidth()) { Text("Calculate 1RM") }
            result?.let { Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(24.dp)) {
                Text("Estimated 1RM", style = MaterialTheme.typography.titleMedium, modifier = Modifier.align(Alignment.CenterHorizontally))
                Text("${"%.1f".format(it.oneRepMax)}", style = MaterialTheme.typography.displayMedium, fontWeight = FontWeight.Bold, modifier = Modifier.align(Alignment.CenterHorizontally))
                HorizontalDivider(Modifier.padding(vertical = 16.dp))
                Text("Rep Estimates:", style = MaterialTheme.typography.titleSmall)
                it.estimatedReps.take(6).forEach { (r, w) ->
                    Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("$r rep${if (r > 1) "s" else ""}"); Text("${"%.1f".format(w)}", fontWeight = FontWeight.Bold) }
                }
            }}}
        }
    }
}
