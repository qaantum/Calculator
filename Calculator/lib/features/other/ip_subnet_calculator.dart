import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IPSubnetCalculator extends ConsumerStatefulWidget {
  const IPSubnetCalculator({super.key});

  @override
  ConsumerState<IPSubnetCalculator> createState() => _IPSubnetCalculatorState();
}

class _IPSubnetCalculatorState extends ConsumerState<IPSubnetCalculator> {
  final _ipController = TextEditingController();
  final _cidrController = TextEditingController(text: '24');

  String _networkAddress = '---';
  String _broadcastAddress = '---';
  String _firstHost = '---';
  String _lastHost = '---';
  String _totalHosts = '---';
  String _subnetMask = '---';

  void _calculate() {
    final ipText = _ipController.text.trim();
    final cidrText = _cidrController.text.trim();

    final cidr = int.tryParse(cidrText);

    if (ipText.isEmpty || cidr == null || cidr < 0 || cidr > 32) {
      _reset();
      return;
    }

    final parts = ipText.split('.');
    if (parts.length != 4) {
      _reset();
      return;
    }

    try {
      final octets = parts.map((e) => int.parse(e)).toList();
      if (octets.any((e) => e < 0 || e > 255)) {
        _reset();
        return;
      }

      // Calculate Subnet Mask
      final mask = (0xFFFFFFFF << (32 - cidr)) & 0xFFFFFFFF;
      final maskOctets = [
        (mask >> 24) & 0xFF,
        (mask >> 16) & 0xFF,
        (mask >> 8) & 0xFF,
        mask & 0xFF,
      ];

      // Calculate Network Address
      final ipVal = (octets[0] << 24) | (octets[1] << 16) | (octets[2] << 8) | octets[3];
      final networkVal = ipVal & mask;
      final networkOctets = [
        (networkVal >> 24) & 0xFF,
        (networkVal >> 16) & 0xFF,
        (networkVal >> 8) & 0xFF,
        networkVal & 0xFF,
      ];

      // Calculate Broadcast Address
      final wildcard = ~mask & 0xFFFFFFFF;
      final broadcastVal = networkVal | wildcard;
      final broadcastOctets = [
        (broadcastVal >> 24) & 0xFF,
        (broadcastVal >> 16) & 0xFF,
        (broadcastVal >> 8) & 0xFF,
        broadcastVal & 0xFF,
      ];

      // Hosts
      final hostsCount = pow(2, 32 - cidr) - 2;
      final firstHostVal = networkVal + 1;
      final lastHostVal = broadcastVal - 1;

      final firstHostOctets = [
        (firstHostVal >> 24) & 0xFF,
        (firstHostVal >> 16) & 0xFF,
        (firstHostVal >> 8) & 0xFF,
        firstHostVal & 0xFF,
      ];

      final lastHostOctets = [
        (lastHostVal >> 24) & 0xFF,
        (lastHostVal >> 16) & 0xFF,
        (lastHostVal >> 8) & 0xFF,
        lastHostVal & 0xFF,
      ];

      setState(() {
        _subnetMask = maskOctets.join('.');
        _networkAddress = networkOctets.join('.');
        _broadcastAddress = broadcastOctets.join('.');
        _totalHosts = hostsCount > 0 ? hostsCount.toString() : '0';
        _firstHost = hostsCount > 0 ? firstHostOctets.join('.') : 'N/A';
        _lastHost = hostsCount > 0 ? lastHostOctets.join('.') : 'N/A';
      });
    } catch (e) {
      _reset();
    }
  }

  void _reset() {
    setState(() {
      _networkAddress = '---';
      _broadcastAddress = '---';
      _firstHost = '---';
      _lastHost = '---';
      _totalHosts = '---';
      _subnetMask = '---';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IP Subnet Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _ipController,
                    decoration: const InputDecoration(
                      labelText: 'IP Address',
                      hintText: '192.168.1.1',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('/', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _cidrController,
                    decoration: const InputDecoration(
                      labelText: 'CIDR',
                      hintText: '24',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildResultRow('Subnet Mask', _subnetMask),
                    const Divider(),
                    _buildResultRow('Network Address', _networkAddress),
                    const Divider(),
                    _buildResultRow('Broadcast Address', _broadcastAddress),
                    const Divider(),
                    _buildResultRow('Total Hosts', _totalHosts),
                    const Divider(),
                    _buildResultRow('First Host', _firstHost),
                    const Divider(),
                    _buildResultRow('Last Host', _lastHost),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontFamily: 'monospace')),
        ],
      ),
    );
  }
}
