import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class InvestmentGrowthCalculator extends ConsumerStatefulWidget {
  const InvestmentGrowthCalculator({super.key});

  @override
  ConsumerState<InvestmentGrowthCalculator> createState() => _InvestmentGrowthCalculatorState();
}

class _InvestmentGrowthCalculatorState extends ConsumerState<InvestmentGrowthCalculator> {
  final _initialController = TextEditingController();
  final _contributionController = TextEditingController();
  final _rateController = TextEditingController();
  final _yearsController = TextEditingController();

  String? _totalValue;
  String? _totalContributions;
  String? _totalInterest;

  void _calculate() {
    final initial = double.tryParse(_initialController.text) ?? 0;
    final contribution = double.tryParse(_contributionController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    final years = double.tryParse(_yearsController.text) ?? 0;

    final r = rate / 100;
    final n = 12; // Monthly contributions
    final t = years;

    // Future Value of Initial Amount: P * (1 + r/n)^(nt)
    final fvInitial = initial * pow(1 + r / n, n * t);

    // Future Value of Contributions: PMT * ((1 + r/n)^(nt) - 1) / (r/n)
    double fvContributions = 0;
    if (r != 0) {
      fvContributions = contribution * (pow(1 + r / n, n * t) - 1) / (r / n);
    } else {
      fvContributions = contribution * n * t;
    }

    final totalValue = fvInitial + fvContributions;
    final totalContributed = initial + (contribution * n * t);
    final totalInterest = totalValue - totalContributed;

    final currency = NumberFormat.simpleCurrency();

    setState(() {
      _totalValue = currency.format(totalValue);
      _totalContributions = currency.format(totalContributed);
      _totalInterest = currency.format(totalInterest);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Investment Growth')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _initialController,
              decoration: const InputDecoration(
                labelText: 'Initial Amount',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contributionController,
              decoration: const InputDecoration(
                labelText: 'Monthly Contribution',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rateController,
              decoration: const InputDecoration(
                labelText: 'Annual Return Rate (%)',
                suffixText: '%',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _yearsController,
              decoration: const InputDecoration(
                labelText: 'Years to Grow',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            if (_totalValue != null) ...[
              const SizedBox(height: 32),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text('Future Value', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        _totalValue!,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                      ),
                      const Divider(height: 32),
                      _buildResultRow(context, 'Total Contributed', _totalContributions!),
                      _buildResultRow(context, 'Total Interest Earned', _totalInterest!),
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

  Widget _buildResultRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
