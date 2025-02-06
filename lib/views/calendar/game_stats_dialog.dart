import 'package:flutter/material.dart';
import 'package:mystats/models/game/game_model.dart';
import 'package:mystats/views/calendar/batter_stats_page.dart';
import 'package:mystats/views/calendar/pitcher_stats_page.dart';
import 'package:mystats/widgets/common/custom_button.dart';
import 'package:mystats/widgets/common/custom_icon_button.dart';

class GameStatsDialog extends StatelessWidget {
  final GameModel game;

  const GameStatsDialog({
    super.key,
    required this.game,
  });

  bool _canRecordStats() {
    final now = DateTime.now();
    final gameEndTime = game.date.add(const Duration(minutes: 30));
    return now.isAfter(gameEndTime);
  }

  void _showTimeWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                Icons.access_time,
                color: Colors.orange,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                '아직 기록을 입력할 수 없습니다',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '경기 종료 30분 후부터 기록을 입력할 수 있습니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: '확인',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canRecordStats = _canRecordStats();

    return Dialog(
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
                Text(
                  'VS ${game.opponent} 기록',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                CustomIconButton(
                  icon: Icons.close,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: '타자 기록',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              onPressed: () {
                if (!canRecordStats) {
                  _showTimeWarning(context);
                  return;
                }
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BatterStatsPage(
                      gameId: game.id,
                      date: game.date,
                      game: game,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: '투수 기록',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              onPressed: () {
                if (!canRecordStats) {
                  _showTimeWarning(context);
                  return;
                }
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PitcherStatsPage(
                      gameId: game.id,
                      date: game.date,
                      game: game,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
