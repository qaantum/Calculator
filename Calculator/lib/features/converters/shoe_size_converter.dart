import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoeSizeConverter extends ConsumerStatefulWidget {
  const ShoeSizeConverter({super.key});

  @override
  ConsumerState<ShoeSizeConverter> createState() => _ShoeSizeConverterState();
}

class _ShoeSizeConverterState extends ConsumerState<ShoeSizeConverter> {
  String _category = 'Men'; // Men, Women, Kids
  String _fromRegion = 'US'; // US, UK, EU, CM
  String _toRegion = 'EU';
  double _inputValue = 9.0;

  // Simplified conversion tables (approximate)
  // Base is US size
  final Map<String, Map<String, double>> _offsets = {
    'Men': {'US': 0, 'UK': -0.5, 'EU': 33, 'CM': 18}, // Very rough approx, usually non-linear
  };

  // Better approach: Lookup tables
  // [US, UK, EU, CM]
  final List<List<double>> _menSizes = [
    [6, 5.5, 39, 23.5],
    [6.5, 6, 39, 24.1],
    [7, 6.5, 40, 24.4],
    [7.5, 7, 40.5, 24.8],
    [8, 7.5, 41, 25.4],
    [8.5, 8, 41.5, 25.7],
    [9, 8.5, 42, 26],
    [9.5, 9, 42.5, 26.7],
    [10, 9.5, 43, 27],
    [10.5, 10, 43.5, 27.3],
    [11, 10.5, 44, 27.9],
    [11.5, 11, 44.5, 28.3],
    [12, 11.5, 45, 28.6],
    [13, 12.5, 46, 29.4],
    [14, 13.5, 47, 30.2],
  ];

  final List<List<double>> _womenSizes = [
    [4, 2, 35, 20.8],
    [4.5, 2.5, 35, 21.3],
    [5, 3, 35.5, 21.6],
    [5.5, 3.5, 36, 22.2],
    [6, 4, 36.5, 22.5],
    [6.5, 4.5, 37, 23],
    [7, 5, 37.5, 23.5],
    [7.5, 5.5, 38, 23.8],
    [8, 6, 38.5, 24.1],
    [8.5, 6.5, 39, 24.6],
    [9, 7, 40, 25.1],
    [9.5, 7.5, 40.5, 25.4],
    [10, 8, 41, 25.9],
    [10.5, 8.5, 41.5, 26.2],
    [11, 9, 42, 26.7],
  ];

  List<double> _getAvailableSizes(String region) {
    int index = _getIndex(region);
    List<List<double>> table = _category == 'Men' ? _menSizes : _womenSizes;
    return table.map((row) => row[index]).toList();
  }

  int _getIndex(String region) {
    switch (region) {
      case 'US': return 0;
      case 'UK': return 1;
      case 'EU': return 2;
      case 'CM': return 3;
      default: return 0;
    }
  }

  String _convert() {
    int fromIdx = _getIndex(_fromRegion);
    int toIdx = _getIndex(_toRegion);
    List<List<double>> table = _category == 'Men' ? _menSizes : _womenSizes;

    // Find the row that matches the input value
    for (var row in table) {
      if ((row[fromIdx] - _inputValue).abs() < 0.1) {
        return row[toIdx].toString();
      }
    }
    return '---';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shoe Size Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Men', label: Text('Men')),
                ButtonSegment(value: 'Women', label: Text('Women')),
              ],
              selected: {_category},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _category = newSelection.first;
                  _inputValue = _getAvailableSizes(_fromRegion).first;
                });
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('From', style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: _fromRegion,
                        isExpanded: true,
                        items: ['US', 'UK', 'EU', 'CM'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _fromRegion = newValue!;
                            _inputValue = _getAvailableSizes(_fromRegion).first;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<double>(
                        value: _inputValue,
                        isExpanded: true,
                        items: _getAvailableSizes(_fromRegion).map((double value) {
                          return DropdownMenuItem<double>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _inputValue = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(Icons.arrow_forward, size: 32, color: Colors.grey),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('To', style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: _toRegion,
                        isExpanded: true,
                        items: ['US', 'UK', 'EU', 'CM'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _toRegion = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _convert(),
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
