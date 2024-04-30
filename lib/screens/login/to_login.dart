import 'package:Mowasil/screens/login/driver_login.dart';
import 'package:Mowasil/screens/login/driver_registration.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Import for Future.delayed
import 'package:Mowasil/screens/login/user_login.dart';
import 'package:Mowasil/screens/login/components/new_account.dart';
import 'package:Mowasil/screens/login/components/sign_in_buttons.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class ToLogin extends StatefulWidget {
  const ToLogin({Key? key}) : super(key: key);

  @override
  State<ToLogin> createState() => _ToLoginState();
}

class _ToLoginState extends State<ToLogin> {
  bool isVisible = true; // Track the container's visibility (initially visible)
  double containerOffset = 0.0; // Offset for sliding right
  bool showUserLogin = false; // Flag for delayed UserLogin appearance

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
      containerOffset = isVisible ? 0.0 : MediaQuery.of(context).size.width;
    });

    // Set showUserLogin flag after a delay for smooth transition
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        showUserLogin = true;
      });
    });
  }

  void toggleVisibility2() {
    setState(() {
      isVisible = !isVisible;
      containerOffset = isVisible ? 0.0 : MediaQuery.of(context).size.width;
    });

    // Set showUserLogin flag after a delay for smooth transition
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        showUserLogin = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          right: 0.0, // Align to the right edge
          bottom: 0.0, // Position at the bottom
          child: AnimatedOpacity(
            opacity: isVisible ? 1.0 : 0.5, // Control visibility with opacity
            duration:
                const Duration(milliseconds: 600), // Adjust for desired speed
            curve: Curves.easeInCubic, // Add easing for natural feel
            child: Container(
              width: screenWidth,
              height: screenHeight / 2,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
              ),
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
        if (!isVisible)
          showUserLogin
              ? UserLogin(
                  onBack: toggleVisibility, // Pass the toggle function
                )
              : const SizedBox.shrink(),
        if (!isVisible)
          showUserLogin
              ? DriverLogin(
                  onBack: toggleVisibility2, // Pass the toggle function
                )
              : const SizedBox.shrink(), // Placeholder while waiting
      ],
    );
  }
}
