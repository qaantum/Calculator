import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class CirclePropertiesCalculator extends ConsumerStatefulWidget {
  const CirclePropertiesCalculator({super.key});

  @override
  ConsumerState<CirclePropertiesCalculator> createState() => _CirclePropertiesCalculatorState();
}

class _CirclePropertiesCalculatorState extends ConsumerState<CirclePropertiesCalculator> {
  final _radiusController = TextEditingController();
  final _diameterController = TextEditingController();
  final _circumferenceController = TextEditingController();
  final _areaController = TextEditingController();

  bool _isUpdating = false;

  void _updateFromRadius(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    double r = double.tryParse(value) ?? 0;
    if (r > 0) {
      _diameterController.text = (r * 2).toStringAsFixed(4);
      _circumferenceController.text = (2 * pi * r).toStringAsFixed(4);
      _areaController.text = (pi * r * r).toStringAsFixed(4);
    } else {
      _clearAll();
    }
    _isUpdating = false;
  }

  void _updateFromDiameter(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    double d = double.tryParse(value) ?? 0;
    if (d > 0) {
      double r = d / 2;
      _radiusController.text = r.toStringAsFixed(4);
      _circumferenceController.text = (pi * d).toStringAsFixed(4);
      _areaController.text = (pi * r * r).toStringAsFixed(4);
    } else {
      _clearAll();
    }
    _isUpdating = false;
  }

  void _updateFromCircumference(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    double c = double.tryParse(value) ?? 0;
    if (c > 0) {
      double r = c / (2 * pi);
      _radiusController.text = r.toStringAsFixed(4);
      _diameterController.text = (r * 2).toStringAsFixed(4);
      _areaController.text = (pi * r * r).toStringAsFixed(4);
    } else {
      _clearAll();
    }
    _isUpdating = false;
  }

  void _updateFromArea(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    double a = double.tryParse(value) ?? 0;
    if (a > 0) {
      double r = sqrt(a / pi);
      _radiusController.text = r.toStringAsFixed(4);
      _diameterController.text = (r * 2).toStringAsFixed(4);
      _circumferenceController.text = (2 * pi * r).toStringAsFixed(4);
    } else {
      _clearAll();
    }
    _isUpdating = false;
  }

  void _clearAll() {
    // Only clear if the active field is empty, but since we are updating others based on one, 
    // if input is invalid, we might want to clear others.
    // To avoid clearing the field being typed in, we only clear others.
    // But since we are setting text on controllers, we need to be careful.
    // For simplicity, if input is 0 or invalid, we won't clear, just stop updating.
    // Actually, let's just clear if the input is explicitly empty.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Circle Properties')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Enter any value to calculate the others.'),
            const SizedBox(height: 16),
            TextField(
              controller: _radiusController,
              decoration: const InputDecoration(labelText: 'Radius (r)', border: OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: _updateFromRadius,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _diameterController,
              decoration: const InputDecoration(labelText: 'Diameter (d)', border: OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: _updateFromDiameter,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _circumferenceController,
              decoration: const InputDecoration(labelText: 'Circumference (C)', border: OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: _updateFromCircumference,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _areaController,
              decoration: const InputDecoration(labelText: 'Area (A)', border: OutlineInputBorder()),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: _updateFromArea,
            ),
            const SizedBox(height: 32),
            // Visual representation could be added here
            CustomPaint(
              size: const Size(200, 200),
              painter: CirclePainter(),
            ),
          ],
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2 - 10, paint);
    
    // Draw Radius
    final p2 = Paint()..color = Colors.red..strokeWidth = 2;
    canvas.drawLine(Offset(size.width / 2, size.height / 2), Offset(size.width - 10, size.height / 2), p2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
