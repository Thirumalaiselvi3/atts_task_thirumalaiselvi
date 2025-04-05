import 'package:atts/Reusable/color.dart';
import 'package:flutter/material.dart';


class LogoDecoration extends BoxDecoration {
  LogoDecoration()
      : super(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: appButton2Color,
        blurRadius: 70,
        spreadRadius: 2,
        offset: const Offset(0, 0),
      ),
    ],
  );
}

