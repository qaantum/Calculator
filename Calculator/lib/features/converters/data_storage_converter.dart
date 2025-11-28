import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataStorageConverter extends ConsumerStatefulWidget {
  const DataStorageConverter({super.key});

  @override
  ConsumerState<DataStorageConverter> createState() => _DataStorageConverterState();
}

class _DataStorageConverterState extends ConsumerState<DataStorageConverter> {
  final _inputController = TextEditingController();
  String _fromUnit = 'MB';
  String _toUnit = 'GB';
  String _result = '---';

  final List<String> _units = ['Bit', 'Byte', 'KB', 'MB', 'GB', 'TB', 'PB'];

  void _calculate() {
    final inputText = _inputController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final input = double.tryParse(inputText);

    if (input == null) {
      setState(() {
        _result = '---';
      });
      return;
    }

    // Convert everything to Bits first
    double bits = 0;
    switch (_fromUnit) {
      case 'Bit': bits = input; break;
      case 'Byte': bits = input * 8; break;
      case 'KB': bits = input * 8 * 1024; break;
      case 'MB': bits = input * 8 * pow(1024, 2); break;
      case 'GB': bits = input * 8 * pow(1024, 3); break;
      case 'TB': bits = input * 8 * pow(1024, 4); break;
      case 'PB': bits = input * 8 * pow(1024, 5); break;
    }

    // Convert Bits to Target
    double output = 0;
    switch (_toUnit) {
      case 'Bit': output = bits; break;
      case 'Byte': output = bits / 8; break;
      case 'KB': output = bits / (8 * 1024); break;
      case 'MB': output = bits / (8 * pow(1024, 2)); break;
      case 'GB': output = bits / (8 * pow(1024, 3)); break;
      case 'TB': output = bits / (8 * pow(1024, 4)); break;
      case 'PB': output = bits / (8 * pow(1024, 5)); break;
    }

    setState(() {
      // Smart formatting
      if (output == 0) {
        _result = '0';
      } else if (output < 0.000001) {
        _result = output.toStringAsExponential(4);
      } else {
        _result = output.toStringAsFixed(6).replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Storage Converter')),
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
