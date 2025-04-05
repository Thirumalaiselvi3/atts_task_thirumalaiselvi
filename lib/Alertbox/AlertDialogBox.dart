import 'package:atts/Reusable/color.dart';
import 'package:flutter/material.dart';

/// show to Logout AlertDialog
showLogoutDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: whiteColor,
            titlePadding: const EdgeInsets.only(
              top: 12,
              left: 26,
            ),
            insetPadding: MediaQuery.of(context).size.width < 650
                ? const EdgeInsets.symmetric(horizontal: 20)
                : const EdgeInsets.symmetric(horizontal: 100),
            buttonPadding:
                const EdgeInsets.only(bottom: 15, left: 20, top: 0, right: 20),
            contentPadding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.07,
              vertical: 10,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(
              "Logout ?",
              style: MediaQuery.of(context).size.width < 650
                  ? const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 2,
                      color: appPrimaryColor,
                    )
                  : const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      height: 2,
                      color: appPrimaryColor,
                    ),
            ),
            content: Text(
              "Are you sure to logout?",
              style: MediaQuery.of(context).size.width < 650
                  ? const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: greyColor,
                    )
                  : const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: greyColor,
                    ),
            ),
            actionsPadding: const EdgeInsets.all(20),
            actions: <Widget>[
              TextButton(
                child: Text("NOT NOW",
                    style: MediaQuery.of(context).size.width < 650
                        ? const TextStyle(
                            color: greyColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          )
                        : const TextStyle(
                            color: greyColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          )),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              Container(
                width: 100,
                height: MediaQuery.of(context).size.width < 650 ? 35 : 40,
                decoration: BoxDecoration(
                    color: appPrimaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: TextButton(
                    child: Text(
                      "LOGOUT",
                      style: MediaQuery.of(context).size.width < 650
                          ? const TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14)
                          : const TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                      textAlign: TextAlign.start,
                    ),
                    onPressed: () async {

                    }),
              ),
            ],
          );
        });
      });
}

