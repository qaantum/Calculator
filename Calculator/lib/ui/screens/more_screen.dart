import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../widgets/calculator_card.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'title': 'Health', 'icon': FontAwesomeIcons.heartPulse, 'route': '/health', 'color': Colors.red},
      {'title': 'Math', 'icon': FontAwesomeIcons.squareRootVariable, 'route': '/math', 'color': Colors.purple},
      {'title': 'Electronics', 'icon': FontAwesomeIcons.microchip, 'route': '/electronics', 'color': Colors.blueGrey},
      {'title': 'Converters', 'icon': FontAwesomeIcons.arrowRightArrowLeft, 'route': '/converters', 'color': Colors.orange},
      {'title': 'Photography', 'icon': FontAwesomeIcons.camera, 'route': '/photography', 'color': Colors.teal},
      {'title': 'Physics', 'icon': FontAwesomeIcons.atom, 'route': '/physics', 'color': Colors.deepPurple},
      {'title': 'Chemistry', 'icon': FontAwesomeIcons.vial, 'route': '/chemistry', 'color': Colors.indigo},
      {'title': 'Gardening', 'icon': FontAwesomeIcons.seedling, 'route': '/gardening', 'color': Colors.green},
      {'title': 'Sports', 'icon': FontAwesomeIcons.baseballBatBall, 'route': '/sports', 'color': Colors.brown},
      {'title': 'Text Tools', 'icon': FontAwesomeIcons.font, 'route': '/text', 'color': Colors.blue},
      {'title': 'Other', 'icon': FontAwesomeIcons.layerGroup, 'route': '/other', 'color': Colors.grey},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('More Categories')),
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
