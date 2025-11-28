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

  bool _isUpdating = false;

  void _onDecimalChanged(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    if (value.isEmpty) {
      _binaryController.clear();
    } else {
      final intValue = int.tryParse(value);
      if (intValue != null) {
        _binaryController.text = intValue.toRadixString(2);
      }
    }

    _isUpdating = false;
  }

  void _onBinaryChanged(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    if (value.isEmpty) {
      _decimalController.clear();
    } else {
      // Filter non-binary characters
      final cleanValue = value.replaceAll(RegExp(r'[^01]'), '');
      if (cleanValue != value) {
        _binaryController.text = cleanValue;
        _binaryController.selection = TextSelection.fromPosition(TextPosition(offset: cleanValue.length));
      }
      
      try {
        final intValue = int.parse(cleanValue, radix: 2);
        _decimalController.text = intValue.toString();
      } catch (e) {
        // Handle overflow or error
      }
    }

    _isUpdating = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Binary Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Convert between Decimal and Binary numbers.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _decimalController,
              decoration: const InputDecoration(labelText: 'Decimal', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: _onDecimalChanged,
            ),
            const SizedBox(height: 16),
            const Icon(Icons.swap_vert),
            const SizedBox(height: 16),
            TextField(
              controller: _binaryController,
              decoration: const InputDecoration(labelText: 'Binary', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: _onBinaryChanged,
            ),
          ],
        ),
      ),
    );
  }
}
