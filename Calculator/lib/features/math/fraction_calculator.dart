import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FractionCalculator extends ConsumerStatefulWidget {
  const FractionCalculator({super.key});

  @override
  ConsumerState<FractionCalculator> createState() => _FractionCalculatorState();
}

class _FractionCalculatorState extends ConsumerState<FractionCalculator> {
  final _num1Controller = TextEditingController();
  final _den1Controller = TextEditingController();
  final _num2Controller = TextEditingController();
  final _den2Controller = TextEditingController();

  String _operation = '+'; // +, -, *, /
  String _resultFraction = '---';
  String _resultDecimal = '---';

  int _gcd(int a, int b) {
    return b == 0 ? a : _gcd(b, a % b);
  }

  void _calculate() {
    final n1 = int.tryParse(_num1Controller.text);
    final d1 = int.tryParse(_den1Controller.text);
    final n2 = int.tryParse(_num2Controller.text);
    final d2 = int.tryParse(_den2Controller.text);

    if (n1 == null || d1 == null || n2 == null || d2 == null || d1 == 0 || d2 == 0) {
      setState(() {
        _resultFraction = '---';
        _resultDecimal = '---';
      });
      return;
    }

    int resNum = 0;
    int resDen = 1;

    switch (_operation) {
      case '+':
        resNum = (n1 * d2) + (n2 * d1);
        resDen = d1 * d2;
        break;
      case '-':
        resNum = (n1 * d2) - (n2 * d1);
        resDen = d1 * d2;
        break;
      case '*':
        resNum = n1 * n2;
        resDen = d1 * d2;
        break;
      case '/':
        if (n2 == 0) {
          setState(() {
            _resultFraction = 'Error';
            _resultDecimal = 'Div by 0';
          });
          return;
        }
        resNum = n1 * d2;
        resDen = d1 * n2;
        break;
    }

    // Simplify
    if (resDen < 0) {
      resNum = -resNum;
      resDen = -resDen;
    }
    
    final common = _gcd(resNum.abs(), resDen);
    resNum ~/= common;
    resDen ~/= common;

    setState(() {
      _resultFraction = '$resNum / $resDen';
      _resultDecimal = (resNum / resDen).toStringAsFixed(4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fraction Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildFractionInput(_num1Controller, _den1Controller),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _operation,
                  items: ['+', '-', '*', '/'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 24)))).toList(),
                  onChanged: (val) {
                    setState(() {
                      _operation = val!;
                      _calculate();
                    });
                  },
                ),
                const SizedBox(width: 8),
                _buildFractionInput(_num2Controller, _den2Controller),
              ],
            ),
            const SizedBox(height: 32),
            const Text('=', style: TextStyle(fontSize: 32)),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(_resultFraction, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('= $_resultDecimal', style: const TextStyle(fontSize: 20, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFractionInput(TextEditingController numCtrl, TextEditingController denCtrl) {
    return Expanded(
      child: Column(
        children: [
          TextField(
            controller: numCtrl,
            textAlign: TextAlign.center,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            decoration: const InputDecoration(hintText: 'Num'),
            onChanged: (_) => _calculate(),
          ),
          const Divider(thickness: 2, color: Colors.black),
          TextField(
            controller: denCtrl,
            textAlign: TextAlign.center,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            decoration: const InputDecoration(hintText: 'Den'),
            onChanged: (_) => _calculate(),
          ),
        ],
      ),
    );
  }
}
