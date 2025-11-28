import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class CurrencyConverter extends ConsumerStatefulWidget {
  const CurrencyConverter({super.key});

  @override
  ConsumerState<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends ConsumerState<CurrencyConverter> {
  final _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double? _result;
  bool _isLoading = false;
  Map<String, double> _rates = {};

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF', 'CNY', 'INR'];

  @override
  void initState() {
    super.initState();
    _fetchRates();
  }

  Future<void> _fetchRates() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _rates = Map<String, double>.from(data['rates']);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load rates: $e')),
        );
      }
    }
  }

  void _calculate() {
    if (_amountController.text.isEmpty || _rates.isEmpty) return;

    final amount = double.tryParse(_amountController.text);
    if (amount == null) return;

    final fromRate = _rates[_fromCurrency] ?? 1.0;
    final toRate = _rates[_toCurrency] ?? 1.0;

    // Convert to USD first (since base is USD), then to target
    final amountInUSD = amount / fromRate;
    final finalAmount = amountInUSD * toRate;

    setState(() {
      _result = finalAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currency Converter')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _fromCurrency,
                          decoration: const InputDecoration(
                            labelText: 'From',
                            border: OutlineInputBorder(),
                          ),
                          items: _currencies.map((c) {
                            return DropdownMenuItem(value: c, child: Text(c));
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _fromCurrency = value!);
                            _calculate();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.arrow_forward),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _toCurrency,
                          decoration: const InputDecoration(
                            labelText: 'To',
                            border: OutlineInputBorder(),
                          ),
                          items: _currencies.map((c) {
                            return DropdownMenuItem(value: c, child: Text(c));
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _toCurrency = value!);
                            _calculate();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (_result != null)
                    Card(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text(
                              '${_amountController.text} $_fromCurrency =',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_result!.toStringAsFixed(2)} $_toCurrency',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                                  ),
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
