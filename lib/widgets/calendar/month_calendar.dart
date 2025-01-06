import 'package:flutter/material.dart';

class MonthCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<DateTime> markedDates;

  const MonthCalendar({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
    this.markedDates = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 월간 달력 위젯 구현
    return Container();
  }
}
