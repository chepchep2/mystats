import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/services/api_service.dart';

final pitcherViewModelProvider =
    ChangeNotifierProvider((ref) => PitcherViewModel(ref.read(apiServiceProvider)));

class PitcherViewModel extends ChangeNotifier {
  final ApiService _apiService;
  
  PitcherViewModel(this._apiService);

  final innings = TextEditingController();
  final wins = TextEditingController();
  final losses = TextEditingController();
  final saves = TextEditingController();
  final holds = TextEditingController();
  final battersFaced = TextEditingController();
  final opponentAtBats = TextEditingController();
  final hitsAllowed = TextEditingController();
  final homerunsAllowed = TextEditingController();
  final walks = TextEditingController();
  final hitByPitch = TextEditingController();
  final strikeouts = TextEditingController();
  final earnedRuns = TextEditingController();

  @override
  void dispose() {
    innings.dispose();
    wins.dispose();
    losses.dispose();
    saves.dispose();
    holds.dispose();
    battersFaced.dispose();
    opponentAtBats.dispose();
    hitsAllowed.dispose();
    homerunsAllowed.dispose();
    walks.dispose();
    hitByPitch.dispose();
    strikeouts.dispose();
    earnedRuns.dispose();
    super.dispose();
  }

  bool validate() {
    try {
      // 필수 입력 필드 검증
      if (innings.text.isEmpty) return false;

      // 이닝 형식 검증 (정수 또는 .1, .2만 허용)
      final inningsValue = double.parse(innings.text);
      final decimal = (inningsValue % 1) * 10;
      if (decimal != 0 && decimal != 1 && decimal != 2) return false;

      // 상대 타석 >= 피안타 검증
      final atBats = int.tryParse(opponentAtBats.text) ?? 0;
      final hits = int.tryParse(hitsAllowed.text) ?? 0;
      if (atBats > 0 && hits > atBats) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  void save(BuildContext context,
      {required int gameId, required DateTime date}) async {
    if (!validate()) return;

    try {
      await _apiService.createPitcherRecord(
        date: date,
        innings: double.parse(innings.text),
        wins: int.tryParse(wins.text) ?? 0,
        losses: int.tryParse(losses.text) ?? 0,
        saves: int.tryParse(saves.text) ?? 0,
        holds: int.tryParse(holds.text) ?? 0,
        battersFaced: int.tryParse(battersFaced.text) ?? 0,
        opponentAtBats: int.tryParse(opponentAtBats.text) ?? 0,
        hitsAllowed: int.tryParse(hitsAllowed.text) ?? 0,
        homerunsAllowed: int.tryParse(homerunsAllowed.text) ?? 0,
        walks: int.tryParse(walks.text) ?? 0,
        hitByPitch: int.tryParse(hitByPitch.text) ?? 0,
        strikeouts: int.tryParse(strikeouts.text) ?? 0,
        earnedRuns: int.tryParse(earnedRuns.text) ?? 0,
      );

      if (context.mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}
