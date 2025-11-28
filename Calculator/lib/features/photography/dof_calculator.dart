import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DofCalculator extends ConsumerStatefulWidget {
  const DofCalculator({super.key});

  @override
  ConsumerState<DofCalculator> createState() => _DofCalculatorState();
}

class _DofCalculatorState extends ConsumerState<DofCalculator> {
  final _focalLengthController = TextEditingController();
  final _apertureController = TextEditingController();
  final _distanceController = TextEditingController();
  
  String _sensorSize = 'Full Frame';
  
  String _nearLimit = '---';
  String _farLimit = '---';
  String _totalDof = '---';
  String _hyperfocal = '---';

  // Circle of Confusion (CoC) values (mm)
  final Map<String, double> _cocValues = {
    'Full Frame': 0.030,
    'APS-C (Canon)': 0.019,
    'APS-C (Nikon/Sony)': 0.020,
    'Micro 4/3': 0.015,
    '1 inch': 0.011,
  };

  void _calculate() {
    final focalText = _focalLengthController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final apertureText = _apertureController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final distText = _distanceController.text.replaceAll(RegExp(r'[^0-9.]'), '');

    final f = double.tryParse(focalText); // mm
    final N = double.tryParse(apertureText); // f-number
    final d = double.tryParse(distText); // meters

    if (f == null || N == null || d == null || f == 0 || N == 0 || d == 0) {
      setState(() {
        _nearLimit = '---';
        _farLimit = '---';
        _totalDof = '---';
        _hyperfocal = '---';
      });
      return;
    }

    final coc = _cocValues[_sensorSize] ?? 0.030;
    
    // Hyperfocal Distance H = (f^2) / (N * c) + f
    // f is in mm, coc is in mm. Result in mm.
    final H_mm = (pow(f, 2) / (N * coc)) + f;
    final H_m = H_mm / 1000; // Convert to meters

    // Distance d is in meters. Convert to mm for calculation or keep H in meters.
    // Let's work in meters.
    // Near Limit Dn = (H * d) / (H + (d - f/1000))
    // Far Limit Df = (H * d) / (H - (d - f/1000))
    
    // Simplified (ignoring f in denominator as d >> f usually):
    // Dn = (H * d) / (H + d)
    // Df = (H * d) / (H - d)
    // But let's use the more precise one:
    
    final s = d * 1000; // Subject distance in mm
    final Dn_mm = (H_mm * s) / (H_mm + (s - f));
    final Df_mm = (H_mm * s) / (H_mm - (s - f));

    final Dn_m = Dn_mm / 1000;
    
    double? Df_m;
    if (s >= H_mm) {
      Df_m = double.infinity;
    } else {
      Df_m = Df_mm / 1000;
      if (Df_m < 0) Df_m = double.infinity; // Should not happen if s < H
    }

    setState(() {
      _hyperfocal = '${H_m.toStringAsFixed(2)} m';
      _nearLimit = '${Dn_m.toStringAsFixed(2)} m';
      
      if (Df_m == double.infinity) {
        _farLimit = 'Infinity';
        _totalDof = 'Infinite';
      } else {
        _farLimit = '${Df_m!.toStringAsFixed(2)} m';
        _totalDof = '${(Df_m - Dn_m).toStringAsFixed(2)} m';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Depth of Field')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _sensorSize,
              decoration: const InputDecoration(labelText: 'Sensor Size', border: OutlineInputBorder()),
              items: _cocValues.keys.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _sensorSize = val);
                  _calculate();
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _focalLengthController,
                    decoration: const InputDecoration(labelText: 'Focal Length (mm)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _apertureController,
                    decoration: const InputDecoration(labelText: 'Aperture (f/)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _distanceController,
              decoration: const InputDecoration(labelText: 'Subject Distance (m)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.purple.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildResultRow('Hyperfocal Distance', _hyperfocal),
                    const Divider(),
                    _buildResultRow('Near Limit', _nearLimit),
                    const Divider(),
                    _buildResultRow('Far Limit', _farLimit),
                    const Divider(),
                    _buildResultRow('Total DoF', _totalDof, isBold: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
