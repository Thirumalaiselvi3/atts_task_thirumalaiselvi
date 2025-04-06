import 'package:atts/UI/Authentication/login.dart';
import 'package:atts/UI/Dashboard/bottomNav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    firebaseUser.bindStream(auth.authStateChanges());
    super.onInit();
  }

  // Sign Up
  Future<void> signUp(
      String email,
      String password,
      String code,
      String phone,
      String username,
      String address,
      ) async {
    try {
      UserCredential cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user info to Firestore
      await firestore.collection("users").doc(cred.user!.uid).set({
        "uid": cred.user!.uid,
        "email": email,
        "username": username,
        "address": address,
        "phone": '$code $phone',
        "createdAt": DateTime.now(),
      });


      Get.snackbar("Success", "Account created!");

      // Navigate to Login page or Home page after sign up
      Get.offAll(() => LoginScreen()); // or HomePage()
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Sign In
  Future<void> signIn(String email, String password) async {
    try {
      UserCredential cred = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Save sign in data or update last login
      await firestore.collection("users").doc(cred.user!.uid).update({
        "lastLogin": DateTime.now(),
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("uid", cred.user!.uid);
      print('user id ${cred.user!.uid}');
      Get.snackbar("Success", "Logged in!");
      Get.offAll(() => BottomNavBar());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await auth.signOut();
  }
}
