import 'dart:convert';

import 'package:flutter/material.dart';

import '../LocalStorage.dart';
import '../consts.dart';
import '../dto/Event.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  LocalStorage store = LocalStorage();
  int eventsNumber = 0;
  String contactsNumber = '0';
  List<Event> todayEvents = [];

  @override
  void initState() {
    getContacts();
    getEvents();
    super.initState();
  }

  void getContacts() {
    store.getStringList(CONTACTS).then(
        (value) => setState(() => contactsNumber = value.length.toString()));
  }

  void getEvents() {
    store.getStringList(EVENTS).then((value) {
      Map<DateTime, List<Event>> updatedSelectedEvents = {};
      value.forEach((element) {
        Map<String, dynamic> parsedJson = jsonDecode(element);
        parsedJson.forEach((key, value) {
          DateTime date = DateTime.parse(key);
          List<Event> eventsList = [];
          for (var element in value) {
            Map<String, dynamic> eventJson = jsonDecode(element);
            Event event = Event.fromJson(eventJson);
            eventsList.add(event);
          }
          updatedSelectedEvents[date] = eventsList;
          setState(() {
            eventsNumber = eventsNumber + eventsList.length;
          });
        });
      });
      DateTime now = DateTime.now();
      DateTime date = DateTime.utc(now.year, now.month, now.day);
      setState(() {
        todayEvents = updatedSelectedEvents[date] ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.calendar_today),
                          title: Text('Scheduled'),
                          subtitle: Center(
                            child: Text(
                              eventsNumber.toString(),
                              style: TextStyle(fontSize: 32.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.phone,
                          ),
                          title: const Text('Contacts'),
                          subtitle: Center(
                            child: Text(
                              contactsNumber,
                              style: const TextStyle(fontSize: 32.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Text(
            "Today Events:",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          todayEvents.isEmpty
              ? const Center(
                  child: Text(
                    "no meetings",
                    style: TextStyle(fontSize: 16.0),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: todayEvents.length,
                  itemBuilder: (BuildContext context, int index) {
                    Event event = todayEvents[index];
                    return Card(
                      child: ListTile(
                        title: Text(event.title),
                        subtitle: Text(
                          '${event.startTime.hour}:${event.startTime.minute} - ${event.endTime.hour}:${event.endTime.minute}',
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
