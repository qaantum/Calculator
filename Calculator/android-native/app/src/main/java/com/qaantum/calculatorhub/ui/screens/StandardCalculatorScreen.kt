package com.qaantum.calculatorhub.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.qaantum.calculatorhub.calculators.StandardCalculator

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun StandardCalculatorScreen() {
    val calculator = remember { StandardCalculator() }
    var input by remember { mutableStateOf(calculator.getInput()) }
    var result by remember { mutableStateOf(calculator.getResult()) }
    var expression by remember { mutableStateOf(calculator.getExpression()) }

    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Standard Calculator") })
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
                if (expression.isNotEmpty()) {
                    Text(
                        text = expression,
                        fontSize = 24.sp,
                        color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                }
                Text(
                    text = input,
                    fontSize = 64.sp,
                    fontWeight = FontWeight.Bold
                )
            }

            // Button grid
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(3f)
                    .padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                CalculatorButtonRow(
                    buttons = listOf("C", "⌫", "%", "÷"),
                    onButtonClick = { button ->
                        calculator.onButtonPressed(button)
                        input = calculator.getInput()
                        result = calculator.getResult()
                        expression = calculator.getExpression()
                    }
                )
                CalculatorButtonRow(
                    buttons = listOf("7", "8", "9", "×"),
                    onButtonClick = { button ->
                        calculator.onButtonPressed(button)
                        input = calculator.getInput()
                        result = calculator.getResult()
                        expression = calculator.getExpression()
                    }
                )
                CalculatorButtonRow(
                    buttons = listOf("4", "5", "6", "-"),
                    onButtonClick = { button ->
                        calculator.onButtonPressed(button)
                        input = calculator.getInput()
                        result = calculator.getResult()
                        expression = calculator.getExpression()
                    }
                )
                CalculatorButtonRow(
                    buttons = listOf("1", "2", "3", "+"),
                    onButtonClick = { button ->
                        calculator.onButtonPressed(button)
                        input = calculator.getInput()
                        result = calculator.getResult()
                        expression = calculator.getExpression()
                    }
                )
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    CalculatorButton(
                        text = "0",
                        modifier = Modifier.weight(2f),
                        onClick = {
                            calculator.onButtonPressed("0")
                            input = calculator.getInput()
                            result = calculator.getResult()
                            expression = calculator.getExpression()
                        }
                    )
                    CalculatorButton(
                        text = ".",
                        modifier = Modifier.weight(1f),
                        onClick = {
                            calculator.onButtonPressed(".")
                            input = calculator.getInput()
                            result = calculator.getResult()
                            expression = calculator.getExpression()
                        }
                    )
                    CalculatorButton(
                        text = "=",
                        modifier = Modifier.weight(1f),
                        onClick = {
                            calculator.onButtonPressed("=")
                            input = calculator.getInput()
                            result = calculator.getResult()
                            expression = calculator.getExpression()
                        }
                    )
                }
            }
        }
    }
}

@Composable
fun CalculatorButtonRow(
    buttons: List<String>,
    onButtonClick: (String) -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        buttons.forEach { button ->
            CalculatorButton(
                text = button,
                modifier = Modifier.weight(1f),
                onClick = { onButtonClick(button) }
            )
        }
    }
}

@Composable
fun CalculatorButton(
    text: String,
    modifier: Modifier = Modifier,
    onClick: () -> Unit
) {
    Button(
        onClick = onClick,
        modifier = modifier.height(80.dp),
        colors = ButtonDefaults.buttonColors(
            containerColor = when (text) {
                "C", "⌫", "%" -> MaterialTheme.colorScheme.secondary
                "÷", "×", "-", "+", "=" -> MaterialTheme.colorScheme.primary
                else -> MaterialTheme.colorScheme.surfaceVariant
            }
        )
    ) {
        Text(
            text = text,
            fontSize = 24.sp,
            fontWeight = FontWeight.Bold
        )
    }
}

