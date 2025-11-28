import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RuleOf72Calculator extends ConsumerStatefulWidget {
  const RuleOf72Calculator({super.key});

  @override
  ConsumerState<RuleOf72Calculator> createState() => _RuleOf72CalculatorState();
}

class _RuleOf72CalculatorState extends ConsumerState<RuleOf72Calculator> {
  final _rateController = TextEditingController();
  
  String _years = '---';

  void _calculate() {
    final rateText = _rateController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final rate = double.tryParse(rateText);

    if (rate == null || rate == 0) {
      setState(() {
        _years = '---';
      });
      return;
    }

    // Years to double = 72 / Interest Rate
    final years = 72 / rate;

    setState(() {
      _years = '${years.toStringAsFixed(1)} years';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rule of 72')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Estimate how long it takes for an investment to double in value.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rateController,
              decoration: const InputDecoration(labelText: 'Annual Interest Rate (%)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.green.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Time to Double', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _years,
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
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
