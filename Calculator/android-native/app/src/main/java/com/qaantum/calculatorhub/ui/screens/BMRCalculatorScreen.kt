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
import com.qaantum.calculatorhub.calculators.BMRCalculator
import com.qaantum.calculatorhub.customcalculator.ForkCalculator
import com.qaantum.calculatorhub.customcalculator.CustomCalculatorService

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BMRCalculatorScreen(navController: androidx.navigation.NavController) {
    var age by remember { mutableStateOf("") }
    var height by remember { mutableStateOf("") }
    var weight by remember { mutableStateOf("") }
    var gender by remember { mutableStateOf("Male") }
    var bmr by remember { mutableStateOf<Double?>(null) }
    var showCustomizeSheet by remember { mutableStateOf(false) }
    val calculator = remember { BMRCalculator() }
    val context = LocalContext.current

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "BMR Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { padding ->
        Column(
            modifier = Modifier.fillMaxSize().padding(padding).padding(16.dp).verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                FilterChip(selected = gender == "Male", onClick = { gender = "Male" }, label = { Text("Male") }, modifier = Modifier.weight(1f))
                FilterChip(selected = gender == "Female", onClick = { gender = "Female" }, label = { Text("Female") }, modifier = Modifier.weight(1f))
            }
            OutlinedTextField(value = age, onValueChange = { age = it }, label = { Text("Age") }, modifier = Modifier.fillMaxWidth(), keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            OutlinedTextField(value = height, onValueChange = { height = it }, label = { Text("Height (cm)") }, modifier = Modifier.fillMaxWidth(), keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(value = weight, onValueChange = { weight = it }, label = { Text("Weight (kg)") }, modifier = Modifier.fillMaxWidth(), keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            Button(onClick = {
                val a = age.toIntOrNull() ?: return@Button
                val h = height.toDoubleOrNull() ?: return@Button
                val w = weight.toDoubleOrNull() ?: return@Button
                bmr = calculator.calculate(gender, a, h, w).bmr
            }, modifier = Modifier.fillMaxWidth()) { Text("Calculate BMR", modifier = Modifier.padding(8.dp)) }
            
            bmr?.let {
                Card(modifier = Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.secondaryContainer)) {
                    Column(modifier = Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Basal Metabolic Rate", style = MaterialTheme.typography.titleMedium)
                        Text("${it.toInt()} kcal/day", style = MaterialTheme.typography.displayMedium, fontWeight = FontWeight.Bold)
                        Text("Calories burned at rest", style = MaterialTheme.typography.bodySmall)
                    }
                }
            }
        }
    }
}
