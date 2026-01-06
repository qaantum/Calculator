import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/widgets/pin_button.dart';

class BloodSugarConverter extends ConsumerStatefulWidget {
  const BloodSugarConverter({super.key});

  @override
  ConsumerState<BloodSugarConverter> createState() => _BloodSugarConverterState();
}

class _BloodSugarConverterState extends ConsumerState<BloodSugarConverter> {
  final _mgdlController = TextEditingController();
  final _mmolController = TextEditingController();
  
  bool _isEditingMgdl = true;

  // Conversion factor: 1 mmol/L = 18.0182 mg/dL
  static const double conversionFactor = 18.0182;

  void _convertFromMgdl() {
    if (!_isEditingMgdl) return;
    final mgdl = double.tryParse(_mgdlController.text);
    if (mgdl != null) {
      final mmol = mgdl / conversionFactor;
      _mmolController.text = mmol.toStringAsFixed(2);
    }
  }

  void _convertFromMmol() {
    if (_isEditingMgdl) return;
    final mmol = double.tryParse(_mmolController.text);
    if (mmol != null) {
      final mgdl = mmol * conversionFactor;
      _mgdlController.text = mgdl.toStringAsFixed(1);
    }
  }

  String _getCategory(double mgdl) {
    if (mgdl < 70) return 'Low (Hypoglycemia)';
    if (mgdl < 100) return 'Normal (Fasting)';
    if (mgdl < 126) return 'Prediabetes (Fasting)';
    return 'Diabetes Range';
  }

  Color _getCategoryColor(double mgdl) {
    if (mgdl < 70) return Colors.orange;
    if (mgdl < 100) return Colors.green;
    if (mgdl < 126) return Colors.amber;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final mgdl = double.tryParse(_mgdlController.text);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Sugar Converter'),
        actions: const [PinButton(route: '/health/bloodsugar')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _mgdlController,
              decoration: const InputDecoration(
                labelText: 'mg/dL',
                hintText: 'US/Japan units',
                suffixText: 'mg/dL',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onTap: () => setState(() => _isEditingMgdl = true),
              onChanged: (_) => _convertFromMgdl(),
            ),
            const SizedBox(height: 16),
            const Center(child: Icon(Icons.swap_vert, size: 32)),
            const SizedBox(height: 16),
            TextField(
              controller: _mmolController,
              decoration: const InputDecoration(
                labelText: 'mmol/L',
                hintText: 'International units',
                suffixText: 'mmol/L',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onTap: () => setState(() => _isEditingMgdl = false),
              onChanged: (_) => _convertFromMmol(),
            ),
            if (mgdl != null && mgdl > 0) ...[
              const SizedBox(height: 24),
              Card(
                color: _getCategoryColor(mgdl).withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text('Classification', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        _getCategory(mgdl),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getCategoryColor(mgdl),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reference Ranges (Fasting)', style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 12),
                      _buildRangeRow('Normal', '70-99 mg/dL', '3.9-5.5 mmol/L', Colors.green),
                      _buildRangeRow('Prediabetes', '100-125 mg/dL', '5.6-6.9 mmol/L', Colors.amber),
                      _buildRangeRow('Diabetes', '≥126 mg/dL', '≥7.0 mmol/L', Colors.red),
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
  
  Widget _buildRangeRow(String label, String mgdl, String mmol, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(mgdl, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          Text(mmol, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
