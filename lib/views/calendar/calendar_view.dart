import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/views/calendar/batter_stats_page.dart';
import 'package:mystats/views/calendar/game_form_dialog.dart';
import 'package:mystats/views/calendar/pitcher_stats_page.dart';
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
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('일정 추가'),
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
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: ListTile(
                        title: Text(game.opponent ?? '상대팀 미정'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '시간: ${game.date.hour}:${game.date.minute.toString().padLeft(2, '0')}'),
                            Text('장소: ${game.location ?? '장소 미정'}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // TODO: 수정 기능 추가
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // TODO: 삭제 기능 추가
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('${game.opponent ?? '상대팀 미정'} 기록 입력'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.sports_baseball),
                                    title: const Text('타자 기록'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => BatterStatsPage(
                                            gameId: game.id,
                                            date: game.date,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const Divider(),
                                  ListTile(
                                    leading: const Icon(
                                        Icons.sports_baseball_outlined),
                                    title: const Text('투수 기록'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PitcherStatsPage(
                                            gameId: game.id,
                                            date: game.date,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('취소'),
                                ),
                              ],
                            ),
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
