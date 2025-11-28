import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LedResistorCalculator extends ConsumerStatefulWidget {
  const LedResistorCalculator({super.key});

  @override
  ConsumerState<LedResistorCalculator> createState() => _LedResistorCalculatorState();
}

class _LedResistorCalculatorState extends ConsumerState<LedResistorCalculator> {
  final _sourceVoltageController = TextEditingController();
  final _ledVoltageController = TextEditingController();
  final _ledCurrentController = TextEditingController(text: '20'); // Default 20mA

  String _result = '---';
  String _power = '---';

  void _calculate() {
    final vs = double.tryParse(_sourceVoltageController.text) ?? 0;
    final vf = double.tryParse(_ledVoltageController.text) ?? 0;
    final i = double.tryParse(_ledCurrentController.text) ?? 0;

    if (vs <= vf || i == 0) {
      setState(() {
        _result = '---';
        _power = '---';
      });
      return;
    }

    // R = (Vs - Vf) / I
    // I is in mA, so convert to A (divide by 1000)
    final r = (vs - vf) / (i / 1000);
    final p = (vs - vf) * (i / 1000); // Power in Watts

    setState(() {
      _result = '${r.toStringAsFixed(2)} Ω';
      _power = '${(p * 1000).toStringAsFixed(1)} mW (${p.toStringAsFixed(3)} W)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LED Resistor Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Calculate the series resistor needed for an LED.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _sourceVoltageController,
              decoration: const InputDecoration(labelText: 'Source Voltage (Vs)', suffixText: 'V', border: OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ledVoltageController,
              decoration: const InputDecoration(labelText: 'LED Forward Voltage (Vf)', suffixText: 'V', border: OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ledCurrentController,
              decoration: const InputDecoration(labelText: 'LED Current (I)', suffixText: 'mA', border: OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Required Resistor', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _result,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                    ),
                    const SizedBox(height: 16),
                    const Text('Resistor Power Dissipation', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _power,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
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
