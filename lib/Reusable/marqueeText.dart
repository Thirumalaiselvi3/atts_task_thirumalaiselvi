import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import 'color.dart';

class MarqueeText extends StatelessWidget {
  final String text;
  final double fontSize;

  const MarqueeText({
    super.key,
    required this.text,
    this.fontSize = 20.0, // Default font size
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: fontSize + 10, // Adjust height based on text size
      child: Marquee(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: amberColor,
          shadows: const [
            Shadow(
              blurRadius: 5.0,
              color: Colors.black,
              offset: Offset(2, 2),
            ),
          ],
        ),
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        blankSpace: 20.0,
        velocity: 50.0,
        pauseAfterRound: const Duration(seconds: 1),
        startPadding: 10.0,
        accelerationDuration: const Duration(seconds: 1),
        accelerationCurve: Curves.easeIn,
        decelerationDuration: const Duration(seconds: 1),
        decelerationCurve: Curves.easeOut,
      ),
    );
  }
}
