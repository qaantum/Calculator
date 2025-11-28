import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SalaryCalculator extends ConsumerStatefulWidget {
  const SalaryCalculator({super.key});

  @override
  ConsumerState<SalaryCalculator> createState() => _SalaryCalculatorState();
}

class _SalaryCalculatorState extends ConsumerState<SalaryCalculator> {
  final _amountController = TextEditingController();
  final _hoursController = TextEditingController(text: '40');
  final _daysController = TextEditingController(text: '5');
  String _frequency = 'Annual';

  Map<String, double> _results = {};

  void _calculate() {
    if (_amountController.text.isEmpty) return;

    final amount = double.parse(_amountController.text);
    final hoursPerWeek = double.parse(_hoursController.text);
    final daysPerWeek = double.parse(_daysController.text);

    double annual;
    switch (_frequency) {
      case 'Annual':
        annual = amount;
        break;
      case 'Monthly':
        annual = amount * 12;
        break;
      case 'Bi-Weekly':
        annual = amount * 26;
        break;
      case 'Weekly':
        annual = amount * 52;
        break;
      case 'Daily':
        annual = amount * daysPerWeek * 52;
        break;
      case 'Hourly':
        annual = amount * hoursPerWeek * 52;
        break;
      default:
        annual = 0;
    }

    setState(() {
      _results = {
        'Annual': annual,
        'Monthly': annual / 12,
        'Bi-Weekly': annual / 26,
        'Weekly': annual / 52,
        'Daily': annual / 52 / daysPerWeek,
        'Hourly': annual / 52 / hoursPerWeek,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency();

    return Scaffold(
      appBar: AppBar(title: const Text('Salary Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: _frequency,
                    decoration: const InputDecoration(
                      labelText: 'Frequency',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Annual', child: Text('Year')),
                      DropdownMenuItem(value: 'Monthly', child: Text('Month')),
                      DropdownMenuItem(value: 'Bi-Weekly', child: Text('2 Weeks')),
                      DropdownMenuItem(value: 'Weekly', child: Text('Week')),
                      DropdownMenuItem(value: 'Daily', child: Text('Day')),
                      DropdownMenuItem(value: 'Hourly', child: Text('Hour')),
                    ],
                    onChanged: (value) {
                      setState(() => _frequency = value!);
                      _calculate();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _hoursController,
                    decoration: const InputDecoration(
                      labelText: 'Hours / Week',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _daysController,
                    decoration: const InputDecoration(
                      labelText: 'Days / Week',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (_results.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: _results.entries.map((e) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key, style: Theme.of(context).textTheme.bodyLarge),
                              Text(
                                currencyFormat.format(e.value),
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
