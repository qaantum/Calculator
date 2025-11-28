import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PowerUnitConverter extends ConsumerStatefulWidget {
  const PowerUnitConverter({super.key});

  @override
  ConsumerState<PowerUnitConverter> createState() => _PowerUnitConverterState();
}

class _PowerUnitConverterState extends ConsumerState<PowerUnitConverter> {
  final _inputController = TextEditingController();
  String _fromUnit = 'W';
  String _toUnit = 'kW';
  String _result = '---';

  final List<String> _units = ['W', 'kW', 'MW', 'HP (mech)', 'HP (elec)'];

  void _calculate() {
    final inputText = _inputController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final input = double.tryParse(inputText);

    if (input == null) {
      setState(() {
        _result = '---';
      });
      return;
    }

    // Convert to Watts (W)
    double w = 0;
    switch (_fromUnit) {
      case 'W': w = input; break;
      case 'kW': w = input * 1000; break;
      case 'MW': w = input * 1000000; break;
      case 'HP (mech)': w = input * 745.7; break;
      case 'HP (elec)': w = input * 746; break;
    }

    // Convert to Target
    double output = 0;
    switch (_toUnit) {
      case 'W': output = w; break;
      case 'kW': output = w / 1000; break;
      case 'MW': output = w / 1000000; break;
      case 'HP (mech)': output = w / 745.7; break;
      case 'HP (elec)': output = w / 746; break;
    }

    setState(() {
      _result = output.toStringAsFixed(4).replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Power Converter')),
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
