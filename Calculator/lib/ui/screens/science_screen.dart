import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../widgets/calculator_card.dart';

class ScienceScreen extends StatelessWidget {
  const ScienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calculators = [
      // Physics
      {'title': 'Acceleration', 'icon': FontAwesomeIcons.gaugeHigh, 'route': '/science/acceleration'},
      {'title': 'Density', 'icon': FontAwesomeIcons.cubes, 'route': '/science/density'},
      {'title': 'Force', 'icon': FontAwesomeIcons.weightHanging, 'route': '/science/force'},
      {'title': 'Kinetic Energy', 'icon': FontAwesomeIcons.personRunning, 'route': '/science/kinetic'},
      {'title': 'Power (Physics)', 'icon': FontAwesomeIcons.bolt, 'route': '/science/power'},
      {'title': 'Projectile Motion', 'icon': FontAwesomeIcons.share, 'route': '/science/projectile'},
      // Chemistry
      {'title': 'Dilution', 'icon': FontAwesomeIcons.flask, 'route': '/science/dilution'},
      {'title': 'Ideal Gas Law', 'icon': FontAwesomeIcons.cloud, 'route': '/science/idealgas'},
    ];

    // Sort alphabetically
    calculators.sort((a, b) => (a['title'] as String).compareTo(b['title'] as String));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Science Calculators'),
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
                    color: Colors.teal,
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
