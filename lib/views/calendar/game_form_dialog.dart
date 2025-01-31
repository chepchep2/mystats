import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/models/game/game_model.dart';
import 'package:mystats/viewmodels/calendar/calendar_viewmodel.dart';

class GameFormDialog extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const GameFormDialog({
    super.key,
    required this.selectedDate,
  });

  @override
  ConsumerState<GameFormDialog> createState() => _GameFormDialogState();
}

class _GameFormDialogState extends ConsumerState<GameFormDialog> {
  final opponentController = TextEditingController();
  final locationController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('경기 일정 추가'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '날짜: ${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('시간'),
              trailing: TextButton(
                onPressed: () async {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (time != null) {
                    setState(() {
                      selectedTime = time;
                    });
                  }
                },
                child: Text(
                    '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}'),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: opponentController,
              decoration: const InputDecoration(
                labelText: '상대팀',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: '장소',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            final DateTime gameDateTime = DateTime(
              widget.selectedDate.year,
              widget.selectedDate.month,
              widget.selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );

            final game = GameModel(
              id: DateTime.now().millisecondsSinceEpoch,
              date: gameDateTime,
              opponent: opponentController.text,
              location: locationController.text,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            ref
                .read(calendarProvider.notifier)
                .addEvent(widget.selectedDate, game);
            Navigator.pop(context);
          },
          child: const Text('저장'),
        ),
      ],
    );
  }
}
