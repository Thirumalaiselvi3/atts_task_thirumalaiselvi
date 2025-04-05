import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:atts/Reusable/button.dart';
import 'package:atts/Reusable/color.dart';
import 'package:atts/Reusable/container_decoration.dart';
import 'package:atts/Reusable/customTextfield.dart';
import 'package:atts/Reusable/text_styles.dart';
import 'package:atts/Routes/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginScreen extends StatefulWidget {


  const LoginScreen({
    Key? key,
  }): super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  RegExp emailRegex = RegExp(r'\S+@\S+\.\S+');
  String? errorMessage;
  var showPassword = true;
  bool loginLoad = false;
  callNav() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_tab', 1);
    Navigator.pushNamedAndRemoveUntil(
        context, AttsRoutes.bottomNavBarRoute, (route) => false);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image.asset(
                          "assets/arrow.png",
                          width: size.width * 0.1,
                          height: size.height * 0.05,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: LogoDecoration(),
                      child: Image.asset(
                        "assets/logo1.png",
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Center(
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(seconds: 2), // Scale effect
                        tween: Tween<double>(begin: 0.7, end: 1.0),
                        builder: (context, scale, child) {
                          return Transform.scale(
                            scale: scale,
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TyperAnimatedText(
                                  'WELCOME TO SRI SUNDARARAJA PERUMAL TEMPLE',
                                  textAlign: TextAlign.center,
                                  textStyle: MyTextStyle.splashTitle(),
                                  speed: const Duration(
                                      milliseconds: 100), // Letter speed
                                ),
                              ],
                              totalRepeatCount: 1, // Run once
                              isRepeatingAnimation: false,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 0, left: 10, right: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(20), // Rounded edges
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 10, sigmaY: 10), // Glass blur effect
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: appButton1Color, width: 1),
                                    borderRadius: BorderRadius.circular(20)),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 5),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 15),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text("Your Email",
                                                style: MyTextStyle.f14(
                                                    appButton1Color))),
                                      ),
                                      CustomTextField(
                                          hint: "Email Address",
                                          readOnly: false,
                                          controller: email,
                                          baseColor: appPrimaryColor,
                                          borderColor: appButton1Color,
                                          errorColor: redColor,
                                          inputType: TextInputType.text,
                                          showSuffixIcon: false,
                                          fTextInputFormatter:
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[a-zA-Z0-9.@]")),
                                          obscureText: false,
                                          maxLength: 30,
                                          onChanged: (val) {
                                            _formKey.currentState!.validate();
                                          },
                                          validator: (value) {
                                            if (value != null) {
                                              if (value.isEmpty) {
                                                return 'Please enter your email';
                                              } else if (!emailRegex
                                                  .hasMatch(value)) {
                                                return 'Please enter valid email';
                                              } else {
                                                return null;
                                              }
                                            }
                                            return null;
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 15),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Password",
                                            style: MyTextStyle.f14(
                                                appButton1Color),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ),
                                      CustomTextField(
                                          hint: "Password",
                                          readOnly: false,
                                          controller: password,
                                          baseColor: appPrimaryColor,
                                          borderColor: appButton1Color,
                                          errorColor: redColor,
                                          inputType: TextInputType.text,
                                          obscureText: showPassword,
                                          showSuffixIcon: true,
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              showPassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: appFirstColor,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                showPassword = !showPassword;
                                              });
                                            },
                                          ),
                                          maxLength: 80,
                                          onChanged: (val) {
                                            _formKey.currentState!.validate();
                                          },
                                          validator: (value) {
                                            if (value != null) {
                                              if (value.isEmpty) {
                                                return 'Please enter your password';
                                              } else {
                                                return null;
                                              }
                                            }
                                            return null;
                                          }),

                                      SizedBox(height: 10),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      loginLoad
                          ? const SpinKitCircle(
                          color: appPrimaryColor, size: 30)
                          : InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, AttsRoutes.bottomNavBarRoute);
                        },
                        child: appButton(
                            height: 50,
                            width: size.width * 0.90,
                            color: whiteColor,
                            buttonText: "Login"),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Do not have an account? ",
                                  style: MyTextStyle.f14(whiteColor)),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/signUp');
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => const SignUp()));
                                },
                                child: Text("Sign up",
                                    style: MyTextStyle.f14(appTitleColor)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
