import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OhmsLawCalculator extends ConsumerStatefulWidget {
  const OhmsLawCalculator({super.key});

  @override
  ConsumerState<OhmsLawCalculator> createState() => _OhmsLawCalculatorState();
}

class _OhmsLawCalculatorState extends ConsumerState<OhmsLawCalculator> {
  final _vController = TextEditingController();
  final _iController = TextEditingController();
  final _rController = TextEditingController();
  final _pController = TextEditingController();

  String _resultV = '---';
  String _resultI = '---';
  String _resultR = '---';
  String _resultP = '---';

  void _calculate() {
    final vText = _vController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final iText = _iController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final rText = _rController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final pText = _pController.text.replaceAll(RegExp(r'[^0-9.]'), '');

    final v = double.tryParse(vText);
    final i = double.tryParse(iText);
    final r = double.tryParse(rText);
    final p = double.tryParse(pText);

    int count = 0;
    if (v != null) count++;
    if (i != null) count++;
    if (r != null) count++;
    if (p != null) count++;

    if (count < 2) {
      setState(() {
        _resultV = '---';
        _resultI = '---';
        _resultR = '---';
        _resultP = '---';
      });
      return;
    }

    double? calcV = v;
    double? calcI = i;
    double? calcR = r;
    double? calcP = p;

    if (v != null && i != null) {
      calcR = v / i;
      calcP = v * i;
    } else if (v != null && r != null) {
      calcI = v / r;
      calcP = (v * v) / r;
    } else if (v != null && p != null) {
      calcI = p / v;
      calcR = (v * v) / p;
    } else if (i != null && r != null) {
      calcV = i * r;
      calcP = (i * i) * r;
    } else if (i != null && p != null) {
      calcV = p / i;
      calcR = p / (i * i);
    } else if (r != null && p != null) {
      calcV = sqrt(p * r);
      calcI = sqrt(p / r);
    }

    setState(() {
      _resultV = calcV != null ? '${calcV.toStringAsFixed(2)} V' : '---';
      _resultI = calcI != null ? '${calcI.toStringAsFixed(2)} A' : '---';
      _resultR = calcR != null ? '${calcR.toStringAsFixed(2)} Ω' : '---';
      _resultP = calcP != null ? '${calcP.toStringAsFixed(2)} W' : '---';
    });
  }

  void _clear() {
    _vController.clear();
    _iController.clear();
    _rController.clear();
    _pController.clear();
    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ohm\'s Law Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clear,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Enter any 2 values to calculate the rest:', style: TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            TextField(
              controller: _vController,
              decoration: const InputDecoration(labelText: 'Voltage (V)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _iController,
              decoration: const InputDecoration(labelText: 'Current (A)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rController,
              decoration: const InputDecoration(labelText: 'Resistance (Ω)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pController,
              decoration: const InputDecoration(labelText: 'Power (W)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.amber.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildResultRow(context, 'Voltage', _resultV),
                    const Divider(),
                    _buildResultRow(context, 'Current', _resultI),
                    const Divider(),
                    _buildResultRow(context, 'Resistance', _resultR),
                    const Divider(),
                    _buildResultRow(context, 'Power', _resultP),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          Text(value, style: const TextStyle(fontSize: 18, color: Colors.black)),
        ],
      ),
    );
  }
}
