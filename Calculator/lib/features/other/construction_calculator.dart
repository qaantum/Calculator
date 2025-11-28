import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConstructionCalculator extends ConsumerStatefulWidget {
  const ConstructionCalculator({super.key});

  @override
  ConsumerState<ConstructionCalculator> createState() => _ConstructionCalculatorState();
}

class _ConstructionCalculatorState extends ConsumerState<ConstructionCalculator> {
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _depthController = TextEditingController(); // For concrete
  
  // Paint: 350-400 sq ft per gallon
  // Concrete: Length x Width x Depth (cu ft) / 27 = cu yards
  
  int _mode = 0; // 0: Paint, 1: Concrete, 2: Flooring
  String? _result;

  void _calculate() {
    final length = double.tryParse(_lengthController.text);
    final width = double.tryParse(_widthController.text);
    
    if (length == null || width == null) return;

    final area = length * width; // sq ft

    if (_mode == 0) {
      // Paint (Wall)
      // Assume 1 gallon covers 350 sq ft
      final gallons = area / 350;
      setState(() {
        _result = '${gallons.toStringAsFixed(2)} Gallons\n(approx. for 1 coat)';
      });
    } else if (_mode == 1) {
      // Concrete (Slab)
      final depthInches = double.tryParse(_depthController.text);
      if (depthInches == null) return;
      
      final depthFt = depthInches / 12;
      final volumeCuFt = area * depthFt;
      final volumeCuYards = volumeCuFt / 27;
      
      // 80lb bag = ~0.6 cu ft
      final bags80 = volumeCuFt / 0.6;
      
      setState(() {
        _result = '${volumeCuYards.toStringAsFixed(2)} Cubic Yards\nOR\n${bags80.ceil()} Bags (80lb)';
      });
    } else {
      // Flooring
      // Add 10% waste
      final totalArea = area * 1.10;
      setState(() {
        _result = '${totalArea.toStringAsFixed(2)} Sq Ft\n(includes 10% waste)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Construction Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Paint')),
                ButtonSegment(value: 1, label: Text('Concrete')),
                ButtonSegment(value: 2, label: Text('Flooring')),
              ],
              selected: {_mode},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _mode = newSelection.first;
                  _result = null;
                  _calculate();
                });
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lengthController,
                    decoration: const InputDecoration(labelText: 'Length (ft)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _widthController,
                    decoration: const InputDecoration(labelText: 'Width (ft)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            if (_mode == 1) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _depthController,
                decoration: const InputDecoration(labelText: 'Depth (inches)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculate(),
              ),
            ],
            if (_result != null) ...[
              const SizedBox(height: 32),
              Card(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text('Estimated Materials', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        _result!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onTertiaryContainer,
                            ),
                      ),
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
