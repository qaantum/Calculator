import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlantSpacingCalculator extends ConsumerStatefulWidget {
  const PlantSpacingCalculator({super.key});

  @override
  ConsumerState<PlantSpacingCalculator> createState() => _PlantSpacingCalculatorState();
}

class _PlantSpacingCalculatorState extends ConsumerState<PlantSpacingCalculator> {
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _spacingController = TextEditingController();

  String _plants = '---';
  int _unitSystem = 0; // 0: Imperial, 1: Metric

  void _calculate() {
    final l = double.tryParse(_lengthController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
    final w = double.tryParse(_widthController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
    final s = double.tryParse(_spacingController.text.replaceAll(RegExp(r'[^0-9.]'), ''));

    if (l == null || w == null || s == null || s == 0) {
      setState(() {
        _plants = '---';
      });
      return;
    }

    double lNorm, wNorm, sNorm;

    if (_unitSystem == 0) {
      // Imperial: Length (ft), Width (ft), Spacing (in)
      // Normalize to inches
      lNorm = l * 12;
      wNorm = w * 12;
      sNorm = s;
    } else {
      // Metric: Length (m), Width (m), Spacing (cm)
      // Normalize to cm
      lNorm = l * 100;
      wNorm = w * 100;
      sNorm = s;
    }

    // Calculate rows and columns
    final rows = (lNorm / sNorm).floor();
    final cols = (wNorm / sNorm).floor();
    
    final total = rows * cols;

    // Triangular spacing (more efficient) is approx 15% more plants
    final triangular = (total * 1.15).floor();

    setState(() {
      _plants = '$total plants (Grid)\n~$triangular plants (Triangular)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plant Spacing')),
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
              'Estimate how many plants fit in a rectangular area.',
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
              controller: _spacingController,
              decoration: InputDecoration(
                labelText: _unitSystem == 0 ? 'Spacing (inches)' : 'Spacing (cm)', 
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.green.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Total Plants Needed', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _plants,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
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
