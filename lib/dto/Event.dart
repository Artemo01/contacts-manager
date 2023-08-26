import 'package:flutter/material.dart';

class Event {
  final String title;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String? phoneNumber;

  Event({
    required this.title,
    required this.startTime,
    required this.endTime,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
      'endTime': {'hour': endTime.hour, 'minute': endTime.minute},
      'phoneNumber': phoneNumber,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      startTime: TimeOfDay(
        hour: json['startTime']['hour'],
        minute: json['startTime']['minute'],
      ),
      endTime: TimeOfDay(
        hour: json['endTime']['hour'],
        minute: json['endTime']['minute'],
      ),
      phoneNumber: json['phoneNumber'],
    );
  }
}
