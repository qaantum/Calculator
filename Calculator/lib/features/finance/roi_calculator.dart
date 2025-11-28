import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RoiCalculator extends ConsumerStatefulWidget {
  const RoiCalculator({super.key});

  @override
  ConsumerState<RoiCalculator> createState() => _RoiCalculatorState();
}

class _RoiCalculatorState extends ConsumerState<RoiCalculator> {
  final _investmentController = TextEditingController();
  final _finalValueController = TextEditingController();

  String? _returnAmount;
  String? _roiPercentage;

  void _calculate() {
    final initial = double.tryParse(_investmentController.text);
    final finalVal = double.tryParse(_finalValueController.text);

    if (initial == null || finalVal == null || initial == 0) return;

    final gain = finalVal - initial;
    final roi = (gain / initial) * 100;

    final currency = NumberFormat.simpleCurrency();

    setState(() {
      _returnAmount = currency.format(gain);
      _roiPercentage = '${roi.toStringAsFixed(2)}%';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Return on Investment (ROI)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _investmentController,
              decoration: const InputDecoration(
                labelText: 'Initial Investment',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _finalValueController,
              decoration: const InputDecoration(
                labelText: 'Final Value',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            if (_roiPercentage != null) ...[
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text('Total Return', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        _returnAmount!,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: _returnAmount!.startsWith('-') ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text('ROI', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        _roiPercentage!,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
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
