import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RentalPropertyCalculator extends ConsumerStatefulWidget {
  const RentalPropertyCalculator({super.key});

  @override
  ConsumerState<RentalPropertyCalculator> createState() => _RentalPropertyCalculatorState();
}

class _RentalPropertyCalculatorState extends ConsumerState<RentalPropertyCalculator> {
  final _propertyValueController = TextEditingController();
  final _rentController = TextEditingController();
  final _expensesController = TextEditingController(); // Monthly
  final _mortgageController = TextEditingController(); // Monthly

  String _capRate = '---';
  String _cashFlow = '---';

  void _calculate() {
    final value = double.tryParse(_propertyValueController.text);
    final rent = double.tryParse(_rentController.text);
    final expenses = double.tryParse(_expensesController.text) ?? 0;
    final mortgage = double.tryParse(_mortgageController.text) ?? 0;

    if (value == null || rent == null || value == 0) {
      setState(() {
        _capRate = '---';
        _cashFlow = '---';
      });
      return;
    }

    // Annual calculations
    final annualRent = rent * 12;
    final annualExpenses = expenses * 12;
    final annualMortgage = mortgage * 12;

    // NOI = Annual Rent - Annual Operating Expenses (excluding mortgage)
    final noi = annualRent - annualExpenses;

    // Cap Rate = NOI / Property Value
    final capRate = (noi / value) * 100;

    // Cash Flow = NOI - Annual Mortgage
    final cashFlowAnnual = noi - annualMortgage;
    final cashFlowMonthly = cashFlowAnnual / 12;

    setState(() {
      _capRate = '${capRate.toStringAsFixed(2)}%';
      _cashFlow = '\$${cashFlowMonthly.toStringAsFixed(2)} / mo\n(\$${cashFlowAnnual.toStringAsFixed(2)} / yr)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rental Property Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Calculate Cap Rate and Cash Flow.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _propertyValueController,
              decoration: const InputDecoration(labelText: 'Property Value (\$)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rentController,
              decoration: const InputDecoration(labelText: 'Monthly Rent Income (\$)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _expensesController,
              decoration: const InputDecoration(labelText: 'Monthly Expenses (Excl. Mortgage) (\$)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _mortgageController,
              decoration: const InputDecoration(labelText: 'Monthly Mortgage Payment (\$)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.green.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Cap Rate', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _capRate,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(),
                    const Text('Cash Flow', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _cashFlow,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
