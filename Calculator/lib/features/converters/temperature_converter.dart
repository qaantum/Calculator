import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/widgets/pin_button.dart';

class TemperatureConverter extends ConsumerStatefulWidget {
  const TemperatureConverter({super.key});

  @override
  ConsumerState<TemperatureConverter> createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends ConsumerState<TemperatureConverter> {
  final _celsiusController = TextEditingController();
  final _fahrenheitController = TextEditingController();
  final _kelvinController = TextEditingController();
  
  String? _activeInput;

  void _convertFrom(String source) {
    _activeInput = source;
    
    switch (source) {
      case 'celsius':
        final c = double.tryParse(_celsiusController.text);
        if (c != null) {
          _fahrenheitController.text = ((c * 9/5) + 32).toStringAsFixed(2);
          _kelvinController.text = (c + 273.15).toStringAsFixed(2);
        }
        break;
      case 'fahrenheit':
        final f = double.tryParse(_fahrenheitController.text);
        if (f != null) {
          final c = (f - 32) * 5/9;
          _celsiusController.text = c.toStringAsFixed(2);
          _kelvinController.text = (c + 273.15).toStringAsFixed(2);
        }
        break;
      case 'kelvin':
        final k = double.tryParse(_kelvinController.text);
        if (k != null) {
          final c = k - 273.15;
          _celsiusController.text = c.toStringAsFixed(2);
          _fahrenheitController.text = ((c * 9/5) + 32).toStringAsFixed(2);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        actions: const [PinButton(route: '/converters/temperature')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTemperatureField(
              controller: _celsiusController,
              label: 'Celsius',
              suffix: '°C',
              icon: Icons.thermostat,
              color: Colors.blue,
              source: 'celsius',
            ),
            const SizedBox(height: 16),
            const Center(child: Icon(Icons.swap_vert, size: 24)),
            const SizedBox(height: 16),
            _buildTemperatureField(
              controller: _fahrenheitController,
              label: 'Fahrenheit',
              suffix: '°F',
              icon: Icons.thermostat,
              color: Colors.orange,
              source: 'fahrenheit',
            ),
            const SizedBox(height: 16),
            const Center(child: Icon(Icons.swap_vert, size: 24)),
            const SizedBox(height: 16),
            _buildTemperatureField(
              controller: _kelvinController,
              label: 'Kelvin',
              suffix: 'K',
              icon: Icons.science,
              color: Colors.purple,
              source: 'kelvin',
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reference Points', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 12),
                    _buildReferenceRow('Water Freezes', '0°C', '32°F', '273.15K'),
                    _buildReferenceRow('Water Boils', '100°C', '212°F', '373.15K'),
                    _buildReferenceRow('Body Temp', '37°C', '98.6°F', '310.15K'),
                    _buildReferenceRow('Absolute Zero', '-273.15°C', '-459.67°F', '0K'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required IconData icon,
    required Color color,
    required String source,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon, color: color),
      ),
      keyboardType: TextInputType.number,
      onChanged: (_) => _convertFrom(source),
    );
  }

  Widget _buildReferenceRow(String label, String c, String f, String k) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontSize: 12))),
          Expanded(child: Text(c, style: const TextStyle(fontSize: 12, color: Colors.blue))),
          Expanded(child: Text(f, style: const TextStyle(fontSize: 12, color: Colors.orange))),
          Expanded(child: Text(k, style: const TextStyle(fontSize: 12, color: Colors.purple))),
        ],
      ),
    );
  }
}
