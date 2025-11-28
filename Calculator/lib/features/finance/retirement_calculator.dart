import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RetirementCalculator extends ConsumerStatefulWidget {
  const RetirementCalculator({super.key});

  @override
  ConsumerState<RetirementCalculator> createState() => _RetirementCalculatorState();
}

class _RetirementCalculatorState extends ConsumerState<RetirementCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _currentAgeController = TextEditingController();
  final _retireAgeController = TextEditingController(text: '65');
  final _savingsController = TextEditingController(text: '0');
  final _contributionController = TextEditingController();
  final _rateController = TextEditingController(text: '7');

  double? _totalSavings;
  double? _monthlyIncome;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final currentAge = int.parse(_currentAgeController.text);
      final retireAge = int.parse(_retireAgeController.text);
      final savings = double.parse(_savingsController.text);
      final contribution = double.parse(_contributionController.text);
      final rate = double.parse(_rateController.text) / 100 / 12;

      final years = retireAge - currentAge;
      final months = years * 12;

      if (months <= 0) return;

      // FV of Initial Savings
      final fvSavings = savings * pow(1 + rate, months);

      // FV of Contributions
      final fvContributions = contribution * (pow(1 + rate, months) - 1) / rate;

      final total = fvSavings + fvContributions;
      // 4% Rule for safe withdrawal rate (annual) -> monthly
      final monthlyIncome = (total * 0.04) / 12;

      setState(() {
        _totalSavings = total;
        _monthlyIncome = monthlyIncome;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency();

    return Scaffold(
      appBar: AppBar(title: const Text('Retirement Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _currentAgeController,
                      decoration: const InputDecoration(
                        labelText: 'Current Age',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _retireAgeController,
                      decoration: const InputDecoration(
                        labelText: 'Retirement Age',
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
                controller: _savingsController,
                decoration: const InputDecoration(
                  labelText: 'Current Savings',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contributionController,
                decoration: const InputDecoration(
                  labelText: 'Monthly Contribution',
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
                  labelText: 'Expected Annual Return',
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
              if (_totalSavings != null) ...[
                const SizedBox(height: 32),
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('Total at Retirement', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          currencyFormat.format(_totalSavings),
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                        const Divider(height: 32),
                        Text('Est. Monthly Income (4% Rule)', style: Theme.of(context).textTheme.titleSmall),
                        Text(
                          currencyFormat.format(_monthlyIncome),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
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
