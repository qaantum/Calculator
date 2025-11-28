import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CaseConverter extends ConsumerStatefulWidget {
  const CaseConverter({super.key});

  @override
  ConsumerState<CaseConverter> createState() => _CaseConverterState();
}

class _CaseConverterState extends ConsumerState<CaseConverter> {
  final _controller = TextEditingController();
  String _convertedText = '';

  void _convert(String type) {
    final text = _controller.text;
    String result = '';

    switch (type) {
      case 'upper':
        result = text.toUpperCase();
        break;
      case 'lower':
        result = text.toLowerCase();
        break;
      case 'title':
        result = text.split(' ').map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        }).join(' ');
        break;
      case 'sentence':
        result = text.split(RegExp(r'(?<=[.!?])\s+')).map((sentence) {
          if (sentence.isEmpty) return '';
          return sentence[0].toUpperCase() + sentence.substring(1).toLowerCase();
        }).join(' ');
        break;
      case 'inverse':
        result = text.split('').map((char) {
          if (char == char.toUpperCase()) return char.toLowerCase();
          return char.toUpperCase();
        }).join('');
        break;
    }

    setState(() {
      _convertedText = result;
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _convertedText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Case Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter text here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(onPressed: () => _convert('upper'), child: const Text('UPPERCASE')),
                ElevatedButton(onPressed: () => _convert('lower'), child: const Text('lowercase')),
                ElevatedButton(onPressed: () => _convert('title'), child: const Text('Title Case')),
                ElevatedButton(onPressed: () => _convert('sentence'), child: const Text('Sentence case')),
                ElevatedButton(onPressed: () => _convert('inverse'), child: const Text('iNVERSE cASE')),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Result:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                _convertedText.isEmpty ? 'Converted text will appear here' : _convertedText,
                style: TextStyle(color: _convertedText.isEmpty ? Colors.grey : null),
              ),
            ),
            const SizedBox(height: 16),
            if (_convertedText.isNotEmpty)
              ElevatedButton.icon(
                onPressed: _copyToClipboard,
                icon: const Icon(Icons.copy),
                label: const Text('Copy Result'),
              ),
          ],
        ),
      ),
    );
  }
}
