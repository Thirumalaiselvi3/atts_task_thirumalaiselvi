import 'package:atts/Reusable/text_styles.dart';
import 'package:flutter/material.dart';
import 'color.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color titleColor;

  const CommonAppBar({
    super.key,
    required this.title,
    this.backgroundColor = appFirstColor,
    this.titleColor = appBottomColor ,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Image.asset(
            "assets/arrow.png",
            width: 18,
            height: 18,
            alignment: Alignment.topCenter,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      title: Text(
        title,
        style: MyTextStyle.f16( titleColor ,weight: FontWeight.bold),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
