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
              backgroundColor: Colors.white,
              textColor: Colors.black,
              text: '타자 기록',
              onPressed: () {
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
              backgroundColor: Colors.white,
              textColor: Colors.black,
              text: '투수 기록',
              onPressed: () {
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

  Widget _buildStatsButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
