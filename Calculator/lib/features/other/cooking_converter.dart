import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CookingConverter extends ConsumerStatefulWidget {
  const CookingConverter({super.key});

  @override
  ConsumerState<CookingConverter> createState() => _CookingConverterState();
}

class _CookingConverterState extends ConsumerState<CookingConverter> {
  final _amountController = TextEditingController();
  String _fromUnit = 'Cups';
  String _toUnit = 'Milliliters';
  String _ingredient = 'Water'; // Density matters for weight
  String? _result;

  final Map<String, double> _volumeToMl = {
    'Teaspoons': 4.92892,
    'Tablespoons': 14.7868,
    'Fluid Ounces': 29.5735,
    'Cups': 236.588,
    'Pints': 473.176,
    'Quarts': 946.353,
    'Gallons': 3785.41,
    'Milliliters': 1.0,
    'Liters': 1000.0,
  };

  // Density g/ml
  final Map<String, double> _densities = {
    'Water': 1.0,
    'Flour (All Purpose)': 0.53,
    'Sugar (Granulated)': 0.85,
    'Butter': 0.911,
    'Milk': 1.03,
    'Oil': 0.92,
    'Honey': 1.42,
  };

  void _calculate() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) return;

    double ml;
    // Convert input to ML first
    if (_volumeToMl.containsKey(_fromUnit)) {
      ml = amount * _volumeToMl[_fromUnit]!;
    } else {
      // Weight input (Grams/Ounces) - need density to convert to ML
      // Not implementing weight-to-volume yet to keep simple, assuming volume-to-volume for now
      // Or we can add simple weight support
      ml = amount; // Placeholder
    }

    double result;
    if (_volumeToMl.containsKey(_toUnit)) {
      result = ml / _volumeToMl[_toUnit]!;
    } else {
      // Target is weight (Grams)
      // Mass = Volume * Density
      final density = _densities[_ingredient]!;
      if (_toUnit == 'Grams') {
        result = ml * density;
      } else if (_toUnit == 'Ounces (Weight)') {
        result = (ml * density) / 28.3495;
      } else {
        result = 0;
      }
    }

    setState(() {
      _result = '${result.toStringAsFixed(2)} $_toUnit';
    });
  }

  @override
  Widget build(BuildContext context) {
    final units = [..._volumeToMl.keys, 'Grams', 'Ounces (Weight)'];

    return Scaffold(
      appBar: AppBar(title: const Text('Cooking Converter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _ingredient,
              decoration: const InputDecoration(labelText: 'Ingredient (affects weight)', border: OutlineInputBorder()),
              items: _densities.keys.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
              onChanged: (v) => setState(() { _ingredient = v!; _calculate(); }),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _fromUnit,
                    decoration: const InputDecoration(labelText: 'From', border: OutlineInputBorder()),
                    items: _volumeToMl.keys.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                    onChanged: (v) => setState(() { _fromUnit = v!; _calculate(); }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _toUnit,
              decoration: const InputDecoration(labelText: 'To', border: OutlineInputBorder()),
              items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
              onChanged: (v) => setState(() { _toUnit = v!; _calculate(); }),
            ),
            if (_result != null) ...[
              const SizedBox(height: 32),
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text('Result', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        _result!,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
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
}
