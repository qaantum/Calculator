import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/widgets/pin_button.dart';

class VolumeConverter extends ConsumerStatefulWidget {
  const VolumeConverter({super.key});

  @override
  ConsumerState<VolumeConverter> createState() => _VolumeConverterState();
}

class _VolumeConverterState extends ConsumerState<VolumeConverter> {
  final _valueController = TextEditingController();
  String _fromUnit = 'Liters';
  String _toUnit = 'Gallons (US)';
  double? _result;

  // All values relative to liters
  final Map<String, double> _units = {
    'Milliliters': 0.001,
    'Liters': 1,
    'Cubic Meters': 1000,
    'Teaspoons': 0.00492892,
    'Tablespoons': 0.0147868,
    'Fluid Ounces (US)': 0.0295735,
    'Cups (US)': 0.236588,
    'Pints (US)': 0.473176,
    'Quarts (US)': 0.946353,
    'Gallons (US)': 3.78541,
    'Gallons (UK)': 4.54609,
  };

  void _convert() {
    final value = double.tryParse(_valueController.text);
    if (value == null) {
      setState(() => _result = null);
      return;
    }
    
    // Convert to liters first, then to target unit
    final liters = value * _units[_fromUnit]!;
    final result = liters / _units[_toUnit]!;
    
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
        title: const Text('Volume Converter'),
        actions: const [PinButton(route: '/converters/volume')],
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
                    isExpanded: true,
                    items: _units.keys.map((u) => 
                      DropdownMenuItem(value: u, child: Text(u, overflow: TextOverflow.ellipsis))
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
                    isExpanded: true,
                    items: _units.keys.map((u) => 
                      DropdownMenuItem(value: u, child: Text(u, overflow: TextOverflow.ellipsis))
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
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatNumber(_result!),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        _toUnit,
                        style: Theme.of(context).textTheme.titleMedium,
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
