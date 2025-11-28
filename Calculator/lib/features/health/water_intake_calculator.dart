import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WaterIntakeCalculator extends ConsumerStatefulWidget {
  const WaterIntakeCalculator({super.key});

  @override
  ConsumerState<WaterIntakeCalculator> createState() => _WaterIntakeCalculatorState();
}

class _WaterIntakeCalculatorState extends ConsumerState<WaterIntakeCalculator> {
  final _weightController = TextEditingController();
  String _activityLevel = 'Low'; // Low, Medium, High

  String _liters = '---';
  String _ounces = '---';

  void _calculate() {
    final weightText = _weightController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final weight = double.tryParse(weightText);

    if (weight == null || weight == 0) {
      setState(() {
        _liters = '---';
        _ounces = '---';
      });
      return;
    }

    // Base: 35ml per kg
    // Activity: +0.5L for Medium, +1.0L for High
    double intakeLiters = weight * 0.033; // Approx 33ml/kg base

    if (_activityLevel == 'Medium') {
      intakeLiters += 0.5;
    } else if (_activityLevel == 'High') {
      intakeLiters += 1.0;
    }

    // Convert to Ounces (1L = 33.814oz)
    double intakeOunces = intakeLiters * 33.814;

    setState(() {
      _liters = '${intakeLiters.toStringAsFixed(1)} L';
      _ounces = '${intakeOunces.toStringAsFixed(0)} oz';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Water Intake')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                hintText: 'e.g. 70',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _activityLevel,
              decoration: const InputDecoration(
                labelText: 'Activity Level',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Low', child: Text('Low (Sedentary)')),
                DropdownMenuItem(value: 'Medium', child: Text('Medium (30-60 mins exercise)')),
                DropdownMenuItem(value: 'High', child: Text('High (60+ mins exercise)')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _activityLevel = value;
                  });
                  _calculate();
                }
              },
            ),
            const SizedBox(height: 32),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'Daily Recommendation',
                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _liters,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                    Text(
                      _ounces,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
