class BatterRecordModel {
  final int id;
  final int games;
  final int plateAppearances;
  final int atBats;
  final int runs;
  final int hits;
  final int singles;
  final int doubles;
  final int triples;
  final int homeruns;
  final int walks;
  final int rbis;
  final int steals;
  final int hitByPitch;
  final int strikeouts;
  final int doublePlays;
  final double slg;
  final double obp;
  final double ops;
  final double bbK;
  final double avg;
  final DateTime createdAt;
  final DateTime updatedAt;

  BatterRecordModel({
    required this.id,
    required this.games,
    required this.plateAppearances,
    required this.atBats,
    required this.runs,
    required this.hits,
    required this.singles,
    required this.doubles,
    required this.triples,
    required this.homeruns,
    required this.walks,
    required this.rbis,
    required this.steals,
    required this.hitByPitch,
    required this.strikeouts,
    required this.doublePlays,
    required this.slg,
    required this.obp,
    required this.ops,
    required this.bbK,
    required this.avg,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BatterRecordModel.fromJson(Map<String, dynamic> json) {
    return BatterRecordModel(
      id: json['id'] as int,
      games: json['games'] as int? ?? 0,
      plateAppearances: json['plate_appearances'] as int? ?? 0,
      atBats: json['at_bats'] as int? ?? 0,
      runs: json['runs'] as int? ?? 0,
      hits: json['hits'] as int? ?? 0,
      singles: json['singles'] as int? ?? 0,
      doubles: json['doubles'] as int? ?? 0,
      triples: json['triples'] as int? ?? 0,
      homeruns: json['homeruns'] as int? ?? 0,
      walks: json['walks'] as int? ?? 0,
      rbis: json['rbis'] as int? ?? 0,
      steals: json['steals'] as int? ?? 0,
      hitByPitch: json['hit_by_pitch'] as int? ?? 0,
      strikeouts: json['strikeouts'] as int? ?? 0,
      doublePlays: json['double_plays'] as int? ?? 0,
      slg: (json['slg'] as num?)?.toDouble() ?? 0.0,
      obp: (json['obp'] as num?)?.toDouble() ?? 0.0,
      ops: (json['ops'] as num?)?.toDouble() ?? 0.0,
      bbK: (json['bb_k'] as num?)?.toDouble() ?? 0.0,
      avg: (json['avg'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  factory BatterRecordModel.empty({required int id}) {
    final now = DateTime.now();
    return BatterRecordModel(
      id: id,
      games: 0,
      plateAppearances: 0,
      atBats: 0,
      runs: 0,
      hits: 0,
      singles: 0,
      doubles: 0,
      triples: 0,
      homeruns: 0,
      walks: 0,
      rbis: 0,
      steals: 0,
      hitByPitch: 0,
      strikeouts: 0,
      doublePlays: 0,
      slg: 0.0,
      obp: 0.0,
      ops: 0.0,
      bbK: 0.0,
      avg: 0.0,
      createdAt: now,
      updatedAt: now,
    );
  }
}
