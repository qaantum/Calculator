import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RandomNumberGenerator extends ConsumerStatefulWidget {
  const RandomNumberGenerator({super.key});

  @override
  ConsumerState<RandomNumberGenerator> createState() => _RandomNumberGeneratorState();
}

class _RandomNumberGeneratorState extends ConsumerState<RandomNumberGenerator> {
  final _minController = TextEditingController(text: '1');
  final _maxController = TextEditingController(text: '100');
  final _quantityController = TextEditingController(text: '1');
  bool _allowDuplicates = true;

  List<int> _results = [];

  void _generate() {
    final min = int.tryParse(_minController.text) ?? 1;
    final max = int.tryParse(_maxController.text) ?? 100;
    final quantity = int.tryParse(_quantityController.text) ?? 1;

    if (min >= max) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Min must be less than Max')),
      );
      return;
    }

    if (!_allowDuplicates && (max - min + 1) < quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Range too small for unique numbers')),
      );
      return;
    }

    final rng = Random();
    final List<int> numbers = [];

    if (_allowDuplicates) {
      for (var i = 0; i < quantity; i++) {
        numbers.add(min + rng.nextInt(max - min + 1));
      }
    } else {
      final Set<int> uniqueNumbers = {};
      while (uniqueNumbers.length < quantity) {
        uniqueNumbers.add(min + rng.nextInt(max - min + 1));
      }
      numbers.addAll(uniqueNumbers);
    }

    setState(() {
      _results = numbers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Random Number Generator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    decoration: const InputDecoration(
                      labelText: 'Min',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    decoration: const InputDecoration(
                      labelText: 'Max',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Allow Duplicates'),
              value: _allowDuplicates,
              onChanged: (value) => setState(() => _allowDuplicates = value),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _generate,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Generate'),
              ),
            ),
            if (_results.isNotEmpty) ...[
              const SizedBox(height: 32),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _results.map((n) {
                  return Chip(
                    label: Text(
                      n.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
