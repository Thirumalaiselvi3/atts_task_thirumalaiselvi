import 'package:atts/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Controller/Authentication/authentication_controller.dart';
import 'Routes/route.dart';
import 'Routes/route_manager.dart';

void main() async{


    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    Get.put(AuthController());
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseAuth.instance.setLanguageCode('en');
      print('Firebase initialized successfully');
    } catch (e) {
      print('Error initializing Firebase: $e');
    }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ATTS Jewellery',
      initialRoute: AttsRoutes.splashRoute,
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}
