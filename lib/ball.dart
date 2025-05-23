import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  const Ball({super.key, required this.ballNumber});

  final int ballNumber;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/ball$ballNumber.png',
      width: MediaQuery.sizeOf(context).width * 0.8,
    );
  }
}
