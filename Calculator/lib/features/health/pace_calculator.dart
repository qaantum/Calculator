import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaceCalculator extends ConsumerStatefulWidget {
  const PaceCalculator({super.key});

  @override
  ConsumerState<PaceCalculator> createState() => _PaceCalculatorState();
}

class _PaceCalculatorState extends ConsumerState<PaceCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _distanceController = TextEditingController();
  final _hoursController = TextEditingController(text: '0');
  final _minutesController = TextEditingController(text: '0');
  final _secondsController = TextEditingController(text: '0');
  String _unit = 'km';

  String? _pace;
  String? _speed;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final distance = double.parse(_distanceController.text);
      final hours = int.parse(_hoursController.text);
      final minutes = int.parse(_minutesController.text);
      final seconds = int.parse(_secondsController.text);

      if (distance <= 0) return;

      final totalMinutes = (hours * 60) + minutes + (seconds / 60);
      final totalHours = totalMinutes / 60;

      if (totalMinutes <= 0) return;

      final paceMinutes = totalMinutes / distance;
      final paceSeconds = (paceMinutes - paceMinutes.floor()) * 60;

      final speed = distance / totalHours;

      setState(() {
        _pace = '${paceMinutes.floor()}:${paceSeconds.round().toString().padLeft(2, '0')} per $_unit';
        _speed = '${speed.toStringAsFixed(2)} $_unit/h';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pace Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _distanceController,
                      decoration: const InputDecoration(
                        labelText: 'Distance',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _unit,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'km', child: Text('km')),
                        DropdownMenuItem(value: 'miles', child: Text('miles')),
                      ],
                      onChanged: (value) => setState(() => _unit = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Time', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _hoursController,
                      decoration: const InputDecoration(
                        labelText: 'Hours',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _minutesController,
                      decoration: const InputDecoration(
                        labelText: 'Minutes',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _secondsController,
                      decoration: const InputDecoration(
                        labelText: 'Seconds',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _calculate,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Calculate Pace'),
                ),
              ),
              if (_pace != null) ...[
                const SizedBox(height: 32),
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('Pace', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          _pace!,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                        const Divider(height: 32),
                        Text('Speed', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          _speed!,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
