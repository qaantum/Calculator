import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DilutionCalculator extends ConsumerStatefulWidget {
  const DilutionCalculator({super.key});

  @override
  ConsumerState<DilutionCalculator> createState() => _DilutionCalculatorState();
}

class _DilutionCalculatorState extends ConsumerState<DilutionCalculator> {
  final _m1Controller = TextEditingController();
  final _v1Controller = TextEditingController();
  final _m2Controller = TextEditingController();
  final _v2Controller = TextEditingController();

  String _result = '---';

  void _calculate() {
    final m1Text = _m1Controller.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final v1Text = _v1Controller.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final m2Text = _m2Controller.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final v2Text = _v2Controller.text.replaceAll(RegExp(r'[^0-9.]'), '');

    final m1 = double.tryParse(m1Text);
    final v1 = double.tryParse(v1Text);
    final m2 = double.tryParse(m2Text);
    final v2 = double.tryParse(v2Text);

    // M1V1 = M2V2
    // We need 3 inputs to find the 4th.
    
    int inputs = 0;
    if (m1 != null) inputs++;
    if (v1 != null) inputs++;
    if (m2 != null) inputs++;
    if (v2 != null) inputs++;

    if (inputs != 3) {
      setState(() {
        _result = 'Enter any 3 values';
      });
      return;
    }

    String res = '';

    if (m1 == null) {
      // M1 = (M2 * V2) / V1
      if (v1 == 0) return;
      res = 'M1 = ${((m2! * v2!) / v1!).toStringAsFixed(2)}';
    } else if (v1 == null) {
      // V1 = (M2 * V2) / M1
      if (m1 == 0) return;
      res = 'V1 = ${((m2! * v2!) / m1).toStringAsFixed(2)}';
    } else if (m2 == null) {
      // M2 = (M1 * V1) / V2
      if (v2 == 0) return;
      res = 'M2 = ${((m1 * v1!) / v2!).toStringAsFixed(2)}';
    } else if (v2 == null) {
      // V2 = (M1 * V1) / M2
      if (m2 == 0) return;
      res = 'V2 = ${((m1 * v1!) / m2).toStringAsFixed(2)}';
    }

    setState(() {
      _result = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dilution (M1V1 = M2V2)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter any 3 values to calculate the 4th.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _m1Controller,
                    decoration: const InputDecoration(labelText: 'M1 (Initial Conc.)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _v1Controller,
                    decoration: const InputDecoration(labelText: 'V1 (Initial Vol.)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _m2Controller,
                    decoration: const InputDecoration(labelText: 'M2 (Final Conc.)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _v2Controller,
                    decoration: const InputDecoration(labelText: 'V2 (Final Vol.)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
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
