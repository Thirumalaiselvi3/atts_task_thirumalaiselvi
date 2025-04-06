import 'package:atts/Alertbox/AlertDialogBox.dart';
import 'package:atts/Alertbox/common_alert.dart';
import 'package:atts/Controller/Landing%20Page/profile_controller.dart';
import 'package:atts/Reusable/color.dart';
import 'package:atts/Reusable/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ProfileController controller;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('uid');
    if (userId != null) {
      controller = Get.put(ProfileController(userId));
      setState(() {}); // trigger rebuild
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appFirstColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: SpinKitCircle(
              color: appBottomColor,
              size: 50.0,
            ),
          );
        }

        final user = controller.user.value;

        if (user == null) {
          return const Center(
            child: Text(
              "No user found.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }

        return Column(
          children: [
            Container(
              height: 250,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: appBottomColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: appBottomColor),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.username.toUpperCase() ?? "No Name",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: appBottomColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _infoTile(
                        icon: Icons.person,
                        label: "Name",
                        value: user.username),
                    const Divider(color: appBottomColor),
                    _infoTile(
                        icon: Icons.email, label: "Email", value: user.email),
                    const Divider(
                      color: appBottomColor,
                    ),
                    _infoTile(
                        icon: Icons.phone, label: "Phone", value: user.phone),
                    const Divider(color: appBottomColor),
                    _infoTile(
                        icon: Icons.home,
                        label: "Address",
                        value: user.address),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                CommonAlert(
                  context: context,
                  title: "Logout",
                  description: "Are you sure you want to logout?",

                  onOkPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    Get.offAllNamed('/login');
                  },
                );

              },
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: appBottomColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _infoTile(
                        icon: Icons.logout, label: "Logout", value: 'Logout'),
                  )),
            ),
          ],
        );
      }),
    );
  }

  Widget _infoTile(
      {required IconData icon, required String label, required String? value}) {
    return Row(
      children: [
        Icon(icon, color: appBottomColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(value ?? "N/A", style: MyTextStyle.f16(appBottomColor)),
        ),
      ],
    );
  }
}
