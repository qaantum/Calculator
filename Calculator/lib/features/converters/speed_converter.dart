import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpeedConverter extends ConsumerStatefulWidget {
  const SpeedConverter({super.key});

  @override
  ConsumerState<SpeedConverter> createState() => _SpeedConverterState();
}

class _SpeedConverterState extends ConsumerState<SpeedConverter> {
  final _inputController = TextEditingController();
  String _fromUnit = 'km/h';
  String _toUnit = 'mph';
  String _result = '---';

  final List<String> _units = ['m/s', 'km/h', 'mph', 'knot'];

  void _calculate() {
    final inputText = _inputController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final input = double.tryParse(inputText);

    if (input == null) {
      setState(() {
        _result = '---';
      });
      return;
    }

    // Convert to m/s
    double ms = 0;
    switch (_fromUnit) {
      case 'm/s': ms = input; break;
      case 'km/h': ms = input / 3.6; break;
      case 'mph': ms = input * 0.44704; break;
      case 'knot': ms = input * 0.514444; break;
    }

    // Convert to Target
    double output = 0;
    switch (_toUnit) {
      case 'm/s': output = ms; break;
      case 'km/h': output = ms * 3.6; break;
      case 'mph': output = ms / 0.44704; break;
      case 'knot': output = ms / 0.514444; break;
    }

    setState(() {
      _result = output.toStringAsFixed(2).replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speed Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(labelText: 'Value', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _fromUnit,
                    decoration: const InputDecoration(labelText: 'From', border: OutlineInputBorder()),
                    items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _fromUnit = val);
                        _calculate();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.arrow_forward),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _toUnit,
                    decoration: const InputDecoration(labelText: 'To', border: OutlineInputBorder()),
                    items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _toUnit = val);
                        _calculate();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.orange.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Result', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      '$_result $_toUnit',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
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
