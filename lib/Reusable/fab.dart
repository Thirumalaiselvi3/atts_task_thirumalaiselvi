import 'package:atts/Reusable/color.dart';
import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;

  const CustomFAB({
    Key? key,
    required this.onPressed,
    this.icon = Icons.add, // default icon
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      child: Icon(icon,color: whiteColor,),
    );
  }
}
