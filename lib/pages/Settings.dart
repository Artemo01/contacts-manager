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
    setState(() => localContacts = []);
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
        ],
      ),
    );
  }
}
