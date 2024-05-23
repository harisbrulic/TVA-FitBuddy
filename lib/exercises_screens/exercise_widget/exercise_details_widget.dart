import 'package:flutter/material.dart';

class ExerciseDetailsWidget extends StatelessWidget {
  final int series;
  final String repetitions;
  final int duration;

  ExerciseDetailsWidget({
    required this.series,
    required this.repetitions,
    required this.duration,
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
                Icon(Icons.format_list_numbered),
                SizedBox(height: 8),
                Text(
                  'Serije',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('$series'),
              ],
            ),
            Column(
              children: [
                Icon(Icons.repeat),
                SizedBox(height: 8),
                Text(
                  'Ponovitve',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('$repetitions'),
              ],
            ),
            Column(
              children: [
                Icon(Icons.timer),
                SizedBox(height: 8),
                Text(
                  'Duration',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('$duration min'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
