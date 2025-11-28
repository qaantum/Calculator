import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RomanNumeralConverter extends ConsumerStatefulWidget {
  const RomanNumeralConverter({super.key});

  @override
  ConsumerState<RomanNumeralConverter> createState() => _RomanNumeralConverterState();
}

class _RomanNumeralConverterState extends ConsumerState<RomanNumeralConverter> {
  final _decimalController = TextEditingController();
  final _romanController = TextEditingController();

  bool _isUpdating = false;

  static const Map<int, String> _romanNumerals = {
    1000: 'M', 900: 'CM', 500: 'D', 400: 'CD',
    100: 'C', 90: 'XC', 50: 'L', 40: 'XL',
    10: 'X', 9: 'IX', 5: 'V', 4: 'IV', 1: 'I'
  };

  String _toRoman(int number) {
    if (number <= 0 || number > 3999) return '';
    final buffer = StringBuffer();
    for (var entry in _romanNumerals.entries) {
      while (number >= entry.key) {
        buffer.write(entry.value);
        number -= entry.key;
      }
    }
    return buffer.toString();
  }

  int _fromRoman(String roman) {
    int result = 0;
    int prev = 0;
    for (int i = roman.length - 1; i >= 0; i--) {
      int curr = 0;
      switch (roman[i]) {
        case 'M': curr = 1000; break;
        case 'D': curr = 500; break;
        case 'C': curr = 100; break;
        case 'L': curr = 50; break;
        case 'X': curr = 10; break;
        case 'V': curr = 5; break;
        case 'I': curr = 1; break;
        default: return 0;
      }
      if (curr < prev) {
        result -= curr;
      } else {
        result += curr;
      }
      prev = curr;
    }
    return result;
  }

  void _onDecimalChanged(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    if (value.isEmpty) {
      _romanController.clear();
    } else {
      final intValue = int.tryParse(value);
      if (intValue != null) {
        _romanController.text = _toRoman(intValue);
      }
    }

    _isUpdating = false;
  }

  void _onRomanChanged(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    if (value.isEmpty) {
      _decimalController.clear();
    } else {
      final cleanValue = value.toUpperCase().replaceAll(RegExp(r'[^MDCLXVI]'), '');
      if (cleanValue != value) {
        _romanController.text = cleanValue;
        _romanController.selection = TextSelection.fromPosition(TextPosition(offset: cleanValue.length));
      }
      
      final intValue = _fromRoman(cleanValue);
      if (intValue > 0) {
        _decimalController.text = intValue.toString();
      }
    }

    _isUpdating = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Roman Numeral Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Convert between Decimal and Roman Numerals (1 - 3999).',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _decimalController,
              decoration: const InputDecoration(labelText: 'Decimal Number', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: _onDecimalChanged,
            ),
            const SizedBox(height: 16),
            const Icon(Icons.swap_vert),
            const SizedBox(height: 16),
            TextField(
              controller: _romanController,
              decoration: const InputDecoration(labelText: 'Roman Numeral', border: OutlineInputBorder()),
              onChanged: _onRomanChanged,
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
      ),
    );
  }
}
