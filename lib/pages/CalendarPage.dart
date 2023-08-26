import 'dart:convert';

import 'package:contacts_management/consts.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../LocalStorage.dart';
import '../dto/Event.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  LocalStorage store = LocalStorage();
  Map<DateTime, List<Event>> selectedEvents = {};
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  List<Event> _getEventsFromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void initState() {
    getEventList();
    super.initState();
  }

  void getEventList() {
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
        });
      });
      setState(() {
        selectedEvents = updatedSelectedEvents;
      });
    });
  }

  void changeFormat(CalendarFormat _format) {
    setState(() {
      format = _format;
    });
  }

  void changeSelectedDay(DateTime selectDay, DateTime focusDay) {
    setState(() {
      selectedDay = selectDay;
      focusedDay = focusDay;
    });
  }

  void _deleteEvent(Event event) {
    setState(() {
      selectedEvents[selectedDay]?.remove(event);
    });

    List<String> selectedStringList = [];
    selectedEvents.forEach((key, value) {
      List<String> eventList = [];
      value.forEach((element) {
        eventList.add(jsonEncode(element));
      });
      selectedStringList.add(jsonEncode({key.toString(): eventList}));
    });

    store.saveStringList(EVENTS, selectedStringList);
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController _eventController = TextEditingController();
        TimeOfDay startTime =
            TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
        TimeOfDay endTime =
            TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

        return AlertDialog(
          title: const Text("Add Event"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _eventController,
                    decoration: const InputDecoration(labelText: "Event Name"),
                  ),
                  ListTile(
                    title: Text(
                        'Start time: ${startTime.hour}:${startTime.minute}'),
                    trailing: const Icon(Icons.timer),
                    onTap: () async {
                      TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                          initialEntryMode: TimePickerEntryMode.input,
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child ?? Container(),
                            );
                          });
                      if (newTime == null) return;
                      setState(() => startTime = newTime);
                    },
                  ),
                  ListTile(
                    title: Text('End time: ${endTime.hour}:${endTime.minute}'),
                    trailing: const Icon(Icons.timer),
                    onTap: () async {
                      TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                          initialEntryMode: TimePickerEntryMode.input,
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child ?? Container(),
                            );
                          });
                      if (newTime == null) return;
                      setState(() => endTime = newTime);
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String eventName = _eventController.text;
                setState(
                  () {
                    // String eventName = _eventController.text;
                    if (eventName.isNotEmpty) {
                      selectedEvents[selectedDay] =
                          selectedEvents[selectedDay] ?? [];
                      selectedEvents[selectedDay]!.add(Event(
                        title: eventName,
                        startTime: startTime,
                        endTime: endTime,
                      ));
                    }
                  },
                );

                if (eventName.isNotEmpty) {
                  List<String> selectedStringList = [];
                  selectedEvents.forEach((key, value) {
                    List<String> eventList = [];
                    value.forEach((element) {
                      eventList.add(jsonEncode(element));
                    });
                    selectedStringList
                        .add(jsonEncode({key.toString(): eventList}));
                  });

                  store.saveStringList(EVENTS, selectedStringList);
                }

                Navigator.pop(context);
              },
              child: const Text("Add"),
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
          TableCalendar(
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            focusedDay: focusedDay,
            calendarFormat: format,
            onFormatChanged: changeFormat,
            onDaySelected: changeSelectedDay,
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },
            eventLoader: _getEventsFromDay,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _getEventsFromDay(selectedDay).length,
              itemBuilder: (context, index) {
                Event event = _getEventsFromDay(selectedDay)[index];
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text(
                    '${event.startTime.hour}:${event.startTime.minute} - ${event.endTime.hour}:${event.endTime.minute}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteEvent(event); // Dodaj funkcję usuwania
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEvent();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
