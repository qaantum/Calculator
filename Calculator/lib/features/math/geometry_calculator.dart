import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeometryCalculator extends ConsumerStatefulWidget {
  const GeometryCalculator({super.key});

  @override
  ConsumerState<GeometryCalculator> createState() => _GeometryCalculatorState();
}

class _GeometryCalculatorState extends ConsumerState<GeometryCalculator> {
  String _shape = 'Circle'; // Circle, Rectangle, Triangle, Sphere, Cube, Cylinder
  
  // Controllers
  final _radiusController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _baseController = TextEditingController();

  String _resultArea = '---';
  String _resultPerimeter = '---'; // or Volume

  void _calculate() {
    double? r = double.tryParse(_radiusController.text);
    double? l = double.tryParse(_lengthController.text);
    double? w = double.tryParse(_widthController.text);
    double? h = double.tryParse(_heightController.text);
    double? b = double.tryParse(_baseController.text);

    String area = '---';
    String perimeter = '---';

    switch (_shape) {
      case 'Circle':
        if (r != null) {
          area = (pi * r * r).toStringAsFixed(2);
          perimeter = (2 * pi * r).toStringAsFixed(2);
        }
        break;
      case 'Rectangle':
        if (l != null && w != null) {
          area = (l * w).toStringAsFixed(2);
          perimeter = (2 * (l + w)).toStringAsFixed(2);
        }
        break;
      case 'Triangle':
        if (b != null && h != null) {
          area = (0.5 * b * h).toStringAsFixed(2);
          // Perimeter requires sides, let's skip or ask for sides?
          // Just Area for now.
          perimeter = 'N/A (Needs sides)';
        }
        break;
      case 'Sphere':
        if (r != null) {
          area = (4 * pi * r * r).toStringAsFixed(2); // Surface Area
          perimeter = ((4/3) * pi * pow(r, 3)).toStringAsFixed(2); // Volume
        }
        break;
      case 'Cube':
        if (l != null) {
          area = (6 * l * l).toStringAsFixed(2); // Surface Area
          perimeter = (l * l * l).toStringAsFixed(2); // Volume
        }
        break;
      case 'Cylinder':
        if (r != null && h != null) {
          area = (2 * pi * r * (r + h)).toStringAsFixed(2); // Surface Area
          perimeter = (pi * r * r * h).toStringAsFixed(2); // Volume
        }
        break;
    }

    setState(() {
      _resultArea = area;
      _resultPerimeter = perimeter;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showRadius = ['Circle', 'Sphere', 'Cylinder'].contains(_shape);
    bool showLength = ['Rectangle', 'Cube'].contains(_shape);
    bool showWidth = ['Rectangle'].contains(_shape);
    bool showHeight = ['Triangle', 'Cylinder'].contains(_shape);
    bool showBase = ['Triangle'].contains(_shape);

    String result2Label = ['Sphere', 'Cube', 'Cylinder'].contains(_shape) ? 'Volume' : 'Perimeter';
    String result1Label = ['Sphere', 'Cube', 'Cylinder'].contains(_shape) ? 'Surface Area' : 'Area';

    return Scaffold(
      appBar: AppBar(title: const Text('Geometry Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _shape,
              decoration: const InputDecoration(labelText: 'Shape', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Circle', child: Text('Circle')),
                DropdownMenuItem(value: 'Rectangle', child: Text('Rectangle')),
                DropdownMenuItem(value: 'Triangle', child: Text('Triangle (Area)')),
                DropdownMenuItem(value: 'Sphere', child: Text('Sphere')),
                DropdownMenuItem(value: 'Cube', child: Text('Cube')),
                DropdownMenuItem(value: 'Cylinder', child: Text('Cylinder')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _shape = val;
                    _resultArea = '---';
                    _resultPerimeter = '---';
                    _radiusController.clear();
                    _lengthController.clear();
                    _widthController.clear();
                    _heightController.clear();
                    _baseController.clear();
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            if (showRadius)
              TextField(
                controller: _radiusController,
                decoration: const InputDecoration(labelText: 'Radius', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculate(),
              ),
            if (showLength)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _lengthController,
                  decoration: const InputDecoration(labelText: 'Length / Side', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculate(),
                ),
              ),
            if (showWidth)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _widthController,
                  decoration: const InputDecoration(labelText: 'Width', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculate(),
                ),
              ),
            if (showBase)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _baseController,
                  decoration: const InputDecoration(labelText: 'Base', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculate(),
                ),
              ),
            if (showHeight)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _heightController,
                  decoration: const InputDecoration(labelText: 'Height', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculate(),
                ),
              ),
            const SizedBox(height: 32),
            Card(
              color: Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(result1Label, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(_resultArea, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(result2Label, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(_resultPerimeter, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
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
