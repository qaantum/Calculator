import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class SleepCalculator extends StatefulWidget {
  const SleepCalculator({super.key});

  @override
  State<SleepCalculator> createState() => _SleepCalculatorState();
}

class _SleepCalculatorState extends State<SleepCalculator> {
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);
  List<DateTime> _bedtimes = [];

  void _calculateBedtimes() {
    final now = DateTime.now();
    final wakeDateTime = DateTime(now.year, now.month, now.day, _wakeTime.hour, _wakeTime.minute);
    
    // Add 24h if wake time is earlier than now (assuming next day) - simplified logic for display
    // Actually we just want to subtract 90min cycles from the wake time.
    
    // Cycles: 6 (9h), 5 (7.5h), 4 (6h), 3 (4.5h)
    final cycles = [6, 5, 4, 3];
    final times = <DateTime>[];

    for (final cycle in cycles) {
      // 90 mins * cycle + 15 mins to fall asleep
      final duration = Duration(minutes: 90 * cycle + 15);
      times.add(wakeDateTime.subtract(duration));
    }

    setState(() {
      _bedtimes = times;
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _wakeTime,
    );
    if (picked != null && picked != _wakeTime) {
      setState(() {
        _wakeTime = picked;
        _bedtimes = []; // Reset results
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Calculator'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('I want to wake up at:', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _selectTime(context),
                      child: Text(
                        _wakeTime.format(context),
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _calculateBedtimes,
                        icon: const Icon(FontAwesomeIcons.bed),
                        label: const Text('Calculate Bedtime'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_bedtimes.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text('You should try to fall asleep at one of these times:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _bedtimes.length,
                  itemBuilder: (context, index) {
                    final time = _bedtimes[index];
                    final cycles = 6 - index;
                    return Card(
                      color: index == 1 ? Theme.of(context).colorScheme.primaryContainer : null, // Highlight 5 cycles (7.5h)
                      child: ListTile(
                        leading: const Icon(FontAwesomeIcons.moon),
                        title: Text(
                          DateFormat.jm().format(time),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('$cycles sleep cycles (${cycles * 1.5} hours)'),
                        trailing: index == 1 ? const Icon(FontAwesomeIcons.check) : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
