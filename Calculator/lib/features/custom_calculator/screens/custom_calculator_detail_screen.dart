import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/custom_calculator_model.dart';
import '../services/math_engine.dart';
import '../services/custom_calculator_service.dart';
import 'custom_calculator_builder_screen.dart';
import '../../../../ui/widgets/formula_graph_widget.dart';

class CustomCalculatorDetailScreen extends StatefulWidget {
  final CustomCalculator? calculator;
  final String? calculatorId;

  const CustomCalculatorDetailScreen({super.key, this.calculator, this.calculatorId});

  @override
  State<CustomCalculatorDetailScreen> createState() => _CustomCalculatorDetailScreenState();
}

class _CustomCalculatorDetailScreenState extends State<CustomCalculatorDetailScreen> {
  CustomCalculator? _calculator;
  Map<String, TextEditingController> _controllers = {};
  String _result = '';
  String? _error;
  bool _loading = true;
  
  // Graph State
  String? _graphXAxisVariable;

  @override
  void initState() {
    super.initState();
    _loadCalculator();
  }

  Future<void> _loadCalculator() async {
    CustomCalculator? loaded;
    if (widget.calculator != null) {
      loaded = widget.calculator;
      // If we have an ID, try to fetch fresh data in case it was edited
      if (loaded != null) {
        final fresh = await CustomCalculatorService().getById(loaded.id);
        if (fresh != null) loaded = fresh;
      }
    } else if (widget.calculatorId != null) {
      loaded = await CustomCalculatorService().getById(widget.calculatorId!);
      if (loaded == null) {
        _error = 'Calculator not found';
      }
    }

    _calculator = loaded;

    if (_calculator != null) {
      // Load last used values
      final lastValues = await CustomCalculatorService().getLastValues(_calculator!.id);
      
      // Re-initialize controllers map to handle variable changes (add/remove)
      final newControllers = <String, TextEditingController>{};
      
      for (var v in _calculator!.inputs) {
        String initialValue = v.defaultValue;
        // Preserve current input if editing, otherwise load last value
        if (_controllers.containsKey(v.name)) {
           initialValue = _controllers[v.name]!.text;
        } else if (lastValues.containsKey(v.name)) {
          initialValue = lastValues[v.name]!.toString();
          if (v.type == VariableType.integer && initialValue.endsWith('.0')) {
            initialValue = initialValue.substring(0, initialValue.length - 2);
          }
        }
        newControllers[v.name] = TextEditingController(text: initialValue);
      }
      
      // Dispose old controllers that are no longer needed
      for (var key in _controllers.keys) {
        if (!newControllers.containsKey(key)) {
          _controllers[key]!.dispose();
        }
      }
      _controllers = newControllers;
    }
    
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _calculate() async {
    setState(() {
      _error = null;
      _result = '';
    });

    final Map<String, double> inputs = {};
    for (var v in _calculator!.inputs) {
      final text = _controllers[v.name]?.text ?? '';
      final val = double.tryParse(text);
      if (val == null) {
        setState(() => _error = 'Invalid value for ${v.name}');
        return;
      }

      // Validation
      if (v.min != null && val < v.min!) {
        setState(() => _error = '${v.name} must be >= ${v.min}');
        return;
      }
      if (v.max != null && val > v.max!) {
        setState(() => _error = '${v.name} must be <= ${v.max}');
        return;
      }

      inputs[v.name] = val;
    }

    // Save values
    await CustomCalculatorService().saveLastValues(_calculator!.id, inputs);

    final result = MathEngine.evaluate(_calculator!.formula, inputs);
    
    setState(() {
      if (result.isSuccess) {
        _result = result.value!.toStringAsFixed(4);
      } else {
        _error = result.error?.message ?? 'Unknown Error';
      }
    });
  }

  void _edit() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CustomCalculatorBuilderScreen(calculator: _calculator),
      ),
    );
    // Refresh data after returning from edit
    _loadCalculator();
  }

  void _duplicate() async {
    if (_calculator == null) return;
    
    // Create a copy with new ID and modified title
    final copy = CustomCalculator(
      id: const Uuid().v4(), // New ID
      title: '${_calculator!.title} (Copy)',
      iconCode: _calculator!.iconCode,
      iconFontFamily: _calculator!.iconFontFamily,
      iconFontPackage: _calculator!.iconFontPackage,
      inputs: List.from(_calculator!.inputs), // Shallow copy of list is fine as items are immutable
      formula: _calculator!.formula,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      pinned: false, // Don't pin copies by default
    );

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CustomCalculatorBuilderScreen(calculator: copy),
      ),
    );
    // No need to refresh current screen as we just created a NEW one. 
    // But if we want to show it, we'd need to navigate to it. 
    // For now, just returning to dashboard or staying here is fine.
    // Actually, usually you want to go back to the list to see the new one.
    if (mounted) {
      Navigator.of(context).pop(); // Go back to dashboard to see the new entry
    }
  }

  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Calculator?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      await CustomCalculatorService().deleteCalculator(_calculator!.id);
      if (mounted) {
        Navigator.of(context).pop(); // Return to dashboard
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    }
    
    if (_calculator == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(_error ?? 'Calculator not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_calculator!.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _edit,
            tooltip: 'Edit Calculator',
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _duplicate,
            tooltip: 'Duplicate Calculator',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _delete,
            tooltip: 'Delete Calculator',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Formula Display
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Formula',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _calculator!.formula,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Inputs
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (_calculator!.inputs.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('No variables defined.'),
                      ),
                    ..._calculator!.inputs.map((v) {
                      String helper = v.description ?? '';
                      if (v.min != null || v.max != null) {
                        String limits = '';
                        if (v.min != null && v.max != null) {
                          limits = 'Range: ${v.min} - ${v.max}';
                        } else if (v.min != null) {
                          limits = 'Min: ${v.min}';
                        } else if (v.max != null) {
                          limits = 'Max: ${v.max}';
                        }
                        
                        if (helper.isNotEmpty) {
                          helper += ' • $limits';
                        } else {
                          helper = limits;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextField(
                          controller: _controllers[v.name],
                          decoration: InputDecoration(
                            labelText: '${v.name} ${v.unitLabel != null ? '(${v.unitLabel})' : ''}',
                            helperText: helper.isNotEmpty ? helper : null,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: v.type == VariableType.number),
                          readOnly: v.type == VariableType.date,
                          onTap: v.type == VariableType.date ? () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              // Store as timestamp (seconds)
                              final timestamp = date.millisecondsSinceEpoch / 1000;
                              _controllers[v.name]!.text = timestamp.toString();
                            }
                          } : null,
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _calculate,
                        icon: const Icon(FontAwesomeIcons.calculator),
                        label: const Text('Calculate'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Result / Error
            if (_result.isNotEmpty || _error != null) ...[
              const SizedBox(height: 24),
              Card(
                color: _error != null ? Theme.of(context).colorScheme.errorContainer : Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        _error != null ? 'Error' : 'Result',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _error != null ? Theme.of(context).colorScheme.onErrorContainer : Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error ?? _result,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _error != null ? Theme.of(context).colorScheme.onErrorContainer : Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            // Graph Section
            if (_calculator!.inputs.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                child: ExpansionTile(
                  title: const Text('Visualize Formula'),
                  leading: const Icon(Icons.show_chart),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('X-Axis Variable: '),
                              const SizedBox(width: 8),
                              DropdownButton<String>(
                                value: _graphXAxisVariable ?? _calculator!.inputs.first.name,
                                items: _calculator!.inputs.map((v) => DropdownMenuItem(value: v.name, child: Text(v.name))).toList(),
                                onChanged: (v) => setState(() => _graphXAxisVariable = v),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 300,
                            child: FormulaGraphWidget(
                              formula: _calculator!.formula,
                              variables: _calculator!.inputs,
                              currentValues: {
                                for (var v in _calculator!.inputs)
                                  v.name: double.tryParse(_controllers[v.name]?.text ?? '0') ?? 0.0
                              },
                              xAxisVariable: _graphXAxisVariable ?? _calculator!.inputs.first.name,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
