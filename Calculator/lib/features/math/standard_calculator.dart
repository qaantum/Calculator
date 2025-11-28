import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:auto_size_text/auto_size_text.dart';

class StandardCalculator extends StatefulWidget {
  const StandardCalculator({super.key});

  @override
  State<StandardCalculator> createState() => _StandardCalculatorState();
}

class _StandardCalculatorState extends State<StandardCalculator> {
  String _input = '0';
  String _result = '';
  String _expression = '';

  void _onPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _input = '0';
        _result = '';
        _expression = '';
      } else if (buttonText == '⌫') {
        if (_input.length > 1) {
          _input = _input.substring(0, _input.length - 1);
        } else {
          _input = '0';
        }
      } else if (buttonText == '=') {
        _calculate();
      } else {
        if (_input == '0' && !_isOperator(buttonText)) {
          _input = buttonText;
        } else {
          _input += buttonText;
        }
      }
    });
  }

  bool _isOperator(String x) {
    return x == '/' || x == '*' || x == '-' || x == '+';
  }

  void _calculate() {
    try {
      String finalInput = _input;
      finalInput = finalInput.replaceAll('×', '*');
      finalInput = finalInput.replaceAll('÷', '/');

      Parser p = Parser();
      Expression exp = p.parse(finalInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        _expression = _input;
        // Remove decimal if integer
        if (eval % 1 == 0) {
          _result = eval.toInt().toString();
        } else {
          _result = eval.toString();
        }
        _input = _result;
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Standard Calculator')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: TextStyle(fontSize: 24, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  AutoSizeText(
                    _input,
                    style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                _buildRow(['C', '÷', '×', '⌫']),
                _buildRow(['7', '8', '9', '-']),
                _buildRow(['4', '5', '6', '+']),
                _buildRow(['1', '2', '3', '=']),
                _buildRow(['%', '0', '.', '']), // Empty for layout balance if needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((text) {
          if (text.isEmpty) return const Spacer();
          return Expanded(
            child: InkWell(
              onTap: () => _onPressed(text),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: _getButtonColor(text, context),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color? _getButtonColor(String text, BuildContext context) {
    if (_isOperator(text) || text == '=' || text == '÷' || text == '×') {
      return Theme.of(context).colorScheme.primary;
    }
    if (text == 'C' || text == '⌫') {
      return Theme.of(context).colorScheme.error;
    }
    return null; // Default text color
  }
}
