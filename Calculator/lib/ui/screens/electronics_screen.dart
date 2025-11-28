import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../widgets/calculator_card.dart';

class ElectronicsScreen extends StatelessWidget {
  const ElectronicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calculators = [
      {'title': 'Battery Life', 'icon': FontAwesomeIcons.batteryFull, 'route': '/electronics/battery'},
      {'title': 'Capacitor Energy', 'icon': FontAwesomeIcons.bolt, 'route': '/electronics/capacitor'},
      {'title': 'LED Resistor', 'icon': FontAwesomeIcons.lightbulb, 'route': '/electronics/led'},
      {'title': 'Ohm\'s Law', 'icon': FontAwesomeIcons.bolt, 'route': '/electronics/ohms'},
      {'title': 'Resistor Color Code', 'icon': FontAwesomeIcons.palette, 'route': '/electronics/resistor'},
      {'title': 'Voltage Divider', 'icon': FontAwesomeIcons.plug, 'route': '/electronics/voltage'},
    ];

    // Sort alphabetically
    calculators.sort((a, b) => (a['title'] as String).compareTo(b['title'] as String));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Electronics Calculators'),
            centerTitle: false,
            floating: true,
            pinned: true,
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final calc = calculators[index];
                  return CalculatorCard(
                    title: calc['title'] as String,
                    icon: calc['icon'] as IconData,
                    color: Colors.amber,
                    route: calc['route'] as String,
                    onTap: () => context.go(calc['route'] as String),
                  );
                },
                childCount: calculators.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
