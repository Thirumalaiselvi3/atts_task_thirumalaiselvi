import 'dart:async';
import 'package:atts/Reusable/color.dart';
import 'package:atts/Routes/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  dynamic userId;
  dynamic roleId;
  final String title = "Sri Sundararaja Perumal Temple";

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
      roleId = prefs.getString("roleId");
    });
    debugPrint("SplashUserId: $userId");
    debugPrint("SplashRoleId: $roleId");
  }

  callApis() async {
    await getToken();
  }

  @override
  void initState() {
    callApis();
    navigateToNextScreen();
    super.initState();
  }

  void navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(
          context, AttsRoutes.secondSplashRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [appBottomColor, appButton2Color],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/logo.png',
            width: size.width * 0.6, // Adjust width dynamically
          ).animate().fade(duration: 1200.ms), // Fading animation
        ),
      ),
    );
  }
}
