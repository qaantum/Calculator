package com.qaantum.calculatorhub.customcalculator.screens

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import com.qaantum.calculatorhub.customcalculator.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CustomCalculatorListScreen(
    onCalculatorClick: (CustomCalculator) -> Unit,
    onCreateNew: () -> Unit,
    onTemplateClick: (CustomCalculator) -> Unit,
    onBack: () -> Unit
) {
    val context = LocalContext.current
    val service = remember { CustomCalculatorService(context) }
    
    var calculators by remember { mutableStateOf<List<CustomCalculator>>(emptyList()) }
    var selectedCategory by remember { mutableStateOf("All") }
    var searchQuery by remember { mutableStateOf("") }
    
    // Template categories
    val templateCategories = listOf("All", "Finance", "Physics", "Math", "Health", "Conversions", "Advanced")
    
    val categorizedTemplates = remember {
        mapOf(
            "Finance" to CalculatorTemplates.templates.filter { 
                it.title in listOf("BMI Calculator", "Compound Interest", "Mortgage Payment", "Tip Calculator", "ROI Calculator", "Rule of 72")
            },
            "Physics" to CalculatorTemplates.templates.filter {
                it.title in listOf("Force (F = ma)", "Kinetic Energy", "Gravitational Force", "Ohm's Law (V = IR)", "Projectile Range", "Wave Frequency")
            },
            "Math" to CalculatorTemplates.templates.filter {
                it.title in listOf("Quadratic Formula", "Circle Area", "Sphere Volume", "Pythagorean Theorem", "Distance Formula")
            },
            "Health" to CalculatorTemplates.templates.filter {
                it.title in listOf("BMI Calculator", "BMR (Mifflin-St Jeor)", "Target Heart Rate", "Water Intake")
            },
            "Conversions" to CalculatorTemplates.templates.filter {
                it.title in listOf("Celsius to Fahrenheit", "Fahrenheit to Celsius", "Km to Miles", "Kg to Pounds")
            },
            "Advanced" to CalculatorTemplates.templates.filter {
                it.title in listOf("Definite Integral ∫x² dx", "Derivative at Point", "Logarithm (any base)", "Trigonometry", "Days Between Dates", "Age Calculator")
            }
        )
    }
    
    val displayedTemplates = remember(selectedCategory) {
        if (selectedCategory == "All") CalculatorTemplates.templates
        else categorizedTemplates[selectedCategory] ?: emptyList()
    }
    
    val filteredCalculators = remember(calculators, searchQuery) {
        if (searchQuery.isBlank()) calculators
        else calculators.filter { it.title.contains(searchQuery, ignoreCase = true) }
    }
    
    LaunchedEffect(Unit) {
        calculators = service.getCalculators()
    }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Custom Calculators") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                },
                actions = {
                    IconButton(onClick = onCreateNew) {
                        Icon(Icons.Default.Add, contentDescription = "Create New")
                    }
                }
            )
        },
        floatingActionButton = {
            ExtendedFloatingActionButton(
                onClick = onCreateNew,
                icon = { Icon(Icons.Default.Add, contentDescription = null) },
                text = { Text("New Calculator") }
            )
        }
    ) { padding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            // Header Card
            item {
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 8.dp),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(
                                Icons.Default.Functions,
                                contentDescription = null,
                                modifier = Modifier.size(32.dp),
                                tint = MaterialTheme.colorScheme.onPrimaryContainer
                            )
                            Spacer(modifier = Modifier.width(12.dp))
                            Column {
                                Text(
                                    "Build Your Own",
                                    style = MaterialTheme.typography.titleMedium,
                                    fontWeight = FontWeight.Bold,
                                    color = MaterialTheme.colorScheme.onPrimaryContainer
                                )
                                Text(
                                    "Create custom formulas with 30+ math functions",
                                    style = MaterialTheme.typography.bodySmall,
                                    color = MaterialTheme.colorScheme.onPrimaryContainer.copy(alpha = 0.7f)
                                )
                            }
                        }
                        Spacer(modifier = Modifier.height(12.dp))
                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            AssistChip(
                                onClick = {},
                                label = { Text("sin, cos, tan") },
                                colors = AssistChipDefaults.assistChipColors(
                                    containerColor = MaterialTheme.colorScheme.surface
                                )
                            )
                            AssistChip(
                                onClick = {},
                                label = { Text("∫ integrate") },
                                colors = AssistChipDefaults.assistChipColors(
                                    containerColor = MaterialTheme.colorScheme.surface
                                )
                            )
                            AssistChip(
                                onClick = {},
                                label = { Text("d/dx") },
                                colors = AssistChipDefaults.assistChipColors(
                                    containerColor = MaterialTheme.colorScheme.surface
                                )
                            )
                        }
                    }
                }
            }
            
            // Your Calculators Section
            item {
                Text(
                    "Your Calculators",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold
                )
            }
            
            if (calculators.isEmpty()) {
                item {
                    Card(
                        modifier = Modifier.fillMaxWidth(),
                        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)
                    ) {
                        Column(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(24.dp),
                            horizontalAlignment = Alignment.CenterHorizontally
                        ) {
                            Icon(
                                Icons.Default.Calculate,
                                contentDescription = null,
                                modifier = Modifier.size(48.dp),
                                tint = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                            Spacer(modifier = Modifier.height(12.dp))
                            Text(
                                "No custom calculators yet",
                                style = MaterialTheme.typography.bodyLarge,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                            Spacer(modifier = Modifier.height(4.dp))
                            Text(
                                "Create your own or start from a template below",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                            Spacer(modifier = Modifier.height(16.dp))
                            Button(onClick = onCreateNew) {
                                Icon(Icons.Default.Add, contentDescription = null)
                                Spacer(modifier = Modifier.width(8.dp))
                                Text("Create New")
                            }
                        }
                    }
                }
            } else {
                items(filteredCalculators) { calc ->
                    CalculatorCard(
                        calculator = calc,
                        onClick = { onCalculatorClick(calc) }
                    )
                }
            }
            
            // Templates Section
            item {
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    "Templates",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold
                )
                Text(
                    "Start with a pre-built formula and customize it",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
            
            // Category Chips
            item {
                LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    items(templateCategories) { category ->
                        FilterChip(
                            selected = selectedCategory == category,
                            onClick = { selectedCategory = category },
                            label = { Text(category) }
                        )
                    }
                }
            }
            
            // Template Grid
            items(displayedTemplates.chunked(2)) { row ->
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    row.forEach { template ->
                        TemplateCard(
                            template = template,
                            onClick = { onTemplateClick(template) },
                            modifier = Modifier.weight(1f)
                        )
                    }
                    if (row.size == 1) {
                        Spacer(modifier = Modifier.weight(1f))
                    }
                }
            }
            
            // Bottom padding for FAB
            item {
                Spacer(modifier = Modifier.height(80.dp))
            }
        }
    }
}

@Composable
private fun CalculatorCard(
    calculator: CustomCalculator,
    onClick: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onClick() }
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                Icons.Default.Functions,
                contentDescription = null,
                modifier = Modifier.size(40.dp),
                tint = MaterialTheme.colorScheme.primary
            )
            Spacer(modifier = Modifier.width(16.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    calculator.title,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Medium
                )
                Text(
                    calculator.formula,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
                Spacer(modifier = Modifier.height(4.dp))
                Row {
                    AssistChip(
                        onClick = {},
                        label = { Text("${calculator.inputs.size} vars") },
                        modifier = Modifier.height(24.dp)
                    )
                }
            }
            Icon(
                Icons.Default.ChevronRight,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

@Composable
private fun TemplateCard(
    template: CustomCalculator,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier
            .height(100.dp)
            .clickable { onClick() },
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.secondaryContainer)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(12.dp),
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            Text(
                template.title,
                style = MaterialTheme.typography.titleSmall,
                fontWeight = FontWeight.Medium,
                maxLines = 2,
                overflow = TextOverflow.Ellipsis
            )
            Text(
                template.formula,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSecondaryContainer.copy(alpha = 0.7f),
                maxLines = 2,
                overflow = TextOverflow.Ellipsis
            )
        }
    }
}
