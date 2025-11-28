import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResistorColorCodeCalculator extends ConsumerStatefulWidget {
  const ResistorColorCodeCalculator({super.key});

  @override
  ConsumerState<ResistorColorCodeCalculator> createState() => _ResistorColorCodeCalculatorState();
}

class _ResistorColorCodeCalculatorState extends ConsumerState<ResistorColorCodeCalculator> {
  // 4-Band Resistor
  // Band 1: Digit 1
  // Band 2: Digit 2
  // Band 3: Multiplier
  // Band 4: Tolerance

  int _band1 = 1; // Brown (1)
  int _band2 = 0; // Black (0)
  int _multiplier = 2; // Red (x100)
  int _tolerance = 1; // Gold (5%) - index in tolerance list

  final List<Map<String, dynamic>> _colors = [
    {'name': 'Black', 'color': Colors.black, 'val': 0, 'mult': 1},
    {'name': 'Brown', 'color': Colors.brown, 'val': 1, 'mult': 10},
    {'name': 'Red', 'color': Colors.red, 'val': 2, 'mult': 100},
    {'name': 'Orange', 'color': Colors.orange, 'val': 3, 'mult': 1000},
    {'name': 'Yellow', 'color': Colors.yellow, 'val': 4, 'mult': 10000},
    {'name': 'Green', 'color': Colors.green, 'val': 5, 'mult': 100000},
    {'name': 'Blue', 'color': Colors.blue, 'val': 6, 'mult': 1000000},
    {'name': 'Violet', 'color': Colors.purple, 'val': 7, 'mult': 10000000},
    {'name': 'Grey', 'color': Colors.grey, 'val': 8, 'mult': 100000000},
    {'name': 'White', 'color': Colors.white, 'val': 9, 'mult': 1000000000},
  ];

  final List<Map<String, dynamic>> _tolerances = [
    {'name': 'Brown', 'color': Colors.brown, 'val': 1.0},
    {'name': 'Red', 'color': Colors.red, 'val': 2.0},
    {'name': 'Green', 'color': Colors.green, 'val': 0.5},
    {'name': 'Blue', 'color': Colors.blue, 'val': 0.25},
    {'name': 'Violet', 'color': Colors.purple, 'val': 0.1},
    {'name': 'Grey', 'color': Colors.grey, 'val': 0.05},
    {'name': 'Gold', 'color': const Color(0xFFFFD700), 'val': 5.0},
    {'name': 'Silver', 'color': const Color(0xFFC0C0C0), 'val': 10.0},
  ];

  String _result = '';

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _calculate() {
    final digit1 = _colors[_band1]['val'] as int;
    final digit2 = _colors[_band2]['val'] as int;
    final mult = _colors[_multiplier]['mult'] as int;
    final tol = _tolerances[_tolerance]['val'] as double;

    final resistance = ((digit1 * 10) + digit2) * mult;
    
    String resistanceStr;
    if (resistance >= 1000000) {
      resistanceStr = '${(resistance / 1000000).toStringAsFixed(resistance % 1000000 == 0 ? 0 : 2)} MΩ';
    } else if (resistance >= 1000) {
      resistanceStr = '${(resistance / 1000).toStringAsFixed(resistance % 1000 == 0 ? 0 : 2)} kΩ';
    } else {
      resistanceStr = '$resistance Ω';
    }

    setState(() {
      _result = '$resistanceStr ±$tol%';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resistor Color Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '4-Band Resistor Calculator',
              style: TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Resistor Visual
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0), // Resistor body color
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBand(_colors[_band1]['color']),
                  _buildBand(_colors[_band2]['color']),
                  _buildBand(_colors[_multiplier]['color']),
                  const SizedBox(width: 20), // Gap for tolerance
                  _buildBand(_tolerances[_tolerance]['color']),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              _result,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildDropdown('Band 1', _colors, _band1, (val) {
              setState(() { _band1 = val!; _calculate(); });
            }),
            _buildDropdown('Band 2', _colors, _band2, (val) {
              setState(() { _band2 = val!; _calculate(); });
            }),
            _buildDropdown('Multiplier', _colors, _multiplier, (val) {
              setState(() { _multiplier = val!; _calculate(); });
            }),
            _buildDropdown('Tolerance', _tolerances, _tolerance, (val) {
              setState(() { _tolerance = val!; _calculate(); });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBand(Color color) {
    return Container(
      width: 20,
      height: 100,
      color: color,
    );
  }

  Widget _buildDropdown(String label, List<Map<String, dynamic>> items, int value, ValueChanged<int?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              items: List.generate(items.length, (index) {
                final item = items[index];
                return DropdownMenuItem(
                  value: index,
                  child: Row(
                    children: [
                      Container(width: 20, height: 20, color: item['color'], margin: const EdgeInsets.only(right: 8)),
                      Text(item['name']),
                    ],
                  ),
                );
              }),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
