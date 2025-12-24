import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BinaryConverter extends ConsumerStatefulWidget {
  const BinaryConverter({super.key});

  @override
  ConsumerState<BinaryConverter> createState() => _BinaryConverterState();
}

class _BinaryConverterState extends ConsumerState<BinaryConverter> {
  final _decimalController = TextEditingController();
  final _binaryController = TextEditingController();
  final _octalController = TextEditingController();
  final _hexController = TextEditingController();

  bool _isUpdating = false;

  void _updateFromDecimal(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    if (value.isEmpty) {
      _binaryController.clear();
      _octalController.clear();
      _hexController.clear();
    } else {
      final intValue = int.tryParse(value);
      if (intValue != null && intValue >= 0) {
        _binaryController.text = intValue.toRadixString(2);
        _octalController.text = intValue.toRadixString(8);
        _hexController.text = intValue.toRadixString(16).toUpperCase();
      }
    }

    _isUpdating = false;
  }

  void _updateFromBase(String value, int radix, TextEditingController sourceController) {
    if (_isUpdating) return;
    _isUpdating = true;

    if (value.isEmpty) {
      _decimalController.clear();
      _binaryController.clear();
      _octalController.clear();
      _hexController.clear();
    } else {
      try {
        final intValue = int.parse(value.toUpperCase(), radix: radix);
        if (intValue >= 0) {
          _decimalController.text = intValue.toString();
          if (sourceController != _binaryController) {
            _binaryController.text = intValue.toRadixString(2);
          }
          if (sourceController != _octalController) {
            _octalController.text = intValue.toRadixString(8);
          }
          if (sourceController != _hexController) {
            _hexController.text = intValue.toRadixString(16).toUpperCase();
          }
        }
      } catch (e) {
        // Invalid input for this base
      }
    }

    _isUpdating = false;
  }

  Widget _buildNumberField(String label, TextEditingController controller, int radix, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            filled: true,
          ),
          keyboardType: radix == 16 ? TextInputType.text : TextInputType.number,
          onChanged: (v) => radix == 10 ? _updateFromDecimal(v) : _updateFromBase(v, radix, controller),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Number Base Converter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Convert between Decimal, Binary, Octal, and Hexadecimal.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            _buildNumberField('Decimal (Base 10)', _decimalController, 10, 'e.g. 255'),
            const SizedBox(height: 16),
            _buildNumberField('Binary (Base 2)', _binaryController, 2, 'e.g. 11111111'),
            const SizedBox(height: 16),
            _buildNumberField('Octal (Base 8)', _octalController, 8, 'e.g. 377'),
            const SizedBox(height: 16),
            _buildNumberField('Hexadecimal (Base 16)', _hexController, 16, 'e.g. FF'),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Quick Reference:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('• Binary: 0-1'),
                    Text('• Octal: 0-7'),
                    Text('• Decimal: 0-9'),
                    Text('• Hex: 0-9, A-F'),
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
