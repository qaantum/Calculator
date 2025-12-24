import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConcreteCalculator extends ConsumerStatefulWidget {
  const ConcreteCalculator({super.key});

  @override
  ConsumerState<ConcreteCalculator> createState() => _ConcreteCalculatorState();
}

class _ConcreteCalculatorState extends ConsumerState<ConcreteCalculator> {
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _depthController = TextEditingController(text: '10');
  bool _isMetric = true;
  String _shape = 'slab'; // slab, column, stairs

  Map<String, double> _calculate() {
    final length = double.tryParse(_lengthController.text) ?? 0;
    final width = double.tryParse(_widthController.text) ?? 0;
    var depth = double.tryParse(_depthController.text) ?? 0;

    if (length == 0 || width == 0 || depth == 0) {
      return {'volume': 0, 'bags': 0, 'weight': 0};
    }

    // Convert depth to same unit as length/width
    if (_isMetric) {
      depth = depth / 100; // cm to m
    } else {
      depth = depth / 12; // inches to feet
    }

    double volume;
    if (_shape == 'column') {
      // Circular column: π * r² * h
      volume = 3.14159 * (width / 2) * (width / 2) * length;
    } else {
      // Rectangular slab
      volume = length * width * depth;
    }

    // Convert to standard units and calculate bags/weight
    double volumeMetric; // cubic meters
    if (_isMetric) {
      volumeMetric = volume;
    } else {
      // Convert cubic feet to cubic meters
      volumeMetric = volume * 0.0283168;
    }

    // Bags: ~0.6 m³ per 50kg bag (or ~1.5 cubic feet per 80lb bag)
    final bags = volumeMetric / 0.015; // Approximately 67 bags per m³
    
    // Weight: concrete is ~2400 kg/m³
    final weight = volumeMetric * 2400;

    // Convert volume for display
    final displayVolume = _isMetric ? volumeMetric : volume;

    return {
      'volume': displayVolume,
      'bags': bags,
      'weight': weight,
    };
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculate();
    final unitLength = _isMetric ? 'm' : 'ft';
    final unitDepth = _isMetric ? 'cm' : 'in';
    final unitVolume = _isMetric ? 'm³' : 'ft³';

    return Scaffold(
      appBar: AppBar(title: const Text('Concrete Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Calculate concrete volume for your project.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Metric')),
                ButtonSegment(value: false, label: Text('Imperial')),
              ],
              selected: {_isMetric},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() => _isMetric = newSelection.first);
              },
            ),
            const SizedBox(height: 16),
            const Text('Project Type:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'slab', label: Text('Slab')),
                ButtonSegment(value: 'column', label: Text('Column')),
              ],
              selected: {_shape},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() => _shape = newSelection.first);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lengthController,
                    decoration: InputDecoration(
                      labelText: _shape == 'column' ? 'Height' : 'Length',
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
                      labelText: _shape == 'column' ? 'Diameter' : 'Width',
                      suffixText: unitLength,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            if (_shape == 'slab') ...[
              const SizedBox(height: 12),
              TextField(
                controller: _depthController,
                decoration: InputDecoration(
                  labelText: 'Thickness/Depth',
                  suffixText: unitDepth,
                  border: const OutlineInputBorder(),
                  helperText: 'Standard slab: ${_isMetric ? "10-15 cm" : "4-6 inches"}',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setState(() {}),
              ),
            ],
            const SizedBox(height: 24),
            if (result['volume']! > 0) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text('🧱', style: TextStyle(fontSize: 40)),
                      const Text('Concrete Needed'),
                      Text(
                        '${result['volume']!.toStringAsFixed(2)} $unitVolume',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      if (!_isMetric) Text(
                        '(${(result['volume']! / 27).toStringAsFixed(2)} cubic yards)',
                        style: const TextStyle(fontSize: 14),
                      ),
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
                      const Text('Materials:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildRow('Pre-mix bags (${_isMetric ? "25kg" : "80lb"})', '~${result['bags']!.ceil()} bags'),
                      _buildRow('Weight', '${(result['weight']! / 1000).toStringAsFixed(1)} tonnes'),
                      if (!_isMetric) _buildRow('Cubic yards', '${(result['volume']! / 27).toStringAsFixed(2)} yd³'),
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
                    children: const [
                      Text('💡 Tips:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('• Order 5-10% extra for waste'),
                      Text('• Ready-mix is better for large projects'),
                      Text('• Standard mix: 1:2:3 (cement:sand:gravel)'),
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

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
