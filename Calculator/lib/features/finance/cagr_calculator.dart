import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CAGRCalculator extends ConsumerStatefulWidget {
  const CAGRCalculator({super.key});

  @override
  ConsumerState<CAGRCalculator> createState() => _CAGRCalculatorState();
}

class _CAGRCalculatorState extends ConsumerState<CAGRCalculator> {
  final _startValueController = TextEditingController();
  final _endValueController = TextEditingController();
  final _yearsController = TextEditingController();

  String _cagr = '---';
  String _totalGrowth = '---';

  void _calculate() {
    // Strip non-numeric characters
    final startText = _startValueController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final endText = _endValueController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final yearsText = _yearsController.text.replaceAll(RegExp(r'[^0-9.]'), '');

    final start = double.tryParse(startText);
    final end = double.tryParse(endText);
    final years = double.tryParse(yearsText);

    if (start == null || end == null || years == null || years == 0 || start == 0) {
      setState(() {
        _cagr = '---';
        _totalGrowth = '---';
      });
      return;
    }

    // CAGR = (End / Start)^(1/n) - 1
    final cagrVal = pow(end / start, 1 / years) - 1;
    final totalGrowthVal = (end - start) / start;

    final percent = NumberFormat.decimalPercentPattern(decimalDigits: 2);

    setState(() {
      _cagr = percent.format(cagrVal);
      _totalGrowth = percent.format(totalGrowthVal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CAGR Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _startValueController,
              decoration: const InputDecoration(
                labelText: 'Beginning Value',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _endValueController,
              decoration: const InputDecoration(
                labelText: 'Ending Value',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _yearsController,
              decoration: const InputDecoration(
                labelText: 'Number of Years',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'Results update automatically',
                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    _buildResultRow(context, 'CAGR', _cagr, isBold: true),
                    const Divider(),
                    _buildResultRow(context, 'Total Growth', _totalGrowth),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(BuildContext context, String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: isBold ? Theme.of(context).colorScheme.onTertiaryContainer : null,
                ),
          ),
        ],
      ),
    );
  }
}
