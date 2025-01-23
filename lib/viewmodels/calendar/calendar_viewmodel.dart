import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarState {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;
  final Map<DateTime, List<dynamic>> events;

  CalendarState({
    required this.focusedDay,
    this.selectedDay,
    this.calendarFormat = CalendarFormat.month,
    this.events = const {},
  });

  CalendarState copyWith({
    DateTime? focusedDay,
    DateTime? selectedDay,
    CalendarFormat? calendarFormat,
    Map<DateTime, List<dynamic>>? events,
  }) {
    return CalendarState(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      calendarFormat: calendarFormat ?? this.calendarFormat,
      events: events ?? this.events,
    );
  }
}

final calendarProvider =
    StateNotifierProvider<CalendarViewModel, CalendarState>((ref) {
  return CalendarViewModel();
});

class CalendarViewModel extends StateNotifier<CalendarState> {
  CalendarViewModel()
      : super(CalendarState(
          focusedDay: DateTime.now(),
          calendarFormat: CalendarFormat.month, // 이 부분이 누락되어 있었음
          events: const {},
        ));

  void updateSelectedDay(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(state.selectedDay, selectedDay)) {
      state = state.copyWith(
        selectedDay: selectedDay,
        focusedDay: focusedDay,
      );
    }
  }

  void updateCalendarFormat(CalendarFormat format) {
    if (state.calendarFormat != format) {
      state = state.copyWith(calendarFormat: format);
    }
  }

  void addEvent(DateTime date, dynamic event) {
    final events = Map<DateTime, List<dynamic>>.from(state.events);
    if (events[date] != null) {
      events[date]!.add(event);
    } else {
      events[date] = [event];
    }
    state = state.copyWith(events: events);
  }

  List<dynamic> getEventsForDay(DateTime date) {
    return state.events[date] ?? [];
  }
}
