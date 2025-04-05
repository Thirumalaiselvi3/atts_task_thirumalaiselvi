import 'package:flutter/material.dart';


class LogoDecoration extends BoxDecoration {
  LogoDecoration()
      : super(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: Colors.yellow.withOpacity(0.6),
        blurRadius: 70,
        spreadRadius: 2,
        offset: const Offset(0, 0),
      ),
    ],
  );
}

