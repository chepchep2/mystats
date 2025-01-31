import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final batterViewModelProvider =
    ChangeNotifierProvider((ref) => BatterViewModel());

class BatterViewModel extends ChangeNotifier {
  final plateAppearances = TextEditingController();
  final atBats = TextEditingController();
  final runs = TextEditingController();
  final hits = TextEditingController();
  final doubles = TextEditingController();
  final triples = TextEditingController();
  final homeruns = TextEditingController();
  final rbis = TextEditingController();
  final walks = TextEditingController();
  final hitByPitch = TextEditingController();
  final strikeouts = TextEditingController();
  final stolenBases = TextEditingController();
  final caughtStealing = TextEditingController();

  @override
  void dispose() {
    plateAppearances.dispose();
    atBats.dispose();
    runs.dispose();
    hits.dispose();
    doubles.dispose();
    triples.dispose();
    homeruns.dispose();
    rbis.dispose();
    walks.dispose();
    hitByPitch.dispose();
    strikeouts.dispose();
    stolenBases.dispose();
    caughtStealing.dispose();
    super.dispose();
  }

  bool validate() {
    // 필수 입력 필드 검증
    if (plateAppearances.text.isEmpty || atBats.text.isEmpty) return false;

    return true;
  }

  void save(BuildContext context,
      {required int gameId, required DateTime date}) {
    if (!validate()) return;

    // TODO: 서버에 데이터 저장

    Navigator.of(context).pop();
  }
}
