import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebtSnowballCalculator extends ConsumerStatefulWidget {
  const DebtSnowballCalculator({super.key});

  @override
  ConsumerState<DebtSnowballCalculator> createState() => _DebtSnowballCalculatorState();
}

class DebtItem {
  String name;
  double balance;
  double rate;
  double minPayment;

  DebtItem({required this.name, required this.balance, required this.rate, required this.minPayment});
}

class _DebtSnowballCalculatorState extends ConsumerState<DebtSnowballCalculator> {
  final List<DebtItem> _debts = [];
  final _extraPaymentController = TextEditingController();

  // Dialog controllers
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _rateController = TextEditingController();
  final _minPaymentController = TextEditingController();

  String _result = 'Add debts to see payoff plan.';

  void _addDebt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Debt'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Debt Name')),
              TextField(controller: _balanceController, decoration: const InputDecoration(labelText: 'Balance'), keyboardType: TextInputType.number),
              TextField(controller: _rateController, decoration: const InputDecoration(labelText: 'Interest Rate (%)'), keyboardType: TextInputType.number),
              TextField(controller: _minPaymentController, decoration: const InputDecoration(labelText: 'Min Payment'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              setState(() {
                _debts.add(DebtItem(
                  name: _nameController.text.isEmpty ? 'Debt ${_debts.length + 1}' : _nameController.text,
                  balance: double.tryParse(_balanceController.text) ?? 0,
                  rate: double.tryParse(_rateController.text) ?? 0,
                  minPayment: double.tryParse(_minPaymentController.text) ?? 0,
                ));
              });
              _nameController.clear();
              _balanceController.clear();
              _rateController.clear();
              _minPaymentController.clear();
              Navigator.pop(context);
              _calculate();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _calculate() {
    if (_debts.isEmpty) {
      setState(() => _result = 'Add debts to see payoff plan.');
      return;
    }

    // Sort by balance (Snowball method)
    List<DebtItem> sortedDebts = List.from(_debts);
    sortedDebts.sort((a, b) => a.balance.compareTo(b.balance));

    double extraPayment = double.tryParse(_extraPaymentController.text) ?? 0;
    double totalPaid = 0;
    int totalMonths = 0;
    
    // Simulation (simplified)
    // This is a complex calculation, for MVP we'll just estimate time for the first debt or total time.
    // Let's do a simplified simulation.
    
    // We need to simulate month by month.
    // Deep copy for simulation
    List<Map<String, dynamic>> simDebts = sortedDebts.map((d) => {
      'name': d.name,
      'balance': d.balance,
      'rate': d.rate / 100 / 12,
      'min': d.minPayment,
      'paid': false,
    }).toList();

    int months = 0;
    bool allPaid = false;

    while (!allPaid && months < 1200) { // Cap at 100 years
      months++;
      double availableExtra = extraPayment;
      allPaid = true;

      // 1. Pay minimums
      for (var debt in simDebts) {
        if (debt['balance'] > 0) {
          allPaid = false;
          double interest = debt['balance'] * debt['rate'];
          double payment = debt['min'];
          
          if (debt['balance'] + interest < payment) {
            payment = debt['balance'] + interest;
          }
          
          // If debt is paid off, add its min payment to snowball
          if (debt['paid']) {
            availableExtra += debt['min'];
            continue;
          }

          debt['balance'] += interest;
          debt['balance'] -= payment;
          totalPaid += payment;

          if (debt['balance'] <= 0.01) {
            debt['balance'] = 0;
            debt['paid'] = true;
            // The min payment for this debt is now available for the next debt in THIS month? 
            // Usually snowball adds it to the NEXT month's snowball. Let's keep it simple.
            // We'll just say the freed up min payment goes to snowball next month.
          }
        } else {
          // Already paid, add min to available
          availableExtra += debt['min'];
        }
      }

      // 2. Apply snowball (extra + freed up minimums) to lowest balance unpaid debt
      for (var debt in simDebts) {
        if (debt['balance'] > 0) {
          double payment = availableExtra;
          if (debt['balance'] < payment) {
            payment = debt['balance'];
            availableExtra -= payment; // Remaining goes to next debt
          } else {
            availableExtra = 0;
          }
          
          debt['balance'] -= payment;
          totalPaid += payment;
          
          if (debt['balance'] <= 0.01) {
            debt['balance'] = 0;
            debt['paid'] = true;
          }
          
          if (availableExtra <= 0) break;
        }
      }
    }

    setState(() {
      int years = months ~/ 12;
      int remainingMonths = months % 12;
      _result = 'Debt Free in: $years years, $remainingMonths months\nTotal Paid: \$${totalPaid.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debt Snowball Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _extraPaymentController,
              decoration: const InputDecoration(labelText: 'Monthly Extra Payment (\$)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _addDebt,
              icon: const Icon(Icons.add),
              label: const Text('Add Debt'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _debts.length,
                itemBuilder: (context, index) {
                  final debt = _debts[index];
                  return Card(
                    child: ListTile(
                      title: Text(debt.name),
                      subtitle: Text('\$${debt.balance} at ${debt.rate}% (Min: \$${debt.minPayment})'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _debts.removeAt(index);
                            _calculate();
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _result,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
