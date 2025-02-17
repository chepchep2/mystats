import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/models/game/game_model.dart';
import 'package:mystats/services/api_service.dart';
import 'package:mystats/providers/auth_provider.dart';
import 'package:mystats/widgets/common/custom_text_field.dart';
import 'package:mystats/widgets/common/custom_button.dart';
import 'package:mystats/widgets/common/custom_time_picker.dart';
import 'package:go_router/go_router.dart';

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
  bool _isLoading = false;

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

  void _validateAndSubmit() async {
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

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ref.read(apiServiceProvider);
      final game = await apiService.createGame(
        date: gameDateTime,
        opponent: _opponentController.text.trim(),
        location: _locationController.text.trim(),
      );

      if (mounted) {
        widget.onSave(game);
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = e.toString();
        if (errorMessage.contains('401')) {
          errorMessage = '로그인이 필요합니다. 다시 로그인해주세요.';
          // 로그아웃 처리
          ref.read(authProvider.notifier).logout();
          // 로그인 화면으로 이동
          if (context.mounted) {
            context.go('/login');
          }
        } else {
          errorMessage = '경기 일정 추가 실패';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _opponentController,
                hint: '상대팀을 입력하세요',
                prefixIcon: Icons.people,
                // errorText: _opponentError,
                onChanged: (_) {
                  if (_opponentError != null) {
                    setState(() {
                      _opponentError = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _locationController,
                hint: '장소를 입력하세요',
                prefixIcon: Icons.location_on,
                // errorText: _locationError,
                onChanged: (_) {
                  if (_locationError != null) {
                    setState(() {
                      _locationError = null;
                    });
                  }
                },
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
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: CustomButton(
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      onPressed: () => context.pop(),
                      text: '취소',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      onPressed: _validateAndSubmit,
                      text: '저장',
                      isLoading: _isLoading,
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

  @override
  void dispose() {
    _opponentController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
