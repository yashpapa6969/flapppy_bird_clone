import 'package:flutter/material.dart';

import 'dart:async';

import 'barrier.dart';
import 'bird.dart';
import 'coverscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Game(),
    );
  }
}

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  _Game createState() => _Game();
}

class _Game extends State<Game> {
  // bird variables
  static double birdY = 0;
  int score = 0;

  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9;
  double velocity = 3.5;
  double birdWidth = 0.1;
  double birdHeight = 0.1;

  // game settings
  bool gameHasStarted = false;

  // barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    // [topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6],
  ];
  double getBarrierWidth(double screenWidth) => screenWidth * 0.1; // Example: 10% of the screen width
  double getBarrierHeight(double screenHeight) => screenHeight * 0.3; // Example: 30% of the screen height
  double getBirdSize(double screenWidth) => screenWidth * 0.1; // Example: bird size as 10% of the screen width

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      // a real physical jump is the same as an upside down parabola
      // so this is a simple quadratic equation
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;
      });

      if (birdIsDead()) {
        timer.cancel();
        _showDialog();
      } else {
        moveMap();
      }

      time += 0.01;
    });
  }

  void incrementScore() {
    setState(() {
      score += 1;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.005;
      });

      // Check if the barrier is just passing the bird and if so, increment the score
      // This logic assumes that your bird stays in the center and the barriers move towards the bird
      if (barrierX[i] < 0 && barrierX[i] + 0.005 >= 0) {
        incrementScore();
      }

      // When the barrier goes off the screen, reset its position and possibly increase difficulty
      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
        // You could adjust barrierHeight here to increase difficulty
      }
    }
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
      barrierX = [2, 2 + 1.5];
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return score >= 3
              ? AlertDialog(
                  backgroundColor: Colors.brown,
                  title: Center(
                    child: Text(
                      "Flag{ILOVEGDSCXYZ}",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        score = 0;
                        resetGame();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          padding: EdgeInsets.all(7),
                          color: Colors.white,
                          child: Text(
                            'Restart',
                            style: TextStyle(color: Colors.brown),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : AlertDialog(
                  backgroundColor: Colors.brown,
                  title: Center(
                    child: Text(
                      "G A M E  O V E R",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        score = 0;
                        resetGame();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          padding: EdgeInsets.all(7),
                          color: Colors.white,
                          child: Text(
                            'Restart',
                            style: TextStyle(color: Colors.brown),
                          ),
                        ),
                      ),
                    )
                  ],
                );
        });
  }

  void _showDialog1() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: Center(
              child: Text(
                "Restart",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Text(
                      'Click to view',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  bool birdIsDead() {
    if (birdY < -1 || birdY > 1) {
      return true;
    }

    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(

              image: NetworkImage(
                  'https://raw.githubusercontent.com/yashpapa6969/mysql-Node-Injection/main/fb-game-background.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  child: Center(
                    child: Stack(
                      children: [
                        // bird
                        MyBird(
                          birdY: birdY,
                          birdWidth: birdWidth,
                          birdHeight: birdHeight,
                        ),

                        // tap to play
                        MyCoverScreen(gameHasStarted: gameHasStarted),

                        MyBarrier(
                          barrierX: barrierX[0],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][0],
                          isThisBottomBarrier: false,
                          score: score,
                        ),

                        // Bottom barrier 0
                        MyBarrier(
                          score: score,
                          barrierX: barrierX[0],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][1],
                          isThisBottomBarrier: true,
                        ),

                        // Top barrier 1
                        MyBarrier(
                          score: score,
                          barrierX: barrierX[1],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][0],
                          isThisBottomBarrier: false,
                        ),

                        // Bottom barrier 1
                        MyBarrier(
                          score: score,
                          barrierX: barrierX[1],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][1],
                          isThisBottomBarrier: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '0',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 35),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'S C O R E',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '10',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 35),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'B E S T',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
