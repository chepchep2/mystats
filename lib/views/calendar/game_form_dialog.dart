import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/models/game/game_model.dart';
import 'package:mystats/viewmodels/calendar/calendar_viewmodel.dart';
import 'package:mystats/widgets/common/custom_text_field.dart';
import 'package:mystats/widgets/common/custom_button.dart';
import 'package:mystats/widgets/common/custom_time_picker.dart';

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
  String? opponentError;
  String? locationError;

  void _validateAndSubmit() {
    setState(() {
      opponentError =
          opponentController.text.trim().isEmpty ? '상대팀을 입력해주세요' : null;
      locationError =
          locationController.text.trim().isEmpty ? '장소를 입력해주세요' : null;
    });

    if (opponentController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty) {
      return;
    }

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
      opponent: opponentController.text.trim(),
      location: locationController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    ref.read(calendarProvider.notifier).addEvent(widget.selectedDate, game);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '경기 일정 추가',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomTimePicker(
                selectedTime: selectedTime,
                onTimeChanged: (newTime) {
                  setState(() {
                    selectedTime = newTime;
                  });
                },
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: opponentController,
                    hint: '상대팀을 입력하세요',
                    prefixIcon: Icons.people,
                    onChanged: (_) {
                      if (opponentError != null) {
                        setState(() {
                          opponentError = null;
                        });
                      }
                    },
                  ),
                  if (opponentError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Text(
                        opponentError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: locationController,
                    hint: '장소를 입력하세요',
                    prefixIcon: Icons.location_on,
                    onChanged: (_) {
                      if (locationError != null) {
                        setState(() {
                          locationError = null;
                        });
                      }
                    },
                  ),
                  if (locationError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Text(
                        locationError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      onPressed: () => Navigator.pop(context),
                      text: '취소',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      onPressed: _validateAndSubmit,
                      text: '추가',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
