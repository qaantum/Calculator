import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IdealWeightCalculator extends ConsumerStatefulWidget {
  const IdealWeightCalculator({super.key});

  @override
  ConsumerState<IdealWeightCalculator> createState() => _IdealWeightCalculatorState();
}

class _IdealWeightCalculatorState extends ConsumerState<IdealWeightCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController(); // cm or ft
  final _inchesController = TextEditingController(); // in
  String _gender = 'Male';
  bool _isMetric = true;

  double? _idealWeight;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      double heightInches;

      if (_isMetric) {
        final heightCm = double.parse(_heightController.text);
        heightInches = heightCm / 2.54;
      } else {
        final ft = double.parse(_heightController.text);
        final inches = double.tryParse(_inchesController.text) ?? 0;
        heightInches = (ft * 12) + inches;
      }

      if (heightInches <= 60) {
        // Devine formula base case
        setState(() {
          _idealWeight = _gender == 'Male' ? 50.0 : 45.5;
        });
        return;
      }

      double weightKg;
      if (_gender == 'Male') {
        weightKg = 50.0 + 2.3 * (heightInches - 60);
      } else {
        weightKg = 45.5 + 2.3 * (heightInches - 60);
      }

      setState(() {
        _idealWeight = weightKg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ideal Weight Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Metric (cm)')),
                  ButtonSegment(value: false, label: Text('Imperial (ft/in)')),
                ],
                selected: {_isMetric},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    _isMetric = newSelection.first;
                    _idealWeight = null;
                    _heightController.clear();
                    _inchesController.clear();
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
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _calculate,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Calculate Ideal Weight'),
                ),
              ),
              if (_idealWeight != null) ...[
                const SizedBox(height: 32),
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('Ideal Weight (Devine)', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          _isMetric
                              ? '${_idealWeight!.toStringAsFixed(1)} kg'
                              : '${(_idealWeight! * 2.20462).toStringAsFixed(1)} lbs',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
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
}
