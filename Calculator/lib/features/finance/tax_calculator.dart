import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TaxCalculator extends ConsumerStatefulWidget {
  const TaxCalculator({super.key});

  @override
  ConsumerState<TaxCalculator> createState() => _TaxCalculatorState();
}

class _TaxCalculatorState extends ConsumerState<TaxCalculator> {
  final _amountController = TextEditingController();
  String _status = 'Single';

  double? _tax;
  double? _netIncome;
  double? _effectiveRate;

  // 2024 US Federal Tax Brackets (Simplified)
  final Map<String, List<Map<String, double>>> _brackets = {
    'Single': [
      {'limit': 11600, 'rate': 0.10},
      {'limit': 47150, 'rate': 0.12},
      {'limit': 100525, 'rate': 0.22},
      {'limit': 191950, 'rate': 0.24},
      {'limit': 243725, 'rate': 0.32},
      {'limit': 609350, 'rate': 0.35},
      {'limit': double.infinity, 'rate': 0.37},
    ],
    'Married': [
      {'limit': 23200, 'rate': 0.10},
      {'limit': 94300, 'rate': 0.12},
      {'limit': 201050, 'rate': 0.22},
      {'limit': 383900, 'rate': 0.24},
      {'limit': 487450, 'rate': 0.32},
      {'limit': 731200, 'rate': 0.35},
      {'limit': double.infinity, 'rate': 0.37},
    ],
  };

  void _calculate() {
    if (_amountController.text.isEmpty) return;

    final income = double.parse(_amountController.text);
    final brackets = _brackets[_status]!;
    
    double tax = 0;
    double previousLimit = 0;

    for (var bracket in brackets) {
      final limit = bracket['limit']!;
      final rate = bracket['rate']!;

      if (income > limit) {
        tax += (limit - previousLimit) * rate;
        previousLimit = limit;
      } else {
        tax += (income - previousLimit) * rate;
        break;
      }
    }

    setState(() {
      _tax = tax;
      _netIncome = income - tax;
      _effectiveRate = (tax / income) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency();

    return Scaffold(
      appBar: AppBar(title: const Text('Income Tax Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Annual Income',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Filing Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Single', child: Text('Single')),
                DropdownMenuItem(value: 'Married', child: Text('Married Filing Jointly')),
              ],
              onChanged: (value) {
                setState(() => _status = value!);
                _calculate();
              },
            ),
            const SizedBox(height: 32),
            if (_tax != null)
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text('Estimated Federal Tax', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        currencyFormat.format(_tax),
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                      ),
                      const Divider(height: 32),
                      _buildResultRow('Net Income', _netIncome!, currencyFormat),
                      _buildResultRow('Effective Tax Rate', _effectiveRate!, null, suffix: '%'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, double amount, NumberFormat? format, {String suffix = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            format != null ? format.format(amount) : '${amount.toStringAsFixed(2)}$suffix',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
