import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EffectiveRateCalculator extends ConsumerStatefulWidget {
  const EffectiveRateCalculator({super.key});

  @override
  ConsumerState<EffectiveRateCalculator> createState() => _EffectiveRateCalculatorState();
}

class _EffectiveRateCalculatorState extends ConsumerState<EffectiveRateCalculator> {
  final _nominalRateController = TextEditingController();
  String _frequency = 'Monthly';
  String? _effectiveRate;

  final Map<String, int> _frequencies = {
    'Daily': 365,
    'Weekly': 52,
    'Bi-Weekly': 26,
    'Monthly': 12,
    'Quarterly': 4,
    'Semi-Annually': 2,
    'Annually': 1,
  };

  void _calculate() {
    final nominal = double.tryParse(_nominalRateController.text);
    if (nominal == null) return;

    final n = _frequencies[_frequency]!;
    final r = nominal / 100;

    // Effective Rate = (1 + r/n)^n - 1
    final effective = pow(1 + r / n, n) - 1;

    setState(() {
      _effectiveRate = '${(effective * 100).toStringAsFixed(4)}%';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Effective Rate Converter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nominalRateController,
              decoration: const InputDecoration(
                labelText: 'Nominal Annual Rate (%)',
                suffixText: '%',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _frequency,
              decoration: const InputDecoration(
                labelText: 'Compounding Frequency',
                border: OutlineInputBorder(),
              ),
              items: _frequencies.keys.map((f) {
                return DropdownMenuItem(value: f, child: Text(f));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _frequency = value!;
                  _calculate();
                });
              },
            ),
            if (_effectiveRate != null) ...[
              const SizedBox(height: 32),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text('Effective Annual Rate (APY)', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        _effectiveRate!,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
