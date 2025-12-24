package com.qaantum.calculatorhub.customcalculator.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
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
import java.util.UUID

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CustomCalculatorBuilderScreen(
    existingCalculator: CustomCalculator? = null,
    onSave: () -> Unit,
    onBack: () -> Unit
) {
    val context = LocalContext.current
    val service = remember { CustomCalculatorService(context) }
    
    var title by remember { mutableStateOf(existingCalculator?.title ?: "") }
    var formula by remember { mutableStateOf(existingCalculator?.formula ?: "") }
    var variables by remember { mutableStateOf(existingCalculator?.inputs?.toMutableList() ?: mutableListOf()) }
    
    // Variable creation state
    var varName by remember { mutableStateOf("") }
    var varUnit by remember { mutableStateOf("") }
    var varDesc by remember { mutableStateOf("") }
    var varMin by remember { mutableStateOf("") }
    var varMax by remember { mutableStateOf("") }
    
    // Playground state
    val playgroundValues = remember { mutableStateMapOf<String, String>() }
    var result by remember { mutableStateOf("") }
    var error by remember { mutableStateOf<String?>(null) }
    
    // Help dialog
    var showHelp by remember { mutableStateOf(false) }
    
    // Selected tab for formula helpers
    var selectedTab by remember { mutableStateOf(0) }
    
    // Formula helper categories
    val formulaHelpers = listOf(
        "Basic" to listOf("+", "-", "*", "/", "^", "()", "pi", "e", "phi"),
        "Trig" to listOf("sin()", "cos()", "tan()", "asin()", "acos()", "atan()"),
        "Log" to listOf("ln()", "log()", "log(x,b)", "exp()"),
        "Root" to listOf("sqrt()", "cbrt()", "root(x,n)"),
        "Round" to listOf("abs()", "ceil()", "floor()", "round()"),
        "Calc" to listOf("deriv(f,x,p)", "integrate(f,x,a,b)"),
        "Stat" to listOf("min(a,b)", "max(a,b)", "factorial()"),
        "Date" to listOf("age()", "daysBetween()")
    )
    
    // Initialize playground values
    LaunchedEffect(variables) {
        variables.forEach { v ->
            if (!playgroundValues.containsKey(v.name)) {
                playgroundValues[v.name] = v.defaultValue
            }
        }
    }
    
    fun addVariable() {
        if (varName.isBlank()) return
        if (variables.any { it.name == varName }) {
            error = "Variable '$varName' already exists"
            return
        }
        
        val reserved = listOf("pi", "e", "phi", "log", "ln", "sqrt", "sin", "cos", "tan", "abs", 
            "ceil", "floor", "round", "exp", "asin", "acos", "atan", "sinh", "cosh", "tanh",
            "cbrt", "root", "min", "max", "deriv", "integrate", "factorial", "mod", "age", "daysbetween")
        if (varName.lowercase() in reserved) {
            error = "'$varName' is a reserved word"
            return
        }
        
        variables = (variables + CalculatorVariable(
            name = varName,
            unitLabel = varUnit.ifBlank { null },
            description = varDesc.ifBlank { null },
            min = varMin.toDoubleOrNull(),
            max = varMax.toDoubleOrNull()
        )).toMutableList()
        
        playgroundValues[varName] = "0"
        varName = ""
        varUnit = ""
        varDesc = ""
        varMin = ""
        varMax = ""
        error = null
    }
    
    fun removeVariable(name: String) {
        variables = variables.filter { it.name != name }.toMutableList()
        playgroundValues.remove(name)
    }
    
    fun testFormula() {
        error = null
        result = ""
        
        val inputs = mutableMapOf<String, Double>()
        for (v in variables) {
            val text = playgroundValues[v.name] ?: ""
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
        
        when (val mathResult = MathEngine.evaluate(formula, inputs)) {
            is MathResult.Success -> result = String.format("%.6f", mathResult.value).trimEnd('0').trimEnd('.')
            is MathResult.Error -> error = mathResult.message
        }
    }
    
    fun saveCalculator() {
        if (title.isBlank()) {
            error = "Please enter a title"
            return
        }
        if (formula.isBlank()) {
            error = "Please enter a formula"
            return
        }
        
        val calculator = CustomCalculator(
            id = existingCalculator?.id ?: UUID.randomUUID().toString(),
            title = title,
            inputs = variables,
            formula = formula,
            createdAt = existingCalculator?.createdAt ?: System.currentTimeMillis(),
            updatedAt = System.currentTimeMillis(),
            pinned = existingCalculator?.pinned ?: false
        )
        
        service.saveCalculator(calculator)
        onSave()
    }
    
    // Help Dialog
    if (showHelp) {
        AlertDialog(
            onDismissRequest = { showHelp = false },
            title = { Text("Supported Functions") },
            text = {
                LazyColumn {
                    items(MathEngine.supportedFunctions) { line ->
                        Text(
                            line,
                            style = MaterialTheme.typography.bodySmall,
                            modifier = Modifier.padding(vertical = 4.dp)
                        )
                    }
                }
            },
            confirmButton = {
                TextButton(onClick = { showHelp = false }) {
                    Text("Got it")
                }
            }
        )
    }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(if (existingCalculator == null) "Build Calculator" else "Edit Calculator") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                },
                actions = {
                    IconButton(onClick = { showHelp = true }) {
                        Icon(Icons.Default.Help, contentDescription = "Help")
                    }
                    IconButton(onClick = { saveCalculator() }) {
                        Icon(Icons.Default.Check, contentDescription = "Save")
                    }
                }
            )
        }
    ) { padding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Title
            item {
                OutlinedTextField(
                    value = title,
                    onValueChange = { title = it },
                    label = { Text("Calculator Name") },
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true,
                    leadingIcon = { Icon(Icons.Default.Edit, contentDescription = null) }
                )
            }
            
            // Variables Section
            item {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("Define Variables", style = MaterialTheme.typography.titleMedium)
                    Text("${variables.size} defined", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
            }
            
            item {
                Card(modifier = Modifier.fillMaxWidth()) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            OutlinedTextField(
                                value = varName,
                                onValueChange = { varName = it.filter { c -> c.isLetterOrDigit() || c == '_' } },
                                label = { Text("Name") },
                                placeholder = { Text("x, rate, mass...") },
                                modifier = Modifier.weight(1f),
                                singleLine = true
                            )
                            OutlinedTextField(
                                value = varUnit,
                                onValueChange = { varUnit = it },
                                label = { Text("Unit") },
                                placeholder = { Text("kg, $, %...") },
                                modifier = Modifier.weight(0.6f),
                                singleLine = true
                            )
                        }
                        Spacer(modifier = Modifier.height(8.dp))
                        OutlinedTextField(
                            value = varDesc,
                            onValueChange = { varDesc = it },
                            label = { Text("Description (optional)") },
                            placeholder = { Text("What does this variable represent?") },
                            modifier = Modifier.fillMaxWidth(),
                            singleLine = true
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            OutlinedTextField(
                                value = varMin,
                                onValueChange = { varMin = it },
                                label = { Text("Min") },
                                modifier = Modifier.weight(1f),
                                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                                singleLine = true
                            )
                            OutlinedTextField(
                                value = varMax,
                                onValueChange = { varMax = it },
                                label = { Text("Max") },
                                modifier = Modifier.weight(1f),
                                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                                singleLine = true
                            )
                        }
                        Spacer(modifier = Modifier.height(12.dp))
                        Button(
                            onClick = { addVariable() },
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            Icon(Icons.Default.Add, contentDescription = null)
                            Spacer(modifier = Modifier.width(8.dp))
                            Text("Add Variable")
                        }
                    }
                }
            }
            
            // Variable Chips
            if (variables.isNotEmpty()) {
                item {
                    LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        items(variables) { v ->
                            AssistChip(
                                onClick = { formula += v.name },
                                label = { 
                                    Text(buildString {
                                        append(v.name)
                                        v.unitLabel?.let { append(" ($it)") }
                                    })
                                },
                                trailingIcon = {
                                    IconButton(
                                        onClick = { removeVariable(v.name) },
                                        modifier = Modifier.size(18.dp)
                                    ) {
                                        Icon(Icons.Default.Close, contentDescription = "Remove", modifier = Modifier.size(14.dp))
                                    }
                                }
                            )
                        }
                    }
                }
            }
            
            // Formula Section
            item {
                Text("Write Formula", style = MaterialTheme.typography.titleMedium)
            }
            
            item {
                OutlinedTextField(
                    value = formula,
                    onValueChange = { formula = it },
                    label = { Text("Formula") },
                    placeholder = { Text("e.g. m * a or sqrt(x^2 + y^2)") },
                    modifier = Modifier.fillMaxWidth(),
                    minLines = 2,
                    maxLines = 4,
                    supportingText = { Text("Tap chips below to insert functions") }
                )
            }
            
            // Formula Helper Tabs
            item {
                ScrollableTabRow(
                    selectedTabIndex = selectedTab,
                    modifier = Modifier.fillMaxWidth()
                ) {
                    formulaHelpers.forEachIndexed { index, (name, _) ->
                        Tab(
                            selected = selectedTab == index,
                            onClick = { selectedTab = index },
                            text = { Text(name) }
                        )
                    }
                }
            }
            
            item {
                LazyRow(horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                    items(formulaHelpers[selectedTab].second) { op ->
                        SuggestionChip(
                            onClick = { 
                                // Insert at cursor or append
                                val insertText = if (op.endsWith("()")) {
                                    op.dropLast(1) // Keep the opening parenthesis
                                } else if (op.contains(",")) {
                                    op.replace("x", "").replace("a", "").replace("b", "").replace("n", "").replace("p", "").replace("f", "")
                                } else {
                                    op
                                }
                                formula += insertText
                            },
                            label = { Text(op) }
                        )
                    }
                }
            }
            
            // Test Section
            item {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("Test Formula", style = MaterialTheme.typography.titleMedium)
                    TextButton(onClick = { showHelp = true }) {
                        Icon(Icons.Default.Info, contentDescription = null, modifier = Modifier.size(16.dp))
                        Spacer(modifier = Modifier.width(4.dp))
                        Text("Functions Help")
                    }
                }
            }
            
            item {
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        if (variables.isEmpty()) {
                            Text(
                                "Add variables above to test your formula",
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                style = MaterialTheme.typography.bodyMedium
                            )
                        } else {
                            variables.forEach { v ->
                                OutlinedTextField(
                                    value = playgroundValues[v.name] ?: "",
                                    onValueChange = { playgroundValues[v.name] = it },
                                    label = { 
                                        Text(buildString {
                                            append(v.name)
                                            v.unitLabel?.let { append(" ($it)") }
                                        })
                                    },
                                    modifier = Modifier.fillMaxWidth(),
                                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal),
                                    singleLine = true,
                                    supportingText = v.description?.let { { Text(it) } }
                                )
                                Spacer(modifier = Modifier.height(8.dp))
                            }
                            
                            Spacer(modifier = Modifier.height(8.dp))
                            
                            Button(
                                onClick = { testFormula() },
                                modifier = Modifier.fillMaxWidth()
                            ) {
                                Icon(Icons.Default.PlayArrow, contentDescription = null)
                                Spacer(modifier = Modifier.width(8.dp))
                                Text("Calculate")
                            }
                        }
                        
                        Spacer(modifier = Modifier.height(16.dp))
                        HorizontalDivider()
                        Spacer(modifier = Modifier.height(16.dp))
                        
                        if (error != null) {
                            Card(
                                colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.errorContainer)
                            ) {
                                Row(
                                    modifier = Modifier.padding(12.dp),
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Icon(Icons.Default.Warning, contentDescription = null, tint = MaterialTheme.colorScheme.onErrorContainer)
                                    Spacer(modifier = Modifier.width(8.dp))
                                    Text(error!!, color = MaterialTheme.colorScheme.onErrorContainer)
                                }
                            }
                        } else {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Text("Result:", style = MaterialTheme.typography.titleMedium)
                                Text(
                                    result.ifEmpty { "—" },
                                    style = MaterialTheme.typography.headlineMedium,
                                    color = if (result.isNotEmpty()) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onSurface
                                )
                            }
                        }
                    }
                }
            }
            
            // Save Button
            item {
                Spacer(modifier = Modifier.height(8.dp))
                Button(
                    onClick = { saveCalculator() },
                    modifier = Modifier.fillMaxWidth(),
                    colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.primary)
                ) {
                    Icon(Icons.Default.Save, contentDescription = null)
                    Spacer(modifier = Modifier.width(8.dp))
                    Text("Save Calculator")
                }
            }
        }
    }
}
