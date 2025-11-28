import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

class ReverseTextGenerator extends StatefulWidget {
  const ReverseTextGenerator({super.key});

  @override
  State<ReverseTextGenerator> createState() => _ReverseTextGeneratorState();
}

class _ReverseTextGeneratorState extends State<ReverseTextGenerator> {
  final _controller = TextEditingController();
  String _result = '';

  void _reverse() {
    setState(() {
      _result = _controller.text.split('').reversed.join('');
    });
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: _result));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reverse Text'),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Enter Text',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (v) => _reverse(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_result.isNotEmpty)
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Result', style: Theme.of(context).textTheme.titleMedium),
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.copy),
                            onPressed: _copy,
                          ),
                        ],
                      ),
                      const Divider(),
                      Text(
                        _result,
                        style: const TextStyle(fontSize: 18),
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
