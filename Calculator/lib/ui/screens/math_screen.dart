import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../widgets/calculator_card.dart';

class MathScreen extends StatelessWidget {
  const MathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calculators = [
      {'title': 'Aspect Ratio', 'icon': FontAwesomeIcons.expand, 'route': '/math/aspectratio'},
      {'title': 'Binary Converter', 'icon': FontAwesomeIcons.zero, 'route': '/math/binary'},
      {'title': 'Circle Properties', 'icon': FontAwesomeIcons.circle, 'route': '/math/circle'},
      {'title': 'Factorial', 'icon': FontAwesomeIcons.exclamation, 'route': '/math/factorial'},
      {'title': 'Fibonacci', 'icon': FontAwesomeIcons.arrowUpRightDots, 'route': '/math/fibonacci'},
      {'title': 'Fraction', 'icon': FontAwesomeIcons.divide, 'route': '/math/fraction'},
      {'title': 'GCD / LCM', 'icon': FontAwesomeIcons.calculator, 'route': '/math/gcdlcm'},
      {'title': 'Geometry', 'icon': FontAwesomeIcons.shapes, 'route': '/math/geometry'},
      {'title': 'Hex Converter', 'icon': FontAwesomeIcons.f, 'route': '/math/hex'},
      {'title': 'Matrix Determinant', 'icon': FontAwesomeIcons.tableCells, 'route': '/math/matrix'},
      {'title': 'Percentage', 'icon': FontAwesomeIcons.percent, 'route': '/math/percentage'},
      {'title': 'Permutation & Comb', 'icon': FontAwesomeIcons.arrowDownUpAcrossLine, 'route': '/math/permcomb'},
      {'title': 'Prime Factorization', 'icon': FontAwesomeIcons.hashtag, 'route': '/math/prime'},
      {'title': 'Quadratic Solver', 'icon': FontAwesomeIcons.xmarksLines, 'route': '/math/quadratic'},
      {'title': 'Random Number', 'icon': FontAwesomeIcons.shuffle, 'route': '/math/random'},
      {'title': 'Roman Numerals', 'icon': FontAwesomeIcons.iCursor, 'route': '/math/roman'},
      {'title': 'Slope', 'icon': FontAwesomeIcons.arrowTrendUp, 'route': '/math/slope'},
      {'title': 'Standard Deviation', 'icon': FontAwesomeIcons.chartBar, 'route': '/math/stddev'},
      {'title': 'Surface Area', 'icon': FontAwesomeIcons.layerGroup, 'route': '/math/surfacearea'},
      {'title': 'Volume', 'icon': FontAwesomeIcons.cube, 'route': '/math/volume'},
      // NEW CALCULATORS
      {'title': 'Logarithm', 'icon': FontAwesomeIcons.squareRootVariable, 'route': '/math/logarithm'},
      {'title': 'Statistics', 'icon': FontAwesomeIcons.chartBar, 'route': '/math/statistics'},
      {'title': 'Summation', 'icon': FontAwesomeIcons.plus, 'route': '/math/summation'},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Math Calculators'),
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
                    color: Colors.blueAccent,
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
