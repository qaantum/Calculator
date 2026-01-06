import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/widgets/pin_button.dart';

class LengthConverter extends ConsumerStatefulWidget {
  const LengthConverter({super.key});

  @override
  ConsumerState<LengthConverter> createState() => _LengthConverterState();
}

class _LengthConverterState extends ConsumerState<LengthConverter> {
  final _valueController = TextEditingController();
  String _fromUnit = 'Meters';
  String _toUnit = 'Feet';
  double? _result;

  // All values relative to meters
  final Map<String, double> _units = {
    'Millimeters': 0.001,
    'Centimeters': 0.01,
    'Meters': 1,
    'Kilometers': 1000,
    'Inches': 0.0254,
    'Feet': 0.3048,
    'Yards': 0.9144,
    'Miles': 1609.344,
    'Nautical Miles': 1852,
  };

  void _convert() {
    final value = double.tryParse(_valueController.text);
    if (value == null) {
      setState(() => _result = null);
      return;
    }
    
    // Convert to meters first, then to target unit
    final meters = value * _units[_fromUnit]!;
    final result = meters / _units[_toUnit]!;
    
    setState(() => _result = result);
  }

  void _swap() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
    });
    _convert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Length Converter'),
        actions: const [PinButton(route: '/converters/length')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _convert(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _fromUnit,
                    decoration: const InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(),
                    ),
                    items: _units.keys.map((u) => 
                      DropdownMenuItem(value: u, child: Text(u))
                    ).toList(),
                    onChanged: (v) {
                      setState(() => _fromUnit = v!);
                      _convert();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton.filled(
                    onPressed: _swap,
                    icon: const Icon(Icons.swap_horiz),
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _toUnit,
                    decoration: const InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(),
                    ),
                    items: _units.keys.map((u) => 
                      DropdownMenuItem(value: u, child: Text(u))
                    ).toList(),
                    onChanged: (v) {
                      setState(() => _toUnit = v!);
                      _convert();
                    },
                  ),
                ),
              ],
            ),
            if (_result != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        '${_valueController.text} $_fromUnit =',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_formatNumber(_result!)} $_toUnit',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatNumber(double n) {
    if (n.abs() > 1e6 || (n.abs() < 0.001 && n != 0)) {
      return n.toStringAsExponential(4);
    }
    return n.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
}
