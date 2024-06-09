import 'package:flutter/material.dart';

class PointsWidget extends StatelessWidget {
  final int points;

  PointsWidget({
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    int level = calculateLevel(points);
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Level $level',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              '$points Points',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: points / 1000,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 255, 189, 23)),
              minHeight: 10,
            ),
          ],
        ),
      ),
    );
  }

  int calculateLevel(int points) {
    if (points >= 0 && points < 1000) {
      return 1;
    } else if (points >= 1000 && points < 2000) {
      return 2;
    } else if (points >= 2000 && points < 3000) {
      return 3;
    } else if (points >= 3000 && points < 4000) {
      return 4;
    } else if (points >= 4000 && points < 5000) {
      return 5;
    } else if (points >= 5000 && points < 6000) {
      return 6;
    } else if (points >= 6000 && points < 7000) {
      return 7;
    } else if (points >= 7000 && points < 8000) {
      return 8;
    } else if (points >= 8000 && points < 9000) {
      return 9;
    } else if (points >= 9000 && points < 10000) {
      return 10;
    } else {
      return 11;
    }
  }
}
