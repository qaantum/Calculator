import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VoltageDividerCalculator extends ConsumerStatefulWidget {
  const VoltageDividerCalculator({super.key});

  @override
  ConsumerState<VoltageDividerCalculator> createState() => _VoltageDividerCalculatorState();
}

class _VoltageDividerCalculatorState extends ConsumerState<VoltageDividerCalculator> {
  final _vinController = TextEditingController();
  final _r1Controller = TextEditingController();
  final _r2Controller = TextEditingController();

  String _vout = '---';

  void _calculate() {
    final vinText = _vinController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final r1Text = _r1Controller.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final r2Text = _r2Controller.text.replaceAll(RegExp(r'[^0-9.]'), '');

    final vin = double.tryParse(vinText);
    final r1 = double.tryParse(r1Text);
    final r2 = double.tryParse(r2Text);

    if (vin == null || r1 == null || r2 == null || (r1 + r2) == 0) {
      setState(() {
        _vout = '---';
      });
      return;
    }

    // Vout = Vin * (R2 / (R1 + R2))
    final vout = vin * (r2 / (r1 + r2));

    setState(() {
      _vout = '${vout.toStringAsFixed(2)} V';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voltage Divider')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _vinController,
              decoration: const InputDecoration(labelText: 'Input Voltage (Vin)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _r1Controller,
              decoration: const InputDecoration(labelText: 'Resistor 1 (R1) Ω', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _r2Controller,
              decoration: const InputDecoration(labelText: 'Resistor 2 (R2) Ω', border: OutlineInputBorder()),
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
                    const Text('Output Voltage (Vout)', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _vout,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
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
