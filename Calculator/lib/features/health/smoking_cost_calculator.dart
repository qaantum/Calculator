import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SmokingCostCalculator extends ConsumerStatefulWidget {
  const SmokingCostCalculator({super.key});

  @override
  ConsumerState<SmokingCostCalculator> createState() => _SmokingCostCalculatorState();
}

class _SmokingCostCalculatorState extends ConsumerState<SmokingCostCalculator> {
  final _packsPerDayController = TextEditingController();
  final _costPerPackController = TextEditingController();
  final _yearsController = TextEditingController();

  String _weeklyCost = '---';
  String _monthlyCost = '---';
  String _yearlyCost = '---';
  String _lifetimeCost = '---';

  void _calculate() {
    final packs = double.tryParse(_packsPerDayController.text) ?? 0;
    final cost = double.tryParse(_costPerPackController.text) ?? 0;
    final years = double.tryParse(_yearsController.text) ?? 0;

    if (packs == 0 || cost == 0) {
      setState(() {
        _weeklyCost = '---';
        _monthlyCost = '---';
        _yearlyCost = '---';
        _lifetimeCost = '---';
      });
      return;
    }

    final dailyCost = packs * cost;
    final weekly = dailyCost * 7;
    final monthly = dailyCost * 30.44; // Average days in month
    final yearly = dailyCost * 365.25;
    final lifetime = yearly * years;

    setState(() {
      _weeklyCost = '\$${weekly.toStringAsFixed(2)}';
      _monthlyCost = '\$${monthly.toStringAsFixed(2)}';
      _yearlyCost = '\$${yearly.toStringAsFixed(2)}';
      _lifetimeCost = '\$${lifetime.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smoking Cost Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'See how much money you could save by quitting.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _packsPerDayController,
              decoration: const InputDecoration(labelText: 'Packs per Day', border: OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _costPerPackController,
              decoration: const InputDecoration(labelText: 'Cost per Pack (\$)', border: OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _yearsController,
              decoration: const InputDecoration(labelText: 'Years Smoking (for Lifetime cost)', border: OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildResultRow('Weekly Cost', _weeklyCost),
                    const Divider(),
                    _buildResultRow('Monthly Cost', _monthlyCost),
                    const Divider(),
                    _buildResultRow('Yearly Cost', _yearlyCost),
                    const Divider(),
                    _buildResultRow('Lifetime Cost', _lifetimeCost, isTotal: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isTotal ? Colors.red : Colors.black)),
        ],
      ),
    );
  }
}
