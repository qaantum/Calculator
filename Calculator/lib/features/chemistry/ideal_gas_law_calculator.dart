import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IdealGasLawCalculator extends ConsumerStatefulWidget {
  const IdealGasLawCalculator({super.key});

  @override
  ConsumerState<IdealGasLawCalculator> createState() => _IdealGasLawCalculatorState();
}

class _IdealGasLawCalculatorState extends ConsumerState<IdealGasLawCalculator> {
  final _pController = TextEditingController();
  final _vController = TextEditingController();
  final _nController = TextEditingController();
  final _tController = TextEditingController();

  String _result = '---';

  // R constant = 8.314 J/(mol·K) or L·kPa/(mol·K)
  // Let's assume standard units:
  // P in kPa
  // V in Liters
  // n in moles
  // T in Kelvin
  final double R = 8.314;

  void _calculate() {
    final pText = _pController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final vText = _vController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final nText = _nController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final tText = _tController.text.replaceAll(RegExp(r'[^0-9.]'), '');

    final p = double.tryParse(pText);
    final v = double.tryParse(vText);
    final n = double.tryParse(nText);
    final t = double.tryParse(tText);

    // PV = nRT
    // Need 3 inputs
    
    int inputs = 0;
    if (p != null) inputs++;
    if (v != null) inputs++;
    if (n != null) inputs++;
    if (t != null) inputs++;

    if (inputs != 3) {
      setState(() {
        _result = 'Enter any 3 values';
      });
      return;
    }

    String res = '';

    if (p == null) {
      // P = nRT / V
      if (v == 0) return;
      res = 'P = ${((n! * R * t!) / v!).toStringAsFixed(2)} kPa';
    } else if (v == null) {
      // V = nRT / P
      if (p == 0) return;
      res = 'V = ${((n! * R * t!) / p).toStringAsFixed(2)} L';
    } else if (n == null) {
      // n = PV / RT
      if (t == 0) return;
      res = 'n = ${((p! * v!) / (R * t!)).toStringAsFixed(4)} mol';
    } else if (t == null) {
      // T = PV / nR
      if (n == 0) return;
      res = 'T = ${((p! * v!) / (n * R)).toStringAsFixed(2)} K';
    }

    setState(() {
      _result = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ideal Gas Law (PV = nRT)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter any 3 values. Units: P (kPa), V (L), n (mol), T (K).',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pController,
              decoration: const InputDecoration(labelText: 'Pressure (P) [kPa]', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _vController,
              decoration: const InputDecoration(labelText: 'Volume (V) [L]', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nController,
              decoration: const InputDecoration(labelText: 'Moles (n) [mol]', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tController,
              decoration: const InputDecoration(labelText: 'Temperature (T) [K]', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.lime.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Result', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _result,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                      textAlign: TextAlign.center,
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
