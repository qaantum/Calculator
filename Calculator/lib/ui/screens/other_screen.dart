import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../widgets/calculator_card.dart';

class OtherScreen extends StatelessWidget {
  const OtherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calculators = [
      {'title': 'Age', 'icon': FontAwesomeIcons.cakeCandles, 'route': '/other/age'},
      {'title': 'Construction', 'icon': FontAwesomeIcons.trowel, 'route': '/other/construction'},
      {'title': 'Date Calculator', 'icon': FontAwesomeIcons.calendarDays, 'route': '/other/date'},
      {'title': 'Flooring', 'icon': FontAwesomeIcons.rug, 'route': '/other/flooring'},
      {'title': 'Fuel Cost', 'icon': FontAwesomeIcons.gasPump, 'route': '/other/fuel'},
      {'title': 'GPA Calculator', 'icon': FontAwesomeIcons.graduationCap, 'route': '/other/gpa'},
      {'title': 'Grade Calculator', 'icon': FontAwesomeIcons.a, 'route': '/other/grade'},
      {'title': 'IP Subnet', 'icon': FontAwesomeIcons.networkWired, 'route': '/other/ipsubnet'},
      {'title': 'Password Gen', 'icon': FontAwesomeIcons.key, 'route': '/other/password'},
      {'title': 'Time Calculator', 'icon': FontAwesomeIcons.clock, 'route': '/other/time'},
      {'title': 'TV Size', 'icon': FontAwesomeIcons.tv, 'route': '/other/tvsize'},
      {'title': 'Work Hours', 'icon': FontAwesomeIcons.briefcase, 'route': '/other/workhours'},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Other Calculators'),
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
                    color: Colors.purpleAccent,
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
