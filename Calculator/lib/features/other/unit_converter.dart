import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnitConverter extends ConsumerStatefulWidget {
  const UnitConverter({super.key});

  @override
  ConsumerState<UnitConverter> createState() => _UnitConverterState();
}

class _UnitConverterState extends ConsumerState<UnitConverter> {
  final _inputController = TextEditingController();
  
  String _category = 'Length';
  String _fromUnit = 'Meters';
  String _toUnit = 'Feet';
  String _result = '';

  final Map<String, Map<String, double>> _conversions = {
    'Length': {
      'Meters': 1.0,
      'Kilometers': 0.001,
      'Centimeters': 100.0,
      'Millimeters': 1000.0,
      'Feet': 3.28084,
      'Inches': 39.3701,
      'Yards': 1.09361,
      'Miles': 0.000621371,
    },
    'Weight': {
      'Kilograms': 1.0,
      'Grams': 1000.0,
      'Milligrams': 1000000.0,
      'Pounds': 2.20462,
      'Ounces': 35.274,
      'Tons': 0.001,
    },
    'Temperature': {
      'Celsius': 0,
      'Fahrenheit': 0,
      'Kelvin': 0,
    },
  };

  void _calculate() {
    if (_inputController.text.isEmpty) {
      setState(() => _result = '');
      return;
    }

    final input = double.tryParse(_inputController.text);
    if (input == null) return;

    double output = 0;

    if (_category == 'Temperature') {
      if (_fromUnit == 'Celsius') {
        if (_toUnit == 'Fahrenheit') {
          output = (input * 9 / 5) + 32;
        } else if (_toUnit == 'Kelvin') {
          output = input + 273.15;
        } else {
          output = input;
        }
      } else if (_fromUnit == 'Fahrenheit') {
        if (_toUnit == 'Celsius') {
          output = (input - 32) * 5 / 9;
        } else if (_toUnit == 'Kelvin') {
          output = (input - 32) * 5 / 9 + 273.15;
        } else {
          output = input;
        }
      } else { // Kelvin
        if (_toUnit == 'Celsius') {
          output = input - 273.15;
        } else if (_toUnit == 'Fahrenheit') {
          output = (input - 273.15) * 9 / 5 + 32;
        } else {
          output = input;
        }
      }
    } else {
      // Convert to base unit then to target unit
      // Base unit is the one with factor 1.0 (Meters, Kilograms)
      final fromFactor = _conversions[_category]![_fromUnit]!;
      final toFactor = _conversions[_category]![_toUnit]!;
      
      // Value in base unit = input / fromFactor
      // Output = Value in base unit * toFactor
      // Wait, my map is: 1 Base = X Unit. So Base -> Unit is * Factor. Unit -> Base is / Factor.
      // Let's verify: 1 Meter = 3.28 Feet. Input 1 Meter -> 3.28 Feet. Correct.
      // Input 3.28 Feet -> 1 Meter. 3.28 / 3.28 = 1. Correct.
      
      final baseValue = input / fromFactor;
      output = baseValue * toFactor;
    }

    setState(() {
      _result = output.toStringAsFixed(4).replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final units = _conversions[_category]!.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Unit Converter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _conversions.keys.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _category = value!;
                  _fromUnit = _conversions[value]!.keys.first;
                  _toUnit = _conversions[value]!.keys.last;
                  _calculate();
                });
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _fromUnit,
                        decoration: const InputDecoration(labelText: 'From'),
                        items: units.map((u) {
                          return DropdownMenuItem(value: u, child: Text(u));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _fromUnit = value!;
                            _calculate();
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _inputController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Value',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _calculate(),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(Icons.arrow_forward),
                ),
                Expanded(
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _toUnit,
                        decoration: const InputDecoration(labelText: 'To'),
                        items: units.map((u) {
                          return DropdownMenuItem(value: u, child: Text(u));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _toUnit = value!;
                            _calculate();
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 56,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _result,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
