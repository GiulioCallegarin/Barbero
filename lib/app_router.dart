import 'package:barbero/pages/appointments_page.dart';
import 'package:barbero/pages/clients_page.dart';
import 'package:barbero/pages/settings_page.dart';
import 'package:flutter/material.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ClientsPage(),
    AppointmentsPage(),
    SettingsPage(),
  ];

  List<BottomNavigationBarItem> get navBarItems {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clients'),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_month),
        label: 'Appointments',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: navBarItems,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
