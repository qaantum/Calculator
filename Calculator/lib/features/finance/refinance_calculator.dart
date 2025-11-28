import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RefinanceCalculator extends StatefulWidget {
  const RefinanceCalculator({super.key});

  @override
  State<RefinanceCalculator> createState() => _RefinanceCalculatorState();
}

class _RefinanceCalculatorState extends State<RefinanceCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _loanAmountController = TextEditingController();
  final _currentRateController = TextEditingController();
  final _currentTermController = TextEditingController();
  final _newRateController = TextEditingController();
  final _newTermController = TextEditingController();
  final _costController = TextEditingController(text: '0');

  double? _monthlySavings;
  double? _lifetimeSavings;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final loanAmount = double.parse(_loanAmountController.text);
      final currentRate = double.parse(_currentRateController.text) / 100 / 12;
      final currentMonths = double.parse(_currentTermController.text) * 12;
      final newRate = double.parse(_newRateController.text) / 100 / 12;
      final newMonths = double.parse(_newTermController.text) * 12;
      final cost = double.parse(_costController.text);

      // Current Loan Payment
      final currentPmt = currentRate == 0
          ? loanAmount / currentMonths
          : loanAmount * currentRate * pow(1 + currentRate, currentMonths) / (pow(1 + currentRate, currentMonths) - 1);

      // New Loan Payment
      final newPmt = newRate == 0
          ? loanAmount / newMonths
          : loanAmount * newRate * pow(1 + newRate, newMonths) / (pow(1 + newRate, newMonths) - 1);

      final monthlySavings = currentPmt - newPmt;
      final totalCurrentCost = currentPmt * currentMonths;
      final totalNewCost = (newPmt * newMonths) + cost;
      final lifetimeSavings = totalCurrentCost - totalNewCost;

      setState(() {
        _monthlySavings = monthlySavings;
        _lifetimeSavings = lifetimeSavings;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refinance Calculator'),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Current Loan', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _loanAmountController,
                        decoration: const InputDecoration(labelText: 'Loan Balance', prefixIcon: Icon(FontAwesomeIcons.dollarSign), border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _currentRateController,
                              decoration: const InputDecoration(labelText: 'Rate (%)', border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _currentTermController,
                              decoration: const InputDecoration(labelText: 'Term (Years)', border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      const Text('New Loan', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _newRateController,
                              decoration: const InputDecoration(labelText: 'Rate (%)', border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _newTermController,
                              decoration: const InputDecoration(labelText: 'Term (Years)', border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _costController,
                        decoration: const InputDecoration(labelText: 'Refinance Cost', prefixIcon: Icon(FontAwesomeIcons.dollarSign), border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _calculate,
                          icon: const Icon(FontAwesomeIcons.calculator),
                          label: const Text('Calculate Savings'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_monthlySavings != null) ...[
                const SizedBox(height: 24),
                Card(
                  color: _lifetimeSavings! >= 0 ? Colors.green.shade100 : Colors.red.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('Monthly Savings', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          '\$${_monthlySavings!.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text('Lifetime Savings', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          '\$${_lifetimeSavings!.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _lifetimeSavings! >= 0 ? Colors.green : Colors.red,
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
