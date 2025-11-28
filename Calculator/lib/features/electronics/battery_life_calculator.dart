import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BatteryLifeCalculator extends ConsumerStatefulWidget {
  const BatteryLifeCalculator({super.key});

  @override
  ConsumerState<BatteryLifeCalculator> createState() => _BatteryLifeCalculatorState();
}

class _BatteryLifeCalculatorState extends ConsumerState<BatteryLifeCalculator> {
  final _capacityController = TextEditingController();
  final _currentController = TextEditingController();
  
  String _hours = '---';

  void _calculate() {
    final capText = _capacityController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final currText = _currentController.text.replaceAll(RegExp(r'[^0-9.]'), '');

    final capacity = double.tryParse(capText);
    final current = double.tryParse(currText);

    if (capacity == null || current == null || current == 0) {
      setState(() {
        _hours = '---';
      });
      return;
    }

    // Battery Life = Capacity / Load * 0.7 (Efficiency factor)
    // Usually 0.7 is a safe bet for discharge efficiency
    final life = (capacity / current) * 0.7;

    setState(() {
      _hours = '${life.toStringAsFixed(1)} hours';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Battery Life Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _capacityController,
              decoration: const InputDecoration(labelText: 'Battery Capacity (mAh)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _currentController,
              decoration: const InputDecoration(labelText: 'Device Consumption (mA)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.amber.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Estimated Runtime', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _hours,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '(Assuming 70% efficiency)',
                      style: TextStyle(fontSize: 12, color: Colors.black45),
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
