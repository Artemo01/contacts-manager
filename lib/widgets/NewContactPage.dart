import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class NewContactPage extends StatefulWidget {
  const NewContactPage({
    Key? key,
    required this.addContact,
  }) : super(key: key);

  final Function addContact;

  @override
  _NewContactPageState createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  late String _name;
  late String _last;
  late String _company;
  late String _phone;

  void validateData() {
    var newContact = Contact.fromMap({
      "displayName": "$_name $_last",
      "givenName": _name,
      "familyName": _last,
      "company": _company,
      "phones": [
        {
          "label": "mobile",
          "value": _phone,
        },
      ],
    });

    widget.addContact(jsonEncode(newContact.toMap()));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New contact'),
        actions: <Widget>[
          IconButton(
            onPressed: () => validateData(),
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: ListView(
        children: [
          TextField(
            onChanged: (value) => _name = value,
            decoration: const InputDecoration(
              labelText: "First name",
              hintText: 'Enter your name',
            ),
          ),
          TextField(
            onChanged: (value) => _last = value,
            decoration: const InputDecoration(
              labelText: "Last name",
              hintText: 'Enter your last name',
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) => _phone = value,
            decoration: const InputDecoration(
              labelText: "Phone number",
              hintText: 'Enter phone number',
            ),
          ),
          TextField(
            onChanged: (value) => _company = value,
            decoration: const InputDecoration(
              labelText: "Company",
              hintText: 'Enter company name',
            ),
          ),
        ],
      ),
    );
  }
}
