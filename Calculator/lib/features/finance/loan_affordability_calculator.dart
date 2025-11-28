import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoanAffordabilityCalculator extends StatefulWidget {
  const LoanAffordabilityCalculator({super.key});

  @override
  State<LoanAffordabilityCalculator> createState() => _LoanAffordabilityCalculatorState();
}

class _LoanAffordabilityCalculatorState extends State<LoanAffordabilityCalculator> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _paymentController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();

  double? _affordableLoanAmount;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final payment = double.parse(_paymentController.text);
      final rate = double.parse(_rateController.text) / 100 / 12;
      final months = double.parse(_yearsController.text) * 12;

      if (rate == 0) {
        setState(() {
          _affordableLoanAmount = payment * months;
        });
      } else {
        // PV = PMT * (1 - (1 + r)^-n) / r
        final pv = payment * (1 - pow(1 + rate, -months)) / rate;
        setState(() {
          _affordableLoanAmount = pv;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Affordability'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _paymentController,
                        decoration: const InputDecoration(
                          labelText: 'Monthly Payment',
                          prefixIcon: Icon(FontAwesomeIcons.dollarSign),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty ? 'Please enter amount' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _rateController,
                        decoration: const InputDecoration(
                          labelText: 'Interest Rate (%)',
                          prefixIcon: Icon(FontAwesomeIcons.percent),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty ? 'Please enter rate' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _yearsController,
                        decoration: const InputDecoration(
                          labelText: 'Loan Term (Years)',
                          prefixIcon: Icon(FontAwesomeIcons.calendarDays),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty ? 'Please enter years' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _calculate,
                          icon: const Icon(FontAwesomeIcons.calculator),
                          label: const Text('Calculate'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_affordableLoanAmount != null) ...[
                const SizedBox(height: 24),
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          'You can afford a loan of',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${_affordableLoanAmount!.toStringAsFixed(2)}',
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
      ),
    );
  }
}
