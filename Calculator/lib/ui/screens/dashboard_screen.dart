import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../core/calculator_data.dart';
import '../../core/pinned_provider.dart';
import '../widgets/calculator_card.dart';
import '../../features/custom_calculator/models/custom_calculator_model.dart';
import '../../features/custom_calculator/services/custom_calculator_service.dart';
import '../../features/custom_calculator/data/calculator_templates.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  List<CustomCalculator> _customCalculators = [];

  @override
  void initState() {
    super.initState();
    _loadCustomCalculators();
  }

  Future<void> _loadCustomCalculators() async {
    final calcs = await CustomCalculatorService().getCalculators();
    if (mounted) {
      setState(() {
        _customCalculators = calcs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinnedRoutes = ref.watch(pinnedCalculatorsProvider);
    
    final pinnedStandard = allCalculators.where((c) => pinnedRoutes.contains(c.route));
    
    final pinnedCustom = _customCalculators.where((c) {
      final route = '/custom/detail?id=${c.id}';
      return pinnedRoutes.contains(route);
    }).map((c) => CalculatorItem(
      title: c.title,
      icon: c.icon,
      route: '/custom/detail?id=${c.id}',
      category: 'Custom',
    ));

    final pinnedCalculators = [...pinnedStandard, ...pinnedCustom];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Calculators Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.myCalculators, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  FilledButton.icon(
                    onPressed: () => _showCreateOptions(context),
                    icon: const Icon(Icons.add),
                    label: Text(AppLocalizations.of(context)!.createNew),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_customCalculators.isEmpty)
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: Text(AppLocalizations.of(context)!.noCalculators)),
                  ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _customCalculators.length,
                  itemBuilder: (context, index) {
                    final calc = _customCalculators[index];
                    return CalculatorCard(
                      title: calc.title,
                      icon: calc.icon,
                      color: Colors.teal,
                      route: '/custom/detail?id=${calc.id}',
                      onTap: () async {
                        await context.push('/custom/detail?id=${calc.id}', extra: calc);
                        _loadCustomCalculators(); // Reload in case deleted
                      },
                    );
                  },
                ),
              const SizedBox(height: 32),

              if (pinnedCalculators.isNotEmpty) ...[
                Text(AppLocalizations.of(context)!.pinnedTools, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: pinnedCalculators.length,
                  itemBuilder: (context, index) {
                    final calc = pinnedCalculators[index];
                    return CalculatorCard(
                      title: calc.title,
                      icon: calc.icon,
                      color: Colors.amber, // Highlight pinned items
                      route: calc.route,
                      onTap: () => context.go(calc.route),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],

              Text(AppLocalizations.of(context)!.quickAccess, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                children: [
                  CalculatorCard(
                    title: AppLocalizations.of(context)!.standard,
                    icon: FontAwesomeIcons.calculator,
                    color: Colors.blue,
                    route: '/standard',
                    onTap: () => context.go('/standard'),
                  ),
                  CalculatorCard(
                    title: AppLocalizations.of(context)!.scientific,
                    icon: FontAwesomeIcons.flask,
                    color: Colors.purple,
                    route: '/scientific',
                    onTap: () => context.go('/scientific'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCreateOptions(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.note_add),
            title: Text(AppLocalizations.of(context)!.startFromScratch),
            onTap: () {
              Navigator.pop(context);
              context.push('/custom/builder').then((_) => _loadCustomCalculators());
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy),
            title: Text(AppLocalizations.of(context)!.useTemplate),
            subtitle: const Text('Start with a pre-made calculator'),
            onTap: () {
              Navigator.pop(context);
              _showTemplatePicker(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showTemplatePicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(AppLocalizations.of(context)!.selectTemplate, style: Theme.of(context).textTheme.titleLarge),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: CalculatorTemplates.templates.length,
                itemBuilder: (context, index) {
                  final template = CalculatorTemplates.templates[index];
                  return ListTile(
                    leading: FaIcon(template.icon),
                    title: Text(template.title),
                    subtitle: Text(template.formula),
                    onTap: () {
                      Navigator.pop(context);
                      
                      final copy = CustomCalculator(
                        id: const Uuid().v4(),
                        title: template.title,
                        iconCode: template.iconCode,
                        iconFontFamily: template.iconFontFamily,
                        iconFontPackage: template.iconFontPackage,
                        inputs: List.from(template.inputs),
                        formula: template.formula,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );

                      context.push('/custom/builder', extra: copy).then((_) => _loadCustomCalculators());
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
