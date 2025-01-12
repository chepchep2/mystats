class UserModel {
  final int id;
  final String email;
  final String name;
  final String team;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.team,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      team: json['team'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'team': team,
    };
  }
}
