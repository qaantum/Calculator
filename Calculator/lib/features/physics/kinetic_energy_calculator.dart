import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KineticEnergyCalculator extends ConsumerStatefulWidget {
  const KineticEnergyCalculator({super.key});

  @override
  ConsumerState<KineticEnergyCalculator> createState() => _KineticEnergyCalculatorState();
}

class _KineticEnergyCalculatorState extends ConsumerState<KineticEnergyCalculator> {
  final _massController = TextEditingController();
  final _velocityController = TextEditingController();
  
  String _energy = '---';

  void _calculate() {
    final mText = _massController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final vText = _velocityController.text.replaceAll(RegExp(r'[^0-9.]'), '');

    final m = double.tryParse(mText);
    final v = double.tryParse(vText);

    if (m == null || v == null) {
      setState(() {
        _energy = '---';
      });
      return;
    }

    // KE = 0.5 * m * v^2
    final ke = 0.5 * m * pow(v, 2);

    setState(() {
      _energy = '${ke.toStringAsFixed(2)} J';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kinetic Energy')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _massController,
              decoration: const InputDecoration(labelText: 'Mass (kg)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _velocityController,
              decoration: const InputDecoration(labelText: 'Velocity (m/s)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.teal.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Kinetic Energy', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _energy,
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
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
