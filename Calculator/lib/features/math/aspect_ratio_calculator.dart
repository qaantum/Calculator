import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AspectRatioCalculator extends ConsumerStatefulWidget {
  const AspectRatioCalculator({super.key});

  @override
  ConsumerState<AspectRatioCalculator> createState() => _AspectRatioCalculatorState();
}

class _AspectRatioCalculatorState extends ConsumerState<AspectRatioCalculator> {
  final _w1Controller = TextEditingController();
  final _h1Controller = TextEditingController();
  final _w2Controller = TextEditingController();
  final _h2Controller = TextEditingController();

  void _calculateW2() {
    final w1 = double.tryParse(_w1Controller.text);
    final h1 = double.tryParse(_h1Controller.text);
    final h2 = double.tryParse(_h2Controller.text);
    if (w1 != null && h1 != null && h2 != null && h1 != 0) {
      _w2Controller.text = ((w1 / h1) * h2).toStringAsFixed(2);
    }
  }

  void _calculateH2() {
    final w1 = double.tryParse(_w1Controller.text);
    final h1 = double.tryParse(_h1Controller.text);
    final w2 = double.tryParse(_w2Controller.text);
    if (w1 != null && h1 != null && w2 != null && w1 != 0) {
      _h2Controller.text = ((h1 / w1) * w2).toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aspect Ratio Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Original Dimensions'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _w1Controller,
                    decoration: const InputDecoration(labelText: 'Width (W1)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _h1Controller,
                    decoration: const InputDecoration(labelText: 'Height (H1)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text('New Dimensions (Enter one to calculate the other)'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _w2Controller,
                    decoration: const InputDecoration(labelText: 'Width (W2)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateH2(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _h2Controller,
                    decoration: const InputDecoration(labelText: 'Height (H2)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateW2(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 8.0,
              children: [
                ActionChip(label: const Text('4:3'), onPressed: () { _w1Controller.text = '4'; _h1Controller.text = '3'; }),
                ActionChip(label: const Text('16:9'), onPressed: () { _w1Controller.text = '16'; _h1Controller.text = '9'; }),
                ActionChip(label: const Text('21:9'), onPressed: () { _w1Controller.text = '21'; _h1Controller.text = '9'; }),
                ActionChip(label: const Text('1:1'), onPressed: () { _w1Controller.text = '1'; _h1Controller.text = '1'; }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
