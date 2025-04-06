import 'package:atts/Routes/route.dart';
import 'package:atts/UI/Authentication/signup.dart';
import 'package:atts/UI/Dashboard/bottomNav.dart';
import 'package:atts/UI/Drawer/Menu/Product/add_product.dart';
import 'package:atts/UI/Drawer/Menu/over_all_report.dart';
import 'package:atts/UI/Drawer/Menu/Product/product_list.dart';
import 'package:atts/UI/SplashScreen/splash_screen.dart';
import 'package:flutter/material.dart';

import '../UI/Authentication/login.dart';
import '../UI/SplashScreen/second_splash_screen.dart';

class InstantPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  InstantPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );
}

class RouteManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AttsRoutes.loginRoute:
        return InstantPageRoute(page: const LoginScreen());
      case AttsRoutes.signUpRoute:
        return InstantPageRoute(page: const SignUp());
      case AttsRoutes.splashRoute:
        return InstantPageRoute(page: const SplashScreen());
      case AttsRoutes.secondSplashRoute:
        return InstantPageRoute(page: const SecondSplashScreen());
      case AttsRoutes.bottomNavBarRoute:
        return InstantPageRoute(page: const BottomNavBar());
        case AttsRoutes.productListRoute:
        return InstantPageRoute(page: const ProductList());
        case AttsRoutes.overAllReportRoute:
        return InstantPageRoute(page:   OverAllReport());
        case AttsRoutes.addProductRoute:
        return InstantPageRoute(page:  AddProduct());


      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Unknown Route')),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
