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
import com.qaantum.calculatorhub.calculators.BodyFatCalculator

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BodyFatCalculatorScreen(navController: androidx.navigation.NavController) {
    var height by remember { mutableStateOf("") }
    var waist by remember { mutableStateOf("") }
    var neck by remember { mutableStateOf("") }
    var hip by remember { mutableStateOf("") }
    var gender by remember { mutableStateOf("Male") }
    var bodyFat by remember { mutableStateOf<Double?>(null) }
    val calculator = remember { BodyFatCalculator() }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Body Fat Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { padding ->
        Column(modifier = Modifier.fillMaxSize().padding(padding).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                FilterChip(selected = gender == "Male", onClick = { gender = "Male"; hip = "" }, label = { Text("Male") }, modifier = Modifier.weight(1f))
                FilterChip(selected = gender == "Female", onClick = { gender = "Female" }, label = { Text("Female") }, modifier = Modifier.weight(1f))
            }
            OutlinedTextField(value = height, onValueChange = { height = it }, label = { Text("Height (cm)") }, modifier = Modifier.fillMaxWidth(), keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(value = neck, onValueChange = { neck = it }, label = { Text("Neck Circumference (cm)") }, modifier = Modifier.fillMaxWidth(), keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(value = waist, onValueChange = { waist = it }, label = { Text("Waist Circumference (cm)") }, modifier = Modifier.fillMaxWidth(), keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            if (gender == "Female") {
                OutlinedTextField(value = hip, onValueChange = { hip = it }, label = { Text("Hip Circumference (cm)") }, modifier = Modifier.fillMaxWidth(), keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            }
            Button(onClick = {
                val h = height.toDoubleOrNull() ?: return@Button
                val w = waist.toDoubleOrNull() ?: return@Button
                val n = neck.toDoubleOrNull() ?: return@Button
                val hp = if (gender == "Female") hip.toDoubleOrNull() ?: return@Button else 0.0
                bodyFat = calculator.calculate(gender, h, w, n, hp).bodyFatPercentage
            }, modifier = Modifier.fillMaxWidth()) { Text("Calculate Body Fat", modifier = Modifier.padding(8.dp)) }
            
            bodyFat?.let {
                Card(modifier = Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.secondaryContainer)) {
                    Column(modifier = Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Body Fat Percentage", style = MaterialTheme.typography.titleMedium)
                        Text("${String.format("%.1f", it)}%", style = MaterialTheme.typography.displayMedium, fontWeight = FontWeight.Bold)
                    }
                }
            }
        }
    }
}
