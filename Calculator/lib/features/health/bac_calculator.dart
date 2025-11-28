import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BacCalculator extends ConsumerStatefulWidget {
  const BacCalculator({super.key});

  @override
  ConsumerState<BacCalculator> createState() => _BacCalculatorState();
}

class _BacCalculatorState extends ConsumerState<BacCalculator> {
  final _weightController = TextEditingController();
  final _drinksController = TextEditingController();
  final _hoursController = TextEditingController();
  
  String _gender = 'Male';
  String _bac = '---';
  String _status = '';

  void _calculate() {
    final weightText = _weightController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final drinksText = _drinksController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final hoursText = _hoursController.text.replaceAll(RegExp(r'[^0-9.]'), '');

    final weight = double.tryParse(weightText); // kg
    final drinks = double.tryParse(drinksText); // standard drinks
    final hours = double.tryParse(hoursText);

    if (weight == null || drinks == null || hours == null || weight == 0) {
      setState(() {
        _bac = '---';
        _status = '';
      });
      return;
    }

    // Widmark Formula
    // BAC = [Alcohol consumed in grams / (Body weight in grams x r)] x 100 - (elapsed time x 0.015)
    
    // Standard drink ~ 14 grams of alcohol (US)
    final alcoholGrams = drinks * 14;
    final weightGrams = weight * 1000;
    
    // r constant: 0.68 for men, 0.55 for women
    final r = _gender == 'Male' ? 0.68 : 0.55;

    double bac = (alcoholGrams / (weightGrams * r)) * 100;
    
    // Metabolism: 0.015% per hour
    bac = bac - (hours * 0.015);

    if (bac < 0) bac = 0;

    String status = '';
    if (bac < 0.02) {
      status = 'Sober';
    } else if (bac < 0.08) {
      status = 'Impaired';
    } else {
      status = 'Legally Intoxicated (US)';
    }

    setState(() {
      _bac = '${bac.toStringAsFixed(3)}%';
      _status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BAC Calculator (Estimate)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Disclaimer: This is an estimate only. Do not rely on this for driving decisions.',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() => _gender = val);
                  _calculate();
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _drinksController,
              decoration: const InputDecoration(labelText: 'Standard Drinks', hintText: '1 drink = 14g alcohol', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _hoursController,
              decoration: const InputDecoration(labelText: 'Hours Since First Drink', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Estimated BAC', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _bac,
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _status,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
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
