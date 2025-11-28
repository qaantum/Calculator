import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetWorthCalculator extends ConsumerStatefulWidget {
  const NetWorthCalculator({super.key});

  @override
  ConsumerState<NetWorthCalculator> createState() => _NetWorthCalculatorState();
}

class _NetWorthCalculatorState extends ConsumerState<NetWorthCalculator> {
  // Assets
  final _cashController = TextEditingController();
  final _propertyController = TextEditingController();
  final _investmentsController = TextEditingController();
  final _otherAssetsController = TextEditingController();

  // Liabilities
  final _loansController = TextEditingController();
  final _mortgageController = TextEditingController();
  final _creditCardController = TextEditingController();
  final _otherLiabilitiesController = TextEditingController();

  String _netWorth = '---';
  String _totalAssets = '---';
  String _totalLiabilities = '---';

  void _calculate() {
    double getVal(TextEditingController c) => double.tryParse(c.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

    final assets = getVal(_cashController) + getVal(_propertyController) + getVal(_investmentsController) + getVal(_otherAssetsController);
    final liabilities = getVal(_loansController) + getVal(_mortgageController) + getVal(_creditCardController) + getVal(_otherLiabilitiesController);
    
    final net = assets - liabilities;

    setState(() {
      _totalAssets = '\$${assets.toStringAsFixed(2)}';
      _totalLiabilities = '\$${liabilities.toStringAsFixed(2)}';
      _netWorth = '\$${net.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Net Worth Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection('Assets', [
              _buildField('Cash / Bank', _cashController),
              _buildField('Property / Real Estate', _propertyController),
              _buildField('Investments', _investmentsController),
              _buildField('Other Assets', _otherAssetsController),
            ], Colors.green.shade50),
            const SizedBox(height: 16),
            _buildSection('Liabilities', [
              _buildField('Loans', _loansController),
              _buildField('Mortgage', _mortgageController),
              _buildField('Credit Card Debt', _creditCardController),
              _buildField('Other Liabilities', _otherLiabilitiesController),
            ], Colors.red.shade50),
            const SizedBox(height: 32),
            Card(
              color: Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildResultRow('Total Assets', _totalAssets, Colors.green),
                    const Divider(),
                    _buildResultRow('Total Liabilities', _totalLiabilities, Colors.red),
                    const Divider(thickness: 2),
                    _buildResultRow('Net Worth', _netWorth, Colors.blue.shade900, isBold: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children, Color color) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), isDense: true),
        keyboardType: TextInputType.number,
        onChanged: (_) => _calculate(),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 24 : 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
