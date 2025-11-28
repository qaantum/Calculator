import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoilMulchCalculator extends ConsumerStatefulWidget {
  const SoilMulchCalculator({super.key});

  @override
  ConsumerState<SoilMulchCalculator> createState() => _SoilMulchCalculatorState();
}

class _SoilMulchCalculatorState extends ConsumerState<SoilMulchCalculator> {
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _depthController = TextEditingController();

  String _result = '---';
  String _bags = '---';
  int _unitSystem = 0; // 0: Imperial, 1: Metric

  void _calculate() {
    final l = double.tryParse(_lengthController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
    final w = double.tryParse(_widthController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
    final d = double.tryParse(_depthController.text.replaceAll(RegExp(r'[^0-9.]'), ''));

    if (l == null || w == null || d == null) {
      setState(() {
        _result = '---';
        _bags = '---';
      });
      return;
    }

    if (_unitSystem == 0) {
      // Imperial: Length (ft), Width (ft), Depth (in)
      // Volume in cubic feet = L * W * (D/12)
      final cubicFeet = l * w * (d / 12);
      
      // Cubic yards = Cubic feet / 27
      final cubicYards = cubicFeet / 27;

      // Standard bag size in US is often 2 cubic feet.
      final bags2cf = (cubicFeet / 2).ceil();

      setState(() {
        _result = '${cubicYards.toStringAsFixed(2)} cubic yards\n(${cubicFeet.toStringAsFixed(2)} cubic feet)';
        _bags = '$bags2cf bags (2 cu.ft each)';
      });
    } else {
      // Metric: Length (m), Width (m), Depth (cm)
      // Volume in cubic meters = L * W * (D/100)
      final cubicMeters = l * w * (d / 100);
      
      // Liters = Cubic Meters * 1000
      final liters = cubicMeters * 1000;

      // Standard bag size in Metric regions often 50L or 40L. Let's use 50L.
      final bags50L = (liters / 50).ceil();

      setState(() {
        _result = '${cubicMeters.toStringAsFixed(2)} m³\n(${liters.toStringAsFixed(0)} Liters)';
        _bags = '$bags50L bags (50L each)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Soil & Mulch Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Imperial (ft/in)')),
                ButtonSegment(value: 1, label: Text('Metric (m/cm)')),
              ],
              selected: {_unitSystem},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _unitSystem = newSelection.first;
                  _calculate();
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Calculate volume of soil or mulch needed for a rectangular bed.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lengthController,
                    decoration: InputDecoration(
                      labelText: _unitSystem == 0 ? 'Length (ft)' : 'Length (m)', 
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _widthController,
                    decoration: InputDecoration(
                      labelText: _unitSystem == 0 ? 'Width (ft)' : 'Width (m)', 
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _depthController,
              decoration: InputDecoration(
                labelText: _unitSystem == 0 ? 'Depth (inches)' : 'Depth (cm)', 
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.brown.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Volume Needed', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _result,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(),
                    const Text('Estimated Bags', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _bags,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
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
