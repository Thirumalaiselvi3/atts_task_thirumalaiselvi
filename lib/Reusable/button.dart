
import 'package:flutter/material.dart';

import 'color.dart';

Widget appButton({
  double height = 50.0,
  double width = 150.0,
  double font = 14,
  String? buttonText,
  Color? color,
  VoidCallback? onTap,
}) {
  return Center(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [appButton1Color, appButton2Color],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            buttonText ?? '',
            style: TextStyle(
              fontSize: font,
              color: color ?? whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ),
  );
}
