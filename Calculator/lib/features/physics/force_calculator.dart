import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForceCalculator extends ConsumerStatefulWidget {
  const ForceCalculator({super.key});

  @override
  ConsumerState<ForceCalculator> createState() => _ForceCalculatorState();
}

class _ForceCalculatorState extends ConsumerState<ForceCalculator> {
  final _massController = TextEditingController();
  final _accelController = TextEditingController();
  
  String _force = '---';

  void _calculate() {
    final mText = _massController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final aText = _accelController.text.replaceAll(RegExp(r'[^0-9.]'), '');

    final m = double.tryParse(mText);
    final a = double.tryParse(aText);

    if (m == null || a == null) {
      setState(() {
        _force = '---';
      });
      return;
    }

    // F = m * a
    final f = m * a;

    setState(() {
      _force = '${f.toStringAsFixed(2)} N';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Force Calculator (F=ma)')),
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
              controller: _accelController,
              decoration: const InputDecoration(labelText: 'Acceleration (m/s²)', border: OutlineInputBorder()),
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
                    const Text('Force', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _force,
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
