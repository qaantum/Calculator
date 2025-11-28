import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../widgets/calculator_card.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calculators = [
      {'title': 'BAC', 'icon': FontAwesomeIcons.wineGlass, 'route': '/health/bac'},
      {'title': 'BMI', 'icon': FontAwesomeIcons.weightScale, 'route': '/health/bmi'},
      {'title': 'BMR', 'icon': FontAwesomeIcons.fire, 'route': '/health/bmr'},
      {'title': 'Body Fat', 'icon': FontAwesomeIcons.person, 'route': '/health/bodyfat'},
      {'title': 'Calories', 'icon': FontAwesomeIcons.utensils, 'route': '/health/calories'},
      {'title': 'Child Height', 'icon': FontAwesomeIcons.child, 'route': '/health/childheight'},
      {'title': 'Ideal Weight', 'icon': FontAwesomeIcons.weightScale, 'route': '/health/idealweight'},
      {'title': 'Macro', 'icon': FontAwesomeIcons.utensils, 'route': '/health/macro'},
      {'title': 'One Rep Max', 'icon': FontAwesomeIcons.dumbbell, 'route': '/health/onerepmax'},
      {'title': 'Pace', 'icon': FontAwesomeIcons.personRunning, 'route': '/health/pace'},
      {'title': 'Pregnancy Due Date', 'icon': FontAwesomeIcons.baby, 'route': '/health/duedate'},
      {'title': 'Protein Intake', 'icon': FontAwesomeIcons.drumstickBite, 'route': '/health/protein'},
      {'title': 'Sleep Calculator', 'icon': FontAwesomeIcons.bed, 'route': '/health/sleep'},
      {'title': 'Smoking Cost', 'icon': FontAwesomeIcons.banSmoking, 'route': '/health/smoking'},
      {'title': 'Target Heart Rate', 'icon': FontAwesomeIcons.heartPulse, 'route': '/health/heartrate'},
      {'title': 'Water Intake', 'icon': FontAwesomeIcons.glassWater, 'route': '/health/water'},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Health & Fitness'),
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
                    color: Colors.redAccent,
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
