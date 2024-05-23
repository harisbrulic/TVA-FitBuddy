// lib/exercise.dart
class Exercise {
  final String id;
  final String name;
  final String description;
  final int duration;
  final int calories;
  final String type;
  final String difficulty;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.calories,
    required this.type,
    required this.difficulty,
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
    );
  }
}
