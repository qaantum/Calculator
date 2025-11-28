import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MarginMarkupCalculator extends ConsumerStatefulWidget {
  const MarginMarkupCalculator({super.key});

  @override
  ConsumerState<MarginMarkupCalculator> createState() => _MarginMarkupCalculatorState();
}

class _MarginMarkupCalculatorState extends ConsumerState<MarginMarkupCalculator> {
  final _costController = TextEditingController();
  final _revenueController = TextEditingController();

  String _grossProfit = '---';
  String _margin = '---';
  String _markup = '---';

  void _calculate() {
    final costText = _costController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final revenueText = _revenueController.text.replaceAll(RegExp(r'[^0-9.]'), '');

    final cost = double.tryParse(costText);
    final revenue = double.tryParse(revenueText);

    if (cost == null || revenue == null) {
      setState(() {
        _grossProfit = '---';
        _margin = '---';
        _markup = '---';
      });
      return;
    }

    final profit = revenue - cost;
    final marginVal = (profit / revenue);
    final markupVal = (profit / cost);

    final currency = NumberFormat.simpleCurrency();
    final percent = NumberFormat.decimalPercentPattern(decimalDigits: 2);

    setState(() {
      _grossProfit = currency.format(profit);
      _margin = revenue != 0 ? percent.format(marginVal) : '---';
      _markup = cost != 0 ? percent.format(markupVal) : '---';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Margin & Markup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _costController,
              decoration: const InputDecoration(
                labelText: 'Cost',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _revenueController,
              decoration: const InputDecoration(
                labelText: 'Revenue (Selling Price)',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'Results update automatically',
                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    _buildResultRow(context, 'Gross Profit', _grossProfit),
                    const Divider(),
                    _buildResultRow(context, 'Margin', _margin, isBold: true),
                    const Divider(),
                    _buildResultRow(context, 'Markup', _markup, isBold: true),
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
                  color: isBold ? Theme.of(context).colorScheme.onSecondaryContainer : null,
                ),
          ),
        ],
      ),
    );
  }
}
