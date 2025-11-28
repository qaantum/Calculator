import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class TVMCalculator extends ConsumerStatefulWidget {
  const TVMCalculator({super.key});

  @override
  ConsumerState<TVMCalculator> createState() => _TVMCalculatorState();
}

class _TVMCalculatorState extends ConsumerState<TVMCalculator> {
  final _pvController = TextEditingController();
  final _fvController = TextEditingController();
  final _pmtController = TextEditingController();
  final _rateController = TextEditingController();
  final _periodsController = TextEditingController();

  String _result = '';

  // Simple TVM solver (solving for one missing variable)
  // Formula: PV + PMT * (1+r*type) * ((1-(1+r)^-n)/r) + FV * (1+r)^-n = 0
  // Simplified for this MVP:
  // FV = PV * (1+r)^n + PMT * ((1+r)^n - 1) / r
  
  void _calculate(String target) {
    double? pv = double.tryParse(_pvController.text);
    double? fv = double.tryParse(_fvController.text);
    double? pmt = double.tryParse(_pmtController.text);
    double? r = double.tryParse(_rateController.text); // Annual rate %
    double? n = double.tryParse(_periodsController.text);

    if (r != null) r = r / 100; // Convert to decimal

    // Assume annual compounding for simplicity in this MVP version
    // Or assume rate is per period if user enters it that way.
    // Let's assume Rate is per period for generic TVM.

    try {
      if (target == 'FV') {
        if (pv != null && pmt != null && r != null && n != null) {
          // FV = - (PV * (1+r)^n + PMT * ((1+r)^n - 1) / r)
          // Note: Standard TVM sign convention: Cash outflows are negative.
          // If user enters positive PV, it means they have money.
          // Let's stick to positive inputs for simplicity and handle signs internally or just output magnitude.
          
          final fvVal = pv * pow(1 + r, n) + pmt * (pow(1 + r, n) - 1) / r;
          setState(() {
            _fvController.text = fvVal.toStringAsFixed(2);
            _result = 'Calculated Future Value';
          });
        }
      } else if (target == 'PV') {
        if (fv != null && pmt != null && r != null && n != null) {
          // PV = (FV - PMT * ((1+r)^n - 1) / r) / (1+r)^n
          // Rearranging FV formula
          final pvVal = (fv - pmt * (pow(1 + r, n) - 1) / r) / pow(1 + r, n);
           setState(() {
            _pvController.text = pvVal.toStringAsFixed(2);
            _result = 'Calculated Present Value';
          });
        }
      }
      // Implementing PMT, Rate, N requires iterative solving or complex algebra.
      // For MVP, let's stick to PV and FV solving which are most common.
      else {
        setState(() {
          _result = 'Solving for $target is not supported in this version yet.';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TVM Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Time Value of Money (Simple)',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            _buildRow('Present Value (PV)', _pvController, 'PV'),
            _buildRow('Future Value (FV)', _fvController, 'FV'),
            _buildRow('Payment (PMT)', _pmtController, 'PMT'),
            _buildRow('Rate per Period (%)', _rateController, 'Rate'),
            _buildRow('Number of Periods (N)', _periodsController, 'N'),
            const SizedBox(height: 16),
            Text(_result, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            const Text(
              'Note: Enter inputs as positive numbers. Currently solves for PV or FV.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, TextEditingController controller, String target) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          const SizedBox(width: 8),
          if (target == 'PV' || target == 'FV')
            ElevatedButton(
              onPressed: () => _calculate(target),
              child: Text('Solve $target'),
            ),
        ],
      ),
    );
  }
}
