package com.qaantum.calculatorhub.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.qaantum.calculatorhub.R
import com.qaantum.calculatorhub.data.CalculatorData
import com.qaantum.calculatorhub.ui.components.CategoryCard
import com.qaantum.calculatorhub.ui.theme.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(navController: NavController) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { 
                    Column {
                        Text("Calculator Hub", fontWeight = FontWeight.Bold)
                        Text("Professional Tools", style = MaterialTheme.typography.labelMedium)
                    }
                },
                actions = {
                    IconButton(onClick = { /* TODO: Settings */ }) {
                        Icon(Icons.Default.Settings, contentDescription = "Settings")
                    }
                }
            )
        },
        floatingActionButton = {
            ExtendedFloatingActionButton(
                onClick = { navController.navigate("/custom") },
                containerColor = MaterialTheme.colorScheme.primary,
                contentColor = MaterialTheme.colorScheme.onPrimary,
                icon = { Icon(Icons.Default.Build, "Custom") },
                text = { Text("Custom Builder") }
            )
        }
    ) { padding ->
        val context = androidx.compose.ui.platform.LocalContext.current
        val customService = remember { com.qaantum.calculatorhub.customcalculator.CustomCalculatorService(context) }
        val myTools = remember { customService.getCalculators() }

        LazyVerticalGrid(
            columns = GridCells.Fixed(2),
            contentPadding = PaddingValues(16.dp),
            horizontalArrangement = Arrangement.spacedBy(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp),
            modifier = Modifier.padding(padding)
        ) {
            if (myTools.isNotEmpty()) {
                item(span = { androidx.compose.foundation.lazy.grid.GridItemSpan(2) }) {
                    Text(
                        "My Tools",
                        style = MaterialTheme.typography.titleSmall,
                        color = MaterialTheme.colorScheme.primary,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.padding(bottom = 0.dp)
                    )
                }
                items(myTools) { tool ->
                    CategoryCard(
                        title = tool.title,
                        icon = Icons.Default.Build, 
                        color = MaterialTheme.colorScheme.tertiary,
                        onClick = { navController.navigate("/custom/detail/${tool.id}") }
                    )
                }
            }

            // Quick Access Section (Spans full width)
            item(span = { androidx.compose.foundation.lazy.grid.GridItemSpan(2) }) {
                Text(
                    "Quick Access",
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.primary,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(bottom = 0.dp)
                )
            }

            // Standard Calculator Card
            item {
                CategoryCard(
                    title = "Standard",
                    icon = Icons.Default.Calculate,
                    color = MaterialTheme.colorScheme.primary,
                    onClick = { navController.navigate("/standard") }
                )
            }

            // Scientific Calculator Card
            item {
                CategoryCard(
                    title = "Scientific",
                    icon = Icons.Default.Science, // Changed icon to Science/Flask if available or generic
                    color = MaterialTheme.colorScheme.secondary,
                    onClick = { navController.navigate("/scientific") }
                )
            }

            // Categories Section Header
            item(span = { androidx.compose.foundation.lazy.grid.GridItemSpan(2) }) {
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    "Categories",
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.primary,
                    fontWeight = FontWeight.Bold
                )
            }

            items(CalculatorData.categories) { category ->
                CategoryCard(
                    title = category,
                    icon = getCategoryIcon(category),
                    color = getCategoryColor(category),
                    onClick = {
                        navController.navigate("category/$category")
                    }
                )
            }
            
            item { Spacer(modifier = Modifier.height(64.dp)) } // Spacer for FAB
        }
    }
}

fun getCategoryIcon(category: String): ImageVector {
    return when (category) {
        "Finance" -> Icons.Default.AttachMoney
        "Math" -> Icons.Default.Calculate
        "Health" -> Icons.Default.Favorite
        "Converters" -> Icons.Default.Transform
        "Other" -> Icons.Default.Widgets
        else -> Icons.Default.Category
    }
}

@Composable
fun getCategoryColor(category: String): Color {
    // In our clean theme, we might want to keep icons somewhat uniform or use our palette accents
    return when (category) {
        "Finance" -> MaterialTheme.colorScheme.primary
        "Math" -> MaterialTheme.colorScheme.primary
        "Health" -> Red500
        else -> MaterialTheme.colorScheme.secondary
    }
}

