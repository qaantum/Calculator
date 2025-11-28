import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../widgets/calculator_card.dart';

class LifestyleScreen extends StatelessWidget {
  const LifestyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calculators = [
      // Gardening
      {'title': 'Plant Spacing', 'icon': FontAwesomeIcons.rulerHorizontal, 'route': '/lifestyle/spacing'},
      {'title': 'Soil / Mulch', 'icon': FontAwesomeIcons.trowel, 'route': '/lifestyle/soil'},
      // Sports
      {'title': 'Pizza Party', 'icon': FontAwesomeIcons.pizzaSlice, 'route': '/lifestyle/pizza'},
      {'title': 'Cricket Run Rate', 'icon': FontAwesomeIcons.baseballBatBall, 'route': '/lifestyle/cricket'},
      {'title': 'Tennis Score', 'icon': FontAwesomeIcons.tableTennisPaddleBall, 'route': '/lifestyle/tennis'},
      // Photography
      {'title': 'Depth of Field', 'icon': FontAwesomeIcons.camera, 'route': '/lifestyle/dof'},
      {'title': 'Exposure Value', 'icon': FontAwesomeIcons.sun, 'route': '/lifestyle/ev'},
    ];

    // Sort alphabetically
    calculators.sort((a, b) => (a['title'] as String).compareTo(b['title'] as String));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Lifestyle Calculators'),
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
                    color: Colors.green,
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
