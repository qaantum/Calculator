import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FibonacciGenerator extends ConsumerStatefulWidget {
  const FibonacciGenerator({super.key});

  @override
  ConsumerState<FibonacciGenerator> createState() => _FibonacciGeneratorState();
}

class _FibonacciGeneratorState extends ConsumerState<FibonacciGenerator> {
  final _countController = TextEditingController(text: '10');
  List<BigInt> _sequence = [];

  void _generate() {
    int n = int.tryParse(_countController.text) ?? 0;
    if (n < 1) n = 1;
    if (n > 1000) n = 1000; // Limit to prevent freezing

    List<BigInt> seq = [];
    if (n >= 1) seq.add(BigInt.from(0));
    if (n >= 2) seq.add(BigInt.from(1));

    for (int i = 2; i < n; i++) {
      seq.add(seq[i - 1] + seq[i - 2]);
    }

    setState(() {
      _sequence = seq;
    });
  }

  @override
  void initState() {
    super.initState();
    _generate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fibonacci Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _countController,
              decoration: const InputDecoration(
                labelText: 'Number of Terms (Max 1000)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _generate(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _sequence.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: SelectableText(_sequence[index].toString()),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _sequence[index].toString()));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied!')),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
