import 'package:flutter/material.dart';
import 'package:mystats/models/game/game_model.dart';
import 'package:mystats/widgets/common/custom_button.dart';

class GameDeleteDialog extends StatelessWidget {
  final GameModel game;
  final VoidCallback onDelete;

  const GameDeleteDialog({
    super.key,
    required this.game,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'VS ${game.opponent} 경기 일정을 삭제하시겠습니까?',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: '취소',
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: '삭제',
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    onPressed: () {
                      onDelete();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
