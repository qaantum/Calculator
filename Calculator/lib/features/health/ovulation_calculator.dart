import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OvulationCalculator extends ConsumerStatefulWidget {
  const OvulationCalculator({super.key});

  @override
  ConsumerState<OvulationCalculator> createState() => _OvulationCalculatorState();
}

class _OvulationCalculatorState extends ConsumerState<OvulationCalculator> {
  DateTime? _lastPeriodDate;
  final _cycleLengthController = TextEditingController(text: '28');

  String _fertileWindow = '---';
  String _ovulationDate = '---';
  String _nextPeriod = '---';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _lastPeriodDate) {
      setState(() {
        _lastPeriodDate = picked;
        _calculate();
      });
    }
  }

  void _calculate() {
    if (_lastPeriodDate == null) return;

    final cycleLength = int.tryParse(_cycleLengthController.text);
    if (cycleLength == null || cycleLength < 20 || cycleLength > 45) {
      // Basic validation
      return;
    }

    // Ovulation is typically 14 days before the next period
    final nextPeriodDate = _lastPeriodDate!.add(Duration(days: cycleLength));
    final ovulation = nextPeriodDate.subtract(const Duration(days: 14));
    
    // Fertile window is typically 5 days before ovulation + ovulation day
    final fertileStart = ovulation.subtract(const Duration(days: 5));
    final fertileEnd = ovulation;

    final dateFormat = DateFormat('MMM d, yyyy');

    setState(() {
      _ovulationDate = dateFormat.format(ovulation);
      _fertileWindow = '${dateFormat.format(fertileStart)} - ${dateFormat.format(fertileEnd)}';
      _nextPeriod = dateFormat.format(nextPeriodDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ovulation Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Estimate your fertile window and ovulation date.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(_lastPeriodDate == null 
                ? 'Select First Day of Last Period' 
                : 'Last Period: ${DateFormat('MMM d, yyyy').format(_lastPeriodDate!)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.grey)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cycleLengthController,
              decoration: const InputDecoration(
                labelText: 'Cycle Length (days)',
                border: OutlineInputBorder(),
                helperText: 'Usually 28 days',
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.pink.shade50,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Estimated Ovulation', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _ovulationDate,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(),
                    const Text('Fertile Window', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _fertileWindow,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(),
                    const Text('Next Period Starts', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _nextPeriod,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Note: This is an estimation and should not be used for contraception.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
