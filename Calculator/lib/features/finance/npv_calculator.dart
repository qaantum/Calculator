import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../ui/widgets/pin_button.dart';

class NPVCalculator extends ConsumerStatefulWidget {
  const NPVCalculator({super.key});

  @override
  ConsumerState<NPVCalculator> createState() => _NPVCalculatorState();
}

class _NPVCalculatorState extends ConsumerState<NPVCalculator> {
  final _discountRateController = TextEditingController(text: '10');
  final _initialInvestmentController = TextEditingController();
  final List<TextEditingController> _cashFlowControllers = [TextEditingController()];
  
  double? _npv;

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
    final rate = double.tryParse(_discountRateController.text);
    final initial = double.tryParse(_initialInvestmentController.text);
    
    if (rate == null || initial == null) return;
    
    final r = rate / 100;
    double npv = -initial;
    
    for (int i = 0; i < _cashFlowControllers.length; i++) {
      final cf = double.tryParse(_cashFlowControllers[i].text) ?? 0;
      npv += cf / pow(1 + r, i + 1);
    }
    
    setState(() {
      _npv = npv;
    });
  }

  double pow(double base, int exp) {
    double result = 1;
    for (int i = 0; i < exp; i++) {
      result *= base;
    }
    return result;
  }

  @override
  void dispose() {
    _discountRateController.dispose();
    _initialInvestmentController.dispose();
    for (var c in _cashFlowControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('NPV Calculator'),
        actions: const [PinButton(route: '/finance/npv')],
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
            const SizedBox(height: 16),
            TextField(
              controller: _discountRateController,
              decoration: const InputDecoration(
                labelText: 'Discount Rate',
                suffixText: '%',
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
            if (_npv != null) ...[
              const SizedBox(height: 24),
              Card(
                color: _npv! >= 0 
                    ? Colors.green.withOpacity(0.1) 
                    : Colors.red.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text('Net Present Value', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        currency.format(_npv),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _npv! >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _npv! >= 0 ? 'Profitable Investment' : 'Unprofitable Investment',
                        style: TextStyle(
                          color: _npv! >= 0 ? Colors.green : Colors.red,
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
