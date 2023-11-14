import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final double barrierWidth; // out of 2, where 2 is the width of the screen
  final double barrierHeight; // proportion of the screen height
  final double barrierX;
  final bool isThisBottomBarrier;
  final int score; // Added score here

  MyBarrier({
    required this.barrierHeight,
    required this.barrierWidth,
    required this.isThisBottomBarrier,
    required this.barrierX,
    required this.score, // Require score
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Your barrier widget
        Container(
          alignment: Alignment(
            (2 * barrierX + barrierWidth) / (2 - barrierWidth),
            isThisBottomBarrier ? 1 : -1,
          ),
          child: Container(
            color: Colors.green,
            width: MediaQuery.of(context).size.width * barrierWidth / 2,
            height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
          ),
        ),
        // Score Display - Positioned in the top center of the screen
        Positioned(
          top: 20,
          right: 20,
          child: Text(
            'Score: $score',
            style: TextStyle(
              color: Colors.black
              ,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
