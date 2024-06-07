class Exercise {
  final String id;
  final String name;
  final String description;
  final int duration;
  final int calories;
  final String type;
  final String difficulty;
  final int series;
  final String repetitions;
  final bool favourite;
  final String userId;
  final DateTime created;
  final DateTime updated;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.calories,
    required this.type,
    required this.difficulty,
    required this.series,
    required this.repetitions,
    required this.favourite,
    required this.userId,
    required this.created,
    required this.updated,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      duration: json['duration'],
      calories: json['calories'],
      type: json['type'],
      difficulty: json['difficulty'],
      series: json['series'],
      repetitions: json['repetitions'],
      favourite: json['favourite'],
      userId: json['userId'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'duration': duration,
      'calories': calories,
      'type': type,
      'difficulty': difficulty,
      'series': series,
      'repetitions': repetitions,
      'favourite': favourite,
      'userId': userId,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }
}
