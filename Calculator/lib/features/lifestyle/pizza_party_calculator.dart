import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PizzaPartyCalculator extends StatefulWidget {
  const PizzaPartyCalculator({super.key});

  @override
  State<PizzaPartyCalculator> createState() => _PizzaPartyCalculatorState();
}

class _PizzaPartyCalculatorState extends State<PizzaPartyCalculator> {
  final _peopleController = TextEditingController();
  final _slicesPerPersonController = TextEditingController(text: '3');
  final _slicesPerPizzaController = TextEditingController(text: '8');
  
  int? _pizzasNeeded;

  void _calculate() {
    final people = int.tryParse(_peopleController.text);
    final slicesPerPerson = int.tryParse(_slicesPerPersonController.text);
    final slicesPerPizza = int.tryParse(_slicesPerPizzaController.text);

    if (people != null && slicesPerPerson != null && slicesPerPizza != null && slicesPerPizza > 0) {
      final totalSlices = people * slicesPerPerson;
      setState(() {
        _pizzasNeeded = (totalSlices / slicesPerPizza).ceil();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizza Party Calculator'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _peopleController,
                      decoration: const InputDecoration(
                        labelText: 'Number of People',
                        prefixIcon: Icon(FontAwesomeIcons.users),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _slicesPerPersonController,
                            decoration: const InputDecoration(
                              labelText: 'Slices / Person',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _slicesPerPizzaController,
                            decoration: const InputDecoration(
                              labelText: 'Slices / Pizza',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _calculate,
                        icon: const Icon(FontAwesomeIcons.pizzaSlice),
                        label: const Text('Calculate Pizzas'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_pizzasNeeded != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Colors.orange.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text('You need to order', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black)),
                      const SizedBox(height: 8),
                      Text(
                        '$_pizzasNeeded Pizzas',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
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
