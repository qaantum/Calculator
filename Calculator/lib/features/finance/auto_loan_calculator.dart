import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AutoLoanCalculator extends ConsumerStatefulWidget {
  const AutoLoanCalculator({super.key});

  @override
  ConsumerState<AutoLoanCalculator> createState() => _AutoLoanCalculatorState();
}

class _AutoLoanCalculatorState extends ConsumerState<AutoLoanCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _downPaymentController = TextEditingController(text: '0');
  final _tradeInController = TextEditingController(text: '0');
  final _rateController = TextEditingController();
  final _termController = TextEditingController(text: '60');
  final _taxController = TextEditingController(text: '0');

  double? _monthlyPayment;
  double? _totalInterest;
  double? _totalCost;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final price = double.parse(_priceController.text);
      final downPayment = double.parse(_downPaymentController.text);
      final tradeIn = double.parse(_tradeInController.text);
      final rate = double.parse(_rateController.text) / 100 / 12;
      final termMonths = int.parse(_termController.text);
      final taxRate = double.parse(_taxController.text) / 100;

      final taxableAmount = price - tradeIn; // Usually trade-in reduces taxable amount
      final salesTax = taxableAmount * taxRate;
      final loanAmount = price + salesTax - downPayment - tradeIn;

      if (loanAmount <= 0) {
        setState(() {
          _monthlyPayment = 0;
          _totalInterest = 0;
          _totalCost = 0;
        });
        return;
      }

      if (rate == 0) {
        setState(() {
          _monthlyPayment = loanAmount / termMonths;
          _totalInterest = 0;
          _totalCost = loanAmount;
        });
      } else {
        final monthlyPayment = loanAmount * (rate * pow(1 + rate, termMonths)) / (pow(1 + rate, termMonths) - 1);
        final totalPayment = monthlyPayment * termMonths;
        setState(() {
          _monthlyPayment = monthlyPayment;
          _totalInterest = totalPayment - loanAmount;
          _totalCost = totalPayment;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency();

    return Scaffold(
      appBar: AppBar(title: const Text('Auto Loan Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Price',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _downPaymentController,
                      decoration: const InputDecoration(
                        labelText: 'Down Payment',
                        prefixText: '\$',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _tradeInController,
                      decoration: const InputDecoration(
                        labelText: 'Trade-in Value',
                        prefixText: '\$',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rateController,
                      decoration: const InputDecoration(
                        labelText: 'Interest Rate',
                        suffixText: '%',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _termController,
                      decoration: const InputDecoration(
                        labelText: 'Term (Months)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _taxController,
                decoration: const InputDecoration(
                  labelText: 'Sales Tax',
                  suffixText: '%',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _calculate,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Calculate'),
                ),
              ),
              if (_monthlyPayment != null) ...[
                const SizedBox(height: 32),
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('Monthly Payment', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          currencyFormat.format(_monthlyPayment),
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                        const Divider(height: 32),
                        _buildResultRow('Total Interest', _totalInterest!, currencyFormat),
                        _buildResultRow('Total Cost', _totalCost!, currencyFormat),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, double amount, NumberFormat format) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(format.format(amount), style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
