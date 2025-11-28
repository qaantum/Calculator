import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class SlopeCalculator extends ConsumerStatefulWidget {
  const SlopeCalculator({super.key});

  @override
  ConsumerState<SlopeCalculator> createState() => _SlopeCalculatorState();
}

class _SlopeCalculatorState extends ConsumerState<SlopeCalculator> {
  final _x1Controller = TextEditingController();
  final _y1Controller = TextEditingController();
  final _x2Controller = TextEditingController();
  final _y2Controller = TextEditingController();

  String _slope = '---';
  String _distance = '---';
  String _midpoint = '---';
  String _equation = '---';

  void _calculate() {
    final x1 = double.tryParse(_x1Controller.text);
    final y1 = double.tryParse(_y1Controller.text);
    final x2 = double.tryParse(_x2Controller.text);
    final y2 = double.tryParse(_y2Controller.text);

    if (x1 == null || y1 == null || x2 == null || y2 == null) {
      setState(() {
        _slope = '---';
        _distance = '---';
        _midpoint = '---';
        _equation = '---';
      });
      return;
    }

    // Slope (m)
    double? m;
    if (x2 - x1 != 0) {
      m = (y2 - y1) / (x2 - x1);
    }

    // Distance
    final d = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));

    // Midpoint
    final mx = (x1 + x2) / 2;
    final my = (y1 + y2) / 2;

    // Equation y = mx + b -> b = y - mx
    String eq = '';
    if (m != null) {
      final b = y1 - (m * x1);
      final bSign = b >= 0 ? '+' : '-';
      eq = 'y = ${m.toStringAsFixed(2)}x $bSign ${b.abs().toStringAsFixed(2)}';
    } else {
      eq = 'x = $x1'; // Vertical line
    }

    setState(() {
      _slope = m != null ? m.toStringAsFixed(4) : 'Undefined (Vertical)';
      _distance = d.toStringAsFixed(4);
      _midpoint = '(${mx.toStringAsFixed(2)}, ${my.toStringAsFixed(2)})';
      _equation = eq;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Slope Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Point 1 (x1, y1)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _x1Controller,
                    decoration: const InputDecoration(labelText: 'x1', border: OutlineInputBorder()),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _y1Controller,
                    decoration: const InputDecoration(labelText: 'y1', border: OutlineInputBorder()),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Point 2 (x2, y2)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _x2Controller,
                    decoration: const InputDecoration(labelText: 'x2', border: OutlineInputBorder()),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _y2Controller,
                    decoration: const InputDecoration(labelText: 'y2', border: OutlineInputBorder()),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildResultRow('Slope (m)', _slope),
                    const Divider(),
                    _buildResultRow('Distance', _distance),
                    const Divider(),
                    _buildResultRow('Midpoint', _midpoint),
                    const Divider(),
                    _buildResultRow('Equation', _equation),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
