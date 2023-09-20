import 'dart:convert';

import 'package:contacts_management/LocalStorage.dart';
import 'package:contacts_management/consts.dart';
import 'package:contacts_management/pages/ContactPage.dart';
import 'package:contacts_management/widgets/NewContactPage.dart';
import 'package:flutter/material.dart';

import '../dto/Event.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<String> contacts = [];
  List<Event> eventsList = [];
  LocalStorage store = LocalStorage();

  @override
  void initState() {
    super.initState();
    getEvents();
    store
        .getStringList(CONTACTS)
        .then((value) => setState(() => contacts = value));
  }

  void addContact(String contact) {
    List<String> newContactsList = contacts;
    newContactsList.insert(0, contact);
    setState(() {
      contacts = newContactsList;
    });
    store.saveStringList(CONTACTS, contacts);
  }

  void createNewContact() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewContactPage(
                  addContact: addContact,
                )));
  }

  void openContact(contact) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                  eventsList: eventsList,
                )));
  }

  void getEvents() {
    store.getStringList(EVENTS).then((value) {
      List<Event> selectedEventsList = [];
      value.forEach((element) {
        Map<String, dynamic> parsedJson = jsonDecode(element);
        parsedJson.forEach((key, value) {
          for (var element in value) {
            Map<String, dynamic> eventJson = jsonDecode(element);
            Event event = Event.fromJson(eventJson);
            selectedEventsList.add(event);
          }
        });
      });
      setState(() {
        eventsList = selectedEventsList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: contacts.map((e) {
          Map<String, dynamic> contact = jsonDecode(e);
          return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(contact['displayName'][0]),
              ),
              title: Text(contact['displayName']),
              subtitle: Text(contact['phones'][0]['value']),
              onTap: () => openContact(contact));
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewContact(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
