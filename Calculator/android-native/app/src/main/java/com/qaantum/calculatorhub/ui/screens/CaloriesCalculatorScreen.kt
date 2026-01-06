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
import com.qaantum.calculatorhub.calculators.CaloriesCalculator

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CaloriesCalculatorScreen(navController: androidx.navigation.NavController) {
    var age by remember { mutableStateOf("") }
    var height by remember { mutableStateOf("") }
    var weight by remember { mutableStateOf("") }
    var gender by remember { mutableStateOf("Male") }
    var activityLevel by remember { mutableFloatStateOf(1.2f) }
    var tdee by remember { mutableStateOf<Double?>(null) }
    val calculator = remember { CaloriesCalculator() }

    val activities = listOf(
        1.2f to "Sedentary", 1.375f to "Lightly active", 1.55f to "Moderately active", 
        1.725f to "Very active", 1.9f to "Super active"
    )

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Calorie Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { padding ->
        Column(modifier = Modifier.fillMaxSize().padding(padding).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                FilterChip(selected = gender == "Male", onClick = { gender = "Male" }, label = { Text("Male") }, modifier = Modifier.weight(1f))
                FilterChip(selected = gender == "Female", onClick = { gender = "Female" }, label = { Text("Female") }, modifier = Modifier.weight(1f))
            }
            OutlinedTextField(value = age, onValueChange = { age = it }, label = { Text("Age") }, modifier = Modifier.fillMaxWidth(), keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            OutlinedTextField(value = height, onValueChange = { height = it }, label = { Text("Height (cm)") }, modifier = Modifier.fillMaxWidth(), keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            OutlinedTextField(value = weight, onValueChange = { weight = it }, label = { Text("Weight (kg)") }, modifier = Modifier.fillMaxWidth(), keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal))
            
            Text("Activity Level", style = MaterialTheme.typography.titleMedium)
            activities.forEach { (level, desc) ->
                Row(verticalAlignment = Alignment.CenterVertically) {
                    RadioButton(selected = activityLevel == level, onClick = { activityLevel = level })
                    Text(desc, modifier = Modifier.padding(start = 8.dp))
                }
            }
            
            Button(onClick = {
                val a = age.toIntOrNull() ?: return@Button
                val h = height.toDoubleOrNull() ?: return@Button
                val w = weight.toDoubleOrNull() ?: return@Button
                tdee = calculator.calculate(gender, a, h, w, activityLevel.toDouble()).tdee
            }, modifier = Modifier.fillMaxWidth()) { Text("Calculate", modifier = Modifier.padding(8.dp)) }
            
            tdee?.let {
                Card(modifier = Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.tertiaryContainer)) {
                    Column(modifier = Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Daily Calorie Needs", style = MaterialTheme.typography.titleMedium)
                        Text("${it.toInt()} kcal", style = MaterialTheme.typography.displayMedium, fontWeight = FontWeight.Bold)
                        Text("To maintain current weight", style = MaterialTheme.typography.bodySmall)
                    }
                }
            }
        }
    }
}
