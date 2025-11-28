import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class QuadraticSolver extends ConsumerStatefulWidget {
  const QuadraticSolver({super.key});

  @override
  ConsumerState<QuadraticSolver> createState() => _QuadraticSolverState();
}

class _QuadraticSolverState extends ConsumerState<QuadraticSolver> {
  final _aController = TextEditingController();
  final _bController = TextEditingController();
  final _cController = TextEditingController();

  String _result = '---';

  void _calculate() {
    final aText = _aController.text.replaceAll(RegExp(r'[^0-9.-]'), '');
    final bText = _bController.text.replaceAll(RegExp(r'[^0-9.-]'), '');
    final cText = _cController.text.replaceAll(RegExp(r'[^0-9.-]'), '');

    final a = double.tryParse(aText);
    final b = double.tryParse(bText);
    final c = double.tryParse(cText);

    if (a == null || b == null || c == null) {
      setState(() {
        _result = '---';
      });
      return;
    }

    if (a == 0) {
      setState(() {
        _result = 'Not a quadratic equation (a = 0)';
      });
      return;
    }

    // Discriminant = b^2 - 4ac
    final d = (b * b) - (4 * a * c);

    if (d > 0) {
      final x1 = (-b + sqrt(d)) / (2 * a);
      final x2 = (-b - sqrt(d)) / (2 * a);
      setState(() {
        _result = 'Two Real Roots:\nx1 = ${x1.toStringAsFixed(4)}\nx2 = ${x2.toStringAsFixed(4)}';
      });
    } else if (d == 0) {
      final x = -b / (2 * a);
      setState(() {
        _result = 'One Real Root:\nx = ${x.toStringAsFixed(4)}';
      });
    } else {
      final realPart = -b / (2 * a);
      final imagPart = sqrt(-d) / (2 * a);
      setState(() {
        _result = 'Complex Roots:\nx1 = ${realPart.toStringAsFixed(2)} + ${imagPart.toStringAsFixed(2)}i\nx2 = ${realPart.toStringAsFixed(2)} - ${imagPart.toStringAsFixed(2)}i';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quadratic Solver')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Solves ax² + bx + c = 0',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _aController,
                    decoration: const InputDecoration(labelText: 'a', border: OutlineInputBorder()),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _bController,
                    decoration: const InputDecoration(labelText: 'b', border: OutlineInputBorder()),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _cController,
                    decoration: const InputDecoration(labelText: 'c', border: OutlineInputBorder()),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Roots', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _result,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
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
