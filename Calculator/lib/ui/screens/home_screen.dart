import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(FontAwesomeIcons.house),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(FontAwesomeIcons.calculator),
                        label: Text('Standard'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(FontAwesomeIcons.flask),
                        label: Text('Scientific'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(FontAwesomeIcons.coins),
                        label: Text('Finance'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(FontAwesomeIcons.heartPulse),
                        label: Text('Health'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(FontAwesomeIcons.squareRootVariable),
                        label: Text('Math'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(FontAwesomeIcons.microchip),
                        label: Text('Electronics'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(FontAwesomeIcons.arrowRightArrowLeft),
                        label: Text('Converters'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(FontAwesomeIcons.atom),
                        label: Text('Science'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(FontAwesomeIcons.seedling),
                        label: Text('Lifestyle'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(FontAwesomeIcons.font),
                        label: Text('Text'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(FontAwesomeIcons.layerGroup),
                        label: Text('Other'),
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
                  _buildDrawerItem(context, 'Home', FontAwesomeIcons.house, '/dashboard', 0),
                  _buildDrawerItem(context, 'Standard', FontAwesomeIcons.calculator, '/standard', 1),
                  _buildDrawerItem(context, 'Scientific', FontAwesomeIcons.flask, '/scientific', 2),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: Text('Categories', style: TextStyle(color: Colors.grey)),
                  ),
                  _buildDrawerItem(context, 'Finance', FontAwesomeIcons.coins, '/finance', 3),
                  _buildDrawerItem(context, 'Health', FontAwesomeIcons.heartPulse, '/health', 4),
                  _buildDrawerItem(context, 'Math', FontAwesomeIcons.squareRootVariable, '/math', 5),
                  _buildDrawerItem(context, 'Electronics', FontAwesomeIcons.microchip, '/electronics', 6),
                  _buildDrawerItem(context, 'Converters', FontAwesomeIcons.arrowRightArrowLeft, '/converters', 7),
                  _buildDrawerItem(context, 'Science', FontAwesomeIcons.atom, '/science', 8),
                  _buildDrawerItem(context, 'Lifestyle', FontAwesomeIcons.seedling, '/lifestyle', 9),
                  _buildDrawerItem(context, 'Text Tools', FontAwesomeIcons.font, '/text', 10),
                  _buildDrawerItem(context, 'Other', FontAwesomeIcons.layerGroup, '/other', 11),
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
