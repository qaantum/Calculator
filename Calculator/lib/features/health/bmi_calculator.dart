import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BMICalculator extends ConsumerStatefulWidget {
  const BMICalculator({super.key});

  @override
  ConsumerState<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends ConsumerState<BMICalculator> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController(); // cm or ft
  final _weightController = TextEditingController(); // kg or lbs
  final _inchesController = TextEditingController(); // for ft/in

  bool _isMetric = true;
  double? _bmi;
  String? _category;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      double height;
      double weight = double.parse(_weightController.text);

      if (_isMetric) {
        // Metric: kg / (m^2)
        height = double.parse(_heightController.text) / 100; // cm to m
      } else {
        // Imperial: 703 * lbs / (in^2)
        final feet = double.parse(_heightController.text);
        final inches = _inchesController.text.isEmpty ? 0.0 : double.parse(_inchesController.text);
        height = (feet * 12) + inches; // total inches
      }

      double bmi;
      if (_isMetric) {
        bmi = weight / pow(height, 2);
      } else {
        bmi = 703 * weight / pow(height, 2);
      }

      String category;
      if (bmi < 18.5) {
        category = 'Underweight';
      } else if (bmi < 25) {
        category = 'Normal';
      } else if (bmi < 30) {
        category = 'Overweight';
      } else {
        category = 'Obese';
      }

      setState(() {
        _bmi = bmi;
        _category = category;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Metric (kg/cm)')),
                  ButtonSegment(value: false, label: Text('Imperial (lbs/ft)')),
                ],
                selected: {_isMetric},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    _isMetric = newSelection.first;
                    _bmi = null;
                    _category = null;
                    _heightController.clear();
                    _weightController.clear();
                    _inchesController.clear();
                  });
                },
              ),
              const SizedBox(height: 24),
              if (_isMetric)
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _heightController,
                        decoration: const InputDecoration(
                          labelText: 'Feet',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _inchesController,
                        decoration: const InputDecoration(
                          labelText: 'Inches',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
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
                  child: Text('Calculate BMI'),
                ),
              ),
              if (_bmi != null) ...[
                const SizedBox(height: 32),
                Card(
                  color: _getCategoryColor(context, _category!),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('Your BMI', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          _bmi!.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _category!,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Color _getCategoryColor(BuildContext context, String category) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (category) {
      case 'Underweight':
        return isDark ? Colors.blue.shade900 : Colors.blue.shade100;
      case 'Normal':
        return isDark ? Colors.green.shade900 : Colors.green.shade100;
      case 'Overweight':
        return isDark ? Colors.orange.shade900 : Colors.orange.shade100;
      case 'Obese':
        return isDark ? Colors.red.shade900 : Colors.red.shade100;
      default:
        return isDark ? Colors.grey.shade800 : Colors.grey.shade100;
    }
  }
}
