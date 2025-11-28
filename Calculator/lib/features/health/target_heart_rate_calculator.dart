import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TargetHeartRateCalculator extends ConsumerStatefulWidget {
  const TargetHeartRateCalculator({super.key});

  @override
  ConsumerState<TargetHeartRateCalculator> createState() => _TargetHeartRateCalculatorState();
}

class _TargetHeartRateCalculatorState extends ConsumerState<TargetHeartRateCalculator> {
  final _ageController = TextEditingController();
  final _restingHrController = TextEditingController();
  
  String _maxHr = '---';
  String _zone1 = '---'; // 50-60%
  String _zone2 = '---'; // 60-70%
  String _zone3 = '---'; // 70-80%
  String _zone4 = '---'; // 80-90%
  String _zone5 = '---'; // 90-100%

  void _calculate() {
    final ageText = _ageController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final restingText = _restingHrController.text.replaceAll(RegExp(r'[^0-9]'), '');

    final age = int.tryParse(ageText);
    final restingHr = int.tryParse(restingText);

    if (age == null || age == 0) {
      _reset();
      return;
    }

    // Tanaka Formula: 208 - (0.7 * age)
    // Or Standard: 220 - age
    // Let's use Standard for simplicity as it's widely known, or Tanaka for accuracy?
    // Standard is 220 - age.
    final maxHr = 220 - age;

    // Karvonen Formula if Resting HR is provided
    // Target = ((Max - Resting) * %) + Resting
    
    if (restingHr != null) {
      final reserve = maxHr - restingHr;
      setState(() {
        _maxHr = '$maxHr bpm';
        _zone1 = '${(reserve * 0.50 + restingHr).round()} - ${(reserve * 0.60 + restingHr).round()} bpm';
        _zone2 = '${(reserve * 0.60 + restingHr).round()} - ${(reserve * 0.70 + restingHr).round()} bpm';
        _zone3 = '${(reserve * 0.70 + restingHr).round()} - ${(reserve * 0.80 + restingHr).round()} bpm';
        _zone4 = '${(reserve * 0.80 + restingHr).round()} - ${(reserve * 0.90 + restingHr).round()} bpm';
        _zone5 = '${(reserve * 0.90 + restingHr).round()} - $maxHr bpm';
      });
    } else {
      // Standard Zones based on Max HR only
      setState(() {
        _maxHr = '$maxHr bpm';
        _zone1 = '${(maxHr * 0.50).round()} - ${(maxHr * 0.60).round()} bpm';
        _zone2 = '${(maxHr * 0.60).round()} - ${(maxHr * 0.70).round()} bpm';
        _zone3 = '${(maxHr * 0.70).round()} - ${(maxHr * 0.80).round()} bpm';
        _zone4 = '${(maxHr * 0.80).round()} - ${(maxHr * 0.90).round()} bpm';
        _zone5 = '${(maxHr * 0.90).round()} - $maxHr bpm';
      });
    }
  }

  void _reset() {
    setState(() {
      _maxHr = '---';
      _zone1 = '---';
      _zone2 = '---';
      _zone3 = '---';
      _zone4 = '---';
      _zone5 = '---';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Target Heart Rate')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _restingHrController,
              decoration: const InputDecoration(
                labelText: 'Resting Heart Rate (Optional)',
                hintText: 'For Karvonen Formula accuracy',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Max Heart Rate: $_maxHr', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    _buildZoneRow('Zone 1 (Warm Up)', '50-60%', _zone1, Colors.grey),
                    _buildZoneRow('Zone 2 (Fat Burn)', '60-70%', _zone2, Colors.blue),
                    _buildZoneRow('Zone 3 (Aerobic)', '70-80%', _zone3, Colors.green),
                    _buildZoneRow('Zone 4 (Anaerobic)', '80-90%', _zone4, Colors.orange),
                    _buildZoneRow('Zone 5 (VO2 Max)', '90-100%', _zone5, Colors.red),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneRow(String title, String percent, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.circle, color: color, size: 12),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(percent, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          Text(range, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
