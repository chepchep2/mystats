import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/models/game/game_model.dart';
import 'package:mystats/widgets/common/custom_text_field.dart';
import 'package:mystats/widgets/common/custom_button.dart';
import 'package:mystats/widgets/common/custom_time_picker.dart';

class GameFormDialog extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  final Function(GameModel) onSave;
  final GameModel? initialGame;

  const GameFormDialog({
    super.key,
    required this.selectedDate,
    required this.onSave,
    this.initialGame,
  });

  @override
  ConsumerState<GameFormDialog> createState() => _GameFormDialogState();
}

class _GameFormDialogState extends ConsumerState<GameFormDialog> {
  late TextEditingController _opponentController;
  late TextEditingController _locationController;
  late TimeOfDay _selectedTime;
  String? _opponentError;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    _opponentController =
        TextEditingController(text: widget.initialGame?.opponent ?? '');
    _locationController =
        TextEditingController(text: widget.initialGame?.location ?? '');
    _selectedTime = widget.initialGame?.date != null
        ? TimeOfDay(
            hour: widget.initialGame!.date.hour,
            minute: widget.initialGame!.date.minute)
        : TimeOfDay.now();
  }

  void _validateAndSubmit() {
    setState(() {
      _opponentError =
          _opponentController.text.trim().isEmpty ? '상대팀을 입력해주세요' : null;
      _locationError =
          _locationController.text.trim().isEmpty ? '장소를 입력해주세요' : null;
    });

    if (_opponentController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty) {
      return;
    }

    final gameDateTime = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final game = GameModel(
      id: widget.initialGame?.id ?? DateTime.now().millisecondsSinceEpoch,
      date: gameDateTime,
      opponent: _opponentController.text.trim(),
      location: _locationController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onSave(game);
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
                selectedTime: _selectedTime,
                onTimeChanged: (newTime) {
                  setState(() {
                    _selectedTime = newTime;
                  });
                },
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: _opponentController,
                    hint: '상대팀을 입력하세요',
                    prefixIcon: Icons.people,
                    onChanged: (_) {
                      if (_opponentError != null) {
                        setState(() {
                          _opponentError = null;
                        });
                      }
                    },
                  ),
                  if (_opponentError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Text(
                        _opponentError!,
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
                    controller: _locationController,
                    hint: '장소를 입력하세요',
                    prefixIcon: Icons.location_on,
                    onChanged: (_) {
                      if (_locationError != null) {
                        setState(() {
                          _locationError = null;
                        });
                      }
                    },
                  ),
                  if (_locationError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Text(
                        _locationError!,
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
                      text: widget.initialGame != null ? '수정' : '추가',
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
