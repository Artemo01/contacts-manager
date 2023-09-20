import 'package:contacts_management/LocalStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../dto/Event.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({
    Key? key,
    required this.contact,
    required this.eventsList,
  }) : super(key: key);

  final Map<String, dynamic> contact;
  final List<Event> eventsList;

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Widget> contactWidgets = [];
  LocalStorage store = LocalStorage();

  @override
  void initState() {
    super.initState();
    getAllContacts();
  }

  void getAllContacts() {
    widget.contact['phones'].forEach(
      (element) {
        String number = element['value'].replaceAll(new RegExp(r'[^0-9]'), '');
        contactWidgets.insert(
          0,
          Card(
            child: ListTile(
              leading: const Icon(Icons.phone),
              title: Text(number),
              onTap: () async {
                await FlutterPhoneDirectCaller.callNumber(number);
              },
            ),
          ),
        );
      },
    );
    if (widget.contact['company'] != null &&
        widget.contact['company'] != "none") {
      contactWidgets.insert(
        0,
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
            child: Text(
              style: const TextStyle(fontSize: 16.0),
              "Company: " + (widget.contact['company']),
            ),
          ),
        ),
      );
    }

    contactWidgets.add(const Padding(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 0, 0),
        child: Text("Scheduled events:")));
    widget.eventsList.forEach((element) {
      if (element.phoneNumber == widget.contact['displayName']) {
        contactWidgets.add(Card(
          child: ListTile(
            title: Text(element.title),
            subtitle: Text(
              '${element.startTime.hour}:${element.startTime.minute} - ${element.endTime.hour}:${element.endTime.minute}',
            ),
          ),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact['displayName']),
      ),
      body: ListView(
        children: contactWidgets,
      ),
    );
  }
}
