package com.qaantum.calculatorhub.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.qaantum.calculatorhub.calculators.BMICalculator
import com.qaantum.calculatorhub.calculators.BMIResult
import java.text.NumberFormat

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BMICalculatorScreen() {
    var isMetric by remember { mutableStateOf(true) }
    var height by remember { mutableStateOf("") }
    var weight by remember { mutableStateOf("") }
    var inches by remember { mutableStateOf("") }
    var bmiResult by remember { mutableStateOf<BMIResult?>(null) }
    
    val calculator = remember { BMICalculator() }

    Scaffold(
        topBar = {
            TopAppBar(title = { Text("BMI Calculator") })
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Unit selector
            SegmentedButton(
                segments = listOf(
                    ButtonSegment("Metric", selected = isMetric) { isMetric = true },
                    ButtonSegment("Imperial", selected = !isMetric) { isMetric = false }
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
                        keyboardType = androidx.compose.foundation.text.KeyboardType.Number
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
                            keyboardType = androidx.compose.foundation.text.KeyboardType.Number
                        )
                    )
                    OutlinedTextField(
                        value = inches,
                        onValueChange = { inches = it },
                        label = { Text("Inches") },
                        modifier = Modifier.weight(1f),
                        keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
                            keyboardType = androidx.compose.foundation.text.KeyboardType.Number
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
                    keyboardType = androidx.compose.foundation.text.KeyboardType.Number
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

