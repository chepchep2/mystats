import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/viewmodels/stats/pitcher_viewmodel.dart';

class PitcherStatsPage extends ConsumerWidget {
  final int gameId;
  final DateTime date;

  const PitcherStatsPage({
    super.key,
    required this.gameId,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(pitcherViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '투수 기록',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.validate()) {
                try {
                  controller.save(context, gameId: gameId, date: date);
                } catch (e) {
                  // Handle the error
                }
              }
            },
            child: const Text(
              '저장',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatInputItem('승', controller.wins),
                _buildStatInputItem('패', controller.losses),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatInputItem('세이브', controller.saves),
                _buildStatInputItem('홀드', controller.holds),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatInputItem('이닝', controller.innings),
                _buildStatInputItem('실점', controller.earnedRuns),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatInputItem('피안타', controller.hitsAllowed),
                _buildStatInputItem('피홈런', controller.homerunsAllowed),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatInputItem('볼넷', controller.walks),
                _buildStatInputItem('사구', controller.hitByPitch),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatInputItem('탈삼진', controller.strikeouts),
                _buildStatInputItem('상대타자', controller.battersFaced),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatInputItem('상대타수', controller.opponentAtBats),
                const SizedBox(width: 140),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatInputItem(String title, TextEditingController controller) {
    return SizedBox(
      width: 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 40,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
