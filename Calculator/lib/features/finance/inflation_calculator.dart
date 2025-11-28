import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class InflationCalculator extends ConsumerStatefulWidget {
  const InflationCalculator({super.key});

  @override
  ConsumerState<InflationCalculator> createState() => _InflationCalculatorState();
}

class _InflationCalculatorState extends ConsumerState<InflationCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _rateController = TextEditingController();
  final _yearsController = TextEditingController();

  String? _futureValue;
  String? _purchasingPower;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final rate = double.parse(_rateController.text) / 100;
      final years = double.parse(_yearsController.text);

      // Future cost of same goods
      final futureCost = amount * pow(1 + rate, years);
      
      // Purchasing power of current amount in future
      final futurePower = amount / pow(1 + rate, years);

      final currency = NumberFormat.simpleCurrency();

      setState(() {
        _futureValue = currency.format(futureCost);
        _purchasingPower = currency.format(futurePower);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inflation Calculator')),
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
                  labelText: 'Current Amount',
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
                  labelText: 'Inflation Rate (%)',
                  suffixText: '%',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearsController,
                decoration: const InputDecoration(
                  labelText: 'Years',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _calculate,
                child: const Padding(padding: EdgeInsets.all(16.0), child: Text('Calculate')),
              ),
              if (_futureValue != null) ...[
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Future Value', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          _futureValue!,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 4),
                        const Text('Cost of same goods in future'),
                        const Divider(height: 32),
                        Text('Purchasing Power', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          _purchasingPower!,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                        const SizedBox(height: 4),
                        const Text('Value of current money in future'),
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
