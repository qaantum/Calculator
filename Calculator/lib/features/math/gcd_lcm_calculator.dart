import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GcdLcmCalculator extends ConsumerStatefulWidget {
  const GcdLcmCalculator({super.key});

  @override
  ConsumerState<GcdLcmCalculator> createState() => _GcdLcmCalculatorState();
}

class _GcdLcmCalculatorState extends ConsumerState<GcdLcmCalculator> {
  final _num1Controller = TextEditingController();
  final _num2Controller = TextEditingController();
  
  String _gcd = '---';
  String _lcm = '---';

  int _calculateGCD(int a, int b) {
    while (b != 0) {
      var t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  int _calculateLCM(int a, int b) {
    if (a == 0 || b == 0) return 0;
    return (a * b).abs() ~/ _calculateGCD(a, b);
  }

  void _calculate() {
    final n1Text = _num1Controller.text.replaceAll(RegExp(r'[^0-9]'), '');
    final n2Text = _num2Controller.text.replaceAll(RegExp(r'[^0-9]'), '');

    final n1 = int.tryParse(n1Text);
    final n2 = int.tryParse(n2Text);

    if (n1 == null || n2 == null) {
      setState(() {
        _gcd = '---';
        _lcm = '---';
      });
      return;
    }

    final gcd = _calculateGCD(n1, n2);
    final lcm = _calculateLCM(n1, n2);

    setState(() {
      _gcd = gcd.toString();
      _lcm = lcm.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GCD & LCM')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _num1Controller,
              decoration: const InputDecoration(labelText: 'Number 1', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _num2Controller,
              decoration: const InputDecoration(labelText: 'Number 2', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildResultRow('GCD (Greatest Common Divisor)', _gcd),
                    const Divider(),
                    _buildResultRow('LCM (Least Common Multiple)', _lcm),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
    );
  }
}
