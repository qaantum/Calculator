import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class TileCalculator extends ConsumerStatefulWidget {
  const TileCalculator({super.key});

  @override
  ConsumerState<TileCalculator> createState() => _TileCalculatorState();
}

class _TileCalculatorState extends ConsumerState<TileCalculator> {
  final _areaLengthController = TextEditingController();
  final _areaWidthController = TextEditingController();
  final _tileLengthController = TextEditingController(text: '30');
  final _tileWidthController = TextEditingController(text: '30');
  final _groutWidthController = TextEditingController(text: '3');
  final _wasteController = TextEditingController(text: '10');
  bool _isMetric = true;

  Map<String, dynamic> _calculate() {
    final areaLength = double.tryParse(_areaLengthController.text) ?? 0;
    final areaWidth = double.tryParse(_areaWidthController.text) ?? 0;
    var tileLength = double.tryParse(_tileLengthController.text) ?? 0;
    var tileWidth = double.tryParse(_tileWidthController.text) ?? 0;
    var groutWidth = double.tryParse(_groutWidthController.text) ?? 0;
    final wastePercent = double.tryParse(_wasteController.text) ?? 10;

    if (areaLength == 0 || areaWidth == 0 || tileLength == 0 || tileWidth == 0) {
      return {'tiles': 0, 'area': 0, 'boxes': 0};
    }

    // Convert to same units
    if (_isMetric) {
      tileLength = tileLength / 100; // cm to m
      tileWidth = tileWidth / 100;
      groutWidth = groutWidth / 1000; // mm to m
    } else {
      tileLength = tileLength / 12; // inches to feet
      tileWidth = tileWidth / 12;
      groutWidth = groutWidth / 12;
    }

    // Area calculations
    final totalArea = areaLength * areaWidth;
    final tileAreaWithGrout = (tileLength + groutWidth) * (tileWidth + groutWidth);
    
    // Calculate tiles needed
    var tilesNeeded = (totalArea / tileAreaWithGrout).ceil();
    
    // Add waste percentage
    tilesNeeded = (tilesNeeded * (1 + wastePercent / 100)).ceil();

    // Boxes (typically 10-12 tiles per box, assume average coverage per box)
    final boxCoverage = _isMetric ? 1.0 : 10.0; // 1 m² or 10 sq ft per box approximately
    final boxes = (totalArea * (1 + wastePercent / 100) / boxCoverage).ceil();

    return {
      'tiles': tilesNeeded,
      'area': totalArea,
      'boxes': boxes,
      'groutNeeded': totalArea * 0.2, // rough estimate: 0.2 kg/m² for 3mm grout line
    };
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculate();
    final unitArea = _isMetric ? 'm' : 'ft';
    final unitTile = _isMetric ? 'cm' : 'in';
    final unitGrout = _isMetric ? 'mm' : 'in';

    return Scaffold(
      appBar: AppBar(title: const Text('Tile Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Calculate tiles needed for floor or wall.',
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
                setState(() {
                  _isMetric = newSelection.first;
                  _tileLengthController.text = _isMetric ? '30' : '12';
                  _tileWidthController.text = _isMetric ? '30' : '12';
                  _groutWidthController.text = _isMetric ? '3' : '0.125';
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Area to Tile:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _areaLengthController,
                    decoration: InputDecoration(
                      labelText: 'Length',
                      suffixText: unitArea,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _areaWidthController,
                    decoration: InputDecoration(
                      labelText: 'Width',
                      suffixText: unitArea,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Tile Size:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tileLengthController,
                    decoration: InputDecoration(
                      labelText: 'Tile Length',
                      suffixText: unitTile,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _tileWidthController,
                    decoration: InputDecoration(
                      labelText: 'Tile Width',
                      suffixText: unitTile,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _groutWidthController,
                    decoration: InputDecoration(
                      labelText: 'Grout Width',
                      suffixText: unitGrout,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _wasteController,
                    decoration: const InputDecoration(
                      labelText: 'Waste %',
                      suffixText: '%',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (result['tiles'] > 0) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text('🔲', style: TextStyle(fontSize: 40)),
                      const Text('Tiles Needed'),
                      Text(
                        '${result['tiles']}',
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      Text('(includes ${_wasteController.text}% waste)'),
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
                      const Text('Summary:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildRow('Total Area', '${result['area'].toStringAsFixed(2)} ${unitArea}²'),
                      _buildRow('Tiles Required', '${result['tiles']}'),
                      _buildRow('Est. Boxes', '~${result['boxes']}'),
                      if (_isMetric) _buildRow('Grout (estimate)', '~${(result['groutNeeded'] as double).toStringAsFixed(1)} kg'),
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
