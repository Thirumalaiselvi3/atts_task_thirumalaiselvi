import 'package:atts/Reusable/color.dart';
import 'package:atts/UI/Drawer/drawer.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appFirstColor,
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('Click the top-left icon to open the drawer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
