import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TVSizeCalculator extends ConsumerStatefulWidget {
  const TVSizeCalculator({super.key});

  @override
  ConsumerState<TVSizeCalculator> createState() => _TVSizeCalculatorState();
}

class _TVSizeCalculatorState extends ConsumerState<TVSizeCalculator> {
  final _diagonalController = TextEditingController();
  String _aspectRatio = '16:9';

  String _width = '---';
  String _height = '---';
  String _area = '---';
  String _minDistance = '---';
  String _maxDistance = '---';

  void _calculate() {
    final diagText = _diagonalController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final diagonal = double.tryParse(diagText);

    if (diagonal == null || diagonal == 0) {
      setState(() {
        _width = '---';
        _height = '---';
        _area = '---';
        _minDistance = '---';
        _maxDistance = '---';
      });
      return;
    }

    double ratioW = 16;
    double ratioH = 9;

    if (_aspectRatio == '4:3') {
      ratioW = 4;
      ratioH = 3;
    } else if (_aspectRatio == '21:9') {
      ratioW = 21;
      ratioH = 9;
    }

    // Calculate dimensions
    // angle = atan(h/w)
    // h = d * sin(angle)
    // w = d * cos(angle)
    final angle = atan(ratioH / ratioW);
    final height = diagonal * sin(angle);
    final width = diagonal * cos(angle);
    final area = width * height;

    // Viewing Distances (THX / SMPTE)
    // Mixed Usage: 1.5 - 2.5 x Diagonal
    // Cinema (40 deg FOV): 1.2 x Diagonal
    final minDist = diagonal * 1.2;
    final maxDist = diagonal * 2.5;

    setState(() {
      _width = '${width.toStringAsFixed(1)}"';
      _height = '${height.toStringAsFixed(1)}"';
      _area = '${area.toStringAsFixed(0)} sq in';
      _minDistance = '${(minDist / 12).toStringAsFixed(1)} ft'; // Convert to feet
      _maxDistance = '${(maxDist / 12).toStringAsFixed(1)} ft';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TV Size Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _diagonalController,
              decoration: const InputDecoration(
                labelText: 'Screen Diagonal (inches)',
                hintText: 'e.g. 55',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _aspectRatio,
              decoration: const InputDecoration(
                labelText: 'Aspect Ratio',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: '16:9', child: Text('16:9 (Standard TV)')),
                DropdownMenuItem(value: '21:9', child: Text('21:9 (Ultrawide)')),
                DropdownMenuItem(value: '4:3', child: Text('4:3 (Old TV)')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _aspectRatio = value;
                  });
                  _calculate();
                }
              },
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Dimensions', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('Width', _width),
                        _buildStat('Height', _height),
                        _buildStat('Area', _area),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Recommended Viewing Distance', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('Cinema (Immersive)', _minDistance),
                        _buildStat('Mixed Usage', _maxDistance),
                      ],
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

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
