package com.qaantum.calculatorhub.customcalculator.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.qaantum.calculatorhub.customcalculator.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CustomCalculatorDetailScreen(
    calculatorId: String?,
    calculator: CustomCalculator? = null,
    onEdit: (CustomCalculator) -> Unit,
    onDelete: () -> Unit,
    onBack: () -> Unit
) {
    val context = LocalContext.current
    val service = remember { CustomCalculatorService(context) }
    
    var loadedCalculator by remember { mutableStateOf<CustomCalculator?>(null) }
    var loading by remember { mutableStateOf(true) }
    
    val inputValues = remember { mutableStateMapOf<String, String>() }
    var result by remember { mutableStateOf("") }
    var error by remember { mutableStateOf<String?>(null) }
    var showDeleteDialog by remember { mutableStateOf(false) }
    
    // Load calculator
    LaunchedEffect(calculatorId, calculator) {
        loadedCalculator = calculator ?: calculatorId?.let { service.getById(it) }
        
        loadedCalculator?.let { calc ->
            val lastValues = service.getLastValues(calc.id)
            calc.inputs.forEach { v ->
                inputValues[v.name] = lastValues[v.name]?.toString() ?: v.defaultValue
            }
        }
        loading = false
    }
    
    fun calculate() {
        val calc = loadedCalculator ?: return
        error = null
        result = ""
        
        val inputs = mutableMapOf<String, Double>()
        for (v in calc.inputs) {
            val text = inputValues[v.name] ?: ""
            val value = text.toDoubleOrNull()
            if (value == null) {
                error = "Invalid number for '${v.name}'"
                return
            }
            if (v.min != null && value < v.min) {
                error = "'${v.name}' must be ≥ ${v.min}"
                return
            }
            if (v.max != null && value > v.max) {
                error = "'${v.name}' must be ≤ ${v.max}"
                return
            }
            inputs[v.name] = value
        }
        
        // Save values
        service.saveLastValues(calc.id, inputs)
        
        when (val mathResult = MathEngine.evaluate(calc.formula, inputs)) {
            is MathResult.Success -> result = String.format("%.4f", mathResult.value)
            is MathResult.Error -> error = mathResult.message
        }
    }
    
    fun performDelete() {
        loadedCalculator?.let { service.deleteCalculator(it.id) }
        onDelete()
    }
    
    if (showDeleteDialog) {
        AlertDialog(
            onDismissRequest = { showDeleteDialog = false },
            title = { Text("Delete Calculator?") },
            text = { Text("This cannot be undone.") },
            confirmButton = {
                TextButton(onClick = { performDelete() }) {
                    Text("Delete")
                }
            },
            dismissButton = {
                TextButton(onClick = { showDeleteDialog = false }) {
                    Text("Cancel")
                }
            }
        )
    }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(loadedCalculator?.title ?: "Calculator") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                },
                actions = {
                    loadedCalculator?.let { calc ->
                        IconButton(onClick = { onEdit(calc) }) {
                            Icon(Icons.Default.Edit, contentDescription = "Edit")
                        }
                        IconButton(onClick = { showDeleteDialog = true }) {
                            Icon(Icons.Default.Delete, contentDescription = "Delete")
                        }
                    }
                }
            )
        }
    ) { padding ->
        when {
            loading -> {
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(padding),
                    contentAlignment = Alignment.Center
                ) {
                    CircularProgressIndicator()
                }
            }
            loadedCalculator == null -> {
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(padding),
                    contentAlignment = Alignment.Center
                ) {
                    Text("Calculator not found")
                }
            }
            else -> {
                val calc = loadedCalculator!!
                
                LazyColumn(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(padding)
                        .padding(16.dp),
                    verticalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    // Formula Display
                    item {
                        Card(
                            modifier = Modifier.fillMaxWidth(),
                            colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)
                        ) {
                            Column(modifier = Modifier.padding(12.dp)) {
                                Text(
                                    "Formula",
                                    style = MaterialTheme.typography.labelMedium,
                                    color = MaterialTheme.colorScheme.onSurfaceVariant
                                )
                                Spacer(modifier = Modifier.height(4.dp))
                                Text(
                                    calc.formula,
                                    style = MaterialTheme.typography.bodyLarge
                                )
                            }
                        }
                    }
                    
                    // Inputs
                    item {
                        Card(modifier = Modifier.fillMaxWidth()) {
                            Column(modifier = Modifier.padding(16.dp)) {
                                if (calc.inputs.isEmpty()) {
                                    Text("No variables defined")
                                } else {
                                    calc.inputs.forEach { v ->
                                        val helperText = buildString {
                                            v.description?.let { append(it) }
                                            if (v.min != null || v.max != null) {
                                                if (isNotEmpty()) append(" • ")
                                                when {
                                                    v.min != null && v.max != null -> append("Range: ${v.min} - ${v.max}")
                                                    v.min != null -> append("Min: ${v.min}")
                                                    v.max != null -> append("Max: ${v.max}")
                                                }
                                            }
                                        }
                                        
                                        OutlinedTextField(
                                            value = inputValues[v.name] ?: "",
                                            onValueChange = { inputValues[v.name] = it },
                                            label = { Text("${v.name}${v.unitLabel?.let { " ($it)" } ?: ""}") },
                                            modifier = Modifier.fillMaxWidth(),
                                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal),
                                            singleLine = true,
                                            supportingText = if (helperText.isNotEmpty()) {
                                                { Text(helperText) }
                                            } else null
                                        )
                                        Spacer(modifier = Modifier.height(12.dp))
                                    }
                                }
                                
                                Spacer(modifier = Modifier.height(8.dp))
                                
                                Button(
                                    onClick = { calculate() },
                                    modifier = Modifier.fillMaxWidth()
                                ) {
                                    Icon(Icons.Default.Calculate, contentDescription = null)
                                    Spacer(modifier = Modifier.width(8.dp))
                                    Text("Calculate")
                                }
                            }
                        }
                    }
                    
                    // Result
                    if (result.isNotEmpty() || error != null) {
                        item {
                            Card(
                                modifier = Modifier.fillMaxWidth(),
                                colors = CardDefaults.cardColors(
                                    containerColor = if (error != null) 
                                        MaterialTheme.colorScheme.errorContainer 
                                    else 
                                        MaterialTheme.colorScheme.primaryContainer
                                )
                            ) {
                                Column(
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .padding(24.dp),
                                    horizontalAlignment = Alignment.CenterHorizontally
                                ) {
                                    Text(
                                        if (error != null) "Error" else "Result",
                                        style = MaterialTheme.typography.titleMedium,
                                        color = if (error != null)
                                            MaterialTheme.colorScheme.onErrorContainer
                                        else
                                            MaterialTheme.colorScheme.onPrimaryContainer
                                    )
                                    Spacer(modifier = Modifier.height(8.dp))
                                    Text(
                                        error ?: result,
                                        style = MaterialTheme.typography.displaySmall,
                                        color = if (error != null)
                                            MaterialTheme.colorScheme.onErrorContainer
                                        else
                                            MaterialTheme.colorScheme.onPrimaryContainer
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
