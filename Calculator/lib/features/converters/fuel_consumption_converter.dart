import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FuelConsumptionConverter extends ConsumerStatefulWidget {
  const FuelConsumptionConverter({super.key});

  @override
  ConsumerState<FuelConsumptionConverter> createState() => _FuelConsumptionConverterState();
}

class _FuelConsumptionConverterState extends ConsumerState<FuelConsumptionConverter> {
  final _inputController = TextEditingController();
  String _fromUnit = 'MPG (US)';
  String _toUnit = 'L/100km';
  String _result = '---';

  final List<String> _units = ['MPG (US)', 'MPG (UK)', 'L/100km', 'km/L'];

  void _calculate() {
    final inputText = _inputController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final input = double.tryParse(inputText);

    if (input == null || input == 0) {
      setState(() {
        _result = '---';
      });
      return;
    }

    // Convert everything to L/100km first (as base)
    double l100km = 0;
    
    // Constants
    // 1 US Gallon = 3.78541 Liters
    // 1 UK Gallon = 4.54609 Liters
    // 1 Mile = 1.60934 km

    switch (_fromUnit) {
      case 'L/100km':
        l100km = input;
        break;
      case 'km/L':
        // L/100km = 100 / km/L
        l100km = 100 / input;
        break;
      case 'MPG (US)':
        // L/100km = 235.215 / MPG_US
        l100km = 235.215 / input;
        break;
      case 'MPG (UK)':
        // L/100km = 282.481 / MPG_UK
        l100km = 282.481 / input;
        break;
    }

    // Convert L/100km to Target
    double output = 0;
    switch (_toUnit) {
      case 'L/100km':
        output = l100km;
        break;
      case 'km/L':
        output = 100 / l100km;
        break;
      case 'MPG (US)':
        output = 235.215 / l100km;
        break;
      case 'MPG (UK)':
        output = 282.481 / l100km;
        break;
    }

    setState(() {
      _result = output.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fuel Consumption Converter')),
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
