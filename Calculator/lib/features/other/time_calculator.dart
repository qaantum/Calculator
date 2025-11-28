import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeCalculator extends ConsumerStatefulWidget {
  const TimeCalculator({super.key});

  @override
  ConsumerState<TimeCalculator> createState() => _TimeCalculatorState();
}

class _TimeCalculatorState extends ConsumerState<TimeCalculator> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Tab 1: Difference
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);
  String? _difference;

  // Tab 2: Add/Subtract
  TimeOfDay _baseTime = const TimeOfDay(hour: 12, minute: 0);
  final _hoursController = TextEditingController(text: '0');
  final _minutesController = TextEditingController(text: '0');
  bool _isAdd = true;
  TimeOfDay? _resultTime;
  bool _nextDay = false;
  bool _prevDay = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _calculateDifference() {
    final start = _startTime.hour * 60 + _startTime.minute;
    final end = _endTime.hour * 60 + _endTime.minute;

    int diff = end - start;
    if (diff < 0) diff += 24 * 60; // Assume next day if end < start

    final h = diff ~/ 60;
    final m = diff % 60;

    setState(() {
      _difference = '${h}h ${m}m';
    });
  }

  void _calculateAddSubtract() {
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final totalMinutesToAdd = (hours * 60) + minutes;

    final base = _baseTime.hour * 60 + _baseTime.minute;
    int resultTotalMinutes;

    if (_isAdd) {
      resultTotalMinutes = base + totalMinutesToAdd;
    } else {
      resultTotalMinutes = base - totalMinutesToAdd;
    }

    // Handle day overflow/underflow
    bool next = false;
    bool prev = false;
    
    if (resultTotalMinutes >= 24 * 60) {
      next = true;
      resultTotalMinutes %= 24 * 60;
    } else if (resultTotalMinutes < 0) {
      prev = true;
      resultTotalMinutes = (resultTotalMinutes % (24 * 60));
      if (resultTotalMinutes < 0) resultTotalMinutes += 24 * 60; // Dart modulo can be negative
    }

    final h = resultTotalMinutes ~/ 60;
    final m = resultTotalMinutes % 60;

    setState(() {
      _resultTime = TimeOfDay(hour: h, minute: m);
      _nextDay = next;
      _prevDay = prev;
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
      appBar: AppBar(
        title: const Text('Time Calculator'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Difference'),
            Tab(text: 'Add / Subtract'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDifferenceTab(),
          _buildAddSubtractTab(),
        ],
      ),
    );
  }

  Widget _buildDifferenceTab() {
    return SingleChildScrollView(
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
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _calculateDifference,
            child: const Padding(padding: EdgeInsets.all(16.0), child: Text('Calculate Duration')),
          ),
          if (_difference != null) ...[
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text('Duration', style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      _difference!,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddSubtractTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimeSelector(
            context,
            label: 'Start Time',
            time: _baseTime,
            onTap: () => _selectTime(context, (t) => _baseTime = t, _baseTime),
          ),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Add')),
              ButtonSegment(value: false, label: Text('Subtract')),
            ],
            selected: {_isAdd},
            onSelectionChanged: (Set<bool> newSelection) {
              setState(() => _isAdd = newSelection.first);
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _hoursController,
                  decoration: const InputDecoration(labelText: 'Hours', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _minutesController,
                  decoration: const InputDecoration(labelText: 'Minutes', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _calculateAddSubtract,
            child: const Padding(padding: EdgeInsets.all(16.0), child: Text('Calculate Time')),
          ),
          if (_resultTime != null) ...[
            const SizedBox(height: 32),
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text('Result Time', style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      _resultTime!.format(context),
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onTertiaryContainer,
                          ),
                    ),
                    if (_nextDay)
                      Text('(Next Day)', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    if (_prevDay)
                      Text('(Previous Day)', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ],
                ),
              ),
            ),
          ],
        ],
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
