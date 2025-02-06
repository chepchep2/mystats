import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/views/calendar/game_delete_dialog.dart';
import 'package:mystats/views/calendar/game_form_dialog.dart';
import 'package:mystats/views/calendar/game_stats_dialog.dart';
import 'package:mystats/widgets/common/custom_icon_button.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mystats/viewmodels/calendar/calendar_viewmodel.dart';

class CalendarView extends ConsumerWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Center(
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
                  },
                  eventLoader: (day) {
                    return ref
                        .read(calendarProvider.notifier)
                        .getEventsForDay(day);
                  },
                ),
              ),
            ),
            if (calendarState.selectedDay != null) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${calendarState.selectedDay!.month}월 ${calendarState.selectedDay!.day}일 일정',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => GameFormDialog(
                            selectedDate: calendarState.selectedDay!,
                            onSave: (game) {
                              ref.read(calendarProvider.notifier).addGame(game);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      label: const Text(
                        '일정 추가',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: ref
                      .read(calendarProvider.notifier)
                      .getEventsForDay(calendarState.selectedDay!)
                      .length,
                  itemBuilder: (context, index) {
                    final events = ref
                        .read(calendarProvider.notifier)
                        .getEventsForDay(calendarState.selectedDay!);
                    final game = events[index];

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        title: Text(
                          game.opponent!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  '${game.date.hour.toString().padLeft(2, '0')}:${game.date.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  game.location!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconButton(
                              icon: Icons.edit,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => GameFormDialog(
                                    selectedDate: game.date,
                                    initialGame: game,
                                    onSave: (updatedGame) {
                                      ref
                                          .read(calendarProvider.notifier)
                                          .updateGame(updatedGame);
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                            ),
                            CustomIconButton(
                              icon: Icons.delete,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => GameDeleteDialog(
                                    game: game,
                                    onDelete: () {
                                      ref
                                          .read(calendarProvider.notifier)
                                          .deleteGame(game);
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => GameStatsDialog(game: game),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
