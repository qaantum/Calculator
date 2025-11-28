import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DensityCalculator extends StatefulWidget {
  const DensityCalculator({super.key});

  @override
  State<DensityCalculator> createState() => _DensityCalculatorState();
}

class _DensityCalculatorState extends State<DensityCalculator> {
  final _massController = TextEditingController();
  final _volumeController = TextEditingController();
  double? _result;

  void _calculate() {
    final mass = double.tryParse(_massController.text);
    final volume = double.tryParse(_volumeController.text);

    if (mass != null && volume != null && volume != 0) {
      setState(() {
        _result = mass / volume;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Density Calculator'),
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
                      controller: _massController,
                      decoration: const InputDecoration(
                        labelText: 'Mass (kg)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _volumeController,
                      decoration: const InputDecoration(
                        labelText: 'Volume (m³)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _calculate,
                        icon: const Icon(FontAwesomeIcons.calculator),
                        label: const Text('Calculate Density'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text('Density', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        '${_result!.toStringAsFixed(2)} kg/m³',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onTertiaryContainer,
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
