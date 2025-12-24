import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class CountdownCalculator extends ConsumerStatefulWidget {
  const CountdownCalculator({super.key});

  @override
  ConsumerState<CountdownCalculator> createState() => _CountdownCalculatorState();
}

class _CountdownCalculatorState extends ConsumerState<CountdownCalculator> {
  DateTime? _targetDate;
  Timer? _timer;
  Duration _remaining = Duration.zero;
  final _eventNameController = TextEditingController(text: 'My Event');

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );

    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      setState(() {
        _targetDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time?.hour ?? 0,
          time?.minute ?? 0,
        );
        _startTimer();
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  void _updateRemaining() {
    if (_targetDate == null) return;
    final now = DateTime.now();
    setState(() {
      _remaining = _targetDate!.difference(now);
      if (_remaining.isNegative) {
        _remaining = Duration.zero;
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    return Scaffold(
      appBar: AppBar(title: const Text('Countdown Timer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Count down to any event or date.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _eventNameController,
              decoration: const InputDecoration(
                labelText: 'Event Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(_targetDate == null
                  ? 'Select Target Date'
                  : '${_targetDate!.day}/${_targetDate!.month}/${_targetDate!.year} ${_targetDate!.hour}:${_targetDate!.minute.toString().padLeft(2, '0')}'),
              subtitle: const Text('Tap to select date and time'),
              trailing: const Icon(Icons.calendar_today),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              onTap: _selectDate,
            ),
            const SizedBox(height: 32),
            if (_targetDate != null) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        _eventNameController.text.isEmpty ? 'Countdown' : _eventNameController.text,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTimeUnit(days, 'Days'),
                          _buildTimeUnit(hours, 'Hours'),
                          _buildTimeUnit(minutes, 'Mins'),
                          _buildTimeUnit(seconds, 'Secs'),
                        ],
                      ),
                      if (_remaining == Duration.zero && _targetDate!.isBefore(DateTime.now())) ...[
                        const SizedBox(height: 16),
                        const Text('🎉 Event has passed!', style: TextStyle(fontSize: 16)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Summary:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Total: ${_remaining.inDays} days, ${_remaining.inHours % 24} hrs, ${_remaining.inMinutes % 60} mins'),
                      Text('In hours: ${_remaining.inHours}'),
                      Text('In minutes: ${_remaining.inMinutes}'),
                      Text('In seconds: ${_remaining.inSeconds}'),
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

  Widget _buildTimeUnit(int value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
