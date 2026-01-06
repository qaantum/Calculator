import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../ui/widgets/pin_button.dart';

class PaycheckCalculator extends ConsumerStatefulWidget {
  const PaycheckCalculator({super.key});

  @override
  ConsumerState<PaycheckCalculator> createState() => _PaycheckCalculatorState();
}

class _PaycheckCalculatorState extends ConsumerState<PaycheckCalculator> {
  final _grossSalaryController = TextEditingController();
  final _federalTaxController = TextEditingController(text: '22');
  final _stateTaxController = TextEditingController(text: '5');
  final _socialSecurityController = TextEditingController(text: '6.2');
  final _medicareController = TextEditingController(text: '1.45');
  final _healthInsuranceController = TextEditingController(text: '0');
  final _retirement401kController = TextEditingController(text: '0');
  
  String _payPeriod = 'Biweekly';
  
  double? _grossPay;
  double? _totalDeductions;
  double? _netPay;
  Map<String, double>? _deductionBreakdown;

  final List<String> _payPeriods = ['Weekly', 'Biweekly', 'Semi-Monthly', 'Monthly', 'Annual'];

  void _calculate() {
    final annualSalary = double.tryParse(_grossSalaryController.text);
    if (annualSalary == null) return;
    
    final federalRate = double.tryParse(_federalTaxController.text) ?? 0;
    final stateRate = double.tryParse(_stateTaxController.text) ?? 0;
    final ssRate = double.tryParse(_socialSecurityController.text) ?? 0;
    final medicareRate = double.tryParse(_medicareController.text) ?? 0;
    final healthInsurance = double.tryParse(_healthInsuranceController.text) ?? 0;
    final retirement = double.tryParse(_retirement401kController.text) ?? 0;
    
    int periodsPerYear;
    switch (_payPeriod) {
      case 'Weekly':
        periodsPerYear = 52;
        break;
      case 'Biweekly':
        periodsPerYear = 26;
        break;
      case 'Semi-Monthly':
        periodsPerYear = 24;
        break;
      case 'Monthly':
        periodsPerYear = 12;
        break;
      default:
        periodsPerYear = 1;
    }
    
    final grossPay = annualSalary / periodsPerYear;
    
    final federalTax = grossPay * (federalRate / 100);
    final stateTax = grossPay * (stateRate / 100);
    final ssTax = grossPay * (ssRate / 100);
    final medicareTax = grossPay * (medicareRate / 100);
    final retirementDeduction = grossPay * (retirement / 100);
    
    final totalDeductions = federalTax + stateTax + ssTax + medicareTax + healthInsurance + retirementDeduction;
    final netPay = grossPay - totalDeductions;
    
    setState(() {
      _grossPay = grossPay;
      _totalDeductions = totalDeductions;
      _netPay = netPay;
      _deductionBreakdown = {
        'Federal Tax': federalTax,
        'State Tax': stateTax,
        'Social Security': ssTax,
        'Medicare': medicareTax,
        'Health Insurance': healthInsurance,
        '401(k)': retirementDeduction,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paycheck Calculator'),
        actions: const [PinButton(route: '/finance/paycheck')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _grossSalaryController,
              decoration: const InputDecoration(
                labelText: 'Annual Gross Salary',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _payPeriod,
              decoration: const InputDecoration(
                labelText: 'Pay Period',
                border: OutlineInputBorder(),
              ),
              items: _payPeriods.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (v) {
                setState(() => _payPeriod = v!);
                _calculate();
              },
            ),
            const SizedBox(height: 24),
            Text('Tax Rates', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _federalTaxController,
                    decoration: const InputDecoration(
                      labelText: 'Federal',
                      suffixText: '%',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _stateTaxController,
                    decoration: const InputDecoration(
                      labelText: 'State',
                      suffixText: '%',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _socialSecurityController,
                    decoration: const InputDecoration(
                      labelText: 'Social Security',
                      suffixText: '%',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _medicareController,
                    decoration: const InputDecoration(
                      labelText: 'Medicare',
                      suffixText: '%',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Deductions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _healthInsuranceController,
                    decoration: const InputDecoration(
                      labelText: 'Health Insurance',
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _retirement401kController,
                    decoration: const InputDecoration(
                      labelText: '401(k)',
                      suffixText: '%',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            if (_netPay != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text('$_payPeriod Take-Home Pay', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        currency.format(_netPay),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const Divider(height: 24),
                      _buildRow('Gross Pay', currency.format(_grossPay)),
                      const SizedBox(height: 8),
                      ..._deductionBreakdown!.entries.where((e) => e.value > 0).map((e) =>
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: _buildRow(e.key, '-${currency.format(e.value)}', color: Colors.red),
                        ),
                      ),
                      const Divider(height: 16),
                      _buildRow('Total Deductions', '-${currency.format(_totalDeductions)}', color: Colors.red),
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
  
  Widget _buildRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
