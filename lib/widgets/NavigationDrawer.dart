import 'package:contacts_management/dto/NavigationButton.dart';
import 'package:contacts_management/pages/CalendarPage.dart';
import 'package:contacts_management/pages/Contacts.dart';
import 'package:contacts_management/pages/Dashboard.dart';
import 'package:contacts_management/pages/Notebook.dart';
import 'package:contacts_management/pages/Settings.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  final List<NavigationButton> buttons = [
    NavigationButton(
      name: 'Dashboard',
      icon: Icons.dashboard,
      widget: const Dashboard(),
    ),
    NavigationButton(
      name: 'Contacts',
      icon: Icons.phone,
      widget: const Contacts(),
    ),
    NavigationButton(
      name: 'Notebook',
      icon: Icons.notes,
      widget: const Notebook(),
    ),
    NavigationButton(
      name: 'Calendar',
      icon: Icons.calendar_today,
      widget: const CalendarPage(),
    ),
    NavigationButton(
      name: 'Settings',
      icon: Icons.settings,
      widget: const Settings(),
    )
  ];

  Widget bodyWidget = Dashboard();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Management'),
      ),
      drawer: Drawer(
        child: ListView(
            children: buttons.map((e) {
          return ListTile(
            leading: Icon(e.icon),
            title: Text(e.name),
            onTap: () {
              setState(() {
                setState(() => bodyWidget = e.widget);
              });
              Navigator.pop(context);
            },
          );
        }).toList()),
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
          child: bodyWidget),
    );
  }
}
