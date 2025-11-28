import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BMRCalculator extends ConsumerStatefulWidget {
  const BMRCalculator({super.key});

  @override
  ConsumerState<BMRCalculator> createState() => _BMRCalculatorState();
}

class _BMRCalculatorState extends ConsumerState<BMRCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController(); // cm or ft
  final _inchesController = TextEditingController(); // in (for imperial)
  final _weightController = TextEditingController(); // kg or lbs
  String _gender = 'Male';
  bool _isMetric = true;

  double? _bmr;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final age = int.parse(_ageController.text);
      double height;
      double weight;

      if (_isMetric) {
        height = double.parse(_heightController.text);
        weight = double.parse(_weightController.text);
      } else {
        final ft = double.parse(_heightController.text);
        final inches = double.tryParse(_inchesController.text) ?? 0;
        height = (ft * 12 + inches) * 2.54; // Convert to cm
        weight = double.parse(_weightController.text) * 0.453592; // Convert lbs to kg
      }

      double bmr;
      // Mifflin-St Jeor Equation (requires kg and cm)
      if (_gender == 'Male') {
        bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
      } else {
        bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
      }

      setState(() {
        _bmr = bmr;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMR Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Metric (cm/kg)')),
                  ButtonSegment(value: false, label: Text('Imperial (ft/lbs)')),
                ],
                selected: {_isMetric},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    _isMetric = newSelection.first;
                    _bmr = null;
                    _heightController.clear();
                    _inchesController.clear();
                    _weightController.clear();
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: (value) => setState(() => _gender = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      decoration: InputDecoration(
                        labelText: _isMetric ? 'Height (cm)' : 'Height (ft)',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  if (!_isMetric) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _inchesController,
                        decoration: const InputDecoration(
                          labelText: 'Inches',
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: _isMetric ? 'Weight (kg)' : 'Weight (lbs)',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _calculate,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Calculate BMR'),
                ),
              ),
              if (_bmr != null) ...[
                const SizedBox(height: 32),
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('Basal Metabolic Rate', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          '${_bmr!.toStringAsFixed(0)} kcal/day',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                              ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Calories burned at rest',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
