import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:atts/Reusable/color.dart';
import 'package:atts/Reusable/text_styles.dart';
import 'package:atts/Routes/route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SecondSplashScreen extends StatefulWidget {
  const SecondSplashScreen({super.key});

  @override
  State<SecondSplashScreen> createState() => _SecondSplashScreenState();
}

class _SecondSplashScreenState extends State<SecondSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isPressed = false;
  int _currentIndex = 0;
  final List<String> images = [
    'assets/jewel1.jpg',
    'assets/jewel2.jpg',
  ];
  bool isSwipeComplete = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);

    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % images.length;
        });
      }
    });
  }

  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(
  //     vsync: this,
  //     duration: const Duration(seconds: 3),
  //   )..repeat();
  //
  //   _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
  //   Timer.periodic(const Duration(seconds: 3), (timer) {
  //     if (mounted) {
  //       setState(() {
  //         _currentIndex = (_currentIndex + 1) % images.length;
  //       });
  //     }
  //   });
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: Image.asset(
              images[_currentIndex],
              key: ValueKey<String>(images[_currentIndex]),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [blackColor.withOpacity(0.6), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                              'SHINE EVERY MOMENT',
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? uid = prefs.getString("uid");
                      print("Stored UID: $uid");
                      if (uid!.isEmpty) {
                        Navigator.pushNamed(context, AttsRoutes.loginRoute);
                      } else {
                        Navigator.pushNamed(context, AttsRoutes.bottomNavBarRoute);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.all(isPressed ? 4 : 0),
                      decoration: BoxDecoration(
                        gradient: isPressed
                            ? null
                            : const LinearGradient(
                                colors: [
                                  appButton2Color,
                                  appButton1Color,
                                  appButton2Color
                                ],
                              ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: CustomPaint(
                        painter: GradientBorderPainter(_animation),
                        child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pushReplacementNamed(
                                  context, AttsRoutes.loginRoute);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.transparent, // Button background
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 10),
                            ),
                            child: Text(
                              "Start Exploring",
                              style: MyTextStyle.f16(whiteColor,
                                  weight: FontWeight.w600),
                            )),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: Container(
                //     width: double.infinity,
                //     child: ElevatedButton(
                //       onPressed: () {
                //         Navigator.pushReplacementNamed(context,
                //             SundararajaPerumalRoutes.bottomNavBarRoute);
                //       },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: appButton2Color,
                //         foregroundColor: Colors.white, // Text color
                //         shadowColor: Colors.black, // Shadow color
                //         elevation: 5, // Elevation effect
                //         shape: RoundedRectangleBorder(
                //           borderRadius:
                //               BorderRadius.circular(10), // Rounded corners
                //         ),
                //         padding: EdgeInsets.symmetric(
                //             horizontal: 20, vertical: 12), // Padding
                //         textStyle: TextStyle(
                //             fontSize: 16,
                //             fontWeight: FontWeight.bold), // Text style
                //       ),
                //       child: Text('Get Start'),
                //     ),
                //   ),
                // ),

                // Center(
                //   child: Container(
                //     width: size.width * 0.7,
                //     //height: size.height * 0.07,
                //     decoration: BoxDecoration(
                //       gradient: const LinearGradient(
                //         colors: [appFirstColor, appPrimaryColor],
                //         begin: Alignment.topLeft,
                //         end: Alignment.bottomRight,
                //       ),
                //       borderRadius: BorderRadius.circular(30.0),
                //     ),
                //     child: SwipeButton(
                //       thumb: AnimatedContainer(
                //         duration: const Duration(milliseconds: 300),
                //         decoration: BoxDecoration(
                //           color: isSwipeComplete ? appPrimaryColor : whiteColor,
                //           shape: BoxShape.circle,
                //         ),
                //         width: 50,
                //         height: 50,
                //         child: Center(
                //           child: AnimatedSwitcher(
                //             duration: const Duration(milliseconds: 300),
                //             transitionBuilder: (child, animation) =>
                //                 ScaleTransition(scale: animation, child: child),
                //             child: isSwipeComplete
                //                 ? const Icon(Icons.check,
                //                     size: 28,
                //                     color: Colors.white,
                //                     key: ValueKey(
                //                         "tick")) // ✅ Tick Icon with white color
                //                 : const Icon(Icons.arrow_forward_ios,
                //                     size: 24,
                //                     color: Colors.black,
                //                     key: ValueKey(
                //                         "slide")), // ➡ Slide Icon with black color
                //           ),
                //         ),
                //       ),
                //       height: 60.0,
                //
                //       // width: 286.0,
                //       onSwipe: () => _onSwipeCompleted(context),
                //       activeTrackColor: Colors.transparent,
                //       borderRadius: BorderRadius.circular(30.0),
                //       child: Center(
                //         child: Padding(
                //           padding: const EdgeInsets.only(left: 30),
                //           child: Text(
                //             "Swipe to Explore",
                //             textAlign: TextAlign.center,
                //             style: MyTextStyle.f18(
                //               whiteColor,
                //               weight: FontWeight.w700,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  final Animation<double> animation;

  GradientBorderPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.amber.shade200,
          Colors.amber.shade400,
          Colors.amber.shade600,
          Colors.amber.shade800,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
        transform: GradientRotation(animation.value),
      ).createShader(Rect.fromCircle(
          center: size.center(Offset.zero), radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect rRect =
        RRect.fromRectAndRadius(rect, const Radius.circular(30));

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
