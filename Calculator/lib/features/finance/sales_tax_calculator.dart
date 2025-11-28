import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SalesTaxCalculator extends ConsumerStatefulWidget {
  const SalesTaxCalculator({super.key});

  @override
  ConsumerState<SalesTaxCalculator> createState() => _SalesTaxCalculatorState();
}

class _SalesTaxCalculatorState extends ConsumerState<SalesTaxCalculator> {
  final _amountController = TextEditingController();
  final _taxRateController = TextEditingController();
  bool _isReverse = false;

  String? _taxAmount;
  String? _totalAmount;
  String? _netAmount;

  void _calculate() {
    final amount = double.tryParse(_amountController.text);
    final rate = double.tryParse(_taxRateController.text);

    if (amount == null || rate == null) return;

    double tax;
    double total;
    double net;

    if (_isReverse) {
      // Amount is Total (Net + Tax)
      // Total = Net * (1 + Rate/100)
      // Net = Total / (1 + Rate/100)
      total = amount;
      net = total / (1 + rate / 100);
      tax = total - net;
    } else {
      // Amount is Net
      net = amount;
      tax = net * (rate / 100);
      total = net + tax;
    }

    final currency = NumberFormat.simpleCurrency();

    setState(() {
      _taxAmount = currency.format(tax);
      _totalAmount = currency.format(total);
      _netAmount = currency.format(net);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Tax Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Add Tax')),
                ButtonSegment(value: true, label: Text('Reverse Tax')),
              ],
              selected: {_isReverse},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  _isReverse = newSelection.first;
                  _calculate();
                });
              },
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: _isReverse ? 'Total Amount (Inc. Tax)' : 'Net Amount (Excl. Tax)',
                prefixText: '\$',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _taxRateController,
              decoration: const InputDecoration(
                labelText: 'Tax Rate (%)',
                suffixText: '%',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            if (_totalAmount != null) ...[
              const SizedBox(height: 32),
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _buildResultRow(context, 'Net Amount', _netAmount!),
                      const Divider(),
                      _buildResultRow(context, 'Tax Amount', _taxAmount!),
                      const Divider(),
                      _buildResultRow(context, 'Total Amount', _totalAmount!, isBold: true),
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
                  color: isBold ? Theme.of(context).colorScheme.onSecondaryContainer : null,
                ),
          ),
        ],
      ),
    );
  }
}
