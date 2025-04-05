import 'package:atts/Reusable/color.dart';
import 'package:atts/UI/Authentication/login.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BottomNavBar extends StatefulWidget {
  final int initialTab;
  const BottomNavBar({super.key, this.initialTab = 0});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  late int _page;
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [

  ];
  @override


  void initState() {
    super.initState();
    _page = widget.initialTab;


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _page,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: bottomNavigationKey,
        index: _page,
        items: <Widget>[
          _buildNavItem(Icons.home, "Home", 0),
          _buildNavItem(Icons.perm_identity, "Profile", 1),
          _buildNavItem(Icons.phone, "Contact", 2),
        ],
        color: appBottomColor,
        buttonBackgroundColor: appBottomColor,
        backgroundColor: appFirstColor,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),



        onTap: (index) async {
          // if (index == 1) {
          //   // When clicking on Profile tab
          //   SharedPreferences prefs = await SharedPreferences.getInstance();
          //   String? userId = prefs.getString('user_id');
          //
          //   if (userId == null || userId.isEmpty) {
          //     // Redirect to login screen
          //     Navigator.pushNamed(context, '/login');
          //     return; // Do not update the tab index
          //   }
          // }

          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: _page == index ? appTitleShadowColor : appButton1Color,
          size: 30,
        ),
        if (_page != index) // Show label only if not selected
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: appButton1Color,
            ),
          ),
      ],
    );
  }

  // Widget _buildNavItem(IconData icon, String label, int index) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Icon(
  //         icon,
  //         color: _page == index ? appTitleShadowColor : appButton1Color,
  //         size: 30,
  //       ),
  //       Text(
  //         label,
  //         style: TextStyle(
  //           fontSize: 12,
  //           color: _page == index ? appTitleShadowColor : appButton1Color,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
