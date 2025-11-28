import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CricketRunRateCalculator extends ConsumerStatefulWidget {
  const CricketRunRateCalculator({super.key});

  @override
  ConsumerState<CricketRunRateCalculator> createState() => _CricketRunRateCalculatorState();
}

class _CricketRunRateCalculatorState extends ConsumerState<CricketRunRateCalculator> {
  final _runsScoredController = TextEditingController();
  final _oversFacedController = TextEditingController();
  final _runsConcededController = TextEditingController();
  final _oversBowledController = TextEditingController();

  String _nrr = '---';

  void _calculate() {
    final runsScored = double.tryParse(_runsScoredController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
    final oversFaced = double.tryParse(_oversFacedController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
    final runsConceded = double.tryParse(_runsConcededController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
    final oversBowled = double.tryParse(_oversBowledController.text.replaceAll(RegExp(r'[^0-9.]'), ''));

    if (runsScored == null || oversFaced == null || runsConceded == null || oversBowled == null) {
      setState(() {
        _nrr = '---';
      });
      return;
    }

    if (oversFaced == 0 || oversBowled == 0) return;

    // NRR = (Runs Scored / Overs Faced) - (Runs Conceded / Overs Bowled)
    final nrr = (runsScored / oversFaced) - (runsConceded / oversBowled);

    setState(() {
      _nrr = nrr.toStringAsFixed(3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cricket Net Run Rate')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Calculate Net Run Rate (NRR) for a team.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _runsScoredController,
                    decoration: const InputDecoration(labelText: 'Runs Scored', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _oversFacedController,
                    decoration: const InputDecoration(labelText: 'Overs Faced', border: OutlineInputBorder()),
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
                    controller: _runsConcededController,
                    decoration: const InputDecoration(labelText: 'Runs Conceded', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _oversBowledController,
                    decoration: const InputDecoration(labelText: 'Overs Bowled', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Net Run Rate (NRR)', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(
                      _nrr,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                      textAlign: TextAlign.center,
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
