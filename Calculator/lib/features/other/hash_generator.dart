import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/widgets/pin_button.dart';

class HashGenerator extends ConsumerStatefulWidget {
  const HashGenerator({super.key});

  @override
  ConsumerState<HashGenerator> createState() => _HashGeneratorState();
}

class _HashGeneratorState extends ConsumerState<HashGenerator> {
  final _inputController = TextEditingController();
  
  String? _md5Hash;
  String? _sha1Hash;
  String? _sha256Hash;
  String? _sha512Hash;

  void _generateHashes() {
    final input = _inputController.text;
    if (input.isEmpty) {
      setState(() {
        _md5Hash = null;
        _sha1Hash = null;
        _sha256Hash = null;
        _sha512Hash = null;
      });
      return;
    }
    
    final bytes = utf8.encode(input);
    
    setState(() {
      _md5Hash = md5.convert(bytes).toString();
      _sha1Hash = sha1.convert(bytes).toString();
      _sha256Hash = sha256.convert(bytes).toString();
      _sha512Hash = sha512.convert(bytes).toString();
    });
  }

  void _copyToClipboard(String value, String name) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hash Generator'),
        actions: const [PinButton(route: '/other/hash')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                labelText: 'Input Text',
                hintText: 'Enter text to hash',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              onChanged: (_) => _generateHashes(),
            ),
            if (_md5Hash != null) ...[
              const SizedBox(height: 24),
              _buildHashCard('MD5', _md5Hash!, Colors.blue),
              const SizedBox(height: 12),
              _buildHashCard('SHA-1', _sha1Hash!, Colors.orange),
              const SizedBox(height: 12),
              _buildHashCard('SHA-256', _sha256Hash!, Colors.green),
              const SizedBox(height: 12),
              _buildHashCard('SHA-512', _sha512Hash!, Colors.purple),
            ],
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About Hash Functions', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    const Text(
                      '• MD5: 128-bit, fast but not secure for passwords\n'
                      '• SHA-1: 160-bit, deprecated for security\n'
                      '• SHA-256: 256-bit, widely used and secure\n'
                      '• SHA-512: 512-bit, most secure option',
                      style: TextStyle(fontSize: 12),
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

  Widget _buildHashCard(String name, String hash, Color color) {
    return Card(
      child: InkWell(
        onTap: () => _copyToClipboard(hash, name),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  Icon(Icons.copy, size: 20, color: Theme.of(context).disabledColor),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                hash,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
