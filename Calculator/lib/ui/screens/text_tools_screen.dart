import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../widgets/calculator_card.dart';

class TextToolsScreen extends StatelessWidget {
  const TextToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calculators = [
      {'title': 'Base64 Converter', 'icon': FontAwesomeIcons.code, 'route': '/text/base64'},
      {'title': 'Case Converter', 'icon': FontAwesomeIcons.font, 'route': '/text/case'},
      {'title': 'JSON Formatter', 'icon': FontAwesomeIcons.fileCode, 'route': '/text/json'},
      {'title': 'Lorem Ipsum', 'icon': FontAwesomeIcons.paragraph, 'route': '/text/lorem'},
      {'title': 'Reverse Text', 'icon': FontAwesomeIcons.leftRight, 'route': '/text/reverse'},
      {'title': 'Word Count', 'icon': FontAwesomeIcons.alignLeft, 'route': '/text/wordcount'},
    ];

    // Sort alphabetically
    calculators.sort((a, b) => (a['title'] as String).compareTo(b['title'] as String));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Text Tools'),
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
                    color: Colors.tealAccent,
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
