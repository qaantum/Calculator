import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'logic/mortgage_logic.dart';

import '../../ui/widgets/pin_button.dart';

class MortgageCalculator extends ConsumerStatefulWidget {
  const MortgageCalculator({super.key});

  @override
  ConsumerState<MortgageCalculator> createState() => _MortgageCalculatorState();
}

class _MortgageCalculatorState extends ConsumerState<MortgageCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _principalController = TextEditingController();
  final _rateController = TextEditingController();
  final _termController = TextEditingController(text: '30');
  final _taxController = TextEditingController(text: '0');
  final _insuranceController = TextEditingController(text: '0');
  final _hoaController = TextEditingController(text: '0');

  double? _monthlyPrincipalAndInterest;
  double? _monthlyTax;
  double? _monthlyInsurance;
  double? _monthlyHOA;
  double? _totalMonthlyPayment;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final principal = double.parse(_principalController.text);
      final rate = double.parse(_rateController.text);
      final termYears = int.parse(_termController.text);
      final yearlyTax = double.parse(_taxController.text);
      final yearlyInsurance = double.parse(_insuranceController.text);
      final monthlyHOA = double.parse(_hoaController.text);

      final monthlyPI = MortgageLogic.calculateMonthlyPayment(
        principal: principal,
        annualRate: rate,
        termYears: termYears,
      );

      final totalMonthly = MortgageLogic.calculateTotalMonthlyPayment(
        principalAndInterest: monthlyPI,
        annualPropertyTax: yearlyTax,
        annualInsurance: yearlyInsurance,
        monthlyHOA: monthlyHOA,
      );

      setState(() {
        _monthlyPrincipalAndInterest = monthlyPI;
        _monthlyTax = yearlyTax / 12;
        _monthlyInsurance = yearlyInsurance / 12;
        _monthlyHOA = monthlyHOA;
        _totalMonthlyPayment = totalMonthly;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mortgage Calculator'),
        actions: const [
          PinButton(route: '/finance/mortgage'),
        ],
      ),
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
                  labelText: 'Loan Amount',
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
                        labelText: 'Term (Years)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Optional Expenses', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _taxController,
                      decoration: const InputDecoration(
                        labelText: 'Property Tax / Year',
                        prefixText: '\$',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _insuranceController,
                      decoration: const InputDecoration(
                        labelText: 'Insurance / Year',
                        prefixText: '\$',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hoaController,
                decoration: const InputDecoration(
                  labelText: 'HOA Fees / Month',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _calculate,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Calculate Payment'),
                ),
              ),
              if (_totalMonthlyPayment != null) ...[
                const SizedBox(height: 32),
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('Total Monthly Payment', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          currencyFormat.format(_totalMonthlyPayment),
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                        const Divider(height: 32),
                        _buildResultRow('Principal & Interest', _monthlyPrincipalAndInterest!, currencyFormat),
                        _buildResultRow('Property Tax', _monthlyTax!, currencyFormat),
                        _buildResultRow('Home Insurance', _monthlyInsurance!, currencyFormat),
                        _buildResultRow('HOA Fees', _monthlyHOA!, currencyFormat),
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
