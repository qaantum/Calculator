import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DueDateCalculator extends ConsumerStatefulWidget {
  const DueDateCalculator({super.key});

  @override
  ConsumerState<DueDateCalculator> createState() => _DueDateCalculatorState();
}

class _DueDateCalculatorState extends ConsumerState<DueDateCalculator> {
  DateTime? _lastPeriodDate;
  DateTime? _dueDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _lastPeriodDate) {
      setState(() {
        _lastPeriodDate = picked;
        _dueDate = picked.add(const Duration(days: 280));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMMd();

    return Scaffold(
      appBar: AppBar(title: const Text('Pregnancy Due Date')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select the first day of your last menstrual period:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _selectDate(context),
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _lastPeriodDate == null ? 'Select Date' : dateFormat.format(_lastPeriodDate!),
                style: const TextStyle(fontSize: 18),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(24),
              ),
            ),
            if (_dueDate != null) ...[
              const SizedBox(height: 48),
              Card(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Text('Estimated Due Date', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),
                      Text(
                        dateFormat.format(_dueDate!),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onTertiaryContainer,
                            ),
                        textAlign: TextAlign.center,
                      ),
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
}
