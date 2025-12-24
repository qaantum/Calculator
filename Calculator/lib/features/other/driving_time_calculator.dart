import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrivingTimeCalculator extends ConsumerStatefulWidget {
  const DrivingTimeCalculator({super.key});

  @override
  ConsumerState<DrivingTimeCalculator> createState() => _DrivingTimeCalculatorState();
}

class _DrivingTimeCalculatorState extends ConsumerState<DrivingTimeCalculator> {
  final _distanceController = TextEditingController();
  final _speedController = TextEditingController(text: '80');
  bool _isMetric = true;
  
  double? _timeHours;
  double? _arrivalTimeOffset;

  void _calculate() {
    final distance = double.tryParse(_distanceController.text);
    final speed = double.tryParse(_speedController.text);

    if (distance == null || speed == null || speed == 0) {
      setState(() {
        _timeHours = null;
        _arrivalTimeOffset = null;
      });
      return;
    }

    setState(() {
      _timeHours = distance / speed;
      _arrivalTimeOffset = _timeHours;
    });
  }

  String _formatDuration(double hours) {
    final totalMinutes = (hours * 60).round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    
    if (h == 0) return '$m minutes';
    if (m == 0) return '$h hour${h > 1 ? 's' : ''}';
    return '$h hr ${m} min';
  }

  String _getArrivalTime() {
    if (_arrivalTimeOffset == null) return '--';
    final now = DateTime.now();
    final arrival = now.add(Duration(minutes: (_arrivalTimeOffset! * 60).round()));
    final hour = arrival.hour % 12 == 0 ? 12 : arrival.hour % 12;
    final amPm = arrival.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${arrival.minute.toString().padLeft(2, '0')} $amPm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driving Time')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Calculate estimated travel time and arrival.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Metric (km)')),
                ButtonSegment(value: false, label: Text('Imperial (mi)')),
              ],
              selected: {_isMetric},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() => _isMetric = newSelection.first);
                _calculate();
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _distanceController,
              decoration: InputDecoration(
                labelText: 'Distance',
                suffixText: _isMetric ? 'km' : 'mi',
                border: const OutlineInputBorder(),
                hintText: 'e.g. 150',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _speedController,
              decoration: InputDecoration(
                labelText: 'Average Speed',
                suffixText: _isMetric ? 'km/h' : 'mph',
                border: const OutlineInputBorder(),
                helperText: 'Include traffic delays in your estimate',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 24),
            if (_timeHours != null) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text('🚗', style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 8),
                      const Text('Estimated Travel Time'),
                      Text(
                        _formatDuration(_timeHours!),
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.schedule, size: 20),
                              const Text('Leave Now', style: TextStyle(fontSize: 12)),
                              Text(
                                'Arrive ${_getArrivalTime()}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.local_gas_station, size: 20),
                              const Text('Fuel Est.', style: TextStyle(fontSize: 12)),
                              Text(
                                _isMetric 
                                    ? '${((double.tryParse(_distanceController.text) ?? 0) * 0.08).toStringAsFixed(1)} L'
                                    : '${((double.tryParse(_distanceController.text) ?? 0) / 30).toStringAsFixed(1)} gal',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
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
                      const Text('Trip Details:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildDetailRow('Distance', '${_distanceController.text} ${_isMetric ? 'km' : 'mi'}'),
                      _buildDetailRow('Avg Speed', '${_speedController.text} ${_isMetric ? 'km/h' : 'mph'}'),
                      _buildDetailRow('Duration', _formatDuration(_timeHours!)),
                      _buildDetailRow('Decimal Hours', '${_timeHours!.toStringAsFixed(2)} hrs'),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
