import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyBall(),
    );
  }
}


class MyBall extends StatefulWidget {
  const MyBall({super.key});

  @override
  State<MyBall> createState() => _MyBallState();
}

class _MyBallState extends State<MyBall> {
  int ballNumber = 3;

  void changeBall() {
    setState(() {
      ballNumber = Random().nextInt(5) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SafeArea(child: Text('My Ball')),
      ),
      body: Center(
        child: TextButton(
            onPressed: () {
              changeBall();
            },
            child: Image.asset('images/ball$ballNumber.png')),
      ),
    );
  }
}
