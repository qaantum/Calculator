import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class ProjectileMotionCalculator extends ConsumerStatefulWidget {
  const ProjectileMotionCalculator({super.key});

  @override
  ConsumerState<ProjectileMotionCalculator> createState() => _ProjectileMotionCalculatorState();
}

class _ProjectileMotionCalculatorState extends ConsumerState<ProjectileMotionCalculator> {
  final _velocityController = TextEditingController();
  final _angleController = TextEditingController();
  final _heightController = TextEditingController(); // Initial height

  String _range = '---';
  String _maxHeight = '---';
  String _flightTime = '---';

  final double g = 9.81; // m/s^2

  void _calculate() {
    final v = double.tryParse(_velocityController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
    final angleDeg = double.tryParse(_angleController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
    final h0 = double.tryParse(_heightController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

    if (v == null || angleDeg == null) {
      setState(() {
        _range = '---';
        _maxHeight = '---';
        _flightTime = '---';
      });
      return;
    }

    final theta = angleDeg * (pi / 180); // Convert to radians
    final vx = v * cos(theta);
    final vy = v * sin(theta);

    // Time of flight
    // y = h0 + vy*t - 0.5*g*t^2
    // Land when y = 0
    // 0 = h0 + vy*t - 0.5*g*t^2
    // 0.5*g*t^2 - vy*t - h0 = 0
    // Quadratic formula for t
    
    final a = 0.5 * g;
    final b = -vy;
    final c = -h0;

    final discriminant = b * b - 4 * a * c;
    if (discriminant < 0) return;

    final t1 = (-b + sqrt(discriminant)) / (2 * a);
    final t2 = (-b - sqrt(discriminant)) / (2 * a);
    
    final t = max(t1, t2); // Positive time

    // Range = vx * t
    final range = vx * t;

    // Max Height
    // vy_final = vy - g*t_peak = 0 => t_peak = vy / g
    final tPeak = vy / g;
    final hMax = h0 + (vy * tPeak) - (0.5 * g * tPeak * tPeak);

    setState(() {
      _flightTime = '${t.toStringAsFixed(2)} s';
      _range = '${range.toStringAsFixed(2)} m';
      _maxHeight = '${hMax.toStringAsFixed(2)} m';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projectile Motion')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _velocityController,
              decoration: const InputDecoration(labelText: 'Initial Velocity (m/s)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _angleController,
              decoration: const InputDecoration(labelText: 'Launch Angle (degrees)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: 'Initial Height (m) [Optional]', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.indigo.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildResultRow('Max Range', _range),
                    const Divider(),
                    _buildResultRow('Max Height', _maxHeight),
                    const Divider(),
                    _buildResultRow('Flight Time', _flightTime),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
    );
  }
}
