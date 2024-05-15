import 'package:Mowasil/screens/login/driver_login.dart';
import 'package:Mowasil/screens/login/driver_registration.dart';
import 'package:Mowasil/stripe_payment/payment_manager.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Import for Future.delayed
import 'package:Mowasil/screens/login/user_login.dart';
import 'package:Mowasil/screens/login/components/new_account.dart';
import 'package:Mowasil/screens/login/components/sign_in_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class ToLogin extends StatefulWidget {
  const ToLogin({Key? key}) : super(key: key);

  @override
  State<ToLogin> createState() => _ToLoginState();
}

class _ToLoginState extends State<ToLogin> {
  bool isVisible = true;
  bool isVisible2 =
      true; // Track the container's visibility (initially visible)
  double containerOffset = 0.0;
  double containerOffset2 = 0.0; // Offset for sliding right
  bool showUserLogin = false;
  bool showDriverLogin = false;

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
      containerOffset = isVisible ? 0.0 : MediaQuery.of(context).size.width;
    });

    // Set showUserLogin flag after a delay for smooth transition
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        showUserLogin = true;
      });
    });
  }

  void toggleVisibility2() {
    setState(() {
      isVisible2 = !isVisible2;
      containerOffset2 = isVisible2 ? 0.0 : MediaQuery.of(context).size.width;
    });

    // Set showUserLogin flag after a delay for smooth transition
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        showDriverLogin = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    ScreenUtil.init(context);
    return Stack(
      children: [
        Positioned(
          right: .0, // Align to the right edge
          bottom: 90.0, // Position at the bottom
          child: AnimatedOpacity(
            opacity: isVisible ? 1.0 : 0.5, // Control visibility with opacity
            duration:
                const Duration(milliseconds: 100), // Adjust for desired speed
            curve: Curves.easeInCubic, // Add easing for natural feel
            child: Container(
              width: screenWidth,
              height: screenHeight / 3,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(100)),
              ),
              padding: EdgeInsets.only(top: 30.h),
              margin: EdgeInsets.only(top: 20.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginButtons(
                      text: "Login as User",
                      onTap: toggleVisibility, // Call toggleVisibility on tap
                    ),
                    LoginButtons(
                      text: "Login as Driver",
                      onTap: toggleVisibility2,
                    ),
                    const SizedBox(height: 60),
                    NewAccount(),
                  ],
                ),
              ),
            ),
          ),
        ),

        if (!isVisible)
          showUserLogin
              ? UserLogin(
                  onBack: toggleVisibility,
                  context: context, // Pass the toggle function
                )
              : const SizedBox.shrink(),
        if (!isVisible2)
          showDriverLogin
              ? DriverLogin(
                  onBack: toggleVisibility2,
                  context: context, // Pass the toggle function
                )
              : const SizedBox.shrink(), // Placeholder while waiting
      ],
    );
  }
}
