import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OneRepMaxCalculator extends ConsumerStatefulWidget {
  const OneRepMaxCalculator({super.key});

  @override
  ConsumerState<OneRepMaxCalculator> createState() => _OneRepMaxCalculatorState();
}

class _OneRepMaxCalculatorState extends ConsumerState<OneRepMaxCalculator> {
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();

  String? _oneRepMax;
  List<Map<String, String>> _percentages = [];

  void _calculate() {
    final weight = double.tryParse(_weightController.text);
    final reps = double.tryParse(_repsController.text);

    if (weight == null || reps == null || reps == 0) return;

    // Epley Formula: 1RM = w * (1 + r/30)
    final oneRm = weight * (1 + reps / 30);

    setState(() {
      _oneRepMax = oneRm.round().toString();
      _percentages = [
        {'percent': '100%', 'weight': oneRm.round().toString()},
        {'percent': '95%', 'weight': (oneRm * 0.95).round().toString()},
        {'percent': '90%', 'weight': (oneRm * 0.90).round().toString()},
        {'percent': '85%', 'weight': (oneRm * 0.85).round().toString()},
        {'percent': '80%', 'weight': (oneRm * 0.80).round().toString()},
        {'percent': '75%', 'weight': (oneRm * 0.75).round().toString()},
        {'percent': '70%', 'weight': (oneRm * 0.70).round().toString()},
        {'percent': '60%', 'weight': (oneRm * 0.60).round().toString()},
        {'percent': '50%', 'weight': (oneRm * 0.50).round().toString()},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('One Rep Max (1RM)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(labelText: 'Weight Lifted', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _repsController,
                    decoration: const InputDecoration(labelText: 'Reps Performed', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            if (_oneRepMax != null) ...[
              const SizedBox(height: 32),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text('Estimated 1 Rep Max', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        _oneRepMax!,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Training Percentages', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: _percentages.map((p) {
                    return ListTile(
                      title: Text(p['percent']!),
                      trailing: Text(
                        p['weight']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
