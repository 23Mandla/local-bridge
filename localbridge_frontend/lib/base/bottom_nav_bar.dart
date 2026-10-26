import 'package:flutter/material.dart';
import 'package:localbridge_frontend/features/home/view/home_view.dart';

import '../features/quotes/ui/screens/buyer_inbox_screen.dart';

class BottomNavBar extends StatefulWidget {
  final int defaultIndex;

  const BottomNavBar({super.key, this.defaultIndex = 0});

  static MaterialPageRoute route({int initialIndex = 0}) => MaterialPageRoute(
    builder: (context) => BottomNavBar(defaultIndex: initialIndex),
  );

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  static const List<Widget> bottomNavItems = <Widget>[
    HomeView(),
    BuyerInboxScreen(),
    //BusinessProfileScreen(),
  ];

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultIndex;
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: bottomNavItems),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Entrepreneur',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_turned_in_outlined),
            selectedIcon: Icon(Icons.assignment_turned_in),
            label: 'Buyer',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
