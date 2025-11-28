import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoremIpsumGenerator extends ConsumerStatefulWidget {
  const LoremIpsumGenerator({super.key});

  @override
  ConsumerState<LoremIpsumGenerator> createState() => _LoremIpsumGeneratorState();
}

class _LoremIpsumGeneratorState extends ConsumerState<LoremIpsumGenerator> {
  final _countController = TextEditingController(text: '1');
  String _type = 'paragraphs'; // paragraphs, sentences, words
  String _result = '';

  static const String _lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  void _generate() {
    int count = int.tryParse(_countController.text) ?? 1;
    if (count < 1) count = 1;
    if (count > 100) count = 100; // Limit

    String generated = '';

    if (_type == 'paragraphs') {
      generated = List.generate(count, (index) => _lorem).join('\n\n');
    } else if (_type == 'sentences') {
      final sentences = _lorem.split('. ');
      generated = List.generate(count, (index) => sentences[index % sentences.length].trim() + '.').join(' ');
    } else if (_type == 'words') {
      final words = _lorem.replaceAll('.', '').replaceAll(',', '').split(' ');
      generated = List.generate(count, (index) => words[index % words.length]).join(' ');
    }

    setState(() {
      _result = generated;
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _result));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard!')),
    );
  }

  @override
  void initState() {
    super.initState();
    _generate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lorem Ipsum Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _countController,
                    decoration: const InputDecoration(labelText: 'Count', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _generate(),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _type,
                  items: const [
                    DropdownMenuItem(value: 'paragraphs', child: Text('Paragraphs')),
                    DropdownMenuItem(value: 'sentences', child: Text('Sentences')),
                    DropdownMenuItem(value: 'words', child: Text('Words')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _type = val;
                        _generate();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(_result),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _copyToClipboard,
              icon: const Icon(Icons.copy),
              label: const Text('Copy Text'),
            ),
          ],
        ),
      ),
    );
  }
}
