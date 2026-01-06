import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/widgets/pin_button.dart';

class StatisticsCalculator extends ConsumerStatefulWidget {
  const StatisticsCalculator({super.key});

  @override
  ConsumerState<StatisticsCalculator> createState() => _StatisticsCalculatorState();
}

class _StatisticsCalculatorState extends ConsumerState<StatisticsCalculator> {
  final _dataController = TextEditingController();
  
  double? _mean;
  double? _median;
  List<double>? _mode;
  double? _range;
  int? _count;

  void _calculate() {
    final input = _dataController.text.trim();
    if (input.isEmpty) {
      setState(() {
        _mean = null;
        _median = null;
        _mode = null;
      });
      return;
    }
    
    // Parse numbers (comma, space, or newline separated)
    final numbers = input
        .split(RegExp(r'[,\s\n]+'))
        .map((s) => double.tryParse(s.trim()))
        .where((n) => n != null)
        .cast<double>()
        .toList();
    
    if (numbers.isEmpty) return;
    
    // Sort for median
    numbers.sort();
    
    // Mean
    final sum = numbers.reduce((a, b) => a + b);
    final mean = sum / numbers.length;
    
    // Median
    double median;
    final n = numbers.length;
    if (n % 2 == 0) {
      median = (numbers[n ~/ 2 - 1] + numbers[n ~/ 2]) / 2;
    } else {
      median = numbers[n ~/ 2];
    }
    
    // Mode
    final frequency = <double, int>{};
    for (var num in numbers) {
      frequency[num] = (frequency[num] ?? 0) + 1;
    }
    final maxFreq = frequency.values.reduce((a, b) => a > b ? a : b);
    final modes = frequency.entries
        .where((e) => e.value == maxFreq)
        .map((e) => e.key)
        .toList();
    
    // Range
    final range = numbers.last - numbers.first;
    
    setState(() {
      _mean = mean;
      _median = median;
      _mode = maxFreq > 1 ? modes : null; // No mode if all unique
      _range = range;
      _count = numbers.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics Calculator'),
        actions: const [PinButton(route: '/math/statistics')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _dataController,
              decoration: const InputDecoration(
                labelText: 'Enter Numbers',
                hintText: 'Separate with commas, spaces, or newlines',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 8),
            Text(
              'Example: 1, 2, 3, 4, 5 or 1 2 3 4 5',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (_mean != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildStatRow(context, 'Count', '$_count values'),
                      const Divider(height: 24),
                      _buildStatRow(context, 'Mean (Average)', _mean!.toStringAsFixed(4)),
                      const SizedBox(height: 12),
                      _buildStatRow(context, 'Median', _median!.toStringAsFixed(4)),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        context, 
                        'Mode', 
                        _mode != null 
                            ? _mode!.map((m) => m.toStringAsFixed(2)).join(', ')
                            : 'No mode (all unique)',
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(context, 'Range', _range!.toStringAsFixed(4)),
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
  
  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
