import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommissionCalculator extends ConsumerStatefulWidget {
  const CommissionCalculator({super.key});

  @override
  ConsumerState<CommissionCalculator> createState() => _CommissionCalculatorState();
}

class _CommissionCalculatorState extends ConsumerState<CommissionCalculator> {
  final _salePriceController = TextEditingController();
  final _commissionRateController = TextEditingController();

  String _commissionAmount = '---';
  String _netProceeds = '---';

  void _calculate() {
    final salePrice = double.tryParse(_salePriceController.text) ?? 0;
    final rate = double.tryParse(_commissionRateController.text) ?? 0;

    if (salePrice == 0) {
      setState(() {
        _commissionAmount = '---';
        _netProceeds = '---';
      });
      return;
    }

    final commission = salePrice * (rate / 100);
    final net = salePrice - commission;

    setState(() {
      _commissionAmount = '\$${commission.toStringAsFixed(2)}';
      _netProceeds = '\$${net.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Commission Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _salePriceController,
              decoration: const InputDecoration(labelText: 'Sale Price (\$)', border: OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commissionRateController,
              decoration: const InputDecoration(labelText: 'Commission Rate (%)', border: OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.teal.shade50,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Commission Amount', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      _commissionAmount,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    const SizedBox(height: 16),
                    const Text('Net Proceeds', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      _netProceeds,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
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
