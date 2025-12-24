import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../widgets/calculator_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categories = [
      {'title': l10n.catHealth, 'icon': FontAwesomeIcons.heartPulse, 'route': '/health', 'color': Colors.red},
      {'title': l10n.catMath, 'icon': FontAwesomeIcons.squareRootVariable, 'route': '/math', 'color': Colors.purple},
      {'title': l10n.catElectronics, 'icon': FontAwesomeIcons.microchip, 'route': '/electronics', 'color': Colors.blueGrey},
      {'title': l10n.catConverters, 'icon': FontAwesomeIcons.arrowRightArrowLeft, 'route': '/converters', 'color': Colors.orange},
      {'title': l10n.catPhotography, 'icon': FontAwesomeIcons.camera, 'route': '/photography', 'color': Colors.teal},
      {'title': l10n.catPhysics, 'icon': FontAwesomeIcons.atom, 'route': '/physics', 'color': Colors.deepPurple},
      {'title': l10n.catChemistry, 'icon': FontAwesomeIcons.vial, 'route': '/chemistry', 'color': Colors.indigo},
      {'title': l10n.catGardening, 'icon': FontAwesomeIcons.seedling, 'route': '/gardening', 'color': Colors.green},
      {'title': l10n.catSports, 'icon': FontAwesomeIcons.baseballBatBall, 'route': '/sports', 'color': Colors.brown},
      {'title': l10n.catTextTools, 'icon': FontAwesomeIcons.font, 'route': '/text', 'color': Colors.blue},
      {'title': l10n.settings, 'icon': Icons.settings, 'route': '/settings', 'color': Colors.blueGrey},
      {'title': l10n.catOther, 'icon': FontAwesomeIcons.layerGroup, 'route': '/other', 'color': Colors.grey},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.categories)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 1.0,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return CalculatorCard(
            title: cat['title'] as String,
            icon: cat['icon'] as IconData,
            color: cat['color'] as Color,
            route: cat['route'] as String,
            onTap: () => context.go(cat['route'] as String),
          );
        },
      ),
    );
  }
}
