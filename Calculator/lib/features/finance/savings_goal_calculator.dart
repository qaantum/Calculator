import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SavingsGoalCalculator extends ConsumerStatefulWidget {
  const SavingsGoalCalculator({super.key});

  @override
  ConsumerState<SavingsGoalCalculator> createState() => _SavingsGoalCalculatorState();
}

class _SavingsGoalCalculatorState extends ConsumerState<SavingsGoalCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _goalController = TextEditingController();
  final _initialController = TextEditingController(text: '0');
  final _rateController = TextEditingController();
  final _timeController = TextEditingController();

  double? _monthlyContribution;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final goal = double.parse(_goalController.text);
      final initial = double.parse(_initialController.text);
      final rate = double.parse(_rateController.text) / 100 / 12;
      final months = double.parse(_timeController.text) * 12;

      // Formula: PMT = (FV - PV * (1 + r)^n) * r / ((1 + r)^n - 1)
      double pmt;
      if (rate == 0) {
        pmt = (goal - initial) / months;
      } else {
        pmt = (goal - initial * pow(1 + rate, months)) * rate / (pow(1 + rate, months) - 1);
      }

      setState(() {
        _monthlyContribution = pmt > 0 ? pmt : 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency();

    return Scaffold(
      appBar: AppBar(title: const Text('Savings Goal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(
                  labelText: 'Savings Goal Amount',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _initialController,
                decoration: const InputDecoration(
                  labelText: 'Initial Savings',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rateController,
                decoration: const InputDecoration(
                  labelText: 'Annual Interest Rate',
                  suffixText: '%',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Time Period (Years)',
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
                  child: Text('Calculate Required Contribution'),
                ),
              ),
              if (_monthlyContribution != null) ...[
                const SizedBox(height: 32),
                Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('Required Monthly Savings', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          currencyFormat.format(_monthlyContribution),
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onTertiaryContainer,
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
      ),
    );
  }
}
