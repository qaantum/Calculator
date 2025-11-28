import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VolumeCalculator extends StatefulWidget {
  const VolumeCalculator({super.key});

  @override
  State<VolumeCalculator> createState() => _VolumeCalculatorState();
}

class _VolumeCalculatorState extends State<VolumeCalculator> {
  final _formKey = GlobalKey<FormState>();
  String _shape = 'Cube';
  final _param1Controller = TextEditingController();
  final _param2Controller = TextEditingController();
  final _param3Controller = TextEditingController();

  double? _result;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      double res = 0;
      final p1 = double.tryParse(_param1Controller.text) ?? 0;
      final p2 = double.tryParse(_param2Controller.text) ?? 0;
      final p3 = double.tryParse(_param3Controller.text) ?? 0;

      switch (_shape) {
        case 'Cube':
          res = pow(p1, 3).toDouble();
          break;
        case 'Sphere':
          res = (4 / 3) * pi * pow(p1, 3);
          break;
        case 'Cylinder':
          res = pi * pow(p1, 2) * p2;
          break;
        case 'Cone':
          res = (1 / 3) * pi * pow(p1, 2) * p2;
          break;
        case 'Box':
          res = p1 * p2 * p3;
          break;
      }

      setState(() {
        _result = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volume Calculator'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _shape,
                        decoration: const InputDecoration(labelText: 'Shape', border: OutlineInputBorder()),
                        items: ['Cube', 'Sphere', 'Cylinder', 'Cone', 'Box']
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _shape = v!;
                            _param1Controller.clear();
                            _param2Controller.clear();
                            _param3Controller.clear();
                            _result = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_shape == 'Cube' || _shape == 'Sphere')
                        TextFormField(
                          controller: _param1Controller,
                          decoration: InputDecoration(
                            labelText: _shape == 'Cube' ? 'Side Length' : 'Radius',
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      if (_shape == 'Cylinder' || _shape == 'Cone') ...[
                        TextFormField(
                          controller: _param1Controller,
                          decoration: const InputDecoration(labelText: 'Radius', border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _param2Controller,
                          decoration: const InputDecoration(labelText: 'Height', border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ],
                      if (_shape == 'Box') ...[
                        TextFormField(
                          controller: _param1Controller,
                          decoration: const InputDecoration(labelText: 'Length', border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _param2Controller,
                          decoration: const InputDecoration(labelText: 'Width', border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _param3Controller,
                          decoration: const InputDecoration(labelText: 'Height', border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _calculate,
                          icon: const Icon(FontAwesomeIcons.calculator),
                          label: const Text('Calculate'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_result != null) ...[
                const SizedBox(height: 24),
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('Volume', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          _result!.toStringAsFixed(2),
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
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
      ),
    );
  }
}
