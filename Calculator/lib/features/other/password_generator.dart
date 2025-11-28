import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordGenerator extends ConsumerStatefulWidget {
  const PasswordGenerator({super.key});

  @override
  ConsumerState<PasswordGenerator> createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends ConsumerState<PasswordGenerator> {
  double _length = 12;
  bool _uppercase = true;
  bool _lowercase = true;
  bool _numbers = true;
  bool _symbols = true;

  String _password = '';

  void _generate() {
    const lower = 'abcdefghijklmnopqrstuvwxyz';
    const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = '';
    if (_lowercase) chars += lower;
    if (_uppercase) chars += upper;
    if (_numbers) chars += numbers;
    if (_symbols) chars += symbols;

    if (chars.isEmpty) {
      setState(() => _password = '');
      return;
    }

    final rng = Random.secure();
    String password = '';
    for (int i = 0; i < _length.round(); i++) {
      password += chars[rng.nextInt(chars.length)];
    }

    setState(() {
      _password = password;
    });
  }

  void _copyToClipboard() {
    if (_password.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _password));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password copied to clipboard')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _generate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Password Generator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    SelectableText(
                      _password,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filledTonal(
                          onPressed: _generate,
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Regenerate',
                        ),
                        const SizedBox(width: 16),
                        IconButton.filledTonal(
                          onPressed: _copyToClipboard,
                          icon: const Icon(Icons.copy),
                          tooltip: 'Copy',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text('Length: ${_length.round()}', style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: _length,
              min: 4,
              max: 32,
              divisions: 28,
              label: _length.round().toString(),
              onChanged: (value) {
                setState(() => _length = value);
                _generate();
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Uppercase (A-Z)'),
              value: _uppercase,
              onChanged: (value) {
                setState(() => _uppercase = value);
                _generate();
              },
            ),
            SwitchListTile(
              title: const Text('Lowercase (a-z)'),
              value: _lowercase,
              onChanged: (value) {
                setState(() => _lowercase = value);
                _generate();
              },
            ),
            SwitchListTile(
              title: const Text('Numbers (0-9)'),
              value: _numbers,
              onChanged: (value) {
                setState(() => _numbers = value);
                _generate();
              },
            ),
            SwitchListTile(
              title: const Text('Symbols (!@#\$)'),
              value: _symbols,
              onChanged: (value) {
                setState(() => _symbols = value);
                _generate();
              },
            ),
          ],
        ),
      ),
    );
  }
}
