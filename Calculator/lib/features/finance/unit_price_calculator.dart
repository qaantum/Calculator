import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnitPriceCalculator extends ConsumerStatefulWidget {
  const UnitPriceCalculator({super.key});

  @override
  ConsumerState<UnitPriceCalculator> createState() => _UnitPriceCalculatorState();
}

class _UnitPriceCalculatorState extends ConsumerState<UnitPriceCalculator> {
  final _priceAController = TextEditingController();
  final _qtyAController = TextEditingController();
  final _priceBController = TextEditingController();
  final _qtyBController = TextEditingController();

  String? _unitPriceA;
  String? _unitPriceB;
  String _verdict = 'Enter details to compare';

  void _calculate() {
    final priceA = double.tryParse(_priceAController.text);
    final qtyA = double.tryParse(_qtyAController.text);
    final priceB = double.tryParse(_priceBController.text);
    final qtyB = double.tryParse(_qtyBController.text);

    if (priceA != null && qtyA != null && qtyA != 0) {
      _unitPriceA = (priceA / qtyA).toStringAsFixed(4);
    } else {
      _unitPriceA = null;
    }

    if (priceB != null && qtyB != null && qtyB != 0) {
      _unitPriceB = (priceB / qtyB).toStringAsFixed(4);
    } else {
      _unitPriceB = null;
    }

    if (_unitPriceA != null && _unitPriceB != null) {
      final unitA = double.parse(_unitPriceA!);
      final unitB = double.parse(_unitPriceB!);

      if (unitA < unitB) {
        final savings = ((unitB - unitA) / unitB) * 100;
        _verdict = 'Option A is cheaper by ${savings.toStringAsFixed(1)}%';
      } else if (unitB < unitA) {
        final savings = ((unitA - unitB) / unitA) * 100;
        _verdict = 'Option B is cheaper by ${savings.toStringAsFixed(1)}%';
      } else {
        _verdict = 'Both options cost the same per unit';
      }
    } else {
      _verdict = 'Enter details to compare';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unit Price Comparison')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOptionCard(context, 'Option A', _priceAController, _qtyAController, _unitPriceA),
            const SizedBox(height: 16),
            _buildOptionCard(context, 'Option B', _priceBController, _qtyBController, _unitPriceB),
            const SizedBox(height: 32),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'Results update automatically',
                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Text('Verdict', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      _verdict,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
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

  Widget _buildOptionCard(BuildContext context, String title, TextEditingController priceCtrl, TextEditingController qtyCtrl, String? unitPrice) {
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
                    controller: priceCtrl,
                    decoration: const InputDecoration(labelText: 'Price', prefixText: '\$', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: qtyCtrl,
                    decoration: const InputDecoration(labelText: 'Quantity/Weight', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            if (unitPrice != null) ...[
              const SizedBox(height: 8),
              Text(
                'Unit Price: \$$unitPrice',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
