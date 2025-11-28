import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'logic/loan_logic.dart';

class LoanCalculator extends ConsumerStatefulWidget {
  const LoanCalculator({super.key});

  @override
  ConsumerState<LoanCalculator> createState() => _LoanCalculatorState();
}

class _LoanCalculatorState extends ConsumerState<LoanCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _rateController = TextEditingController();
  final _termController = TextEditingController();

  double? _monthlyPayment;
  double? _totalInterest;
  double? _totalCost;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final principal = double.parse(_amountController.text);
      final rate = double.parse(_rateController.text);
      final termMonths = int.parse(_termController.text);

      final result = LoanLogic.calculateLoan(
        principal: principal,
        annualRate: rate,
        termMonths: termMonths,
      );

      setState(() {
        _monthlyPayment = result['monthlyPayment'];
        _totalInterest = result['totalInterest'];
        _totalCost = result['totalCost'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency();

    return Scaffold(
      appBar: AppBar(title: const Text('Loan Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Loan Amount',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rateController,
                decoration: const InputDecoration(
                  labelText: 'Interest Rate',
                  suffixText: '%',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _termController,
                decoration: const InputDecoration(
                  labelText: 'Loan Term (Months)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
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
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('Monthly Payment', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          currencyFormat.format(_monthlyPayment),
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
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
