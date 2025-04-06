import 'package:atts/Reusable/color.dart';
import 'package:atts/UI/Landing%20Screen/Home/home.dart';
import 'package:atts/UI/Landing%20Screen/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int initialTab;
  const BottomNavBar({super.key, this.initialTab = 0});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  late int _page;
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [Home(), Profile()];

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
        ],
        color: appBottomColor,
        buttonBackgroundColor: appBottomColor,
        backgroundColor: appFirstColor,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
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
        if (_page != index)
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
}
