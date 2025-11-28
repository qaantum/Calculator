import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HexConverter extends ConsumerStatefulWidget {
  const HexConverter({super.key});

  @override
  ConsumerState<HexConverter> createState() => _HexConverterState();
}

class _HexConverterState extends ConsumerState<HexConverter> {
  final _decimalController = TextEditingController();
  final _hexController = TextEditingController();

  bool _isUpdating = false;

  void _onDecimalChanged(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    if (value.isEmpty) {
      _hexController.clear();
    } else {
      final intValue = int.tryParse(value);
      if (intValue != null) {
        _hexController.text = intValue.toRadixString(16).toUpperCase();
      }
    }

    _isUpdating = false;
  }

  void _onHexChanged(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    if (value.isEmpty) {
      _decimalController.clear();
    } else {
      // Filter non-hex characters
      final cleanValue = value.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
      if (cleanValue != value) {
        _hexController.text = cleanValue.toUpperCase();
        _hexController.selection = TextSelection.fromPosition(TextPosition(offset: cleanValue.length));
      }
      
      try {
        final intValue = int.parse(cleanValue, radix: 16);
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
      appBar: AppBar(title: const Text('Hexadecimal Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Convert between Decimal and Hexadecimal numbers.',
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
              controller: _hexController,
              decoration: const InputDecoration(labelText: 'Hexadecimal', border: OutlineInputBorder()),
              onChanged: _onHexChanged,
            ),
          ],
        ),
      ),
    );
  }
}
