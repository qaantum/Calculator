import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/custom_calculator_model.dart';
import '../services/custom_calculator_service.dart';
import '../services/math_engine.dart';

class CustomCalculatorBuilderScreen extends StatefulWidget {
  final CustomCalculator? calculator; // Optional: for editing

  const CustomCalculatorBuilderScreen({super.key, this.calculator});

  @override
  State<CustomCalculatorBuilderScreen> createState() => _CustomCalculatorBuilderScreenState();
}

class _CustomCalculatorBuilderScreenState extends State<CustomCalculatorBuilderScreen> {
  final _titleController = TextEditingController();
  final _formulaController = TextEditingController();
  
  // State for variables
  final List<CalculatorVariable> _variables = [];
  
  // Variable Creation State
  final _varNameController = TextEditingController();
  final _varDescController = TextEditingController();
  final _varUnitController = TextEditingController();
  final _varMinController = TextEditingController();
  final _varMaxController = TextEditingController();
  VariableType _varType = VariableType.number;

  // State for Playground
  final Map<String, TextEditingController> _playgroundControllers = {};
  String _playgroundResult = '';
  String? _error;

  // Icon Selection
  IconData _selectedIcon = FontAwesomeIcons.calculator;
  final List<IconData> _availableIcons = [
    FontAwesomeIcons.calculator,
    FontAwesomeIcons.flask,
    FontAwesomeIcons.chartLine,
    FontAwesomeIcons.ruler,
    FontAwesomeIcons.hammer,
    FontAwesomeIcons.heartPulse,
    FontAwesomeIcons.pizzaSlice,
    FontAwesomeIcons.car,
    FontAwesomeIcons.plane,
    FontAwesomeIcons.music,
    FontAwesomeIcons.code,
    FontAwesomeIcons.gamepad,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.calculator != null) {
      _loadCalculator(widget.calculator!);
    }
  }

  void _loadCalculator(CustomCalculator c) {
    _titleController.text = c.title;
    _formulaController.text = c.formula;
    _selectedIcon = IconData(c.iconCode, fontFamily: c.iconFontFamily, fontPackage: c.iconFontPackage);
    
    setState(() {
      _variables.addAll(c.inputs);
      for (var v in _variables) {
        _playgroundControllers[v.name] = TextEditingController();
      }
    });
  }

  void _addVariable() {
    final name = _varNameController.text.trim();
    // Validate reserved words
    final reserved = ['pi', 'e', 'log', 'root', 'deriv', 'integrate'];
    if (reserved.contains(name.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('"$name" is a reserved word')));
      return;
    }
    
    if (name.isEmpty) return;
    if (_variables.any((v) => v.name == name)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Variable name already exists')));
      return;
    }

    setState(() {
      _variables.add(CalculatorVariable(
        name: name,
        description: _varDescController.text.trim().isEmpty ? null : _varDescController.text.trim(),
        unitLabel: _varUnitController.text.trim().isEmpty ? null : _varUnitController.text.trim(),
        min: double.tryParse(_varMinController.text),
        max: double.tryParse(_varMaxController.text),
        type: _varType,
      ));
      _playgroundControllers[name] = TextEditingController();
      
      // Reset inputs
      _varNameController.clear();
      _varDescController.clear();
      _varUnitController.clear();
      _varMinController.clear();
      _varMaxController.clear();
      _varType = VariableType.number;
    });
  }

  void _removeVariable(int index) {
    setState(() {
      final name = _variables[index].name;
      _variables.removeAt(index);
      _playgroundControllers.remove(name);
    });
  }

  void _runPlayground() {
    // UX Improvement: Check if user forgot to click "Add Variable"
    if (_variables.isEmpty && _varNameController.text.isNotEmpty) {
      setState(() {
        _error = 'Please click "+ Add Variable" to use "${_varNameController.text}"';
      });
      return;
    }

    setState(() {
      _error = null;
      _playgroundResult = '';
    });

    final Map<String, double> inputs = {};
    for (var v in _variables) {
      final text = _playgroundControllers[v.name]?.text.trim() ?? '';
      if (text.isEmpty) {
        setState(() => _error = 'Please enter a value for ${v.name}');
        return;
      }
      final val = double.tryParse(text);
      if (val == null) {
        setState(() => _error = 'Invalid number format for ${v.name}');
        return;
      }
      
      // Validate Min/Max
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

    final result = MathEngine.evaluate(_formulaController.text, inputs);
    
    setState(() {
      if (result.isSuccess) {
        _playgroundResult = result.value!.toStringAsFixed(4);
      } else {
        _error = result.error?.message ?? 'Unknown Error';
      }
    });
  }

  Future<void> _saveCalculator() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }
    if (_formulaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a formula')));
      return;
    }

    final newCalc = CustomCalculator(
      id: widget.calculator?.id ?? const Uuid().v4(), // Keep ID if editing
      title: _titleController.text,
      iconCode: _selectedIcon.codePoint,
      iconFontFamily: _selectedIcon.fontFamily,
      iconFontPackage: _selectedIcon.fontPackage,
      inputs: _variables,
      formula: _formulaController.text,
      createdAt: widget.calculator?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      pinned: widget.calculator?.pinned ?? false,
    );

    await CustomCalculatorService().saveCalculator(newCalc);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.calculator == null ? 'Build Calculator' : 'Edit Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveCalculator,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Metadata Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _showIconPicker(),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: FaIcon(_selectedIcon),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Calculator Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Variables Section
            const Text('1. Define Variables', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: TextField(controller: _varNameController, decoration: const InputDecoration(labelText: 'Name (e.g. x)', isDense: true))),
                        const SizedBox(width: 8),
                        Expanded(child: TextField(controller: _varUnitController, decoration: const InputDecoration(labelText: 'Unit (e.g. kg)', isDense: true))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(controller: _varDescController, decoration: const InputDecoration(labelText: 'Description (optional)', isDense: true)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: _varMinController, decoration: const InputDecoration(labelText: 'Min', isDense: true), keyboardType: TextInputType.number)),
                        const SizedBox(width: 8),
                        Expanded(child: TextField(controller: _varMaxController, decoration: const InputDecoration(labelText: 'Max', isDense: true), keyboardType: TextInputType.number)),
                        const SizedBox(width: 8),
                        DropdownButton<VariableType>(
                          value: _varType,
                          items: VariableType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                          onChanged: (v) => setState(() => _varType = v!),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(onPressed: _addVariable, icon: const Icon(Icons.add), label: const Text('Add Variable')),
                  ],
                ),
              ),
            ),
            if (_variables.isNotEmpty)
              Wrap(
                spacing: 8,
                children: _variables.asMap().entries.map((entry) {
                  return Chip(
                    label: Text('${entry.value.name} (${entry.value.unitLabel ?? ''})'),
                    onDeleted: () => _removeVariable(entry.key),
                  );
                }).toList(),
              ),
            const SizedBox(height: 24),

            // 3. Formula Section
            const Text('2. Write Formula', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _formulaController,
              decoration: const InputDecoration(
                labelText: 'Formula',
                hintText: 'e.g. x^2 + y or integrate(x^2, x, 0, 5)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(label: const Text('+'), onPressed: () => _insertText(' + ')),
                ActionChip(label: const Text('-'), onPressed: () => _insertText(' - ')),
                ActionChip(label: const Text('*'), onPressed: () => _insertText(' * ')),
                ActionChip(label: const Text('/'), onPressed: () => _insertText(' / ')),
                ActionChip(label: const Text('^'), onPressed: () => _insertText('^')),
                ActionChip(label: const Text('sqrt'), onPressed: () => _insertText('sqrt()')),
                ActionChip(label: const Text('log'), onPressed: () => _insertText('log(val, base)')),
                ActionChip(label: const Text('root'), onPressed: () => _insertText('root(val, n)')),
                ActionChip(label: const Text('∫ dx'), onPressed: () => _insertText('integrate(expr, var, min, max)')),
                ActionChip(label: const Text('d/dx'), onPressed: () => _insertText('deriv(expr, var, point)')),
                ActionChip(label: const Text('pi'), onPressed: () => _insertText('pi')),
                ActionChip(label: const Text('e'), onPressed: () => _insertText('e')),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Playground Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('3. Playground', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                FilledButton.tonalIcon(
                  onPressed: _runPlayground,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Test Formula'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (_variables.isEmpty) const Text('Add variables to test'),
                    ..._variables.map((v) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextField(
                          controller: _playgroundControllers[v.name],
                          decoration: InputDecoration(
                            labelText: '${v.name} ${v.unitLabel != null ? '(${v.unitLabel})' : ''}',
                            helperText: v.description,
                            isDense: true,
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: v.type == VariableType.number),
                        ),
                      );
                    }),
                    const Divider(),
                    if (_error != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Theme.of(context).colorScheme.onErrorContainer),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer))),
                          ],
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Result:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            _playgroundResult,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
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

  void _insertText(String text) {
    final currentText = _formulaController.text;
    final selection = _formulaController.selection;
    final newText = currentText.replaceRange(
      selection.start >= 0 ? selection.start : currentText.length,
      selection.end >= 0 ? selection.end : currentText.length,
      text,
    );
    _formulaController.text = newText;
  }

  void _showIconPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Icon'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            itemCount: _availableIcons.length,
            itemBuilder: (context, index) {
              return IconButton(
                icon: FaIcon(_availableIcons[index]),
                onPressed: () {
                  setState(() => _selectedIcon = _availableIcons[index]);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
