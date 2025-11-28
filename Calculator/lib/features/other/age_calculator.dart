import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AgeCalculator extends ConsumerStatefulWidget {
  const AgeCalculator({super.key});

  @override
  ConsumerState<AgeCalculator> createState() => _AgeCalculatorState();
}

class _AgeCalculatorState extends ConsumerState<AgeCalculator> {
  DateTime? _birthDate;
  DateTime _targetDate = DateTime.now();

  Map<String, int>? _age;
  Map<String, int>? _nextBirthday;

  void _calculate() {
    if (_birthDate == null) return;

    final birth = _birthDate!;
    final target = _targetDate;

    int years = target.year - birth.year;
    int months = target.month - birth.month;
    int days = target.day - birth.day;

    if (days < 0) {
      months--;
      final daysInLastMonth = DateTime(target.year, target.month, 0).day;
      days += daysInLastMonth;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    // Next Birthday
    DateTime nextBirthday = DateTime(target.year, birth.month, birth.day);
    if (nextBirthday.isBefore(target) || nextBirthday.isAtSameMomentAs(target)) {
      nextBirthday = DateTime(target.year + 1, birth.month, birth.day);
    }

    final diff = nextBirthday.difference(target);
    final nextDays = diff.inDays;
    final nextMonths = (nextDays / 30).floor(); // Approximation
    final remainingDays = nextDays % 30;

    setState(() {
      _age = {'years': years, 'months': months, 'days': days};
      _nextBirthday = {'months': nextMonths, 'days': remainingDays};
    });
  }

  Future<void> _selectDate(BuildContext context, bool isBirthDate) async {
    final initialDate = isBirthDate ? (_birthDate ?? DateTime(2000)) : _targetDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isBirthDate) {
          _birthDate = picked;
        } else {
          _targetDate = picked;
        }
      });
      _calculate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMMd();

    return Scaffold(
      appBar: AppBar(title: const Text('Age Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDateSelector(
              context,
              label: 'Date of Birth',
              date: _birthDate,
              onTap: () => _selectDate(context, true),
            ),
            const SizedBox(height: 16),
            _buildDateSelector(
              context,
              label: 'Age at Date',
              date: _targetDate,
              onTap: () => _selectDate(context, false),
            ),
            const SizedBox(height: 32),
            if (_age != null) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text('Age', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildAgeItem(context, _age!['years']!, 'Years'),
                          _buildAgeItem(context, _age!['months']!, 'Months'),
                          _buildAgeItem(context, _age!['days']!, 'Days'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Next Birthday', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        '${_nextBirthday!['months']} months, ${_nextBirthday!['days']} days',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateFormat.format(DateTime(
                          _targetDate.year + (_targetDate.month > _birthDate!.month || (_targetDate.month == _birthDate!.month && _targetDate.day >= _birthDate!.day) ? 1 : 0),
                          _birthDate!.month,
                          _birthDate!.day,
                        )),
                        style: Theme.of(context).textTheme.bodySmall,
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

  Widget _buildDateSelector(BuildContext context, {required String label, required DateTime? date, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          date != null ? DateFormat.yMMMMd().format(date) : 'Select Date',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildAgeItem(BuildContext context, int value, String label) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
