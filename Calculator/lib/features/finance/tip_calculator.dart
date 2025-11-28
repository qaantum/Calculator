import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TipCalculator extends ConsumerStatefulWidget {
  const TipCalculator({super.key});

  @override
  ConsumerState<TipCalculator> createState() => _TipCalculatorState();
}

class _TipCalculatorState extends ConsumerState<TipCalculator> {
  final _billController = TextEditingController();
  double _tipPercentage = 15;
  int _splitCount = 1;

  String? _tipAmount;
  String? _totalAmount;
  String? _amountPerPerson;

  void _calculate() {
    final bill = double.tryParse(_billController.text);
    if (bill == null) return;

    final tip = bill * (_tipPercentage / 100);
    final total = bill + tip;
    final perPerson = total / _splitCount;

    final currency = NumberFormat.simpleCurrency();

    setState(() {
      _tipAmount = currency.format(tip);
      _totalAmount = currency.format(total);
      _amountPerPerson = currency.format(perPerson);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tip Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _billController,
              decoration: const InputDecoration(
                labelText: 'Bill Amount',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 24),
            Text('Tip Percentage: ${_tipPercentage.round()}%', style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: _tipPercentage,
              min: 0,
              max: 50,
              divisions: 50,
              label: '${_tipPercentage.round()}%',
              onChanged: (value) {
                setState(() {
                  _tipPercentage = value;
                  _calculate();
                });
              },
            ),
            const SizedBox(height: 16),
            Text('Split: $_splitCount Person${_splitCount > 1 ? 's' : ''}', style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: _splitCount.toDouble(),
              min: 1,
              max: 20,
              divisions: 19,
              label: '$_splitCount',
              onChanged: (value) {
                setState(() {
                  _splitCount = value.round();
                  _calculate();
                });
              },
            ),
            if (_totalAmount != null) ...[
              const SizedBox(height: 32),
              Card(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _buildResultRow(context, 'Tip Amount', _tipAmount!),
                      const Divider(),
                      _buildResultRow(context, 'Total Bill', _totalAmount!),
                      const Divider(),
                      _buildResultRow(context, 'Per Person', _amountPerPerson!, isBold: true),
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
