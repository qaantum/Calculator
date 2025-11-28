import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AmortizationSchedule extends ConsumerStatefulWidget {
  const AmortizationSchedule({super.key});

  @override
  ConsumerState<AmortizationSchedule> createState() => _AmortizationScheduleState();
}

class _AmortizationScheduleState extends ConsumerState<AmortizationSchedule> {
  final _amountController = TextEditingController();
  final _rateController = TextEditingController();
  final _yearsController = TextEditingController();

  List<Map<String, dynamic>> _schedule = [];
  String? _monthlyPayment;
  String? _totalInterest;

  void _calculate() {
    final principal = double.tryParse(_amountController.text);
    final rate = double.tryParse(_rateController.text);
    final years = double.tryParse(_yearsController.text);

    if (principal == null || rate == null || years == null) return;

    final r = rate / 100 / 12;
    final n = (years * 12).round();

    final monthlyPayment = (principal * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);

    double balance = principal;
    double totalInterest = 0;
    List<Map<String, dynamic>> schedule = [];

    for (int i = 1; i <= n; i++) {
      final interest = balance * r;
      final principalPayment = monthlyPayment - interest;
      balance -= principalPayment;
      if (balance < 0) balance = 0;
      totalInterest += interest;

      schedule.add({
        'month': i,
        'payment': monthlyPayment,
        'principal': principalPayment,
        'interest': interest,
        'balance': balance,
      });
    }

    final currency = NumberFormat.simpleCurrency();

    setState(() {
      _schedule = schedule;
      _monthlyPayment = currency.format(monthlyPayment);
      _totalInterest = currency.format(totalInterest);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Amortization Schedule')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        decoration: const InputDecoration(labelText: 'Loan Amount', prefixText: '\$'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _rateController,
                        decoration: const InputDecoration(labelText: 'Rate (%)', suffixText: '%'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _yearsController,
                        decoration: const InputDecoration(labelText: 'Years'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton(onPressed: _calculate, child: const Text('Generate Schedule')),
              ],
            ),
          ),
          if (_monthlyPayment != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('Monthly Payment'),
                      Text(_monthlyPayment!, style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Total Interest'),
                      Text(_totalInterest!, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red)),
                    ],
                  ),
                ],
              ),
            ),
          const Divider(),
          if (_schedule.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Month')),
                      DataColumn(label: Text('Payment')),
                      DataColumn(label: Text('Principal')),
                      DataColumn(label: Text('Interest')),
                      DataColumn(label: Text('Balance')),
                    ],
                    rows: _schedule.map((row) {
                      final currency = NumberFormat.simpleCurrency();
                      return DataRow(cells: [
                        DataCell(Text(row['month'].toString())),
                        DataCell(Text(currency.format(row['payment']))),
                        DataCell(Text(currency.format(row['principal']))),
                        DataCell(Text(currency.format(row['interest']))),
                        DataCell(Text(currency.format(row['balance']))),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
