import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JsonFormatter extends ConsumerStatefulWidget {
  const JsonFormatter({super.key});

  @override
  ConsumerState<JsonFormatter> createState() => _JsonFormatterState();
}

class _JsonFormatterState extends ConsumerState<JsonFormatter> {
  final _inputController = TextEditingController();
  final _outputController = TextEditingController();
  String _status = 'Ready';
  Color _statusColor = Colors.grey;

  void _format() {
    final input = _inputController.text;
    if (input.isEmpty) {
      setState(() {
        _outputController.clear();
        _status = 'Ready';
        _statusColor = Colors.grey;
      });
      return;
    }

    try {
      final object = json.decode(input);
      final prettyString = const JsonEncoder.withIndent('  ').convert(object);
      _outputController.text = prettyString;
      setState(() {
        _status = 'Valid JSON';
        _statusColor = Colors.green;
      });
    } catch (e) {
      setState(() {
        _status = 'Invalid JSON: ${e.toString()}';
        _statusColor = Colors.red;
      });
    }
  }

  void _minify() {
    final input = _inputController.text;
    if (input.isEmpty) return;

    try {
      final object = json.decode(input);
      final minifiedString = json.encode(object);
      _outputController.text = minifiedString;
      setState(() {
        _status = 'Valid JSON (Minified)';
        _statusColor = Colors.green;
      });
    } catch (e) {
      setState(() {
        _status = 'Invalid JSON: ${e.toString()}';
        _statusColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JSON Formatter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _format,
                    icon: const Icon(Icons.format_align_left),
                    label: const Text('Format (Pretty)'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _minify,
                    icon: const Icon(Icons.compress),
                    label: const Text('Minify'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _status,
              style: TextStyle(color: _statusColor, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Input', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: TextField(
                            controller: _inputController,
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Paste JSON here...',
                            ),
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Output', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: TextField(
                            controller: _outputController,
                            maxLines: null,
                            expands: true,
                            readOnly: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: _outputController.text));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Copied to clipboard!')),
                                  );
                                },
                              ),
                            ),
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
