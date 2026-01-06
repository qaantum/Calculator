import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/widgets/pin_button.dart';

class DiceRoller extends ConsumerStatefulWidget {
  const DiceRoller({super.key});

  @override
  ConsumerState<DiceRoller> createState() => _DiceRollerState();
}

class _DiceRollerState extends ConsumerState<DiceRoller> with SingleTickerProviderStateMixin {
  int _sides = 6;
  int _count = 1;
  List<int> _results = [];
  int _total = 0;
  bool _isRolling = false;
  
  late AnimationController _animController;
  final _random = Random();

  final List<int> _commonDice = [4, 6, 8, 10, 12, 20, 100];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _roll() async {
    setState(() => _isRolling = true);
    _animController.forward(from: 0);
    
    // Animate random numbers
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (mounted) {
        setState(() {
          _results = List.generate(_count, (_) => _random.nextInt(_sides) + 1);
          _total = _results.fold(0, (a, b) => a + b);
        });
      }
    }
    
    // Final result
    setState(() {
      _results = List.generate(_count, (_) => _random.nextInt(_sides) + 1);
      _total = _results.fold(0, (a, b) => a + b);
      _isRolling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dice Roller'),
        actions: const [PinButton(route: '/other/dice')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Dice Type', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _commonDice.map((d) => 
                ChoiceChip(
                  label: Text('D$d'),
                  selected: _sides == d,
                  onSelected: (_) => setState(() => _sides = d),
                )
              ).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Number of Dice', style: Theme.of(context).textTheme.titleMedium),
                Row(
                  children: [
                    IconButton.filled(
                      onPressed: _count > 1 ? () => setState(() => _count--) : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$_count',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton.filled(
                      onPressed: _count < 20 ? () => setState(() => _count++) : null,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '${_count}D$_sides',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isRolling ? null : _roll,
              icon: const Icon(Icons.casino),
              label: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_isRolling ? 'Rolling...' : 'Roll'),
              ),
            ),
            if (_results.isNotEmpty) ...[
              const SizedBox(height: 32),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text('Total', style: Theme.of(context).textTheme.titleMedium),
                      AnimatedBuilder(
                        animation: _animController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _isRolling ? 1.0 + (_animController.value * 0.1) : 1.0,
                            child: Text(
                              '$_total',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          );
                        },
                      ),
                      if (_count > 1) ...[
                        const Divider(height: 24),
                        Text('Individual Rolls', style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _results.map((r) => 
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '$r',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Range: $_count - ${_count * _sides}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
