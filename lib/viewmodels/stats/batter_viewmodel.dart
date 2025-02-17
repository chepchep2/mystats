import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/services/api_service.dart';

final batterViewModelProvider = ChangeNotifierProvider(
    (ref) => BatterViewModel(ref.read(apiServiceProvider)));

class BatterViewModel extends ChangeNotifier {
  final ApiService _apiService;

  BatterViewModel(this._apiService);

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
  final doublePlays = TextEditingController();

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
    doublePlays.dispose();
    super.dispose();
  }

  bool validate() {
    try {
      // 필수 입력 필드 검증
      if (plateAppearances.text.isEmpty || atBats.text.isEmpty || hits.text.isEmpty) {
        return false;
      }

      // 숫자 형식 검증
      final pa = int.parse(plateAppearances.text);
      final ab = int.parse(atBats.text);
      final h = int.parse(hits.text);
      final d = int.tryParse(doubles.text) ?? 0;
      final t = int.tryParse(triples.text) ?? 0;
      final hr = int.tryParse(homeruns.text) ?? 0;

      // 타석 >= 타수 검증
      if (pa < ab) return false;

      // 안타 종류별 합계 검증
      if (h < (d + t + hr)) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  void save(BuildContext context,
      {required int gameId, required DateTime date}) async {
    if (!validate()) return;

    try {
      final totalHits = int.parse(hits.text);
      final doublesCount = int.tryParse(doubles.text) ?? 0;
      final triplesCount = int.tryParse(triples.text) ?? 0;
      final homerunsCount = int.tryParse(homeruns.text) ?? 0;
      final singlesCount =
          totalHits - (doublesCount + triplesCount + homerunsCount);

      await _apiService.createBatterRecord(
        date: date,
        plateAppearances: int.parse(plateAppearances.text),
        atBats: int.parse(atBats.text),
        runs: int.tryParse(runs.text) ?? 0,
        hits: totalHits,
        singles: singlesCount,
        doubles: doublesCount,
        triples: triplesCount,
        homeruns: homerunsCount,
        walks: int.tryParse(walks.text) ?? 0,
        rbis: int.tryParse(rbis.text) ?? 0,
        steals: int.tryParse(stolenBases.text) ?? 0,
        hitByPitch: int.tryParse(hitByPitch.text) ?? 0,
        strikeouts: int.tryParse(strikeouts.text) ?? 0,
        doublePlays: int.tryParse(doublePlays.text) ?? 0,
      );

      if (context.mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    }
  }
}
