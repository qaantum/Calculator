import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GradeCalculator extends ConsumerStatefulWidget {
  const GradeCalculator({super.key});

  @override
  ConsumerState<GradeCalculator> createState() => _GradeCalculatorState();
}

class _GradeCalculatorState extends ConsumerState<GradeCalculator> {
  final _currentGradeController = TextEditingController();
  final _targetGradeController = TextEditingController();
  final _finalWeightController = TextEditingController();

  String? _requiredGrade;

  void _calculate() {
    final current = double.tryParse(_currentGradeController.text);
    final target = double.tryParse(_targetGradeController.text);
    final weight = double.tryParse(_finalWeightController.text);

    if (current == null || target == null || weight == null) return;

    // Formula: Required = (Target - Current * (1 - Weight/100)) / (Weight/100)
    final w = weight / 100;
    final required = (target - current * (1 - w)) / w;

    setState(() {
      _requiredGrade = required.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grade Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Calculate what you need on your final exam to get a certain grade.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _currentGradeController,
              decoration: const InputDecoration(
                labelText: 'Current Grade (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _targetGradeController,
              decoration: const InputDecoration(
                labelText: 'Target Grade (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _finalWeightController,
              decoration: const InputDecoration(
                labelText: 'Final Exam Weight (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _calculate,
              child: const Padding(padding: EdgeInsets.all(16.0), child: Text('Calculate Required Grade')),
            ),
            if (_requiredGrade != null) ...[
              const SizedBox(height: 32),
              Card(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text('You need to score', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        '$_requiredGrade%',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onTertiaryContainer,
                            ),
                      ),
                      const SizedBox(height: 8),
                      const Text('on your final exam'),
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
