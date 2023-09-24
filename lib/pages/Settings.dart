import 'dart:convert';

import 'package:contacts_management/LocalStorage.dart';
import 'package:contacts_management/consts.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  LocalStorage store = LocalStorage();
  List<String> localContacts = [];

  @override
  void initState() {
    super.initState();
  }

  void getContacts() async {
    store
        .getStringList(CONTACTS)
        .then((value) => setState(() => localContacts = value));

    List<Contact> contacts =
        (await ContactsService.getContacts(withThumbnails: false));

    contacts.forEach((element) {
      if (!localContacts.contains(jsonEncode(element.toMap()))) {
        localContacts.add(jsonEncode(element.toMap()));
      }
    });

    store.saveStringList(CONTACTS, localContacts);
  }

  void removeContacts() {
    store.saveStringList(CONTACTS, []);
    store.saveStringList(COMPANIES, []);
    setState(() => localContacts = []);
  }

  void removeEvents() {
    store.saveStringList(EVENTS, []);
  }

  void showInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("App info"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Application created by:"),
                  Text("Jakub Budziński"),
                  Text("App version: 1.0.0")
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.download_rounded),
            title: const Text('Import Contacts'),
            onTap: () => getContacts(),
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Remove Contacts'),
            onTap: () => removeContacts(),
          ),
          ListTile(
            leading: const Icon(Icons.event_busy),
            title: const Text('Remove All Events'),
            onTap: () => removeEvents(),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Info'),
            onTap: () => showInfo(),
          ),
        ],
      ),
    );
  }
}
