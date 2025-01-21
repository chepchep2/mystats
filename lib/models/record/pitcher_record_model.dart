class PitcherRecordModel {
  final int id;
  final int games;
  final double innings;
  final int wins;
  final int losses;
  final int saves;
  final int holds;
  final double era;
  final double whip;
  final int battersFaced;
  final int opponentAtBats;
  final int hitsAllowed;
  final int homerunsAllowed;
  final int walks;
  final int hitByPitch;
  final int strikeouts;
  final int earnedRuns;
  final double winningPct;
  final double strikeoutRate;
  final double opponentAvg;
  final DateTime createdAt;
  final DateTime updatedAt;

  PitcherRecordModel({
    required this.id,
    required this.games,
    required this.innings,
    required this.wins,
    required this.losses,
    required this.saves,
    required this.holds,
    required this.era,
    required this.whip,
    required this.battersFaced,
    required this.opponentAtBats,
    required this.hitsAllowed,
    required this.homerunsAllowed,
    required this.walks,
    required this.hitByPitch,
    required this.strikeouts,
    required this.earnedRuns,
    required this.winningPct,
    required this.strikeoutRate,
    required this.opponentAvg,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PitcherRecordModel.fromJson(Map<String, dynamic> json) {
    return PitcherRecordModel(
      id: json['id'] as int,
      games: json['games'] as int? ?? 0,
      innings: (json['innings'] as num?)?.toDouble() ?? 0.0,
      wins: json['wins'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
      saves: json['saves'] as int? ?? 0,
      holds: json['holds'] as int? ?? 0,
      era: (json['era'] as num?)?.toDouble() ?? 0.0,
      whip: (json['whip'] as num?)?.toDouble() ?? 0.0,
      battersFaced: json['batters_faced'] as int? ?? 0,
      opponentAtBats: json['opponent_at_bats'] as int? ?? 0,
      hitsAllowed: json['hits_allowed'] as int? ?? 0,
      homerunsAllowed: json['homeruns_allowed'] as int? ?? 0,
      walks: json['walks'] as int? ?? 0,
      hitByPitch: json['hit_by_pitch'] as int? ?? 0,
      strikeouts: json['strikeouts'] as int? ?? 0,
      earnedRuns: json['earned_runs'] as int? ?? 0,
      winningPct: (json['winning_pct'] as num?)?.toDouble() ?? 0.0,
      strikeoutRate: (json['strikeout_rate'] as num?)?.toDouble() ?? 0.0,
      opponentAvg: (json['opponent_avg'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  factory PitcherRecordModel.empty({required int id}) {
    final now = DateTime.now();
    return PitcherRecordModel(
      id: id,
      games: 0,
      innings: 0.0,
      wins: 0,
      losses: 0,
      saves: 0,
      holds: 0,
      era: 0.0,
      whip: 0.0,
      battersFaced: 0,
      opponentAtBats: 0,
      hitsAllowed: 0,
      homerunsAllowed: 0,
      walks: 0,
      hitByPitch: 0,
      strikeouts: 0,
      earnedRuns: 0,
      winningPct: 0.0,
      strikeoutRate: 0.0,
      opponentAvg: 0.0,
      createdAt: now,
      updatedAt: now,
    );
  }
}
