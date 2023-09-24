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
  List<String> filteredContacts = [];
  List<Event> eventsList = [];
  List<String> companies = [];
  LocalStorage store = LocalStorage();
  TextEditingController filterController = TextEditingController();
  bool ascendingOrder = false;
  String filterByCompany = "";

  @override
  void initState() {
    super.initState();
    getEvents();
    getCompanies();
    store.getStringList(CONTACTS).then((value) => setState(() {
          contacts = value;
          filteredContacts = value;
        }));
  }

  void getCompanies() {
    store.getStringList(COMPANIES).then((value) {
      List<String> companiesList = value;
      companiesList.insert(0, "---");
      setState(() => companies = companiesList);
    });
  }

  void addContact(String contact, String company) {
    List<String> newContactsList = contacts;
    List<String> newCompaniesList = companies;
    newContactsList.insert(0, contact);

    if (!companies.contains(company)) {
      store.addToList(COMPANIES, company);
      newCompaniesList.add(company);
    }

    setState(() {
      contacts = newContactsList;
      companies = newCompaniesList;
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

  void _sortContacts() {
    filteredContacts.sort((a, b) {
      Map<String, dynamic> contactA = jsonDecode(a);
      Map<String, dynamic> contactB = jsonDecode(b);
      String displayNameA = contactA['displayName'];
      String displayNameB = contactB['displayName'];
      return ascendingOrder
          ? displayNameA.compareTo(displayNameB)
          : displayNameB.compareTo(displayNameA);
    });
    setState(() {});
  }

  void sortByCompanies() {
    var sorted = contacts;
    if (filterByCompany != "---") {
      sorted = filteredContacts
          .where((element) => jsonDecode(element)['company'] == filterByCompany)
          .toList();
    }

    setState(() {
      filteredContacts = sorted;
    });
  }

  void showFilters() {
    List<String> dropdownList = companies;
    String dropdownValue = dropdownList.first;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Event"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: const Text('A - Z'),
                    value: ascendingOrder,
                    secondary: const Icon(Icons.sort_by_alpha),
                    onChanged: (bool? ascendingValue) {
                      setState(() {
                        ascendingOrder = ascendingValue!;
                        _sortContacts();
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.business),
                    title: DropdownButton(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      items: dropdownList
                          .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                          filterByCompany = dropdownValue;
                          sortByCompanies();
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
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
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: filterController,
                  decoration: const InputDecoration(
                    labelText: 'Filter contacts',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
              ),
              IconButton(
                onPressed: () => showFilters(),
                icon: const Icon(Icons.filter_alt),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> contact =
                    jsonDecode(filteredContacts[index]);
                if (filterController.text.isEmpty ||
                    contact['displayName']
                        .toLowerCase()
                        .contains(filterController.text.toLowerCase())) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(contact['displayName'][0]),
                    ),
                    title: Text(contact['displayName']),
                    subtitle: Text(contact['phones'][0]['value']),
                    onTap: () => openContact(contact),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewContact(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
