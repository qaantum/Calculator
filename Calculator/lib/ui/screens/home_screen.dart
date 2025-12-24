import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/standard');
        break;
      case 2:
        context.go('/scientific');
        break;
      case 3:
        context.go('/finance');
        break;
      case 4:
        context.go('/health');
        break;
      case 5:
        context.go('/math');
        break;
      case 6:
        context.go('/electronics');
        break;
      case 7:
        context.go('/converters');
        break;
      case 8:
        context.go('/science');
        break;
      case 9:
        context.go('/lifestyle');
        break;
      case 10:
        context.go('/text');
        break;
      case 11:
        context.go('/other');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 600)
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (index) => _onItemTapped(index, context),
                    labelType: NavigationRailLabelType.all,
                    destinations: [
                      NavigationRailDestination(
                        icon: const Icon(FontAwesomeIcons.house),
                        label: Text(AppLocalizations.of(context)!.home),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(FontAwesomeIcons.calculator),
                        label: Text(AppLocalizations.of(context)!.standard),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(FontAwesomeIcons.flask),
                        label: Text(AppLocalizations.of(context)!.scientific),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(FontAwesomeIcons.coins),
                        label: Text(AppLocalizations.of(context)!.catFinance),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(FontAwesomeIcons.heartPulse),
                        label: Text(AppLocalizations.of(context)!.catHealth),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(FontAwesomeIcons.squareRootVariable),
                        label: Text(AppLocalizations.of(context)!.catMath),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(FontAwesomeIcons.microchip),
                        label: Text(AppLocalizations.of(context)!.catElectronics),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(FontAwesomeIcons.arrowRightArrowLeft),
                        label: Text(AppLocalizations.of(context)!.catConverters),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(FontAwesomeIcons.atom),
                        label: Text(AppLocalizations.of(context)!.catScience),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(FontAwesomeIcons.seedling),
                        label: Text(AppLocalizations.of(context)!.catLifestyle),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(FontAwesomeIcons.font),
                        label: Text(AppLocalizations.of(context)!.catText),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(FontAwesomeIcons.layerGroup),
                        label: Text(AppLocalizations.of(context)!.catOther),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (MediaQuery.of(context).size.width >= 600) const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.child),
        ],
      ),
      drawer: MediaQuery.of(context).size.width < 600
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text(
                      'Calculator',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  _buildDrawerItem(context, AppLocalizations.of(context)!.home, FontAwesomeIcons.house, '/dashboard', 0),
                  _buildDrawerItem(context, AppLocalizations.of(context)!.standard, FontAwesomeIcons.calculator, '/standard', 1),
                  _buildDrawerItem(context, AppLocalizations.of(context)!.scientific, FontAwesomeIcons.flask, '/scientific', 2),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: Text(AppLocalizations.of(context)!.categories, style: const TextStyle(color: Colors.grey)),
                  ),
                  _buildDrawerItem(context, AppLocalizations.of(context)!.catFinance, FontAwesomeIcons.coins, '/finance', 3),
                  _buildDrawerItem(context, AppLocalizations.of(context)!.catHealth, FontAwesomeIcons.heartPulse, '/health', 4),
                  _buildDrawerItem(context, AppLocalizations.of(context)!.catMath, FontAwesomeIcons.squareRootVariable, '/math', 5),
                  _buildDrawerItem(context, AppLocalizations.of(context)!.catElectronics, FontAwesomeIcons.microchip, '/electronics', 6),
                  _buildDrawerItem(context, AppLocalizations.of(context)!.catConverters, FontAwesomeIcons.arrowRightArrowLeft, '/converters', 7),
                  _buildDrawerItem(context, AppLocalizations.of(context)!.catScience, FontAwesomeIcons.atom, '/science', 8),
                  _buildDrawerItem(context, AppLocalizations.of(context)!.catLifestyle, FontAwesomeIcons.seedling, '/lifestyle', 9),
                  _buildDrawerItem(context, AppLocalizations.of(context)!.catText, FontAwesomeIcons.font, '/text', 10),
                  _buildDrawerItem(context, AppLocalizations.of(context)!.catOther, FontAwesomeIcons.layerGroup, '/other', 11),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, IconData icon, String route, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: _selectedIndex == index,
      onTap: () {
        Navigator.pop(context); // Close drawer
        _onItemTapped(index, context);
      },
    );
  }
}
