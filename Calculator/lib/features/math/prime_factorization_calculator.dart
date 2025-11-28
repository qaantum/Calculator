import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrimeFactorizationCalculator extends ConsumerStatefulWidget {
  const PrimeFactorizationCalculator({super.key});

  @override
  ConsumerState<PrimeFactorizationCalculator> createState() => _PrimeFactorizationCalculatorState();
}

class _PrimeFactorizationCalculatorState extends ConsumerState<PrimeFactorizationCalculator> {
  final _numberController = TextEditingController();
  
  String _factors = '---';
  bool _isPrime = false;

  void _calculate() {
    final text = _numberController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final n = int.tryParse(text);

    if (n == null || n < 2) {
      setState(() {
        _factors = 'Enter integer >= 2';
        _isPrime = false;
      });
      return;
    }

    List<int> factors = [];
    int d = 2;
    int temp = n;

    while (d * d <= temp) {
      while (temp % d == 0) {
        factors.add(d);
        temp ~/= d;
      }
      d++;
    }
    if (temp > 1) {
      factors.add(temp);
    }

    setState(() {
      if (factors.length == 1 && factors[0] == n) {
        _isPrime = true;
        _factors = '$n is Prime';
      } else {
        _isPrime = false;
        _factors = factors.join(' × ');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prime Factorization')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _numberController,
              decoration: const InputDecoration(labelText: 'Integer', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: _isPrime ? Colors.green.shade100 : Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Prime Factors', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _factors,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                      textAlign: TextAlign.center,
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
