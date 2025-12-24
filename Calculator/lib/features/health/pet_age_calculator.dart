import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PetAgeCalculator extends ConsumerStatefulWidget {
  const PetAgeCalculator({super.key});

  @override
  ConsumerState<PetAgeCalculator> createState() => _PetAgeCalculatorState();
}

class _PetAgeCalculatorState extends ConsumerState<PetAgeCalculator> {
  final _ageController = TextEditingController();
  int _petType = 0; // 0: Dog, 1: Cat
  String _size = 'medium'; // For dogs: small, medium, large
  double? _humanAge;

  void _calculate() {
    final petAge = double.tryParse(_ageController.text);
    if (petAge == null || petAge <= 0) {
      setState(() => _humanAge = null);
      return;
    }

    double humanAge;
    
    if (_petType == 0) {
      // Dog age calculation (more accurate than 7x rule)
      // First 2 years age faster, then slows down
      // Size also matters for dogs
      if (petAge <= 1) {
        humanAge = petAge * 15;
      } else if (petAge <= 2) {
        humanAge = 15 + (petAge - 1) * 9;
      } else {
        // After 2 years, size matters
        double yearlyRate;
        switch (_size) {
          case 'small':
            yearlyRate = 4; // Small dogs age slower
            break;
          case 'large':
            yearlyRate = 6; // Large dogs age faster
            break;
          default:
            yearlyRate = 5;
        }
        humanAge = 24 + (petAge - 2) * yearlyRate;
      }
    } else {
      // Cat age calculation
      if (petAge <= 1) {
        humanAge = petAge * 15;
      } else if (petAge <= 2) {
        humanAge = 15 + (petAge - 1) * 9;
      } else {
        humanAge = 24 + (petAge - 2) * 4;
      }
    }

    setState(() => _humanAge = humanAge);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pet Age Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Convert your pet\'s age to human years.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('🐕 Dog')),
                ButtonSegment(value: 1, label: Text('🐈 Cat')),
              ],
              selected: {_petType},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() => _petType = newSelection.first);
                _calculate();
              },
            ),
            const SizedBox(height: 16),
            if (_petType == 0) ...[
              const Text('Dog Size:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'small', label: Text('Small')),
                  ButtonSegment(value: 'medium', label: Text('Medium')),
                  ButtonSegment(value: 'large', label: Text('Large')),
                ],
                selected: {_size},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() => _size = newSelection.first);
                  _calculate();
                },
              ),
              const SizedBox(height: 8),
              Text(
                _size == 'small' 
                    ? 'Under 10 kg / 22 lbs'
                    : _size == 'large' 
                        ? 'Over 25 kg / 55 lbs'
                        : '10-25 kg / 22-55 lbs',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: '${_petType == 0 ? "Dog" : "Cat"}\'s Age (years)',
                border: const OutlineInputBorder(),
                hintText: 'e.g. 5',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 24),
            if (_humanAge != null) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        _petType == 0 ? '🐕' : '🐈',
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_humanAge!.toStringAsFixed(0)} human years',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getLifeStage(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('About this calculation:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text(
                        'The old "7 years" rule is inaccurate. Pets age faster in their first years, then slow down. '
                        'For dogs, size also matters - larger dogs age faster.',
                        style: TextStyle(fontSize: 13),
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

  String _getLifeStage() {
    if (_humanAge == null) return '';
    if (_humanAge! < 15) return 'Puppy/Kitten';
    if (_humanAge! < 25) return 'Young Adult';
    if (_humanAge! < 50) return 'Adult';
    if (_humanAge! < 75) return 'Mature Adult';
    return 'Senior';
  }
}
