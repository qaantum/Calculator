import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/widgets/pin_button.dart';

class MedicationDosageCalculator extends ConsumerStatefulWidget {
  const MedicationDosageCalculator({super.key});

  @override
  ConsumerState<MedicationDosageCalculator> createState() => _MedicationDosageCalculatorState();
}

class _MedicationDosageCalculatorState extends ConsumerState<MedicationDosageCalculator> {
  final _weightController = TextEditingController();
  final _dosePerKgController = TextEditingController();
  final _concentrationController = TextEditingController();
  final _frequencyController = TextEditingController(text: '1');
  
  String _weightUnit = 'kg';
  
  double? _totalDose;
  double? _volumePerDose;
  double? _dailyDose;

  void _calculate() {
    var weight = double.tryParse(_weightController.text);
    final dosePerKg = double.tryParse(_dosePerKgController.text);
    final concentration = double.tryParse(_concentrationController.text);
    final frequency = int.tryParse(_frequencyController.text);
    
    if (weight == null || dosePerKg == null) return;
    
    // Convert to kg if needed
    if (_weightUnit == 'lb') {
      weight = weight * 0.453592;
    }
    
    final totalDose = weight * dosePerKg;
    final dailyDose = totalDose * (frequency ?? 1);
    
    double? volume;
    if (concentration != null && concentration > 0) {
      volume = totalDose / concentration;
    }
    
    setState(() {
      _totalDose = totalDose;
      _volumePerDose = volume;
      _dailyDose = dailyDose;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Dosage'),
        actions: const [PinButton(route: '/health/dosage')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.amber.withOpacity(0.1),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.amber),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'For educational purposes only. Always consult a healthcare provider.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Body Weight',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _weightUnit,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'kg', child: Text('kg')),
                      DropdownMenuItem(value: 'lb', child: Text('lb')),
                    ],
                    onChanged: (v) {
                      setState(() => _weightUnit = v!);
                      _calculate();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dosePerKgController,
              decoration: const InputDecoration(
                labelText: 'Dose per kg',
                suffixText: 'mg/kg',
                border: OutlineInputBorder(),
                helperText: 'Prescribed dosage per kilogram',
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _concentrationController,
              decoration: const InputDecoration(
                labelText: 'Concentration (Optional)',
                suffixText: 'mg/mL',
                border: OutlineInputBorder(),
                helperText: 'For liquid medications',
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _frequencyController,
              decoration: const InputDecoration(
                labelText: 'Doses per Day',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            if (_totalDose != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text('Single Dose', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        '${_totalDose!.toStringAsFixed(2)} mg',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      if (_volumePerDose != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          '= ${_volumePerDose!.toStringAsFixed(2)} mL',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Daily Total'),
                          Text(
                            '${_dailyDose!.toStringAsFixed(2)} mg',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
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
