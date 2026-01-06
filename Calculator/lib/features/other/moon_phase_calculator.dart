import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/widgets/pin_button.dart';

class MoonPhaseCalculator extends ConsumerStatefulWidget {
  const MoonPhaseCalculator({super.key});

  @override
  ConsumerState<MoonPhaseCalculator> createState() => _MoonPhaseCalculatorState();
}

class _MoonPhaseCalculatorState extends ConsumerState<MoonPhaseCalculator> {
  DateTime _selectedDate = DateTime.now();
  
  // Moon phase calculation using Conway's method
  double _getMoonPhase(DateTime date) {
    int year = date.year;
    int month = date.month;
    int day = date.day;
    
    if (month < 3) {
      year--;
      month += 12;
    }
    
    int a = year ~/ 100;
    int b = a ~/ 4;
    int c = 2 - a + b;
    int e = (365.25 * (year + 4716)).floor();
    int f = (30.6001 * (month + 1)).floor();
    
    double jd = c + day + e + f - 1524.5;
    double daysSinceNew = jd - 2451549.5;
    double lunation = daysSinceNew / 29.53059;
    double phase = (lunation - lunation.floor()) * 29.53059;
    
    return phase;
  }

  String _getPhaseName(double phase) {
    if (phase < 1.85) return 'New Moon';
    if (phase < 5.53) return 'Waxing Crescent';
    if (phase < 9.22) return 'First Quarter';
    if (phase < 12.91) return 'Waxing Gibbous';
    if (phase < 16.61) return 'Full Moon';
    if (phase < 20.30) return 'Waning Gibbous';
    if (phase < 23.99) return 'Last Quarter';
    if (phase < 27.68) return 'Waning Crescent';
    return 'New Moon';
  }

  IconData _getPhaseIcon(double phase) {
    if (phase < 1.85) return Icons.nightlight_round;
    if (phase < 9.22) return Icons.nightlight_round; // Crescent
    if (phase < 16.61) return Icons.circle; // Full-ish
    return Icons.nightlight_round;
  }

  double _getIllumination(double phase) {
    // Approximate illumination percentage
    return ((1 - math.cos(2 * math.pi * phase / 29.53)) / 2 * 100);
  }

  @override
  Widget build(BuildContext context) {
    final phase = _getMoonPhase(_selectedDate);
    final phaseName = _getPhaseName(phase);
    final illumination = _getIllumination(phase);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moon Phase Calculator'),
        actions: const [PinButton(route: '/other/moonphase')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Tap to select date'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.indigo.shade900,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: _buildMoonGradient(phase),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      phaseName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${illumination.toStringAsFixed(1)}% Illuminated',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Moon Phases', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildPhaseChip('🌑 New', phase < 1.85),
                        _buildPhaseChip('🌒 Waxing Crescent', phase >= 1.85 && phase < 5.53),
                        _buildPhaseChip('🌓 First Quarter', phase >= 5.53 && phase < 9.22),
                        _buildPhaseChip('🌔 Waxing Gibbous', phase >= 9.22 && phase < 12.91),
                        _buildPhaseChip('🌕 Full', phase >= 12.91 && phase < 16.61),
                        _buildPhaseChip('🌖 Waning Gibbous', phase >= 16.61 && phase < 20.30),
                        _buildPhaseChip('🌗 Last Quarter', phase >= 20.30 && phase < 23.99),
                        _buildPhaseChip('🌘 Waning Crescent', phase >= 23.99),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Gradient _buildMoonGradient(double phase) {
    // Simplified moon visualization
    if (phase < 7.38) {
      // Waxing - right side lit
      return LinearGradient(
        colors: [Colors.grey.shade800, Colors.yellow.shade100],
      );
    } else if (phase < 14.77) {
      // Full moon
      return RadialGradient(
        colors: [Colors.yellow.shade100, Colors.yellow.shade200],
      );
    } else if (phase < 22.15) {
      // Waning - left side lit
      return LinearGradient(
        colors: [Colors.yellow.shade100, Colors.grey.shade800],
      );
    }
    // New moon
    return RadialGradient(
      colors: [Colors.grey.shade700, Colors.grey.shade900],
    );
  }

  Widget _buildPhaseChip(String label, bool isActive) {
    return Chip(
      label: Text(label, style: TextStyle(
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
      )),
      backgroundColor: isActive ? Theme.of(context).colorScheme.primaryContainer : null,
    );
  }
}
