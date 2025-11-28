import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Base64Converter extends ConsumerStatefulWidget {
  const Base64Converter({super.key});

  @override
  ConsumerState<Base64Converter> createState() => _Base64ConverterState();
}

class _Base64ConverterState extends ConsumerState<Base64Converter> {
  final _textController = TextEditingController();
  final _base64Controller = TextEditingController();
  bool _isUpdating = false;

  void _onTextChanged(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    try {
      if (value.isEmpty) {
        _base64Controller.clear();
      } else {
        final bytes = utf8.encode(value);
        final base64Str = base64.encode(bytes);
        _base64Controller.text = base64Str;
      }
    } catch (e) {
      // Ignore errors during typing
    }

    _isUpdating = false;
  }

  void _onBase64Changed(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    try {
      if (value.isEmpty) {
        _textController.clear();
      } else {
        final bytes = base64.decode(value);
        final textStr = utf8.decode(bytes);
        _textController.text = textStr;
      }
    } catch (e) {
      // Ignore errors (invalid base64)
    }

    _isUpdating = false;
  }

  void _copy(TextEditingController controller) {
    Clipboard.setData(ClipboardData(text: controller.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Base64 Encoder/Decoder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Plain Text', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter text to encode...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () => _copy(_textController),
                  ),
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                onChanged: _onTextChanged,
              ),
            ),
            const SizedBox(height: 16),
            const Icon(Icons.swap_vert),
            const SizedBox(height: 16),
            const Text('Base64', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _base64Controller,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter Base64 to decode...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () => _copy(_base64Controller),
                  ),
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                onChanged: _onBase64Changed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
