import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PermutationCombinationCalculator extends ConsumerStatefulWidget {
  const PermutationCombinationCalculator({super.key});

  @override
  ConsumerState<PermutationCombinationCalculator> createState() => _PermutationCombinationCalculatorState();
}

class _PermutationCombinationCalculatorState extends ConsumerState<PermutationCombinationCalculator> {
  final _nController = TextEditingController();
  final _rController = TextEditingController();
  
  String _nPr = '---';
  String _nCr = '---';

  BigInt _factorial(int n) {
    if (n < 0) return BigInt.zero;
    if (n == 0 || n == 1) return BigInt.one;
    BigInt result = BigInt.one;
    for (int i = 2; i <= n; i++) {
      result *= BigInt.from(i);
    }
    return result;
  }

  void _calculate() {
    final nText = _nController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final rText = _rController.text.replaceAll(RegExp(r'[^0-9]'), '');

    final n = int.tryParse(nText);
    final r = int.tryParse(rText);

    if (n == null || r == null || r > n || n < 0 || r < 0) {
      setState(() {
        _nPr = '---';
        _nCr = '---';
      });
      return;
    }

    // nPr = n! / (n-r)!
    // nCr = n! / (r! * (n-r)!)

    final factN = _factorial(n);
    final factR = _factorial(r);
    final factNminusR = _factorial(n - r);

    final nPr = factN ~/ factNminusR;
    final nCr = factN ~/ (factR * factNminusR);

    setState(() {
      _nPr = nPr.toString();
      _nCr = nCr.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permutations & Combinations')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nController,
              decoration: const InputDecoration(labelText: 'Total Items (n)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rController,
              decoration: const InputDecoration(labelText: 'Selected Items (r)', border: OutlineInputBorder()),
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
                    _buildResultRow('Permutations (nPr)', 'Order matters', _nPr),
                    const Divider(),
                    _buildResultRow('Combinations (nCr)', 'Order doesn\'t matter', _nCr),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String subLabel, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subLabel, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
