import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/widgets/pin_button.dart';

class WeightConverter extends ConsumerStatefulWidget {
  const WeightConverter({super.key});

  @override
  ConsumerState<WeightConverter> createState() => _WeightConverterState();
}

class _WeightConverterState extends ConsumerState<WeightConverter> {
  final _valueController = TextEditingController();
  String _fromUnit = 'Kilograms';
  String _toUnit = 'Pounds';
  double? _result;

  // All values relative to kilograms
  final Map<String, double> _units = {
    'Milligrams': 0.000001,
    'Grams': 0.001,
    'Kilograms': 1,
    'Metric Tons': 1000,
    'Ounces': 0.0283495,
    'Pounds': 0.453592,
    'Stones': 6.35029,
    'US Tons': 907.185,
  };

  void _convert() {
    final value = double.tryParse(_valueController.text);
    if (value == null) {
      setState(() => _result = null);
      return;
    }
    
    // Convert to kg first, then to target unit
    final kg = value * _units[_fromUnit]!;
    final result = kg / _units[_toUnit]!;
    
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
        title: const Text('Weight Converter'),
        actions: const [PinButton(route: '/converters/weight')],
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
