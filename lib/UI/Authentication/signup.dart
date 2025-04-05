import 'package:atts/Controller/Authentication/authentication_controller.dart';
import 'package:atts/Reusable/button.dart';
import 'package:atts/Reusable/color.dart';
import 'package:atts/Reusable/customTextfield.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../Reusable/container_decoration.dart';
import '../../Reusable/text_styles.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    super.key,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController address = TextEditingController();
  final AuthController authController = Get.find();
  RegExp emailRegex = RegExp(r'\S+@\S+\.\S+');
  String? errorMessage;
  String _selectedCountryCode = "+91";
  var showPassword = true;
  bool loginLoad = false;
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: appBottomColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10,left: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image.asset(
                      alignment: Alignment.topCenter,
                      "assets/arrow.png",
                      width: size.width * 0.1,
                      height: size.height * 0.05,
                    ),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.only(
                        top: size.height * 0.001, left: 15, right: 15, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            decoration: LogoDecoration(),
                            child: Image.asset(
                              "assets/logo.png",
                              height: 200,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                          child: Text("Let's create your account",
                              style: MyTextStyle.f20(appButton1Color)),
                        ),

                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("User Name", style: MyTextStyle.f14(appButton1Color)),
                        ),
                        CustomTextField(
                            hint: "User Name",
                            readOnly: false,
                            controller: userName,
                            baseColor: appPrimaryColor,
                            borderColor: appButton1Color,
                            errorColor: redColor,
                            inputType: TextInputType.emailAddress,
                            showSuffixIcon: false,
                            fTextInputFormatter: FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9.@]")),
                            obscureText: false,
                            maxLength: 30,
                            onChanged: (val) {
                              _formKey.currentState!.validate();
                            },
                            validator: (value) {
                              if (value != null) {
                                if (value.isEmpty) {
                                  return 'Please enter your Name';
                                }  else {
                                  return null;
                                }
                              }
                              return null;
                            }),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Your Email", style: MyTextStyle.f14(appButton1Color)),
                        ),
                        CustomTextField(
                            hint: "Email Address",
                            readOnly: false,
                            controller: email,
                            baseColor: appPrimaryColor,
                            borderColor: appButton1Color,
                            errorColor: redColor,
                            inputType: TextInputType.emailAddress,
                            showSuffixIcon: false,
                            fTextInputFormatter: FilteringTextInputFormatter.allow(
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
                                } else if (!emailRegex.hasMatch(value)) {
                                  return 'Please enter valid email';
                                } else {
                                  return null;
                                }
                              }
                              return null;
                            }),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Password", style: MyTextStyle.f14(appButton1Color)),
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
                                showPassword ? Icons.visibility_off : Icons.visibility,
                                color: appButton1Color,
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
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Phone Number",
                              style: MyTextStyle.f14(appButton1Color)),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: appButton1Color,
                                  width: 1,
                                ),
                              ),
                              child: CountryCodePicker(
                                onChanged: (countryCode) {
                                  setState(() {
                                    _selectedCountryCode = countryCode.dialCode ?? "+60";
                                  });
                                },
                                initialSelection: _selectedCountryCode,
                                favorite: const ['+60', '+91', '+44'],
                                showCountryOnly: false,
                                textStyle: const TextStyle(color: appButton1Color),
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                                showFlag: false,
                              ),
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextField(
                                    hint: "Phone number",
                                    readOnly: false,
                                    controller: phoneNo,
                                    baseColor: appPrimaryColor,
                                    borderColor: appButton1Color,
                                    errorColor: redColor,
                                    inputType: TextInputType.number,
                                    showSuffixIcon: false,
                                    fTextInputFormatter:
                                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                    obscureText: false,
                                    maxLength: 11,
                                    onChanged: (val) {
                                      _formKey.currentState!.validate();
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your phone number';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:
                          Text("Address", style: MyTextStyle.f14(appButton1Color)),
                        ),
                        CustomTextField(
                            hint: "Address",
                            readOnly: false,
                            controller: address,
                            baseColor: appPrimaryColor,
                            borderColor: appButton1Color,
                            errorColor: redColor,
                            inputType: TextInputType.text,
                            showSuffixIcon: false,
                            obscureText: false,
                            maxLength: 20,
                            onChanged: (val) {
                              _formKey.currentState!.validate();
                            },
                            validator: (value) {
                              if (value != null) {
                                if (value.isEmpty) {
                                  return 'Please enter your Address';
                                } else {
                                  return null;
                                }
                              }
                              return null;
                            }
                        ),
                        SizedBox(height: 10),

                        SizedBox(height: 30),
                        loginLoad
                            ? const SpinKitCircle(color: appPrimaryColor, size: 30)
                            : InkWell(
                          onTap: () {
                            authController.signUp(email.text, password.text, _selectedCountryCode, phoneNo.text, userName.text, address.text);
                          },
                          child: appButton(
                              height: 50,
                              width: size.width * 0.90,
                              color: whiteColor,
                              buttonText: "Register"),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
