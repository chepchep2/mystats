class GameModel {
  final int id;
  final DateTime date;
  final String? opponent;
  final String? location;
  final String? result;
  final int? myScore;
  final int? opponentScore;
  final DateTime createdAt;
  final DateTime updatedAt;

  GameModel({
    required this.id,
    required this.date,
    this.opponent,
    this.location,
    this.result,
    this.myScore,
    this.opponentScore,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      opponent: json['opponent'] as String?,
      location: json['location'] as String?,
      result: json['result'] as String?,
      myScore: json['my_score'] as int?,
      opponentScore: json['opponent_score'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
