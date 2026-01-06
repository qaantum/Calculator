import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../ui/widgets/pin_button.dart';

class DownPaymentCalculator extends ConsumerStatefulWidget {
  const DownPaymentCalculator({super.key});

  @override
  ConsumerState<DownPaymentCalculator> createState() => _DownPaymentCalculatorState();
}

class _DownPaymentCalculatorState extends ConsumerState<DownPaymentCalculator> {
  final _purchasePriceController = TextEditingController();
  final _downPaymentPercentController = TextEditingController(text: '20');
  final _interestRateController = TextEditingController(text: '7');
  final _loanTermController = TextEditingController(text: '30');
  
  double? _downPaymentAmount;
  double? _loanAmount;
  double? _monthlyPayment;

  void _calculate() {
    final price = double.tryParse(_purchasePriceController.text);
    final downPercent = double.tryParse(_downPaymentPercentController.text);
    final rate = double.tryParse(_interestRateController.text);
    final years = int.tryParse(_loanTermController.text);
    
    if (price == null || downPercent == null || rate == null || years == null) return;
    
    final downPayment = price * (downPercent / 100);
    final loan = price - downPayment;
    
    // Monthly payment calculation
    final monthlyRate = rate / 100 / 12;
    final numPayments = years * 12;
    
    double monthly;
    if (monthlyRate == 0) {
      monthly = loan / numPayments;
    } else {
      monthly = loan * (monthlyRate * math.pow(1 + monthlyRate, numPayments)) /
          (math.pow(1 + monthlyRate, numPayments) - 1);
    }
    
    setState(() {
      _downPaymentAmount = downPayment;
      _loanAmount = loan;
      _monthlyPayment = monthly;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Down Payment Calculator'),
        actions: const [PinButton(route: '/finance/downpayment')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _purchasePriceController,
              decoration: const InputDecoration(
                labelText: 'Purchase Price',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _downPaymentPercentController,
              decoration: const InputDecoration(
                labelText: 'Down Payment',
                suffixText: '%',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _interestRateController,
                    decoration: const InputDecoration(
                      labelText: 'Interest Rate',
                      suffixText: '%',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _loanTermController,
                    decoration: const InputDecoration(
                      labelText: 'Loan Term',
                      suffixText: 'years',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            if (_downPaymentAmount != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildRow(context, 'Down Payment', currency.format(_downPaymentAmount)),
                      const Divider(height: 24),
                      _buildRow(context, 'Loan Amount', currency.format(_loanAmount)),
                      const Divider(height: 24),
                      Text('Monthly Payment', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        currency.format(_monthlyPayment),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
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
  
  Widget _buildRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
