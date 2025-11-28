import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class CreditCardPayoffCalculator extends ConsumerStatefulWidget {
  const CreditCardPayoffCalculator({super.key});

  @override
  ConsumerState<CreditCardPayoffCalculator> createState() => _CreditCardPayoffCalculatorState();
}

class _CreditCardPayoffCalculatorState extends ConsumerState<CreditCardPayoffCalculator> {
  final _balanceController = TextEditingController();
  final _rateController = TextEditingController();
  final _paymentController = TextEditingController();

  String _months = '---';
  String _totalInterest = '---';

  void _calculate() {
    final balance = double.tryParse(_balanceController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
    final rate = double.tryParse(_rateController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
    final payment = double.tryParse(_paymentController.text.replaceAll(RegExp(r'[^0-9.]'), ''));

    if (balance == null || rate == null || payment == null || payment == 0) {
      setState(() {
        _months = '---';
        _totalInterest = '---';
      });
      return;
    }

    // Monthly interest rate
    final i = (rate / 100) / 12;
    
    // Check if payment covers interest
    final minInterest = balance * i;
    if (payment <= minInterest) {
      setState(() {
        _months = 'Never';
        _totalInterest = 'Infinite';
      });
      return;
    }

    // N = -log(1 - (i * B) / P) / log(1 + i)
    final n = -log(1 - (i * balance) / payment) / log(1 + i);
    
    final totalPaid = n * payment;
    final totalInterest = totalPaid - balance;

    setState(() {
      _months = '${n.ceil()} months';
      _totalInterest = '\$${totalInterest.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Credit Card Payoff')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _balanceController,
              decoration: const InputDecoration(labelText: 'Card Balance', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rateController,
              decoration: const InputDecoration(labelText: 'Interest Rate (APR %)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _paymentController,
              decoration: const InputDecoration(labelText: 'Monthly Payment', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.red.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildResultRow('Time to Payoff', _months),
                    const Divider(),
                    _buildResultRow('Total Interest', _totalInterest),
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
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
    );
  }
}
