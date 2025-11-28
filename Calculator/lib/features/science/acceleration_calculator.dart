import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccelerationCalculator extends StatefulWidget {
  const AccelerationCalculator({super.key});

  @override
  State<AccelerationCalculator> createState() => _AccelerationCalculatorState();
}

class _AccelerationCalculatorState extends State<AccelerationCalculator> {
  final _v1Controller = TextEditingController();
  final _v2Controller = TextEditingController();
  final _timeController = TextEditingController();
  double? _result;

  void _calculate() {
    final v1 = double.tryParse(_v1Controller.text);
    final v2 = double.tryParse(_v2Controller.text);
    final t = double.tryParse(_timeController.text);

    if (v1 != null && v2 != null && t != null && t != 0) {
      setState(() {
        _result = (v2 - v1) / t;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acceleration Calculator'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _v1Controller,
                      decoration: const InputDecoration(
                        labelText: 'Initial Velocity (m/s)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _v2Controller,
                      decoration: const InputDecoration(
                        labelText: 'Final Velocity (m/s)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _timeController,
                      decoration: const InputDecoration(
                        labelText: 'Time (s)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _calculate,
                        icon: const Icon(FontAwesomeIcons.gaugeHigh),
                        label: const Text('Calculate Acceleration'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text('Acceleration', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        '${_result!.toStringAsFixed(2)} m/s²',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onErrorContainer,
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
