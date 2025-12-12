import 'package:flutter/material.dart';

class CalendarEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final Color color;
  final String? location;
  final bool isAllDay;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.color,
    this.location,
    this.isAllDay = false,
  });

  // Sample events for October 2025
  static List<CalendarEvent> getSampleEvents() {
    return [
      CalendarEvent(
        id: "1",
        title: "Doctor Appointment",
        description: "Annual checkup",
        date: DateTime(2025, 10, 5),
        time: const TimeOfDay(hour: 12, minute: 1),
        color: const Color(0xFF3B82F6),
      ),
      CalendarEvent(
        id: "2",
        title: "School Meeting",
        description: "Parent-teacher conference",
        date: DateTime(2025, 10, 23),
        time: const TimeOfDay(hour: 9, minute: 10),
        color: const Color(0xFF3B82F6),
      ),
      CalendarEvent(
        id: "3",
        title: "Important Deadline",
        description: "Project submission",
        date: DateTime(2025, 10, 25),
        time: const TimeOfDay(hour: 17, minute: 0),
        color: const Color(0xFFEF4444),
      ),
    ];
  }
}

enum CalendarView {
  month,
  week,
  day,
  list,
}
