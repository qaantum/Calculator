import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockProfitCalculator extends ConsumerStatefulWidget {
  const StockProfitCalculator({super.key});

  @override
  ConsumerState<StockProfitCalculator> createState() => _StockProfitCalculatorState();
}

class _StockProfitCalculatorState extends ConsumerState<StockProfitCalculator> {
  final _buyPriceController = TextEditingController();
  final _sellPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _buyCommissionController = TextEditingController();
  final _sellCommissionController = TextEditingController();

  String _profit = '---';
  String _roi = '---';
  Color _resultColor = Colors.black;

  void _calculate() {
    final buyPrice = double.tryParse(_buyPriceController.text) ?? 0;
    final sellPrice = double.tryParse(_sellPriceController.text) ?? 0;
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final buyComm = double.tryParse(_buyCommissionController.text) ?? 0;
    final sellComm = double.tryParse(_sellCommissionController.text) ?? 0;

    if (quantity == 0) {
      setState(() {
        _profit = '---';
        _roi = '---';
        _resultColor = Colors.black;
      });
      return;
    }

    final totalBuyCost = (buyPrice * quantity) + buyComm;
    final totalSellValue = (sellPrice * quantity) - sellComm;
    final profit = totalSellValue - totalBuyCost;
    final roi = (profit / totalBuyCost) * 100;

    setState(() {
      _profit = profit >= 0 ? '\$${profit.toStringAsFixed(2)}' : '-\$${profit.abs().toStringAsFixed(2)}';
      _roi = '${roi.toStringAsFixed(2)}%';
      _resultColor = profit >= 0 ? Colors.green : Colors.red;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Profit Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _buyPriceController,
              decoration: const InputDecoration(labelText: 'Buy Price per Share (\$)', border: OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _sellPriceController,
              decoration: const InputDecoration(labelText: 'Sell Price per Share (\$)', border: OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity (Shares)', border: OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _buyCommissionController,
                    decoration: const InputDecoration(labelText: 'Buy Commission (\$)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _sellCommissionController,
                    decoration: const InputDecoration(labelText: 'Sell Commission (\$)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Card(
              color: _resultColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Net Profit / Loss', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      _profit,
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _resultColor),
                    ),
                    const SizedBox(height: 16),
                    const Text('Return on Investment (ROI)', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      _roi,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _resultColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
