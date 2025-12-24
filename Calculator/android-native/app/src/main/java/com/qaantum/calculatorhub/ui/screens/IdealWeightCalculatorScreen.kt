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
import com.qaantum.calculatorhub.calculators.IdealWeightCalculator

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun IdealWeightCalculatorScreen() {
    var height by remember { mutableStateOf("") }
    var gender by remember { mutableStateOf("Male") }
    var result by remember { mutableStateOf<Triple<Double, Double, Double>?>(null) }
    val calculator = remember { IdealWeightCalculator() }

    Scaffold(topBar = { TopAppBar(title = { Text("Ideal Weight") }) }) { padding ->
        Column(modifier = Modifier.fillMaxSize().padding(padding).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                FilterChip(selected = gender == "Male", onClick = { gender = "Male" }, label = { Text("Male") }, modifier = Modifier.weight(1f))
                FilterChip(selected = gender == "Female", onClick = { gender = "Female" }, label = { Text("Female") }, modifier = Modifier.weight(1f))
            }
            OutlinedTextField(value = height, onValueChange = { height = it }, label = { Text("Height (cm)") }, modifier = Modifier.fillMaxWidth(), keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Button(onClick = {
                val h = height.toDoubleOrNull() ?: return@Button
                val res = calculator.calculate(gender, h)
                result = Triple(res.idealWeight, res.range.first, res.range.second)
            }, modifier = Modifier.fillMaxWidth()) { Text("Calculate", modifier = Modifier.padding(8.dp)) }
            
            result?.let { (ideal, min, max) ->
                Card(modifier = Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                    Column(modifier = Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Ideal Weight (Devine)", style = MaterialTheme.typography.titleMedium)
                        Text("${String.format("%.1f", ideal)} kg", style = MaterialTheme.typography.displayMedium, fontWeight = FontWeight.Bold)
                        HorizontalDivider(modifier = Modifier.padding(vertical = 16.dp))
                        Text("Healthy BMI Range", style = MaterialTheme.typography.titleSmall)
                        Text("${String.format("%.1f", min)} - ${String.format("%.1f", max)} kg", style = MaterialTheme.typography.titleLarge)
                    }
                }
            }
        }
    }
}
