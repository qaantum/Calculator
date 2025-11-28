import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChildHeightPredictor extends ConsumerStatefulWidget {
  const ChildHeightPredictor({super.key});

  @override
  ConsumerState<ChildHeightPredictor> createState() => _ChildHeightPredictorState();
}

class _ChildHeightPredictorState extends ConsumerState<ChildHeightPredictor> {
  final _fatherHeightController = TextEditingController(); // cm or ft
  final _fatherInchesController = TextEditingController(); // in
  final _motherHeightController = TextEditingController(); // cm or ft
  final _motherInchesController = TextEditingController(); // in
  int _gender = 0; // 0: Boy, 1: Girl
  bool _isMetric = true;

  String _result = '---';

  void _calculate() {
    double fatherH;
    double motherH;

    if (_isMetric) {
      fatherH = double.tryParse(_fatherHeightController.text) ?? 0;
      motherH = double.tryParse(_motherHeightController.text) ?? 0;
    } else {
      final fFt = double.tryParse(_fatherHeightController.text) ?? 0;
      final fIn = double.tryParse(_fatherInchesController.text) ?? 0;
      fatherH = (fFt * 12 + fIn) * 2.54;

      final mFt = double.tryParse(_motherHeightController.text) ?? 0;
      final mIn = double.tryParse(_motherInchesController.text) ?? 0;
      motherH = (mFt * 12 + mIn) * 2.54;
    }

    if (fatherH == 0 || motherH == 0) {
      setState(() {
        _result = '---';
      });
      return;
    }

    // Mid-Parental Height Method (in cm)
    // Boy: (Father + Mother + 13) / 2
    // Girl: (Father + Mother - 13) / 2

    double predictedHeightCm;
    if (_gender == 0) { // Boy
      predictedHeightCm = (fatherH + motherH + 13) / 2;
    } else { // Girl
      predictedHeightCm = (fatherH + motherH - 13) / 2;
    }

    setState(() {
      if (_isMetric) {
        _result = '${predictedHeightCm.toStringAsFixed(1)} cm';
      } else {
        final totalInches = predictedHeightCm / 2.54;
        final feet = (totalInches / 12).floor();
        final inches = totalInches % 12;
        _result = '$feet\' ${inches.toStringAsFixed(1)}"';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Child Height Predictor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Predict adult height based on parents\' height (Mid-Parental Method).',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Metric (cm)')),
                ButtonSegment(value: false, label: Text('Imperial (ft/in)')),
              ],
              selected: {_isMetric},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  _isMetric = newSelection.first;
                  _result = '---';
                  _fatherHeightController.clear();
                  _fatherInchesController.clear();
                  _motherHeightController.clear();
                  _motherInchesController.clear();
                });
              },
            ),
            const SizedBox(height: 16),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Boy')),
                ButtonSegment(value: 1, label: Text('Girl')),
              ],
              selected: {_gender},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _gender = newSelection.first;
                  _calculate();
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Father\'s Height', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _fatherHeightController,
                    decoration: InputDecoration(
                      labelText: _isMetric ? 'cm' : 'ft',
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                if (!_isMetric) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _fatherInchesController,
                      decoration: const InputDecoration(
                        labelText: 'in',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculate(),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            const Text('Mother\'s Height', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _motherHeightController,
                    decoration: InputDecoration(
                      labelText: _isMetric ? 'cm' : 'ft',
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                if (!_isMetric) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _motherInchesController,
                      decoration: const InputDecoration(
                        labelText: 'in',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculate(),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Predicted Adult Height', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _result,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isMetric ? '± 5 cm range' : '± 2 inch range',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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
