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
    if (points >= 0 && points < 100) {
      return 1;
    } else if (points >= 100 && points < 200) {
      return 2;
    } else if (points >= 200 && points < 300) {
      return 3;
    } else if (points >= 300 && points < 400) {
      return 4;
    } else if (points >= 400 && points < 500) {
      return 5;
    } else if (points >= 500 && points < 600) {
      return 6;
    } else if (points >= 600 && points < 700) {
      return 7;
    } else if (points >= 700 && points < 800) {
      return 8;
    } else if (points >= 800 && points < 900) {
      return 9;
    } else {
      return 10;
    }
  }
}
