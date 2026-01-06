import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/widgets/pin_button.dart';

class LogarithmCalculator extends ConsumerStatefulWidget {
  const LogarithmCalculator({super.key});

  @override
  ConsumerState<LogarithmCalculator> createState() => _LogarithmCalculatorState();
}

class _LogarithmCalculatorState extends ConsumerState<LogarithmCalculator> {
  final _valueController = TextEditingController();
  final _baseController = TextEditingController(text: '10');
  
  double? _result;
  String _logType = 'Custom';

  void _calculate() {
    final value = double.tryParse(_valueController.text);
    if (value == null || value <= 0) {
      setState(() => _result = null);
      return;
    }
    
    double result;
    switch (_logType) {
      case 'Natural (ln)':
        result = math.log(value);
        break;
      case 'Common (log₁₀)':
        result = math.log(value) / math.ln10;
        break;
      case 'Binary (log₂)':
        result = math.log(value) / math.ln2;
        break;
      default: // Custom base
        final base = double.tryParse(_baseController.text);
        if (base == null || base <= 0 || base == 1) {
          setState(() => _result = null);
          return;
        }
        result = math.log(value) / math.log(base);
    }
    
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logarithm Calculator'),
        actions: const [PinButton(route: '/math/logarithm')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Value',
                hintText: 'Enter a positive number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _logType,
              decoration: const InputDecoration(
                labelText: 'Logarithm Type',
                border: OutlineInputBorder(),
              ),
              items: ['Natural (ln)', 'Common (log₁₀)', 'Binary (log₂)', 'Custom']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) {
                setState(() => _logType = v!);
                _calculate();
              },
            ),
            if (_logType == 'Custom') ...[
              const SizedBox(height: 16),
              TextField(
                controller: _baseController,
                decoration: const InputDecoration(
                  labelText: 'Base',
                  hintText: 'e.g., 2, 10, e',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculate(),
              ),
            ],
            if (_result != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(_getFormulaText(), style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        _result!.toStringAsFixed(8),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
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
  
  String _getFormulaText() {
    final value = _valueController.text;
    switch (_logType) {
      case 'Natural (ln)':
        return 'ln($value)';
      case 'Common (log₁₀)':
        return 'log₁₀($value)';
      case 'Binary (log₂)':
        return 'log₂($value)';
      default:
        return 'log${_baseController.text}($value)';
    }
  }
}
