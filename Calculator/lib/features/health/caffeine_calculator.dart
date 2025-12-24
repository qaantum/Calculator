import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class CaffeineCalculator extends ConsumerStatefulWidget {
  const CaffeineCalculator({super.key});

  @override
  ConsumerState<CaffeineCalculator> createState() => _CaffeineCalculatorState();
}

class _CaffeineCalculatorState extends ConsumerState<CaffeineCalculator> {
  final _amountController = TextEditingController(text: '95');
  String _drinkType = 'coffee';
  TimeOfDay _consumedAt = TimeOfDay.now();
  
  // Caffeine half-life is approximately 5-6 hours for average adults
  final double _halfLife = 5.5;

  final Map<String, int> _drinkCaffeine = {
    'coffee': 95,
    'espresso': 63,
    'black_tea': 47,
    'green_tea': 28,
    'energy_drink': 80,
    'cola': 34,
    'dark_chocolate': 23,
  };

  final Map<String, String> _drinkNames = {
    'coffee': '☕ Coffee (8 oz / 240ml)',
    'espresso': '☕ Espresso (1 shot)',
    'black_tea': '🍵 Black Tea (8 oz)',
    'green_tea': '🍵 Green Tea (8 oz)',
    'energy_drink': '⚡ Energy Drink (8 oz)',
    'cola': '🥤 Cola (12 oz / 355ml)',
    'dark_chocolate': '🍫 Dark Chocolate (1 oz)',
  };

  void _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _consumedAt,
    );
    if (picked != null) {
      setState(() => _consumedAt = picked);
    }
  }

  void _onDrinkChanged(String? drink) {
    if (drink != null) {
      setState(() {
        _drinkType = drink;
        _amountController.text = _drinkCaffeine[drink]?.toString() ?? '95';
      });
    }
  }

  List<Map<String, dynamic>> _calculateLevels() {
    final initial = double.tryParse(_amountController.text) ?? 95;
    final now = TimeOfDay.now();
    
    final List<Map<String, dynamic>> levels = [];
    
    // Calculate for next 24 hours in 2-hour intervals
    for (int hoursLater = 0; hoursLater <= 24; hoursLater += 2) {
      final totalMinutesConsumed = _consumedAt.hour * 60 + _consumedAt.minute;
      final totalMinutesNow = now.hour * 60 + now.minute;
      var elapsedHours = (totalMinutesNow - totalMinutesConsumed) / 60 + hoursLater;
      
      if (elapsedHours < 0) elapsedHours += 24;
      
      // Caffeine decay formula: C(t) = C0 * (0.5)^(t/half_life)
      final remaining = initial * pow(0.5, elapsedHours / _halfLife);
      
      final futureTime = TimeOfDay(
        hour: (now.hour + hoursLater) % 24,
        minute: now.minute,
      );
      
      levels.add({
        'time': futureTime,
        'label': hoursLater == 0 ? 'Now' : '+${hoursLater}h',
        'amount': remaining,
        'percentage': (remaining / initial * 100),
      });
    }
    
    return levels;
  }

  @override
  Widget build(BuildContext context) {
    final levels = _calculateLevels();
    final currentLevel = levels.isNotEmpty ? levels[0]['amount'] as double : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Caffeine Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Track how caffeine metabolizes in your body.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _drinkType,
              decoration: const InputDecoration(
                labelText: 'Drink Type',
                border: OutlineInputBorder(),
              ),
              items: _drinkNames.entries.map((e) => DropdownMenuItem(
                value: e.key,
                child: Text(e.value),
              )).toList(),
              onChanged: _onDrinkChanged,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Caffeine Amount (mg)',
                border: OutlineInputBorder(),
                helperText: 'Average coffee has 95mg per cup',
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text('Consumed at: ${_consumedAt.format(context)}'),
              subtitle: const Text('Tap to change'),
              trailing: const Icon(Icons.access_time),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              onTap: _selectTime,
            ),
            const SizedBox(height: 24),
            Card(
              color: currentLevel > 100 
                  ? Colors.red.shade100 
                  : currentLevel > 50 
                      ? Colors.orange.shade100 
                      : Colors.green.shade100,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('Current Level', style: TextStyle(fontSize: 14)),
                    Text(
                      '${currentLevel.toStringAsFixed(0)} mg',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      currentLevel > 100 
                          ? '⚠️ High - may affect sleep'
                          : currentLevel > 50 
                              ? '☕ Moderate level'
                              : '✓ Low - sleep-safe',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Caffeine Over Time:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  final level = levels[index];
                  final amount = level['amount'] as double;
                  final percentage = level['percentage'] as double;
                  return Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 8),
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Container(
                                width: 40,
                                height: percentage.clamp(0, 100) * 0.7,
                                decoration: BoxDecoration(
                                  color: amount > 50 ? Colors.brown : Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('${amount.toStringAsFixed(0)}mg', style: const TextStyle(fontSize: 10)),
                        Text(level['label'] as String, style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('💡 Tips:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('• Caffeine half-life is ~5.5 hours'),
                    Text('• Stop caffeine 6+ hours before bed'),
                    Text('• Below 50mg is generally sleep-safe'),
                    Text('• 400mg/day is max recommended'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
