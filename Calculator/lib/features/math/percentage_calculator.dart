import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PercentageCalculator extends ConsumerStatefulWidget {
  const PercentageCalculator({super.key});

  @override
  ConsumerState<PercentageCalculator> createState() => _PercentageCalculatorState();
}

class _PercentageCalculatorState extends ConsumerState<PercentageCalculator> {
  // Case 1: What is X% of Y?
  final _c1X = TextEditingController();
  final _c1Y = TextEditingController();
  String _c1Result = '';

  // Case 2: X is what % of Y?
  final _c2X = TextEditingController();
  final _c2Y = TextEditingController();
  String _c2Result = '';

  // Case 3: Percentage Change from X to Y
  final _c3X = TextEditingController();
  final _c3Y = TextEditingController();
  String _c3Result = '';

  void _calculateC1() {
    if (_c1X.text.isEmpty || _c1Y.text.isEmpty) return;
    final x = double.parse(_c1X.text);
    final y = double.parse(_c1Y.text);
    setState(() {
      _c1Result = ((x / 100) * y).toStringAsFixed(2);
    });
  }

  void _calculateC2() {
    if (_c2X.text.isEmpty || _c2Y.text.isEmpty) return;
    final x = double.parse(_c2X.text);
    final y = double.parse(_c2Y.text);
    if (y == 0) return;
    setState(() {
      _c2Result = '${((x / y) * 100).toStringAsFixed(2)}%';
    });
  }

  void _calculateC3() {
    if (_c3X.text.isEmpty || _c3Y.text.isEmpty) return;
    final x = double.parse(_c3X.text);
    final y = double.parse(_c3Y.text);
    if (x == 0) return;
    final change = ((y - x) / x) * 100;
    setState(() {
      _c3Result = '${change > 0 ? '+' : ''}${change.toStringAsFixed(2)}%';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Percentage Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(
              context,
              title: 'What is X% of Y?',
              input1: _c1X,
              label1: 'X (%)',
              input2: _c1Y,
              label2: 'Y (Value)',
              result: _c1Result,
              onChanged: _calculateC1,
            ),
            const SizedBox(height: 16),
            _buildCard(
              context,
              title: 'X is what % of Y?',
              input1: _c2X,
              label1: 'X (Value)',
              input2: _c2Y,
              label2: 'Y (Total)',
              result: _c2Result,
              onChanged: _calculateC2,
            ),
            const SizedBox(height: 16),
            _buildCard(
              context,
              title: 'Percentage Change',
              input1: _c3X,
              label1: 'From (X)',
              input2: _c3Y,
              label2: 'To (Y)',
              result: _c3Result,
              onChanged: _calculateC3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required TextEditingController input1,
    required String label1,
    required TextEditingController input2,
    required String label2,
    required String result,
    required VoidCallback onChanged,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: input1,
                    decoration: InputDecoration(labelText: label1, border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => onChanged(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: input2,
                    decoration: InputDecoration(labelText: label2, border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => onChanged(),
                  ),
                ),
              ],
            ),
            if (result.isNotEmpty) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  result,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
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
