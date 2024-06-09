class Training {
  final String name;
  final int duration;
  final int calories;
  final String difficulty;
  final bool favourite;
  final String userId;
  final List<String> exerciseIds;
  final DateTime created;
  final DateTime updated;

  Training({
    required this.name,
    required this.duration,
    required this.calories,
    required this.difficulty,
    required this.favourite,
    required this.userId,
    required this.exerciseIds,
    required this.created,
    required this.updated,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      name: json['name'],
      duration: json['duration'],
      calories: json['calories'],
      difficulty: json['difficulty'],
      favourite: json['favourite'],
      userId: json['userId'],
      exerciseIds: List<String>.from(json['exerciseIds']),
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }
}
