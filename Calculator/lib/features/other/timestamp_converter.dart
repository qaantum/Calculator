import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimestampConverter extends ConsumerStatefulWidget {
  const TimestampConverter({super.key});

  @override
  ConsumerState<TimestampConverter> createState() => _TimestampConverterState();
}

class _TimestampConverterState extends ConsumerState<TimestampConverter> {
  final _timestampController = TextEditingController();
  final _dateController = TextEditingController();
  bool _isUpdating = false;
  bool _isMilliseconds = false;

  DateTime? _currentDate;
  int? _currentTimestamp;

  @override
  void initState() {
    super.initState();
    _setCurrentTime();
  }

  void _setCurrentTime() {
    final now = DateTime.now();
    _currentDate = now;
    _currentTimestamp = _isMilliseconds ? now.millisecondsSinceEpoch : now.millisecondsSinceEpoch ~/ 1000;
    _timestampController.text = _currentTimestamp.toString();
    _dateController.text = _formatDateTime(now);
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }

  void _onTimestampChanged(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    final timestamp = int.tryParse(value);
    if (timestamp != null) {
      final milliseconds = _isMilliseconds ? timestamp : timestamp * 1000;
      try {
        _currentDate = DateTime.fromMillisecondsSinceEpoch(milliseconds);
        _currentTimestamp = timestamp;
        _dateController.text = _formatDateTime(_currentDate!);
      } catch (e) {
        // Invalid timestamp
      }
    }

    _isUpdating = false;
    setState(() {});
  }

  void _toggleUnit() {
    setState(() {
      _isMilliseconds = !_isMilliseconds;
      if (_currentTimestamp != null) {
        _currentTimestamp = _isMilliseconds 
            ? _currentTimestamp! * 1000 
            : _currentTimestamp! ~/ 1000;
        _timestampController.text = _currentTimestamp.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timestamp Converter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Convert between Unix timestamps and human-readable dates.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Seconds')),
                ButtonSegment(value: true, label: Text('Milliseconds')),
              ],
              selected: {_isMilliseconds},
              onSelectionChanged: (Set<bool> newSelection) => _toggleUnit(),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _timestampController,
              decoration: InputDecoration(
                labelText: 'Unix Timestamp (${_isMilliseconds ? 'ms' : 's'})',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _setCurrentTime,
                  tooltip: 'Set to now',
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: _onTimestampChanged,
            ),
            const SizedBox(height: 16),
            const Icon(Icons.swap_vert, size: 32),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Date & Time (Local)',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 24),
            if (_currentDate != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Details:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('UTC: ${_currentDate!.toUtc()}'),
                      Text('Local: ${_currentDate!.toLocal()}'),
                      Text('Day of Week: ${_getDayOfWeek(_currentDate!.weekday)}'),
                      Text('ISO 8601: ${_currentDate!.toIso8601String()}'),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _setCurrentTime();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Set to current time'), duration: Duration(seconds: 1)),
                );
              },
              icon: const Icon(Icons.access_time),
              label: const Text('Use Current Time'),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayOfWeek(int day) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[day - 1];
  }
}
