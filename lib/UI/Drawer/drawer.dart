import 'package:atts/Reusable/color.dart';
import 'package:atts/Reusable/container_decoration.dart';
import 'package:atts/Reusable/text_styles.dart';
import 'package:atts/Routes/route.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: appFirstColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Center(
                child: Container(
                  decoration: LogoDecoration(),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: appBottomColor,
                    child: ClipOval(
                      child: Image.asset(
                        "assets/logo.png",
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'ATTS JEWELLERY',
                style: MyTextStyle.f24(appBottomColor, weight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                color: appBottomColor,
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: (){
Navigator.pop(context);
Navigator.pushNamed(context, AttsRoutes.productListRoute);
                },
                leading: Icon(Icons.category, color: appBottomColor),
                title: Text(
                  'Product',
                  style: MyTextStyle.f16(appBottomColor),
                ),
              ),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AttsRoutes.overAllReportRoute);
                },
                leading: Icon(Icons.report_gmailerrorred_rounded, color: appBottomColor),
                title: Text(
                  'Over All Report',
                  style: MyTextStyle.f16(appBottomColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
