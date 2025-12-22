package com.qaantum.calculatorhub.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.qaantum.calculatorhub.data.CalculatorData
import com.qaantum.calculatorhub.models.CalculatorItem

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(navController: NavController) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Calculator Hub") }
            )
        }
    ) { padding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            items(CalculatorData.categories) { category ->
                CategorySection(
                    category = category,
                    calculators = CalculatorData.getCalculatorsByCategory(category),
                    navController = navController
                )
            }
        }
    }
}

@Composable
fun CategorySection(
    category: String,
    calculators: List<CalculatorItem>,
    navController: NavController
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Text(
                text = category,
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(bottom = 8.dp)
            )
            calculators.forEach { calculator ->
                CalculatorItemRow(
                    calculator = calculator,
                    onClick = {
                        // Navigate to calculator screen
                        navController.navigate(calculator.route)
                    }
                )
            }
        }
    }
}

@Composable
fun CalculatorItemRow(
    calculator: CalculatorItem,
    onClick: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        onClick = onClick
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(
                text = calculator.title,
                style = MaterialTheme.typography.bodyLarge
            )
        }
    }
}

