import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/widgets/pin_button.dart';

class VO2MaxCalculator extends ConsumerStatefulWidget {
  const VO2MaxCalculator({super.key});

  @override
  ConsumerState<VO2MaxCalculator> createState() => _VO2MaxCalculatorState();
}

class _VO2MaxCalculatorState extends ConsumerState<VO2MaxCalculator> {
  String _method = 'Cooper Test';
  final _distanceController = TextEditingController();
  final _ageController = TextEditingController();
  final _restingHRController = TextEditingController();
  final _maxHRController = TextEditingController();
  
  double? _vo2Max;

  void _calculate() {
    double? result;
    
    switch (_method) {
      case 'Cooper Test':
        // Distance in meters, 12-minute run
        final distance = double.tryParse(_distanceController.text);
        if (distance != null) {
          // VO2 max = (distance - 504.9) / 44.73
          result = (distance - 504.9) / 44.73;
        }
        break;
      case 'Rockport Walk':
        // 1-mile walk test
        final age = double.tryParse(_ageController.text);
        final hr = double.tryParse(_restingHRController.text);
        final time = double.tryParse(_distanceController.text); // time in minutes
        if (age != null && hr != null && time != null) {
          // Simplified Rockport formula
          result = 132.853 - (0.0769 * 150) - (0.3877 * age) + (6.315 * 1) - (3.2649 * time) - (0.1565 * hr);
        }
        break;
      case 'Heart Rate':
        // Using HR ratio method
        final maxHR = double.tryParse(_maxHRController.text);
        final restingHR = double.tryParse(_restingHRController.text);
        if (maxHR != null && restingHR != null) {
          // VO2 max ≈ 15.3 × (HRmax/HRrest)
          result = 15.3 * (maxHR / restingHR);
        }
        break;
    }
    
    setState(() => _vo2Max = result);
  }

  String _getFitnessLevel(double vo2max, int age) {
    // Simplified categories
    if (vo2max >= 50) return 'Excellent';
    if (vo2max >= 40) return 'Good';
    if (vo2max >= 30) return 'Average';
    if (vo2max >= 20) return 'Below Average';
    return 'Poor';
  }

  Color _getFitnessColor(String level) {
    switch (level) {
      case 'Excellent': return Colors.green;
      case 'Good': return Colors.lightGreen;
      case 'Average': return Colors.amber;
      case 'Below Average': return Colors.orange;
      default: return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final age = int.tryParse(_ageController.text) ?? 30;
    final fitnessLevel = _vo2Max != null ? _getFitnessLevel(_vo2Max!, age) : null;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('VO₂ Max Calculator'),
        actions: const [PinButton(route: '/health/vo2max')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _method,
              decoration: const InputDecoration(
                labelText: 'Estimation Method',
                border: OutlineInputBorder(),
              ),
              items: ['Cooper Test', 'Heart Rate']
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _method = v!;
                  _vo2Max = null;
                });
              },
            ),
            const SizedBox(height: 24),
            if (_method == 'Cooper Test') ...[
              TextField(
                controller: _distanceController,
                decoration: const InputDecoration(
                  labelText: 'Distance Run in 12 Minutes',
                  suffixText: 'meters',
                  border: OutlineInputBorder(),
                  helperText: 'Run as far as you can in 12 minutes',
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculate(),
              ),
            ],
            if (_method == 'Heart Rate') ...[
              TextField(
                controller: _maxHRController,
                decoration: const InputDecoration(
                  labelText: 'Maximum Heart Rate',
                  suffixText: 'bpm',
                  border: OutlineInputBorder(),
                  helperText: 'Estimate: 220 - age',
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculate(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _restingHRController,
                decoration: const InputDecoration(
                  labelText: 'Resting Heart Rate',
                  suffixText: 'bpm',
                  border: OutlineInputBorder(),
                  helperText: 'Measure when calm and rested',
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculate(),
              ),
            ],
            if (_vo2Max != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text('Estimated VO₂ Max', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        '${_vo2Max!.toStringAsFixed(1)} mL/kg/min',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _getFitnessColor(fitnessLevel!),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          fitnessLevel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
}
