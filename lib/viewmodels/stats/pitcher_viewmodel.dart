import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pitcherViewModelProvider =
    ChangeNotifierProvider((ref) => PitcherViewModel());

class PitcherViewModel extends ChangeNotifier {
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
    // 필수 입력 필드 검증
    if (innings.text.isEmpty) return false;

    return true;
  }

  void save(BuildContext context,
      {required int gameId, required DateTime date}) {
    if (!validate()) return;

    // TODO: 서버에 데이터 저장

    Navigator.of(context).pop();
  }
}
