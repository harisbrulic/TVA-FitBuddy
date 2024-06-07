class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final DateTime birthdate;
  final String gender;
  final int height;
  final int weight;
  final int points;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.birthdate,
    required this.gender,
    required this.height,
    required this.weight,
    required this.points,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      birthdate: DateTime.parse(json['birthdate']),
      gender: json['gender'],
      height: json['height'],
      weight: json['weight'],
      points: json['points'],
    );
  }
}
