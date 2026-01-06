import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/widgets/pin_button.dart';

class SummationCalculator extends ConsumerStatefulWidget {
  const SummationCalculator({super.key});

  @override
  ConsumerState<SummationCalculator> createState() => _SummationCalculatorState();
}

class _SummationCalculatorState extends ConsumerState<SummationCalculator> {
  final _firstTermController = TextEditingController();
  final _commonDiffController = TextEditingController();
  final _numTermsController = TextEditingController();
  
  String _seriesType = 'Arithmetic';
  double? _sum;
  double? _nthTerm;
  List<double>? _terms;

  void _calculate() {
    final a = double.tryParse(_firstTermController.text);
    final d = double.tryParse(_commonDiffController.text);
    final n = int.tryParse(_numTermsController.text);
    
    if (a == null || d == null || n == null || n <= 0) {
      setState(() {
        _sum = null;
        _nthTerm = null;
        _terms = null;
      });
      return;
    }
    
    double sum;
    double nthTerm;
    List<double> terms = [];
    
    if (_seriesType == 'Arithmetic') {
      // Arithmetic: a, a+d, a+2d, ...
      // Sum = n/2 * (2a + (n-1)d)
      // nth term = a + (n-1)d
      nthTerm = a + (n - 1) * d;
      sum = n / 2 * (2 * a + (n - 1) * d);
      for (int i = 0; i < n && i < 10; i++) {
        terms.add(a + i * d);
      }
    } else {
      // Geometric: a, a*r, a*r^2, ...
      // Sum = a * (1 - r^n) / (1 - r) for r != 1
      // nth term = a * r^(n-1)
      final r = d; // In geometric, d is the common ratio
      nthTerm = a * math.pow(r, n - 1);
      if (r == 1) {
        sum = a * n;
      } else {
        sum = a * (1 - math.pow(r, n)) / (1 - r);
      }
      for (int i = 0; i < n && i < 10; i++) {
        terms.add(a * math.pow(r, i));
      }
    }
    
    setState(() {
      _sum = sum;
      _nthTerm = nthTerm;
      _terms = terms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summation Calculator'),
        actions: const [PinButton(route: '/math/summation')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Arithmetic', label: Text('Arithmetic')),
                ButtonSegment(value: 'Geometric', label: Text('Geometric')),
              ],
              selected: {_seriesType},
              onSelectionChanged: (v) {
                setState(() => _seriesType = v.first);
                _calculate();
              },
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _firstTermController,
              decoration: const InputDecoration(
                labelText: 'First Term (a)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commonDiffController,
              decoration: InputDecoration(
                labelText: _seriesType == 'Arithmetic' 
                    ? 'Common Difference (d)' 
                    : 'Common Ratio (r)',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _numTermsController,
              decoration: const InputDecoration(
                labelText: 'Number of Terms (n)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            if (_sum != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text('Sum of Series', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        _formatNumber(_sum!),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Last Term'),
                          Text(_formatNumber(_nthTerm!), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('First ${_terms!.length} terms:', style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _terms!.map((t) => Chip(label: Text(_formatNumber(t)))).toList(),
                      ),
                      if (int.tryParse(_numTermsController.text)! > 10)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('...', style: TextStyle(fontSize: 24)),
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
    if (n == n.roundToDouble()) {
      return n.toInt().toString();
    }
    return n.toStringAsFixed(4);
  }
}
