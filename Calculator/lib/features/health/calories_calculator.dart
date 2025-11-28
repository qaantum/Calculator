import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CaloriesCalculator extends ConsumerStatefulWidget {
  const CaloriesCalculator({super.key});

  @override
  ConsumerState<CaloriesCalculator> createState() => _CaloriesCalculatorState();
}

class _CaloriesCalculatorState extends ConsumerState<CaloriesCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController(); // cm
  final _weightController = TextEditingController(); // kg
  String _gender = 'Male';
  double _activityLevel = 1.2;

  double? _tdee;

  final Map<double, String> _activityLevels = {
    1.2: 'Sedentary (little or no exercise)',
    1.375: 'Lightly active (light exercise 1-3 days/week)',
    1.55: 'Moderately active (moderate exercise 3-5 days/week)',
    1.725: 'Very active (hard exercise 6-7 days/week)',
    1.9: 'Super active (very hard exercise & physical job)',
  };

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final age = int.parse(_ageController.text);
      final height = double.parse(_heightController.text);
      final weight = double.parse(_weightController.text);

      double bmr;
      if (_gender == 'Male') {
        bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
      } else {
        bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
      }

      setState(() {
        _tdee = bmr * _activityLevel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calorie Calculator (TDEE)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<double>(
                value: _activityLevel,
                decoration: const InputDecoration(
                  labelText: 'Activity Level',
                  border: OutlineInputBorder(),
                ),
                items: _activityLevels.entries.map((e) {
                  return DropdownMenuItem(value: e.key, child: Text(e.value, style: const TextStyle(fontSize: 12)));
                }).toList(),
                onChanged: (value) => setState(() => _activityLevel = value!),
                isExpanded: true,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _calculate,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Calculate Calories'),
                ),
              ),
              if (_tdee != null) ...[
                const SizedBox(height: 32),
                Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('Daily Calorie Needs', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          '${_tdee!.round()} kcal',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                        ),
                        const SizedBox(height: 8),
                        const Text('To maintain current weight'),
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
