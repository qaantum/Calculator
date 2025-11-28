import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatrixDeterminantCalculator extends ConsumerStatefulWidget {
  const MatrixDeterminantCalculator({super.key});

  @override
  ConsumerState<MatrixDeterminantCalculator> createState() => _MatrixDeterminantCalculatorState();
}

class _MatrixDeterminantCalculatorState extends ConsumerState<MatrixDeterminantCalculator> {
  int _size = 2; // 2 or 3
  
  // 3x3 max
  final List<TextEditingController> _controllers = List.generate(9, (_) => TextEditingController());
  
  String _result = '---';

  void _calculate() {
    // Parse values
    List<double> m = [];
    for (var c in _controllers) {
      m.add(double.tryParse(c.text.replaceAll(RegExp(r'[^0-9.-]'), '')) ?? 0);
    }

    double det = 0;

    if (_size == 2) {
      // | a b |
      // | c d |
      // det = ad - bc
      // Indices: 0 1, 3 4 (using 3x3 grid indices for simplicity: 0,1,2; 3,4,5; 6,7,8)
      // Actually let's just map them simply.
      // 2x2 uses indices 0,1, 3,4 from the grid? No, let's just use first 4 controllers for 2x2.
      // 0 1
      // 2 3
      
      final a = double.tryParse(_controllers[0].text) ?? 0;
      final b = double.tryParse(_controllers[1].text) ?? 0;
      final c = double.tryParse(_controllers[3].text) ?? 0; // Using visual layout
      final d = double.tryParse(_controllers[4].text) ?? 0;

      // Wait, let's make the UI dynamic so indices are consistent.
      // If 2x2:
      // 0 1
      // 2 3
      // If 3x3:
      // 0 1 2
      // 3 4 5
      // 6 7 8
      
      // I'll re-read based on size.
    }
    
    // Re-implement logic based on dynamic inputs
    if (_size == 2) {
      final a = double.tryParse(_controllers[0].text) ?? 0;
      final b = double.tryParse(_controllers[1].text) ?? 0;
      final c = double.tryParse(_controllers[2].text) ?? 0;
      final d = double.tryParse(_controllers[3].text) ?? 0;
      det = (a * d) - (b * c);
    } else {
      final a = double.tryParse(_controllers[0].text) ?? 0;
      final b = double.tryParse(_controllers[1].text) ?? 0;
      final c = double.tryParse(_controllers[2].text) ?? 0;
      final d = double.tryParse(_controllers[3].text) ?? 0;
      final e = double.tryParse(_controllers[4].text) ?? 0;
      final f = double.tryParse(_controllers[5].text) ?? 0;
      final g = double.tryParse(_controllers[6].text) ?? 0;
      final h = double.tryParse(_controllers[7].text) ?? 0;
      final i = double.tryParse(_controllers[8].text) ?? 0;

      // det = a(ei - fh) - b(di - fg) + c(dh - eg)
      det = a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g);
    }

    setState(() {
      _result = det.toStringAsFixed(4).replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matrix Determinant')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 2, label: Text('2x2')),
                ButtonSegment(value: 3, label: Text('3x3')),
              ],
              selected: {_size},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _size = newSelection.first;
                  // Clear controllers
                  for (var c in _controllers) {
                    c.clear();
                  }
                  _result = '---';
                });
              },
            ),
            const SizedBox(height: 24),
            _buildMatrixInput(),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Calculate Determinant'),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.purple.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Determinant', style: TextStyle(color: Colors.black54)),
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

  Widget _buildMatrixInput() {
    int rows = _size;
    int cols = _size;

    return Column(
      children: List.generate(rows, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(cols, (col) {
            int index = row * cols + col;
            // Map 2x2 indices (0-3) to controllers 0-3
            // Map 3x3 indices (0-8) to controllers 0-8
            return Container(
              width: 60,
              margin: const EdgeInsets.all(4),
              child: TextField(
                controller: _controllers[index],
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.all(8)),
              ),
            );
          }),
        );
      }),
    );
  }
}
