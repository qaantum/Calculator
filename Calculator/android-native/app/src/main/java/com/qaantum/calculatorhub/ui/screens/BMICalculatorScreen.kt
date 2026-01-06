package com.qaantum.calculatorhub.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Build
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.qaantum.calculatorhub.calculators.BMICalculator
import com.qaantum.calculatorhub.calculators.BMIResult
import com.qaantum.calculatorhub.customcalculator.ForkCalculator
import com.qaantum.calculatorhub.customcalculator.CustomCalculatorService
import com.qaantum.calculatorhub.customcalculator.screens.CustomCalculatorBuilderScreen
import java.text.NumberFormat

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BMICalculatorScreen(navController: androidx.navigation.NavController) {
    var isMetric by remember { mutableStateOf(true) }
    var height by remember { mutableStateOf("") }
    var weight by remember { mutableStateOf("") }
    var inches by remember { mutableStateOf("") }
    var bmiResult by remember { mutableStateOf<BMIResult?>(null) }
    var showCustomizeSheet by remember { mutableStateOf(false) }
    
    val calculator = remember { BMICalculator() }
    val context = LocalContext.current

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "BMI Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Unit selector
            // Unit selector
            SegmentedButton(
                segments = listOf(
                    ButtonSegment("Metric", selected = isMetric),
                    ButtonSegment("Imperial", selected = !isMetric)
                ),
                onSegmentSelected = { index ->
                    isMetric = index == 0
                    bmiResult = null
                    height = ""
                    weight = ""
                    inches = ""
                }
            )

            // Height input
            if (isMetric) {
                OutlinedTextField(
                    value = height,
                    onValueChange = { height = it },
                    label = { Text("Height (cm)") },
                    modifier = Modifier.fillMaxWidth(),
                    keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
                        keyboardType = androidx.compose.ui.text.input.KeyboardType.Number
                    )
                )
            } else {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    OutlinedTextField(
                        value = height,
                        onValueChange = { height = it },
                        label = { Text("Feet") },
                        modifier = Modifier.weight(1f),
                        keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
                            keyboardType = androidx.compose.ui.text.input.KeyboardType.Number
                        )
                    )
                    OutlinedTextField(
                        value = inches,
                        onValueChange = { inches = it },
                        label = { Text("Inches") },
                        modifier = Modifier.weight(1f),
                        keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
                            keyboardType = androidx.compose.ui.text.input.KeyboardType.Number
                        )
                    )
                }
            }

            // Weight input
            OutlinedTextField(
                value = weight,
                onValueChange = { weight = it },
                label = { Text(if (isMetric) "Weight (kg)" else "Weight (lbs)") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
                    keyboardType = androidx.compose.ui.text.input.KeyboardType.Number
                )
            )

            // Calculate button
            Button(
                onClick = {
                    try {
                        val weightValue = weight.toDouble()
                        val result = if (isMetric) {
                            val heightValue = height.toDouble()
                            calculator.calculate(heightValue, weightValue, isMetric = true)
                        } else {
                            val feetValue = height.toDouble()
                            val inchesValue = inches.toDoubleOrNull() ?: 0.0
                            calculator.calculateImperial(feetValue, inchesValue, weightValue)
                        }
                        bmiResult = result
                    } catch (e: Exception) {
                        // Handle error
                    }
                },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("Calculate")
            }

            // Result
            bmiResult?.let { result ->
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.primaryContainer
                    )
                ) {
                    Column(
                        modifier = Modifier.padding(16.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text(
                            text = String.format("%.1f", result.bmi),
                            style = MaterialTheme.typography.displayMedium,
                            fontWeight = FontWeight.Bold
                        )
                        Text(
                            text = result.category,
                            style = MaterialTheme.typography.titleLarge,
                            color = MaterialTheme.colorScheme.onPrimaryContainer
                        )
                    }
                }
            }
        }
    }
}

// Helper composable for segmented button
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SegmentedButton(
    segments: List<ButtonSegment>,
    onSegmentSelected: (Int) -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        segments.forEachIndexed { index, segment ->
            FilterChip(
                selected = segment.selected,
                onClick = { onSegmentSelected(index) },
                label = { Text(segment.label) },
                modifier = Modifier.weight(1f)
            )
        }
    }
}

data class ButtonSegment(
    val label: String,
    val selected: Boolean
)

