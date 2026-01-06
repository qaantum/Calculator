package com.qaantum.calculatorhub.ui.screens

import android.widget.Toast
import androidx.compose.animation.core.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ContentCopy
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import com.qaantum.calculatorhub.calculators.*
import java.util.Calendar

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MoonPhaseCalculatorScreen(navController: androidx.navigation.NavController) {
    val today = Calendar.getInstance()
    var year by remember { mutableStateOf(today.get(Calendar.YEAR).toString()) }
    var month by remember { mutableStateOf((today.get(Calendar.MONTH) + 1).toString()) }
    var day by remember { mutableStateOf(today.get(Calendar.DAY_OF_MONTH).toString()) }
    var result by remember { mutableStateOf<MoonPhaseResult?>(null) }
    val calculator = remember { MoonPhaseCalculator() }

    fun calc() { result = calculator.calculate(year.toIntOrNull() ?: 2024, month.toIntOrNull() ?: 1, day.toIntOrNull() ?: 1) }
    LaunchedEffect(Unit) { calc() }

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Moon Phase Calculator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(month, { month = it; calc() }, Modifier.weight(1f), label = { Text("Month") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                OutlinedTextField(day, { day = it; calc() }, Modifier.weight(1f), label = { Text("Day") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
                OutlinedTextField(year, { year = it; calc() }, Modifier.weight(1.5f), label = { Text("Year") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            }
            result?.let {
                Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                    Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text(getMoonEmoji(it.phaseName), style = MaterialTheme.typography.displayLarge)
                        Spacer(Modifier.height(16.dp))
                        Text(it.phaseName, style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)
                        Spacer(Modifier.height(8.dp))
                        Text("${String.format("%.1f", it.illumination)}% illuminated", style = MaterialTheme.typography.titleMedium)
                    }
                }
            }
        }
    }
}

private fun getMoonEmoji(phase: String) = when (phase) { "New Moon" -> "🌑"; "Waxing Crescent" -> "🌒"; "First Quarter" -> "🌓"; "Waxing Gibbous" -> "🌔"; "Full Moon" -> "🌕"; "Waning Gibbous" -> "🌖"; "Last Quarter" -> "🌗"; else -> "🌘" }

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DiceRollerScreen(navController: androidx.navigation.NavController) {
    var sides by remember { mutableStateOf("6") }
    var count by remember { mutableStateOf("2") }
    var result by remember { mutableStateOf<DiceRollResult?>(null) }
    var isRolling by remember { mutableStateOf(false) }
    val roller = remember { DiceRoller() }
    val shakeOffset by animateFloatAsState(if (isRolling) 10f else 0f, animationSpec = spring(dampingRatio = 0.3f, stiffness = 500f), label = "shake")

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Dice Roller",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(Modifier.fillMaxWidth()) { listOf(4, 6, 8, 10, 12, 20, 100).forEach { FilterChip(sides == it.toString(), { sides = it.toString() }, { Text("D$it") }, Modifier.padding(end = 4.dp)) } }
            OutlinedTextField(count, { count = it }, Modifier.fillMaxWidth(), label = { Text("Number of Dice") }, keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number))
            Button({
                isRolling = true
                result = roller.roll(sides.toIntOrNull() ?: 6, count.toIntOrNull() ?: 1)
                isRolling = false
            }, Modifier.fillMaxWidth().offset(x = shakeOffset.dp)) { Text("🎲 Roll Dice", Modifier.padding(8.dp)) }
            result?.let {
                Card(Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                    Column(Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Total", style = MaterialTheme.typography.titleMedium)
                        Text("${it.total}", style = MaterialTheme.typography.displayMedium, fontWeight = FontWeight.Bold)
                    }
                }
                Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp)) { Text("Individual Rolls:", style = MaterialTheme.typography.titleSmall); Spacer(Modifier.height(8.dp)); Row { it.rolls.forEach { r -> AssistChip({}, { Text("$r") }, Modifier.padding(end = 4.dp)) } } } }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HashGeneratorScreen(navController: androidx.navigation.NavController) {
    var input by remember { mutableStateOf("") }
    var result by remember { mutableStateOf<HashResult?>(null) }
    val generator = remember { HashGenerator() }
    val clipboard = LocalClipboardManager.current
    val context = LocalContext.current

    com.qaantum.calculatorhub.ui.components.CalculatorScaffold(
        title = "Hash Generator",
        navController = navController,
        onCustomize = { navController.navigate("/custom/builder") }
    ) { p ->
        Column(Modifier.fillMaxSize().padding(p).padding(16.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            OutlinedTextField(input, { input = it; if (it.isNotEmpty()) result = generator.generate(it) else result = null }, Modifier.fillMaxWidth().height(120.dp), label = { Text("Enter Text") }, maxLines = 5)
            result?.let {
                listOf("MD5" to it.md5, "SHA-1" to it.sha1, "SHA-256" to it.sha256, "SHA-512" to it.sha512).forEach { (name, hash) ->
                    Card(Modifier.fillMaxWidth()) {
                        Row(Modifier.padding(16.dp), verticalAlignment = Alignment.CenterVertically) {
                            Column(Modifier.weight(1f)) { Text(name, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold); Text(hash, style = MaterialTheme.typography.bodySmall, maxLines = 2) }
                            IconButton({ clipboard.setText(AnnotatedString(hash)); Toast.makeText(context, "Copied!", Toast.LENGTH_SHORT).show() }) { Icon(Icons.Default.ContentCopy, "Copy") }
                        }
                    }
                }
            }
        }
    }
}
