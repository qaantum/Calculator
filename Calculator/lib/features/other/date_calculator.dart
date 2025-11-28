import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DateCalculator extends ConsumerStatefulWidget {
  const DateCalculator({super.key});

  @override
  ConsumerState<DateCalculator> createState() => _DateCalculatorState();
}

class _DateCalculatorState extends ConsumerState<DateCalculator> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Tab 1: Difference
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  Map<String, int>? _difference;

  // Tab 2: Add/Subtract
  DateTime _baseDate = DateTime.now();
  final _yearsController = TextEditingController(text: '0');
  final _monthsController = TextEditingController(text: '0');
  final _daysController = TextEditingController(text: '0');
  bool _isAdd = true;
  DateTime? _resultDate;

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
    final start = _startDate;
    final end = _endDate;

    final diff = end.difference(start);
    final days = diff.inDays.abs();
    
    // Approximate years/months/days
    int y = 0, m = 0, d = 0;
    DateTime temp = start.isBefore(end) ? start : end;
    DateTime target = start.isBefore(end) ? end : start;

    while (temp.year < target.year || (temp.year == target.year && temp.month < target.month)) {
      DateTime nextMonth = DateTime(temp.year, temp.month + 1, temp.day);
      if (nextMonth.day != temp.day) {
         // Handle month end overflow
         nextMonth = DateTime(temp.year, temp.month + 1, 0);
      }
      if (nextMonth.isAfter(target)) break;
      temp = nextMonth;
      m++;
    }
    y = (m / 12).floor();
    m = m % 12;
    d = target.difference(temp).inDays;

    setState(() {
      _difference = {'totalDays': days, 'years': y, 'months': m, 'days': d};
    });
  }

  void _calculateAddSubtract() {
    final years = int.tryParse(_yearsController.text) ?? 0;
    final months = int.tryParse(_monthsController.text) ?? 0;
    final days = int.tryParse(_daysController.text) ?? 0;

    DateTime newDate = _baseDate;
    if (_isAdd) {
      newDate = DateTime(newDate.year + years, newDate.month + months, newDate.day + days);
    } else {
      newDate = DateTime(newDate.year - years, newDate.month - months, newDate.day - days);
    }

    setState(() {
      _resultDate = newDate;
    });
  }

  Future<void> _selectDate(BuildContext context, Function(DateTime) onSelected, DateTime initial) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
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
        title: const Text('Date Calculator'),
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
          _buildDateSelector(
            context,
            label: 'Start Date',
            date: _startDate,
            onTap: () => _selectDate(context, (d) => _startDate = d, _startDate),
          ),
          const SizedBox(height: 16),
          _buildDateSelector(
            context,
            label: 'End Date',
            date: _endDate,
            onTap: () => _selectDate(context, (d) => _endDate = d, _endDate),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _calculateDifference,
            child: const Padding(padding: EdgeInsets.all(16.0), child: Text('Calculate Difference')),
          ),
          if (_difference != null) ...[
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text('${_difference!['totalDays']} Total Days', style: Theme.of(context).textTheme.headlineSmall),
                    const Divider(height: 32),
                    Text(
                      '${_difference!['years']} years, ${_difference!['months']} months, ${_difference!['days']} days',
                      style: Theme.of(context).textTheme.titleMedium,
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
    final dateFormat = DateFormat.yMMMMd();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDateSelector(
            context,
            label: 'Date',
            date: _baseDate,
            onTap: () => _selectDate(context, (d) => _baseDate = d, _baseDate),
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
                  controller: _yearsController,
                  decoration: const InputDecoration(labelText: 'Years', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _monthsController,
                  decoration: const InputDecoration(labelText: 'Months', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _daysController,
                  decoration: const InputDecoration(labelText: 'Days', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _calculateAddSubtract,
            child: const Padding(padding: EdgeInsets.all(16.0), child: Text('Calculate Date')),
          ),
          if (_resultDate != null) ...[
            const SizedBox(height: 32),
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text('Result Date', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      dateFormat.format(_resultDate!),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                    ),
                    Text(
                      DateFormat('EEEE').format(_resultDate!),
                      style: Theme.of(context).textTheme.bodyLarge,
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

  Widget _buildDateSelector(BuildContext context, {required String label, required DateTime date, required VoidCallback onTap}) {
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
          DateFormat.yMMMMd().format(date),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
