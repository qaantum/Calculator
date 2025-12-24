import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/currency_provider.dart';
import '../models/custom_calculator_model.dart';
import '../services/custom_calculator_service.dart';
import '../services/math_engine.dart';
import '../../../../ui/widgets/formula_graph_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomCalculatorBuilderScreen extends ConsumerStatefulWidget {
  final CustomCalculator? calculator; // Optional: for editing

  const CustomCalculatorBuilderScreen({super.key, this.calculator});

  @override
  ConsumerState<CustomCalculatorBuilderScreen> createState() => _CustomCalculatorBuilderScreenState();
}

class _CustomCalculatorBuilderScreenState extends ConsumerState<CustomCalculatorBuilderScreen> {
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
  
  // Graph State
  String? _graphXAxisVariable;

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
    // New Icons
    FontAwesomeIcons.temperatureHalf,
    FontAwesomeIcons.droplet,
    FontAwesomeIcons.bolt,
    FontAwesomeIcons.moneyBill,
    FontAwesomeIcons.piggyBank,
    FontAwesomeIcons.percent,
    FontAwesomeIcons.scaleBalanced,
    FontAwesomeIcons.atom,
    FontAwesomeIcons.dna,
    FontAwesomeIcons.microscope,
    FontAwesomeIcons.weightScale,
    FontAwesomeIcons.personRunning,
    FontAwesomeIcons.clock,
    FontAwesomeIcons.calendar,
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.reservedWord(name))));
      return;
    }
    
    if (name.isEmpty) return;
    if (_variables.any((v) => v.name == name)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.variableExists)));
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
        _error = AppLocalizations.of(context)!.clickToAdd(_varNameController.text);
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
        setState(() => _error = AppLocalizations.of(context)!.enterValue(v.name));
        return;
      }
      final val = double.tryParse(text);
      if (val == null) {
        setState(() => _error = AppLocalizations.of(context)!.invalidNumber(v.name));
        return;
      }
      
      // Validate Min/Max
      if (v.min != null && val < v.min!) {
        setState(() => _error = AppLocalizations.of(context)!.mustBeGreater(v.name, v.min!));
        return;
      }
      if (v.max != null && val > v.max!) {
        setState(() => _error = AppLocalizations.of(context)!.mustBeLess(v.name, v.max!));
        return;
      }

      inputs[v.name] = val;
    }

    final result = MathEngine.evaluate(_formulaController.text, inputs);
    
    setState(() {
      if (result.isSuccess) {
        _playgroundResult = result.value!.toStringAsFixed(4);
      } else {
        _error = result.error?.message ?? AppLocalizations.of(context)!.error;
      }
    });
  }

  Future<void> _saveCalculator() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.enterTitle)));
      return;
    }
    if (_formulaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.enterFormula)));
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
        title: Text(widget.calculator == null ? AppLocalizations.of(context)!.buildCalculator : AppLocalizations.of(context)!.editCalculator),
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
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.calculatorName,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Variables Section
            Text(AppLocalizations.of(context)!.defineVariables, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: TextField(controller: _varNameController, decoration: InputDecoration(labelText: '${AppLocalizations.of(context)!.name} (e.g. x)', isDense: true))),
                        const SizedBox(width: 8),
                        Expanded(child: TextField(controller: _varUnitController, decoration: InputDecoration(labelText: '${AppLocalizations.of(context)!.unit} (e.g. kg)', isDense: true))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(controller: _varDescController, decoration: InputDecoration(labelText: '${AppLocalizations.of(context)!.description} (optional)', isDense: true)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: _varMinController, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.min, isDense: true), keyboardType: TextInputType.number)),
                        const SizedBox(width: 8),
                        Expanded(child: TextField(controller: _varMaxController, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.max, isDense: true), keyboardType: TextInputType.number)),
                        const SizedBox(width: 8),
                        DropdownButton<VariableType>(
                          value: _varType,
                          items: VariableType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                          onChanged: (v) => setState(() => _varType = v!),
                        ),
                      ],

                    ),
                    const SizedBox(height: 8),
                    if (_varType == VariableType.date)
                      Text(AppLocalizations.of(context)!.dateWarning, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 16),
                    FilledButton.icon(onPressed: _addVariable, icon: const Icon(Icons.add), label: Text(AppLocalizations.of(context)!.addVariable)),
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
            Text(AppLocalizations.of(context)!.writeFormula, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _formulaController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.formula,
                hintText: 'e.g. x^2 + y or integrate(x^2, x, 0, 5)',
                border: const OutlineInputBorder(),
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
                ActionChip(label: const Text('daysBetween'), onPressed: () => _insertText('daysBetween(t1, t2)')),
                ActionChip(label: const Text('addDays'), onPressed: () => _insertText('addDays(t, days)')),
                ActionChip(label: const Text('age'), onPressed: () => _insertText('age(birthdate)')),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Playground & Graph Section
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Test'),
                      Tab(text: 'Graph'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 500,
                    child: TabBarView(
                      children: [
                        // Tab 1: Test (Existing Playground)
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppLocalizations.of(context)!.testFormula, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  FilledButton.tonalIcon(
                                    onPressed: _runPlayground,
                                    icon: const Icon(Icons.play_arrow),
                                    label: Text(AppLocalizations.of(context)!.run),
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
                                      if (_variables.isEmpty) Text(AppLocalizations.of(context)!.addVariablesToTest),
                                      ..._variables.map((v) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: TextField(
                                            controller: _playgroundControllers[v.name],
                                            decoration: InputDecoration(
                                              labelText: '${v.name} ${v.unitLabel != null ? '(${v.unitLabel!.replaceAll('\$', ref.watch(currencyProvider))})' : ''}',
                                              helperText: v.description,
                                              isDense: true,
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
                                                _playgroundControllers[v.name]!.text = timestamp.toString();
                                              }
                                            } : null,
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
                                            Text('${AppLocalizations.of(context)!.result}:', style: const TextStyle(fontWeight: FontWeight.bold)),
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
                        
                        // Tab 2: Graph
                        Column(
                          children: [
                            if (_variables.isEmpty)
                              Center(child: Text(AppLocalizations.of(context)!.addVariablesToGraph))
                            else ...[
                              Row(
                                children: [
                                  Text('${AppLocalizations.of(context)!.xAxisVariable}: '),
                                  const SizedBox(width: 8),
                                  DropdownButton<String>(
                                    value: _graphXAxisVariable ?? _variables.first.name,
                                    items: _variables.map((v) => DropdownMenuItem(value: v.name, child: Text(v.name))).toList(),
                                    onChanged: (v) => setState(() => _graphXAxisVariable = v),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: FormulaGraphWidget(
                                  formula: _formulaController.text,
                                  variables: _variables,
                                  currentValues: {
                                    for (var v in _variables)
                                      v.name: double.tryParse(_playgroundControllers[v.name]?.text ?? '0') ?? 0.0
                                  },
                                  xAxisVariable: _graphXAxisVariable ?? _variables.first.name,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
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
        title: Text(AppLocalizations.of(context)!.selectIcon),
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
