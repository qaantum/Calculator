import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ElectricityCostCalculator extends ConsumerStatefulWidget {
  const ElectricityCostCalculator({super.key});

  @override
  ConsumerState<ElectricityCostCalculator> createState() => _ElectricityCostCalculatorState();
}

class _ElectricityCostCalculatorState extends ConsumerState<ElectricityCostCalculator> {
  final _wattsController = TextEditingController();
  final _hoursController = TextEditingController();
  final _rateController = TextEditingController(); // Cents per kWh

  String _dailyCost = '---';
  String _monthlyCost = '---';
  String _yearlyCost = '---';

  void _calculate() {
    // Strip non-numeric characters just in case
    final wattsText = _wattsController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final hoursText = _hoursController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final rateText = _rateController.text.replaceAll(RegExp(r'[^0-9.]'), '');

    final watts = double.tryParse(wattsText);
    final hours = double.tryParse(hoursText);
    final rateCents = double.tryParse(rateText);

    if (watts == null || hours == null || rateCents == null) {
      setState(() {
        _dailyCost = '---';
        _monthlyCost = '---';
        _yearlyCost = '---';
      });
      return;
    }

    final kWhPerDay = (watts * hours) / 1000;
    final costPerDay = kWhPerDay * (rateCents / 100);
    final costPerMonth = costPerDay * 30;
    final costPerYear = costPerDay * 365;

    final currency = NumberFormat.simpleCurrency();

    setState(() {
      _dailyCost = currency.format(costPerDay);
      _monthlyCost = currency.format(costPerMonth);
      _yearlyCost = currency.format(costPerYear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Electricity Cost')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _wattsController,
              decoration: const InputDecoration(
                labelText: 'Power Consumption (Watts)',
                hintText: 'e.g. 100',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _hoursController,
              decoration: const InputDecoration(
                labelText: 'Hours Used Per Day',
                hintText: 'e.g. 5',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rateController,
              decoration: const InputDecoration(
                labelText: 'Electricity Rate (Cents/kWh)',
                hintText: 'e.g. 12',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'Results update automatically',
                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    _buildResultRow(context, 'Daily Cost', _dailyCost),
                    const Divider(),
                    _buildResultRow(context, 'Monthly Cost', _monthlyCost),
                    const Divider(),
                    _buildResultRow(context, 'Yearly Cost', _yearlyCost, isBold: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(BuildContext context, String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: isBold ? Theme.of(context).colorScheme.onSecondaryContainer : null,
                ),
          ),
        ],
      ),
    );
  }
}
