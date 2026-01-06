import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../ui/widgets/pin_button.dart';

class TipSplitCalculator extends ConsumerStatefulWidget {
  const TipSplitCalculator({super.key});

  @override
  ConsumerState<TipSplitCalculator> createState() => _TipSplitCalculatorState();
}

class _TipSplitCalculatorState extends ConsumerState<TipSplitCalculator> {
  final _billController = TextEditingController();
  final _tipPercentController = TextEditingController(text: '18');
  int _people = 2;
  
  double? _tipAmount;
  double? _totalWithTip;
  double? _perPersonAmount;
  double? _perPersonTip;

  void _calculate() {
    final bill = double.tryParse(_billController.text);
    final tipPercent = double.tryParse(_tipPercentController.text);
    
    if (bill == null || tipPercent == null) return;
    
    final tip = bill * (tipPercent / 100);
    final total = bill + tip;
    
    setState(() {
      _tipAmount = tip;
      _totalWithTip = total;
      _perPersonAmount = total / _people;
      _perPersonTip = tip / _people;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tip Split Calculator'),
        actions: const [PinButton(route: '/finance/tipsplit')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 16),
            TextField(
              controller: _tipPercentController,
              decoration: const InputDecoration(
                labelText: 'Tip Percentage',
                suffixText: '%',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [10, 15, 18, 20, 25].map((p) => 
                ActionChip(
                  label: Text('$p%'),
                  onPressed: () {
                    _tipPercentController.text = p.toString();
                    _calculate();
                  },
                )
              ).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Number of People', style: Theme.of(context).textTheme.titleMedium),
                Row(
                  children: [
                    IconButton.filled(
                      onPressed: _people > 1 ? () {
                        setState(() => _people--);
                        _calculate();
                      } : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$_people',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () {
                        setState(() => _people++);
                        _calculate();
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
            if (_perPersonAmount != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text('Each Person Pays', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        currency.format(_perPersonAmount),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        '(includes ${currency.format(_perPersonTip)} tip)',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildRow('Subtotal', currency.format(double.tryParse(_billController.text) ?? 0)),
                      const SizedBox(height: 8),
                      _buildRow('Total Tip', currency.format(_tipAmount), color: Colors.green),
                      const Divider(height: 16),
                      _buildRow('Grand Total', currency.format(_totalWithTip)),
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
  
  Widget _buildRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
