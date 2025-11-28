import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkHoursCalculator extends ConsumerStatefulWidget {
  const WorkHoursCalculator({super.key});

  @override
  ConsumerState<WorkHoursCalculator> createState() => _WorkHoursCalculatorState();
}

class _WorkHoursCalculatorState extends ConsumerState<WorkHoursCalculator> {
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);
  final _breakController = TextEditingController(text: '30'); // minutes

  String? _totalHours;

  void _calculate() {
    final start = _startTime.hour * 60 + _startTime.minute;
    final end = _endTime.hour * 60 + _endTime.minute;
    final breakTime = int.tryParse(_breakController.text) ?? 0;

    int diff = end - start;
    if (diff < 0) diff += 24 * 60; // Assume overnight shift

    final workedMinutes = diff - breakTime;
    final h = workedMinutes ~/ 60;
    final m = workedMinutes % 60;

    setState(() {
      _totalHours = '${h}h ${m}m';
    });
  }

  Future<void> _selectTime(BuildContext context, Function(TimeOfDay) onSelected, TimeOfDay initial) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      setState(() {
        onSelected(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Work Hours Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTimeSelector(
              context,
              label: 'Start Time',
              time: _startTime,
              onTap: () => _selectTime(context, (t) => _startTime = t, _startTime),
            ),
            const SizedBox(height: 16),
            _buildTimeSelector(
              context,
              label: 'End Time',
              time: _endTime,
              onTap: () => _selectTime(context, (t) => _endTime = t, _endTime),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _breakController,
              decoration: const InputDecoration(
                labelText: 'Break Duration (minutes)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _calculate,
              child: const Padding(padding: EdgeInsets.all(16.0), child: Text('Calculate Hours')),
            ),
            if (_totalHours != null) ...[
              const SizedBox(height: 32),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text('Total Hours Worked', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        _totalHours!,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
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
    );
  }

  Widget _buildTimeSelector(BuildContext context, {required String label, required TimeOfDay time, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.access_time),
        ),
        child: Text(
          time.format(context),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
