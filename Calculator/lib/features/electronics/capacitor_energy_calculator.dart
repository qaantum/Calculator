import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class CapacitorEnergyCalculator extends ConsumerStatefulWidget {
  const CapacitorEnergyCalculator({super.key});

  @override
  ConsumerState<CapacitorEnergyCalculator> createState() => _CapacitorEnergyCalculatorState();
}

class _CapacitorEnergyCalculatorState extends ConsumerState<CapacitorEnergyCalculator> {
  final _capacitanceController = TextEditingController();
  final _voltageController = TextEditingController();

  String _energy = '---';
  String _charge = '---';

  void _calculate() {
    final c = double.tryParse(_capacitanceController.text); // Farads
    final v = double.tryParse(_voltageController.text); // Volts

    if (c == null || v == null) {
      setState(() {
        _energy = '---';
        _charge = '---';
      });
      return;
    }

    // E = 0.5 * C * V^2
    final energy = 0.5 * c * pow(v, 2);
    
    // Q = C * V
    final charge = c * v;

    setState(() {
      _energy = '${energy.toStringAsExponential(3)} J';
      _charge = '${charge.toStringAsExponential(3)} C';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capacitor Energy')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _capacitanceController,
              decoration: const InputDecoration(labelText: 'Capacitance (Farads)', border: OutlineInputBorder(), hintText: 'e.g. 0.001'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _voltageController,
              decoration: const InputDecoration(labelText: 'Voltage (Volts)', border: OutlineInputBorder()),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Stored Energy (E)', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(_energy, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                    const Divider(height: 32),
                    const Text('Stored Charge (Q)', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(_charge, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange)),
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
