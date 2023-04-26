import 'package:contacts_management/widgets/NavigationDrawer.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    askPermission();
    super.initState();
  }

  askPermission() async {
    await Permission.contacts.request();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const NavigationDrawer(),
    );
  }
}
