import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

CalendarStyle calendarStyle = CalendarStyle(
    isTodayHighlighted: true,
    selectedDecoration: BoxDecoration(
      color: Colors.blue,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(5.0),
    ),
    selectedTextStyle: const TextStyle(color: Colors.white),
    todayDecoration: BoxDecoration(
      color: Colors.blueGrey,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(5.0),
    ),
    defaultDecoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(5.0),
    ),
    weekendDecoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(5.0),
    ));
