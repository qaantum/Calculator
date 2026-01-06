import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../ui/widgets/pin_button.dart';

class CDCalculator extends ConsumerStatefulWidget {
  const CDCalculator({super.key});

  @override
  ConsumerState<CDCalculator> createState() => _CDCalculatorState();
}

class _CDCalculatorState extends ConsumerState<CDCalculator> {
  final _depositController = TextEditingController();
  final _apyController = TextEditingController(text: '5');
  final _termController = TextEditingController(text: '12');
  
  String _compounding = 'Daily';
  
  double? _totalValue;
  double? _interestEarned;

  final Map<String, int> _compoundingPeriods = {
    'Daily': 365,
    'Monthly': 12,
    'Quarterly': 4,
    'Semi-Annually': 2,
    'Annually': 1,
  };

  void _calculate() {
    final deposit = double.tryParse(_depositController.text);
    final apy = double.tryParse(_apyController.text);
    final months = int.tryParse(_termController.text);
    
    if (deposit == null || apy == null || months == null) return;
    
    final n = _compoundingPeriods[_compounding]!;
    final t = months / 12;
    final r = apy / 100;
    
    // A = P(1 + r/n)^(nt)
    final total = deposit * math.pow(1 + r / n, n * t);
    final interest = total - deposit;
    
    setState(() {
      _totalValue = total;
      _interestEarned = interest;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('CD Calculator'),
        actions: const [PinButton(route: '/finance/cd')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _depositController,
              decoration: const InputDecoration(
                labelText: 'Initial Deposit',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apyController,
              decoration: const InputDecoration(
                labelText: 'APY (Annual Percentage Yield)',
                suffixText: '%',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _termController,
              decoration: const InputDecoration(
                labelText: 'Term',
                suffixText: 'months',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _compounding,
              decoration: const InputDecoration(
                labelText: 'Compounding Frequency',
                border: OutlineInputBorder(),
              ),
              items: _compoundingPeriods.keys.map((p) => 
                DropdownMenuItem(value: p, child: Text(p))
              ).toList(),
              onChanged: (v) {
                setState(() => _compounding = v!);
                _calculate();
              },
            ),
            if (_totalValue != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text('Total Value at Maturity', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        currency.format(_totalValue),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Interest Earned'),
                          Text(
                            currency.format(_interestEarned),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
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
