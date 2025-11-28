import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MacroCalculator extends ConsumerStatefulWidget {
  const MacroCalculator({super.key});

  @override
  ConsumerState<MacroCalculator> createState() => _MacroCalculatorState();
}

class _MacroCalculatorState extends ConsumerState<MacroCalculator> {
  final _caloriesController = TextEditingController();
  String _goal = 'Maintain'; // Maintain, Cut, Bulk
  String _ratio = 'Balanced'; // Balanced, Low Carb, High Protein

  // Ratios (Protein, Fat, Carbs)
  final Map<String, List<double>> _ratios = {
    'Balanced': [0.30, 0.35, 0.35], // P, F, C
    'Low Carb': [0.40, 0.40, 0.20],
    'High Carb': [0.25, 0.20, 0.55],
    'Keto': [0.25, 0.70, 0.05],
  };

  String _protein = '---';
  String _fat = '---';
  String _carbs = '---';

  void _calculate() {
    double calories = double.tryParse(_caloriesController.text) ?? 0;
    if (calories == 0) {
      setState(() {
        _protein = '---';
        _fat = '---';
        _carbs = '---';
      });
      return;
    }

    // Adjust calories based on goal
    if (_goal == 'Cut') {
      calories -= 500;
    } else if (_goal == 'Bulk') {
      calories += 500;
    }

    final ratio = _ratios[_ratio]!;
    final pCals = calories * ratio[0];
    final fCals = calories * ratio[1];
    final cCals = calories * ratio[2];

    // Protein = 4 cal/g, Fat = 9 cal/g, Carbs = 4 cal/g
    final pGrams = pCals / 4;
    final fGrams = fCals / 9;
    final cGrams = cCals / 4;

    setState(() {
      _protein = '${pGrams.round()}g';
      _fat = '${fGrams.round()}g';
      _carbs = '${cGrams.round()}g';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Macro Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _caloriesController,
              decoration: const InputDecoration(labelText: 'Daily TDEE (Calories)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _goal,
              decoration: const InputDecoration(labelText: 'Goal', border: OutlineInputBorder()),
              items: ['Maintain', 'Cut', 'Bulk'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) {
                setState(() {
                  _goal = val!;
                  _calculate();
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _ratio,
              decoration: const InputDecoration(labelText: 'Diet Type', border: OutlineInputBorder()),
              items: _ratios.keys.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) {
                setState(() {
                  _ratio = val!;
                  _calculate();
                });
              },
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMacroCard('Protein', _protein, Colors.red),
                _buildMacroCard('Fats', _fat, Colors.yellow.shade800),
                _buildMacroCard('Carbs', _carbs, Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroCard(String label, String value, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
