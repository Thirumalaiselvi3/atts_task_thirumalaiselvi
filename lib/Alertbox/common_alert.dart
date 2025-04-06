import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Reusable/color.dart';
import '../Reusable/text_styles.dart';

void CommonAlert({
  required BuildContext context,
  required String title,
  required String description,
  required VoidCallback onOkPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: appFirstColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style:MyTextStyle.f16(blackColor,weight: FontWeight.bold)),
        content: Text(description, style: MyTextStyle.f14(blackColor,weight: FontWeight.w400)),
        actions: [
          // Cancel Button (Outlined)
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: appBottomColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text("Cancel", style:MyTextStyle.f14(appBottomColor)),
          ),
          ElevatedButton(
            onPressed: onOkPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: appBottomColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text("OK", style:MyTextStyle.f14(whiteColor)),
          ),
        ],
      );
    },
  );
}
