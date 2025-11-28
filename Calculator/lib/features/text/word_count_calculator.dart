import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordCountCalculator extends ConsumerStatefulWidget {
  const WordCountCalculator({super.key});

  @override
  ConsumerState<WordCountCalculator> createState() => _WordCountCalculatorState();
}

class _WordCountCalculatorState extends ConsumerState<WordCountCalculator> {
  final _controller = TextEditingController();

  int _words = 0;
  int _chars = 0;
  int _charsNoSpace = 0;
  int _sentences = 0;
  int _paragraphs = 0;

  void _analyze() {
    final text = _controller.text;
    
    setState(() {
      _chars = text.length;
      _charsNoSpace = text.replaceAll(RegExp(r'\s'), '').length;
      
      if (text.trim().isEmpty) {
        _words = 0;
        _sentences = 0;
        _paragraphs = 0;
      } else {
        _words = text.trim().split(RegExp(r'\s+')).length;
        _sentences = text.split(RegExp(r'[.!?]+')).where((s) => s.trim().isNotEmpty).length;
        _paragraphs = text.split('\n').where((s) => s.trim().isNotEmpty).length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word Count')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Enter text here...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                onChanged: (_) => _analyze(),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.teal.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('Words', _words),
                    _buildStat('Chars', _chars),
                    _buildStat('Sentences', _sentences),
                    _buildStat('Paragraphs', _paragraphs),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, int value) {
    return Column(
      children: [
        Text(value.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}
