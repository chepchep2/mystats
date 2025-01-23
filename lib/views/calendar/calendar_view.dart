import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart';
import 'package:mystats/viewmodels/calendar/calendar_viewmodel.dart';

class CalendarView extends ConsumerWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TableCalendar(
              firstDay: DateTime(2024, 1, 1),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: calendarState.focusedDay,
              selectedDayPredicate: (day) =>
                  isSameDay(calendarState.selectedDay, day),
              calendarFormat: calendarState.calendarFormat,
              availableCalendarFormats: const {
                CalendarFormat.month: '월',
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
                weekendStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                ref
                    .read(calendarProvider.notifier)
                    .updateSelectedDay(selectedDay, focusedDay);

                context.push(
                    '/record/batter?date=${selectedDay.toString().split(' ')[0]}');
              },
              onFormatChanged: (format) {
                ref
                    .read(calendarProvider.notifier)
                    .updateCalendarFormat(format);
              },
              eventLoader: (day) {
                return ref.read(calendarProvider.notifier).getEventsForDay(day);
              },
            ),
          ),
        ),
      ),
    );
  }
}
