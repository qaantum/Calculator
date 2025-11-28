import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ScientificCalculator extends StatefulWidget {
  const ScientificCalculator({super.key});

  @override
  State<ScientificCalculator> createState() => _ScientificCalculatorState();
}

class _ScientificCalculatorState extends State<ScientificCalculator> {
  String _input = '0';
  String _result = '';
  
  void _onPressed(String text) {
    setState(() {
      if (text == 'C') {
        _input = '0';
        _result = '';
      } else if (text == '⌫') {
        if (_input.length > 1) {
          _input = _input.substring(0, _input.length - 1);
        } else {
          _input = '0';
        }
      } else if (text == '=') {
        _calculate();
      } else {
        if (_input == '0' && !_isOperator(text)) {
          _input = text;
        } else {
          _input += text;
        }
      }
    });
  }

  bool _isOperator(String x) {
    return ['+', '-', '*', '/', '^', '(', ')'].contains(x);
  }

  void _calculate() {
    try {
      String finalInput = _input;
      finalInput = finalInput.replaceAll('×', '*');
      finalInput = finalInput.replaceAll('÷', '/');
      finalInput = finalInput.replaceAll('π', '3.14159265');
      finalInput = finalInput.replaceAll('e', '2.71828182');
      
      // Handle functions
      // math_expressions supports sin, cos, tan, log, ln, sqrt etc.
      
      Parser p = Parser();
      Expression exp = p.parse(finalInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
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
      appBar: AppBar(title: const Text('Scientific Calculator')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: AutoSizeText(
                _input,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                maxLines: 2,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                _buildRow(['C', '(', ')', '⌫']),
                _buildRow(['sin', 'cos', 'tan', '^']),
                _buildRow(['ln', 'log', 'sqrt', '/']),
                _buildRow(['7', '8', '9', '*']),
                _buildRow(['4', '5', '6', '-']),
                _buildRow(['1', '2', '3', '+']),
                _buildRow(['0', '.', 'π', '=']),
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
          return Expanded(
            child: InkWell(
              onTap: () => _onPressed(text),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
                ),
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: _getButtonColor(text, context),
                    ),
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
    if (['=', '+', '-', '*', '/', '^'].contains(text)) {
      return Theme.of(context).colorScheme.primary;
    }
    if (text == 'C' || text == '⌫') {
      return Theme.of(context).colorScheme.error;
    }
    if (['sin', 'cos', 'tan', 'ln', 'log', 'sqrt', '(', ')', 'π'].contains(text)) {
      return Theme.of(context).colorScheme.secondary;
    }
    return null;
  }
}
