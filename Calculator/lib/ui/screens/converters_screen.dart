import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../widgets/calculator_card.dart';

class ConvertersScreen extends StatelessWidget {
  const ConvertersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calculators = [
      {'title': 'Angle', 'icon': FontAwesomeIcons.compass, 'route': '/converters/angle'},
      {'title': 'Area', 'icon': FontAwesomeIcons.vectorSquare, 'route': '/converters/area'},
      {'title': 'Cooking', 'icon': FontAwesomeIcons.utensils, 'route': '/converters/cooking'},
      {'title': 'Data Storage', 'icon': FontAwesomeIcons.hardDrive, 'route': '/converters/storage'},
      {'title': 'Fuel Consumption', 'icon': FontAwesomeIcons.gasPump, 'route': '/converters/fuelconsumption'},
      {'title': 'Power', 'icon': FontAwesomeIcons.bolt, 'route': '/converters/power'},
      {'title': 'Pressure', 'icon': FontAwesomeIcons.gauge, 'route': '/converters/pressure'},
      {'title': 'Shoe Size', 'icon': FontAwesomeIcons.shoePrints, 'route': '/converters/shoesize'},
      {'title': 'Speed', 'icon': FontAwesomeIcons.gaugeHigh, 'route': '/converters/speed'},
      {'title': 'Torque', 'icon': FontAwesomeIcons.wrench, 'route': '/converters/torque'},
      {'title': 'Unit Converter', 'icon': FontAwesomeIcons.arrowRightArrowLeft, 'route': '/converters/unit'},
      // NEW CONVERTERS
      {'title': 'Temperature', 'icon': FontAwesomeIcons.temperatureHalf, 'route': '/converters/temperature'},
      {'title': 'Length', 'icon': FontAwesomeIcons.ruler, 'route': '/converters/length'},
      {'title': 'Weight', 'icon': FontAwesomeIcons.weightScale, 'route': '/converters/weight'},
      {'title': 'Volume', 'icon': FontAwesomeIcons.flask, 'route': '/converters/volume'},
    ];

    // Sort alphabetically
    calculators.sort((a, b) => (a['title'] as String).compareTo(b['title'] as String));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Converters'),
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
                    color: Colors.orangeAccent,
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
