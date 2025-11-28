import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FactorialCalculator extends StatefulWidget {
  const FactorialCalculator({super.key});

  @override
  State<FactorialCalculator> createState() => _FactorialCalculatorState();
}

class _FactorialCalculatorState extends State<FactorialCalculator> {
  final _controller = TextEditingController();
  String? _result;

  void _calculate() {
    final n = int.tryParse(_controller.text);
    if (n != null && n >= 0) {
      if (n > 20) {
        setState(() {
          _result = 'Number too large';
        });
        return;
      }
      
      int res = 1;
      for (int i = 1; i <= n; i++) {
        res *= i;
      }
      
      setState(() {
        _result = res.toString();
      });
    } else {
      setState(() {
        _result = 'Invalid input';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Factorial Calculator'),
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
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Enter a number (0-20)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _calculate,
                        icon: const Icon(FontAwesomeIcons.exclamation),
                        label: const Text('Calculate Factorial'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text('Result', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        _result!,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
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
}
