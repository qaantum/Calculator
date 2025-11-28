import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PowerCalculator extends ConsumerStatefulWidget {
  const PowerCalculator({super.key});

  @override
  ConsumerState<PowerCalculator> createState() => _PowerCalculatorState();
}

class _PowerCalculatorState extends ConsumerState<PowerCalculator> {
  final _workController = TextEditingController();
  final _timeController = TextEditingController();
  final _forceController = TextEditingController();
  final _velocityController = TextEditingController();

  String _result = '---';
  int _mode = 0; // 0: P = W/t, 1: P = Fv

  void _calculate() {
    if (_mode == 0) {
      final w = double.tryParse(_workController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
      final t = double.tryParse(_timeController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
      if (w != null && t != null && t != 0) {
        setState(() => _result = '${(w / t).toStringAsFixed(2)} Watts');
      } else {
        setState(() => _result = '---');
      }
    } else {
      final f = double.tryParse(_forceController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
      final v = double.tryParse(_velocityController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
      if (f != null && v != null) {
        setState(() => _result = '${(f * v).toStringAsFixed(2)} Watts');
      } else {
        setState(() => _result = '---');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Power Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('P = W / t')),
                ButtonSegment(value: 1, label: Text('P = F × v')),
              ],
              selected: {_mode},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _mode = newSelection.first;
                  _result = '---';
                  _workController.clear();
                  _timeController.clear();
                  _forceController.clear();
                  _velocityController.clear();
                });
              },
            ),
            const SizedBox(height: 24),
            if (_mode == 0) ...[
              TextField(
                controller: _workController,
                decoration: const InputDecoration(labelText: 'Work (Joules)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculate(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time (seconds)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculate(),
              ),
            ] else ...[
              TextField(
                controller: _forceController,
                decoration: const InputDecoration(labelText: 'Force (Newtons)', border: OutlineInputBorder()),
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
            ],
            const SizedBox(height: 32),
            Card(
              color: Colors.amber.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Power', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _result,
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
