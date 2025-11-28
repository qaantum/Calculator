import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GPACalculator extends ConsumerStatefulWidget {
  const GPACalculator({super.key});

  @override
  ConsumerState<GPACalculator> createState() => _GPACalculatorState();
}

class _GPACalculatorState extends ConsumerState<GPACalculator> {
  final List<Map<String, dynamic>> _courses = [
    {'credits': 3.0, 'grade': 4.0},
  ];

  double? _gpa;

  final Map<double, String> _gradeScale = {
    4.0: 'A',
    3.7: 'A-',
    3.3: 'B+',
    3.0: 'B',
    2.7: 'B-',
    2.3: 'C+',
    2.0: 'C',
    1.7: 'C-',
    1.0: 'D',
    0.0: 'F',
  };

  void _addCourse() {
    setState(() {
      _courses.add({'credits': 3.0, 'grade': 4.0});
    });
  }

  void _removeCourse(int index) {
    setState(() {
      _courses.removeAt(index);
    });
  }

  void _calculate() {
    double totalPoints = 0;
    double totalCredits = 0;

    for (var course in _courses) {
      totalPoints += (course['credits'] as double) * (course['grade'] as double);
      totalCredits += (course['credits'] as double);
    }

    setState(() {
      _gpa = totalCredits > 0 ? totalPoints / totalCredits : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPA Calculator')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: _courses[index]['credits'].toString(),
                            decoration: const InputDecoration(labelText: 'Credits'),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              _courses[index]['credits'] = double.tryParse(val) ?? 0.0;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<double>(
                            value: _courses[index]['grade'],
                            decoration: const InputDecoration(labelText: 'Grade'),
                            items: _gradeScale.entries.map((e) {
                              return DropdownMenuItem(value: e.key, child: Text('${e.value} (${e.key})'));
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _courses[index]['grade'] = val;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeCourse(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton.icon(
                  onPressed: _addCourse,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Course'),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _calculate,
                  child: const Padding(padding: EdgeInsets.all(16.0), child: Text('Calculate GPA')),
                ),
                if (_gpa != null) ...[
                  const SizedBox(height: 24),
                  Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Text('Your GPA', style: Theme.of(context).textTheme.titleMedium),
                          Text(
                            _gpa!.toStringAsFixed(2),
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
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
        ],
      ),
    );
  }
}
