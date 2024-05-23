import 'package:flutter/material.dart';

class ExerciseDetailsWidget2 extends StatelessWidget {
  final int calories;
  final String type;
  final String difficulty;

  ExerciseDetailsWidget2({
    required this.calories,
    required this.type,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width *
            0.8, // Set width to 80% of screen width
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Icon(Icons.local_fire_department),
                SizedBox(height: 8),
                Text(
                  'Calories',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('$calories'),
              ],
            ),
            Column(
              children: [
                Icon(Icons.category),
                SizedBox(height: 8),
                Text(
                  'Type',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('$type'),
              ],
            ),
            Column(
              children: [
                Icon(Icons.star),
                SizedBox(height: 8),
                Text(
                  'Difficulty',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('$difficulty'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
