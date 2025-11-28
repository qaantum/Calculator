import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EvCalculator extends ConsumerStatefulWidget {
  const EvCalculator({super.key});

  @override
  ConsumerState<EvCalculator> createState() => _EvCalculatorState();
}

class _EvCalculatorState extends ConsumerState<EvCalculator> {
  final _apertureController = TextEditingController();
  final _shutterController = TextEditingController(); // In seconds (e.g. 0.01 for 1/100)
  final _isoController = TextEditingController(text: '100');

  String _ev = '---';

  void _calculate() {
    final apertureText = _apertureController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    // Shutter speed might be entered as fraction "1/100" or decimal "0.01"
    // Let's handle simple division if "/" is present? 
    // For now, let's assume decimal or handle simple parsing.
    String shutterText = _shutterController.text;
    double? shutter;
    if (shutterText.contains('/')) {
      final parts = shutterText.split('/');
      if (parts.length == 2) {
        final num = double.tryParse(parts[0]);
        final den = double.tryParse(parts[1]);
        if (num != null && den != null && den != 0) {
          shutter = num / den;
        }
      }
    } else {
      shutter = double.tryParse(shutterText.replaceAll(RegExp(r'[^0-9.]'), ''));
    }

    final isoText = _isoController.text.replaceAll(RegExp(r'[^0-9.]'), '');

    final N = double.tryParse(apertureText);
    final t = shutter;
    final S = double.tryParse(isoText);

    if (N == null || t == null || S == null || t == 0 || S == 0) {
      setState(() {
        _ev = '---';
      });
      return;
    }

    // EV = log2(N^2 / t) + log2(S / 100)
    // EV_100 = log2(N^2 / t)
    // EV_S = EV_100 + log2(S/100)
    
    final ev100 = log(pow(N, 2) / t) / log(2);
    final evS = ev100 + (log(S / 100) / log(2));

    setState(() {
      _ev = evS.toStringAsFixed(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exposure Value (EV)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _apertureController,
              decoration: const InputDecoration(labelText: 'Aperture (f/)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _shutterController,
              decoration: const InputDecoration(
                labelText: 'Shutter Speed (s)',
                hintText: 'e.g. 1/125 or 0.008',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime, // Allow / char
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _isoController,
              decoration: const InputDecoration(labelText: 'ISO', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.purple.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Exposure Value (EV)', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _ev,
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
