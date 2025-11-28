import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StandardDeviationCalculator extends ConsumerStatefulWidget {
  const StandardDeviationCalculator({super.key});

  @override
  ConsumerState<StandardDeviationCalculator> createState() => _StandardDeviationCalculatorState();
}

class _StandardDeviationCalculatorState extends ConsumerState<StandardDeviationCalculator> {
  final _controller = TextEditingController();
  
  double? _mean;
  double? _variance;
  double? _popStdDev;
  double? _sampleStdDev;
  int _count = 0;

  void _calculate() {
    if (_controller.text.isEmpty) return;

    final input = _controller.text.replaceAll(RegExp(r'[^0-9.,\s-]'), '');
    final parts = input.split(RegExp(r'[,\s]+'));
    final numbers = parts.where((s) => s.isNotEmpty).map(double.tryParse).whereType<double>().toList();

    if (numbers.isEmpty) return;

    final n = numbers.length;
    final mean = numbers.reduce((a, b) => a + b) / n;

    double sumSquaredDiff = 0;
    for (var x in numbers) {
      sumSquaredDiff += pow(x - mean, 2);
    }

    final variance = sumSquaredDiff / n;
    final popStdDev = sqrt(variance);
    final sampleStdDev = n > 1 ? sqrt(sumSquaredDiff / (n - 1)) : 0.0;

    setState(() {
      _count = n;
      _mean = mean;
      _variance = variance;
      _popStdDev = popStdDev;
      _sampleStdDev = sampleStdDev;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Standard Deviation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter numbers (comma or space separated)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _calculate,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Calculate'),
              ),
            ),
            if (_count > 0) ...[
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildResultRow('Count (n)', _count.toString()),
                      const Divider(),
                      _buildResultRow('Mean (μ)', _mean!.toStringAsFixed(4)),
                      const Divider(),
                      _buildResultRow('Variance (σ²)', _variance!.toStringAsFixed(4)),
                      const Divider(),
                      _buildResultRow('Population Std Dev (σ)', _popStdDev!.toStringAsFixed(4)),
                      const Divider(),
                      _buildResultRow('Sample Std Dev (s)', _sampleStdDev!.toStringAsFixed(4)),
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

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}
