import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CompoundInterestCalculator extends ConsumerStatefulWidget {
  const CompoundInterestCalculator({super.key});

  @override
  ConsumerState<CompoundInterestCalculator> createState() => _CompoundInterestCalculatorState();
}

class _CompoundInterestCalculatorState extends ConsumerState<CompoundInterestCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _principalController = TextEditingController();
  final _rateController = TextEditingController();
  final _timeController = TextEditingController();
  final _contributionController = TextEditingController(text: '0');
  String _frequency = '12'; // Monthly by default

  double? _futureValue;
  double? _totalInterest;
  double? _totalContributions;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final principal = double.parse(_principalController.text);
      final rate = double.parse(_rateController.text) / 100;
      final years = double.parse(_timeController.text);
      final contribution = double.parse(_contributionController.text);
      final n = double.parse(_frequency); // Compounds per year

      // Future Value of Principal: P(1 + r/n)^(nt)
      final fvPrincipal = principal * pow(1 + rate / n, n * years);

      // Future Value of Series (Contributions): PMT * [((1 + r/n)^(nt) - 1) / (r/n)]
      double fvContributions = 0;
      if (rate > 0) {
        fvContributions = contribution * (pow(1 + rate / n, n * years) - 1) / (rate / n);
      } else {
        fvContributions = contribution * n * years;
      }

      final total = fvPrincipal + fvContributions;
      final totalContributed = principal + (contribution * n * years);

      setState(() {
        _futureValue = total;
        _totalContributions = totalContributed;
        _totalInterest = total - totalContributed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency();

    return Scaffold(
      appBar: AppBar(title: const Text('Compound Interest')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _principalController,
                decoration: const InputDecoration(
                  labelText: 'Initial Investment',
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _contributionController,
                decoration: const InputDecoration(
                  labelText: 'Monthly Contribution',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _frequency,
                decoration: const InputDecoration(
                  labelText: 'Compounding Frequency',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: '1', child: Text('Annually')),
                  DropdownMenuItem(value: '2', child: Text('Semi-Annually')),
                  DropdownMenuItem(value: '4', child: Text('Quarterly')),
                  DropdownMenuItem(value: '12', child: Text('Monthly')),
                  DropdownMenuItem(value: '365', child: Text('Daily')),
                ],
                onChanged: (value) => setState(() => _frequency = value!),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _calculate,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Calculate'),
                ),
              ),
              if (_futureValue != null) ...[
                const SizedBox(height: 32),
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('Future Value', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          currencyFormat.format(_futureValue),
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                              ),
                        ),
                        const Divider(height: 32),
                        _buildResultRow('Total Contributions', _totalContributions!, currencyFormat),
                        _buildResultRow('Total Interest', _totalInterest!, currencyFormat),
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
