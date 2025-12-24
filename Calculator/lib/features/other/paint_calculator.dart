import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class PaintCalculator extends ConsumerStatefulWidget {
  const PaintCalculator({super.key});

  @override
  ConsumerState<PaintCalculator> createState() => _PaintCalculatorState();
}

class _PaintCalculatorState extends ConsumerState<PaintCalculator> {
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController(text: '2.4');
  final _doorsController = TextEditingController(text: '1');
  final _windowsController = TextEditingController(text: '2');
  int _coats = 2;
  bool _isMetric = true;

  // Coverage: ~10 m² per liter or ~400 sq ft per gallon
  final double _coverageMetric = 10.0; // m² per liter
  final double _coverageImperial = 400.0; // sq ft per gallon

  Map<String, double> _calculate() {
    final length = double.tryParse(_lengthController.text) ?? 0;
    final width = double.tryParse(_widthController.text) ?? 0;
    final height = double.tryParse(_heightController.text) ?? 0;
    final doors = int.tryParse(_doorsController.text) ?? 0;
    final windows = int.tryParse(_windowsController.text) ?? 0;

    if (length == 0 || width == 0 || height == 0) {
      return {'area': 0, 'paint': 0};
    }

    // Calculate wall area
    final perimeter = 2 * (length + width);
    var wallArea = perimeter * height;

    // Subtract doors (standard ~1.9m² or 20 sq ft) and windows (~1.4m² or 15 sq ft)
    if (_isMetric) {
      wallArea -= doors * 1.9;
      wallArea -= windows * 1.4;
    } else {
      wallArea -= doors * 20;
      wallArea -= windows * 15;
    }

    wallArea = max(0, wallArea);

    // Calculate paint needed
    final coverage = _isMetric ? _coverageMetric : _coverageImperial;
    final paintNeeded = (wallArea / coverage) * _coats;

    return {
      'area': wallArea,
      'paint': paintNeeded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculate();
    final unitArea = _isMetric ? 'm²' : 'sq ft';
    final unitVolume = _isMetric ? 'L' : 'gal';
    final unitLength = _isMetric ? 'm' : 'ft';

    return Scaffold(
      appBar: AppBar(title: const Text('Paint Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Calculate how much paint you need for a room.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Metric (m)')),
                ButtonSegment(value: false, label: Text('Imperial (ft)')),
              ],
              selected: {_isMetric},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  _isMetric = newSelection.first;
                  _heightController.text = _isMetric ? '2.4' : '8';
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lengthController,
                    decoration: InputDecoration(
                      labelText: 'Room Length',
                      suffixText: unitLength,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _widthController,
                    decoration: InputDecoration(
                      labelText: 'Room Width',
                      suffixText: unitLength,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(
                labelText: 'Wall Height',
                suffixText: unitLength,
                border: const OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _doorsController,
                    decoration: const InputDecoration(
                      labelText: 'Doors',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _windowsController,
                    decoration: const InputDecoration(
                      labelText: 'Windows',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Number of Coats:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('1')),
                ButtonSegment(value: 2, label: Text('2')),
                ButtonSegment(value: 3, label: Text('3')),
              ],
              selected: {_coats},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() => _coats = newSelection.first);
              },
            ),
            const SizedBox(height: 24),
            if (result['area']! > 0) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text('🎨', style: TextStyle(fontSize: 40)),
                      const Text('Paint Needed'),
                      Text(
                        '${result['paint']!.toStringAsFixed(1)} $unitVolume',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Wall Area: ${result['area']!.toStringAsFixed(1)} $unitArea'),
                      Text('$_coats coat${_coats > 1 ? 's' : ''}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('💡 Tips:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('• Add 10% extra for touch-ups'),
                      Text('• Coverage: ${_isMetric ? "10 m² per liter" : "400 sq ft per gallon"}'),
                      const Text('• Dark colors may need more coats'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
