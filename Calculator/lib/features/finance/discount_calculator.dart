import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DiscountCalculator extends ConsumerStatefulWidget {
  const DiscountCalculator({super.key});

  @override
  ConsumerState<DiscountCalculator> createState() => _DiscountCalculatorState();
}

class _DiscountCalculatorState extends ConsumerState<DiscountCalculator> {
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  
  String? _savedAmount;
  String? _finalPrice;

  void _calculate() {
    final price = double.tryParse(_priceController.text);
    final discount = double.tryParse(_discountController.text);

    if (price == null || discount == null) return;

    final saved = price * (discount / 100);
    final finalPrice = price - saved;

    final currency = NumberFormat.simpleCurrency();

    setState(() {
      _savedAmount = currency.format(saved);
      _finalPrice = currency.format(finalPrice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discount Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Original Price',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _discountController,
              decoration: const InputDecoration(
                labelText: 'Discount (%)',
                suffixText: '%',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            if (_finalPrice != null) ...[
              const SizedBox(height: 32),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text('You Save', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        _savedAmount!,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Divider(height: 32),
                      Text('Final Price', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        _finalPrice!,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
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
    );
  }
}
