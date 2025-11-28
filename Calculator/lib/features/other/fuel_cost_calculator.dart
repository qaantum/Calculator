import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FuelCostCalculator extends ConsumerStatefulWidget {
  const FuelCostCalculator({super.key});

  @override
  ConsumerState<FuelCostCalculator> createState() => _FuelCostCalculatorState();
}

class _FuelCostCalculatorState extends ConsumerState<FuelCostCalculator> {
  final _distanceController = TextEditingController();
  final _efficiencyController = TextEditingController();
  final _priceController = TextEditingController();

  String? _totalCost;
  bool _isMetric = true; // Metric: L/100km, km, price/L. Imperial: MPG, miles, price/gallon.

  void _calculate() {
    final distance = double.tryParse(_distanceController.text);
    final efficiency = double.tryParse(_efficiencyController.text);
    final price = double.tryParse(_priceController.text);

    if (distance == null || efficiency == null || price == null) return;

    double fuelNeeded;
    if (_isMetric) {
      // Efficiency is L/100km
      fuelNeeded = (distance / 100) * efficiency;
    } else {
      // Efficiency is MPG
      fuelNeeded = distance / efficiency;
    }

    final cost = fuelNeeded * price;
    final currency = NumberFormat.simpleCurrency();

    setState(() {
      _totalCost = currency.format(cost);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fuel Cost Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Metric (L/100km)')),
                ButtonSegment(value: false, label: Text('Imperial (MPG)')),
              ],
              selected: {_isMetric},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  _isMetric = newSelection.first;
                  _calculate();
                });
              },
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _distanceController,
              decoration: InputDecoration(
                labelText: _isMetric ? 'Distance (km)' : 'Distance (miles)',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _efficiencyController,
              decoration: InputDecoration(
                labelText: _isMetric ? 'Fuel Efficiency (L/100km)' : 'Fuel Efficiency (MPG)',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: _isMetric ? 'Price per Liter' : 'Price per Gallon',
                prefixText: '\$',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            if (_totalCost != null) ...[
              const SizedBox(height: 32),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text('Estimated Trip Cost', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        _totalCost!,
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
