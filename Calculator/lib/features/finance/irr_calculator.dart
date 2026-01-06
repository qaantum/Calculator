import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../ui/widgets/pin_button.dart';

class IRRCalculator extends ConsumerStatefulWidget {
  const IRRCalculator({super.key});

  @override
  ConsumerState<IRRCalculator> createState() => _IRRCalculatorState();
}

class _IRRCalculatorState extends ConsumerState<IRRCalculator> {
  final _initialInvestmentController = TextEditingController();
  final List<TextEditingController> _cashFlowControllers = [TextEditingController()];
  
  double? _irr;
  String? _error;

  void _addCashFlow() {
    setState(() {
      _cashFlowControllers.add(TextEditingController());
    });
  }

  void _removeCashFlow(int index) {
    if (_cashFlowControllers.length > 1) {
      setState(() {
        _cashFlowControllers[index].dispose();
        _cashFlowControllers.removeAt(index);
      });
      _calculate();
    }
  }

  void _calculate() {
    final initial = double.tryParse(_initialInvestmentController.text);
    if (initial == null) {
      setState(() {
        _irr = null;
        _error = null;
      });
      return;
    }

    List<double> cashFlows = [-initial];
    for (var c in _cashFlowControllers) {
      cashFlows.add(double.tryParse(c.text) ?? 0);
    }

    // Newton-Raphson method to find IRR
    double rate = 0.1; // Initial guess
    const int maxIterations = 100;
    const double tolerance = 0.0001;

    for (int i = 0; i < maxIterations; i++) {
      double npv = 0;
      double derivative = 0;
      
      for (int j = 0; j < cashFlows.length; j++) {
        npv += cashFlows[j] / math.pow(1 + rate, j);
        if (j > 0) {
          derivative -= j * cashFlows[j] / math.pow(1 + rate, j + 1);
        }
      }
      
      if (derivative.abs() < 1e-10) break;
      
      double newRate = rate - npv / derivative;
      
      if ((newRate - rate).abs() < tolerance) {
        setState(() {
          _irr = newRate * 100;
          _error = null;
        });
        return;
      }
      rate = newRate;
    }
    
    setState(() {
      _irr = rate * 100;
      _error = null;
    });
  }

  @override
  void dispose() {
    _initialInvestmentController.dispose();
    for (var c in _cashFlowControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IRR Calculator'),
        actions: const [PinButton(route: '/finance/irr')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _initialInvestmentController,
              decoration: const InputDecoration(
                labelText: 'Initial Investment',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Cash Flows', style: Theme.of(context).textTheme.titleMedium),
                IconButton.filled(
                  onPressed: _addCashFlow,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(_cashFlowControllers.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cashFlowControllers[i],
                        decoration: InputDecoration(
                          labelText: 'Year ${i + 1}',
                          prefixText: '\$',
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _calculate(),
                      ),
                    ),
                    if (_cashFlowControllers.length > 1)
                      IconButton(
                        onPressed: () => _removeCashFlow(i),
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.red,
                      ),
                  ],
                ),
              );
            }),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer)),
                ),
              ),
            ],
            if (_irr != null && _error == null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text('Internal Rate of Return', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        '${_irr!.toStringAsFixed(2)}%',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Annual return rate at which NPV = 0',
                        style: Theme.of(context).textTheme.bodySmall,
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
