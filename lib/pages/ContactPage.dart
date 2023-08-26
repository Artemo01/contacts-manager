import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({
    Key? key,
    required this.contact,
  }) : super(key: key);

  final Map<String, dynamic> contact;

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final List<Widget> contactWidgets = [];

  @override
  void initState() {
    getAllContacts();

    super.initState();
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
