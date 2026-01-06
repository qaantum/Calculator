package com.qaantum.calculatorhub.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.qaantum.calculatorhub.calculators.DiscountCalculator
import com.qaantum.calculatorhub.calculators.DiscountResult
import java.text.NumberFormat
import java.util.Locale

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DiscountCalculatorScreen(navController: androidx.navigation.NavController) {
    var originalPrice by remember { mutableStateOf("") }
    var discountPercent by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<DiscountResult?>(null) }

    val calculator = remember { DiscountCalculator() }
    val currencyFormat = remember { NumberFormat.getCurrencyInstance(Locale.US) }

    fun calculate() {
        val price = originalPrice.toDoubleOrNull() ?: return
        val discount = discountPercent.toDoubleOrNull() ?: return
        result = calculator.calculate(price, discount)
    }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Discount Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(16.dp)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            OutlinedTextField(
                value = originalPrice,
                onValueChange = { 
                    originalPrice = it
                    calculate()
                },
                label = { Text("Original Price") },
                prefix = { Text("$") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )

            OutlinedTextField(
                value = discountPercent,
                onValueChange = { 
                    discountPercent = it
                    calculate()
                },
                label = { Text("Discount (%)") },
                suffix = { Text("%") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
            )

            result?.let { res ->
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.primaryContainer
                    )
                ) {
                    Column(
                        modifier = Modifier.padding(24.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text(
                            "You Save",
                            style = MaterialTheme.typography.titleMedium
                        )
                        Text(
                            currencyFormat.format(res.savedAmount),
                            style = MaterialTheme.typography.headlineSmall,
                            fontWeight = FontWeight.Bold,
                            color = Color(0xFF4CAF50) // Green color
                        )
                        Divider(modifier = Modifier.padding(vertical = 16.dp))
                        Text(
                            "Final Price",
                            style = MaterialTheme.typography.titleMedium
                        )
                        Text(
                            currencyFormat.format(res.finalPrice),
                            style = MaterialTheme.typography.displayMedium,
                            fontWeight = FontWeight.Bold,
                            color = MaterialTheme.colorScheme.onPrimaryContainer
                        )
                    }
                }
            }
        }
    }
}
