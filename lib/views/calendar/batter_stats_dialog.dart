import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/viewmodels/stats/batter_viewmodel.dart';

class BatterStatsDialog extends ConsumerWidget {
  final int gameId;
  final DateTime date;

  const BatterStatsDialog({
    super.key,
    required this.gameId,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(batterViewModelProvider);

    return Dialog(
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '타자 기록',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatInputItem('타석', controller.plateAppearances),
                      _buildStatInputItem('타수', controller.atBats),
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
                      _buildStatInputItem('타점', controller.rbis),
                      _buildStatInputItem('득점', controller.runs),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatInputItem('볼넷', controller.walks),
                      _buildStatInputItem('사구', controller.hitByPitch),
                      _buildStatInputItem('삼진', controller.strikeouts),
                      _buildStatInputItem('도루', controller.stolenBases),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatInputItem('도루실패', controller.caughtStealing),
                      _buildStatInputItem('병살타', controller.doublePlays),
                      const SizedBox(width: 80),
                      const SizedBox(width: 80),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (controller.validate()) {
                      controller.save(context, gameId: gameId, date: date);
                    }
                  },
                  child: const Text('저장'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatInputItem(String title, TextEditingController controller) {
    return SizedBox(
      width: 80,
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
