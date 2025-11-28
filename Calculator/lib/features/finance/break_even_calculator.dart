import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BreakEvenCalculator extends ConsumerStatefulWidget {
  const BreakEvenCalculator({super.key});

  @override
  ConsumerState<BreakEvenCalculator> createState() => _BreakEvenCalculatorState();
}

class _BreakEvenCalculatorState extends ConsumerState<BreakEvenCalculator> {
  final _fixedCostController = TextEditingController();
  final _variableCostController = TextEditingController();
  final _priceController = TextEditingController();

  String _units = '---';
  String _revenue = '---';

  void _calculate() {
    final fixedText = _fixedCostController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final varText = _variableCostController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final priceText = _priceController.text.replaceAll(RegExp(r'[^0-9.]'), '');

    final fixed = double.tryParse(fixedText);
    final variable = double.tryParse(varText);
    final price = double.tryParse(priceText);

    if (fixed == null || variable == null || price == null) {
      setState(() {
        _units = '---';
        _revenue = '---';
      });
      return;
    }

    if (price <= variable) {
      setState(() {
        _units = 'Price must be > Variable Cost';
        _revenue = '---';
      });
      return;
    }

    // Break Even Units = Fixed Costs / (Price - Variable Costs)
    final units = fixed / (price - variable);
    final revenue = units * price;

    final currency = NumberFormat.simpleCurrency();

    setState(() {
      _units = '${units.ceil()} units'; // Round up to nearest whole unit
      _revenue = currency.format(revenue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Break-Even Point')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _fixedCostController,
              decoration: const InputDecoration(labelText: 'Fixed Costs', prefixText: '\$', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _variableCostController,
              decoration: const InputDecoration(labelText: 'Variable Cost per Unit', prefixText: '\$', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Selling Price per Unit', prefixText: '\$', border: OutlineInputBorder()),
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
                    const Text('Break-Even Point', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Units to Sell:'),
                        Text(_units, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Revenue Needed:'),
                        Text(_revenue, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
