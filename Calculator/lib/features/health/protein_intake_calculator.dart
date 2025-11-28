import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProteinIntakeCalculator extends StatefulWidget {
  const ProteinIntakeCalculator({super.key});

  @override
  State<ProteinIntakeCalculator> createState() => _ProteinIntakeCalculatorState();
}

class _ProteinIntakeCalculatorState extends State<ProteinIntakeCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  String _activityLevel = 'Sedentary';
  String _goal = 'Maintain';
  
  double? _proteinResult;

  final Map<String, double> _activityMultipliers = {
    'Sedentary': 0.8,
    'Active': 1.2,
    'Athlete': 1.6,
  };

  final Map<String, double> _goalMultipliers = {
    'Maintain': 1.0,
    'Build Muscle': 1.5,
    'Lose Fat': 1.3,
  };

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final weight = double.parse(_weightController.text);
      // Base calculation: g per kg body weight
      // Standard RDA is 0.8g/kg
      
      double factor = _activityMultipliers[_activityLevel]!;
      double goalFactor = _goalMultipliers[_goal]!;
      
      // Combine factors (simplified logic for demo)
      double totalFactor = (factor + goalFactor) / 2;
      
      // If building muscle, prioritize higher intake
      if (_goal == 'Build Muscle') {
        totalFactor = 1.6 + (factor - 0.8); // Base 1.6g/kg for muscle building
      }

      setState(() {
        _proteinResult = weight * totalFactor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Protein Calculator'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _weightController,
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          prefixIcon: Icon(FontAwesomeIcons.weightScale),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _activityLevel,
                        decoration: const InputDecoration(labelText: 'Activity Level', border: OutlineInputBorder()),
                        items: _activityMultipliers.keys.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
                        onChanged: (v) => setState(() => _activityLevel = v!),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _goal,
                        decoration: const InputDecoration(labelText: 'Goal', border: OutlineInputBorder()),
                        items: _goalMultipliers.keys.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
                        onChanged: (v) => setState(() => _goal = v!),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _calculate,
                          icon: const Icon(FontAwesomeIcons.calculator),
                          label: const Text('Calculate'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_proteinResult != null) ...[
                const SizedBox(height: 24),
                Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('Daily Protein Needs', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          '${_proteinResult!.toStringAsFixed(1)} g',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onTertiaryContainer,
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
