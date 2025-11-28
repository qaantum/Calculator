import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AreaConverter extends ConsumerStatefulWidget {
  const AreaConverter({super.key});

  @override
  ConsumerState<AreaConverter> createState() => _AreaConverterState();
}

class _AreaConverterState extends ConsumerState<AreaConverter> {
  final _inputController = TextEditingController();
  String _fromUnit = 'sq m';
  String _toUnit = 'sq ft';
  String _result = '---';

  final List<String> _units = ['sq m', 'sq ft', 'sq km', 'sq mi', 'acre', 'hectare'];

  void _calculate() {
    final inputText = _inputController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final input = double.tryParse(inputText);

    if (input == null) {
      setState(() {
        _result = '---';
      });
      return;
    }

    // Convert to sq m
    double sqm = 0;
    switch (_fromUnit) {
      case 'sq m': sqm = input; break;
      case 'sq ft': sqm = input * 0.092903; break;
      case 'sq km': sqm = input * 1000000; break;
      case 'sq mi': sqm = input * 2589988.11; break;
      case 'acre': sqm = input * 4046.86; break;
      case 'hectare': sqm = input * 10000; break;
    }

    // Convert to Target
    double output = 0;
    switch (_toUnit) {
      case 'sq m': output = sqm; break;
      case 'sq ft': output = sqm / 0.092903; break;
      case 'sq km': output = sqm / 1000000; break;
      case 'sq mi': output = sqm / 2589988.11; break;
      case 'acre': output = sqm / 4046.86; break;
      case 'hectare': output = sqm / 10000; break;
    }

    setState(() {
      _result = output.toStringAsFixed(6).replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Area Converter')),
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
