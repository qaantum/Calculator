import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlooringCalculator extends ConsumerStatefulWidget {
  const FlooringCalculator({super.key});

  @override
  ConsumerState<FlooringCalculator> createState() => _FlooringCalculatorState();
}

class _FlooringCalculatorState extends ConsumerState<FlooringCalculator> {
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _boxCoverageController = TextEditingController();
  final _priceController = TextEditingController();
  final _wasteController = TextEditingController(text: '10');

  String _result = '---';
  String _cost = '---';

  void _calculate() {
    final l = double.tryParse(_lengthController.text);
    final w = double.tryParse(_widthController.text);
    final coverage = double.tryParse(_boxCoverageController.text);
    final price = double.tryParse(_priceController.text);
    final waste = double.tryParse(_wasteController.text) ?? 0;

    if (l == null || w == null) {
      setState(() {
        _result = '---';
        _cost = '---';
      });
      return;
    }

    final area = l * w;
    final areaWithWaste = area * (1 + waste / 100);

    String resultText = 'Area: ${area.toStringAsFixed(2)} sq ft\n'
        'With ${waste.toStringAsFixed(0)}% Waste: ${areaWithWaste.toStringAsFixed(2)} sq ft';

    if (coverage != null && coverage > 0) {
      final boxes = (areaWithWaste / coverage).ceil();
      resultText += '\n\nBoxes Needed: $boxes';
      
      if (price != null) {
        final totalCost = boxes * price;
        setState(() {
          _cost = 'Total Cost: \$${totalCost.toStringAsFixed(2)}';
        });
      } else {
        setState(() {
          _cost = '---';
        });
      }
    } else {
      setState(() {
        _cost = '---';
      });
    }

    setState(() {
      _result = resultText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flooring Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Calculate flooring needed for a room.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lengthController,
                    decoration: const InputDecoration(labelText: 'Length (ft)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _widthController,
                    decoration: const InputDecoration(labelText: 'Width (ft)', border: OutlineInputBorder()),
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
                    controller: _boxCoverageController,
                    decoration: const InputDecoration(labelText: 'Sq Ft per Box', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _wasteController,
                    decoration: const InputDecoration(labelText: 'Waste %', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price per Box (\$) (Optional)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.brown.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      _result,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    if (_cost != '---') ...[
                      const Divider(),
                      Text(
                        _cost,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
