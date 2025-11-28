import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BodyFatCalculator extends ConsumerStatefulWidget {
  const BodyFatCalculator({super.key});

  @override
  ConsumerState<BodyFatCalculator> createState() => _BodyFatCalculatorState();
}

class _BodyFatCalculatorState extends ConsumerState<BodyFatCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController(); // cm or ft
  final _inchesController = TextEditingController(); // in (for imperial height)
  final _waistController = TextEditingController(); // cm or in
  final _neckController = TextEditingController(); // cm or in
  final _hipController = TextEditingController(); // cm or in (female only)
  String _gender = 'Male';
  bool _isMetric = true;

  double? _bodyFat;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      double height;
      double waist;
      double neck;
      double hip = 0;

      if (_isMetric) {
        height = double.parse(_heightController.text);
        waist = double.parse(_waistController.text);
        neck = double.parse(_neckController.text);
        if (_gender == 'Female') {
          hip = double.parse(_hipController.text);
        }
      } else {
        final ft = double.parse(_heightController.text);
        final inches = double.tryParse(_inchesController.text) ?? 0;
        height = (ft * 12 + inches) * 2.54; // Convert to cm
        waist = double.parse(_waistController.text) * 2.54; // Convert in to cm
        neck = double.parse(_neckController.text) * 2.54; // Convert in to cm
        if (_gender == 'Female') {
          hip = double.parse(_hipController.text) * 2.54; // Convert in to cm
        }
      }

      double bodyFat;
      // US Navy Method (requires cm)
      if (_gender == 'Male') {
        bodyFat = 495 / (1.0324 - 0.19077 * log(waist - neck) / ln10 + 0.15456 * log(height) / ln10) - 450;
      } else {
        bodyFat = 495 / (1.29579 - 0.35004 * log(waist + hip - neck) / ln10 + 0.22100 * log(height) / ln10) - 450;
      }

      setState(() {
        _bodyFat = bodyFat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Body Fat Calculator')),
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
                    _bodyFat = null;
                    _heightController.clear();
                    _inchesController.clear();
                    _waistController.clear();
                    _neckController.clear();
                    _hipController.clear();
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _neckController,
                decoration: InputDecoration(
                  labelText: _isMetric ? 'Neck Circumference (cm)' : 'Neck Circumference (in)',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _waistController,
                decoration: InputDecoration(
                  labelText: _isMetric ? 'Waist Circumference (cm)' : 'Waist Circumference (in)',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              if (_gender == 'Female') ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _hipController,
                  decoration: InputDecoration(
                    labelText: _isMetric ? 'Hip Circumference (cm)' : 'Hip Circumference (in)',
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _calculate,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Calculate Body Fat'),
                ),
              ),
              if (_bodyFat != null) ...[
                const SizedBox(height: 32),
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('Body Fat Percentage', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          '${_bodyFat!.toStringAsFixed(1)}%',
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
