package com.qaantum.calculatorhub.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.qaantum.calculatorhub.calculators.ScientificCalculator

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ScientificCalculatorScreen() {
    val calculator = remember { ScientificCalculator() }
    var input by remember { mutableStateOf(calculator.getInput()) }
    var result by remember { mutableStateOf(calculator.getResult()) }

    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Scientific Calculator") })
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
        ) {
            // Display area
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(2f)
                    .padding(24.dp),
                horizontalAlignment = Alignment.End,
                verticalArrangement = Arrangement.Bottom
            ) {
                Text(
                    text = input,
                    fontSize = 48.sp,
                    fontWeight = FontWeight.Bold,
                    maxLines = 2
                )
            }

            // Button grid
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(5f)
                    .padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                CalculatorButtonRow(
                    buttons = listOf("C", "(", ")", "⌫"),
                    onButtonClick = { button ->
                        calculator.onButtonPressed(button)
                        input = calculator.getInput()
                        result = calculator.getResult()
                    }
                )
                CalculatorButtonRow(
                    buttons = listOf("sin", "cos", "tan", "^"),
                    onButtonClick = { button ->
                        calculator.onButtonPressed(button)
                        input = calculator.getInput()
                        result = calculator.getResult()
                    }
                )
                CalculatorButtonRow(
                    buttons = listOf("ln", "log", "sqrt", "/"),
                    onButtonClick = { button ->
                        calculator.onButtonPressed(button)
                        input = calculator.getInput()
                        result = calculator.getResult()
                    }
                )
                CalculatorButtonRow(
                    buttons = listOf("7", "8", "9", "×"),
                    onButtonClick = { button ->
                        calculator.onButtonPressed(button)
                        input = calculator.getInput()
                        result = calculator.getResult()
                    }
                )
                CalculatorButtonRow(
                    buttons = listOf("4", "5", "6", "-"),
                    onButtonClick = { button ->
                        calculator.onButtonPressed(button)
                        input = calculator.getInput()
                        result = calculator.getResult()
                    }
                )
                CalculatorButtonRow(
                    buttons = listOf("1", "2", "3", "+"),
                    onButtonClick = { button ->
                        calculator.onButtonPressed(button)
                        input = calculator.getInput()
                        result = calculator.getResult()
                    }
                )
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    CalculatorButton(
                        text = "π",
                        modifier = Modifier.weight(1f),
                        onClick = {
                            calculator.onButtonPressed("π")
                            input = calculator.getInput()
                            result = calculator.getResult()
                        }
                    )
                    CalculatorButton(
                        text = "0",
                        modifier = Modifier.weight(1f),
                        onClick = {
                            calculator.onButtonPressed("0")
                            input = calculator.getInput()
                            result = calculator.getResult()
                        }
                    )
                    CalculatorButton(
                        text = ".",
                        modifier = Modifier.weight(1f),
                        onClick = {
                            calculator.onButtonPressed(".")
                            input = calculator.getInput()
                            result = calculator.getResult()
                        }
                    )
                    CalculatorButton(
                        text = "=",
                        modifier = Modifier.weight(1f),
                        onClick = {
                            calculator.onButtonPressed("=")
                            input = calculator.getInput()
                            result = calculator.getResult()
                        }
                    )
                }
            }
        }
    }
}

