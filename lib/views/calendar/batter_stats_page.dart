import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/viewmodels/stats/batter_viewmodel.dart';

class BatterStatsPage extends ConsumerWidget {
  final int gameId;
  final DateTime date;

  const BatterStatsPage({
    super.key,
    required this.gameId,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(batterViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '타자 기록',
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
                _buildStatInputItem('타율', controller.hits),
                _buildStatInputItem('타점', controller.rbis),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatInputItem('안타', controller.hits),
                _buildStatInputItem('2루타', controller.doubles),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatInputItem('3루타', controller.triples),
                _buildStatInputItem('홈런', controller.homeruns),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatInputItem('타석', controller.plateAppearances),
                _buildStatInputItem('타수', controller.atBats),
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
                _buildStatInputItem('삼진', controller.strikeouts),
                _buildStatInputItem('도루', controller.stolenBases),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatInputItem('도루실패', controller.caughtStealing),
                _buildStatInputItem('득점', controller.runs),
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
