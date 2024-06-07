import 'package:Mowasil/screens/login/driver_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Import for Future.delayed
import 'package:Mowasil/screens/login/user_login.dart';
import 'package:Mowasil/screens/login/components/new_account.dart';
import 'package:Mowasil/screens/login/components/sign_in_buttons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ToLogin extends StatefulWidget {
  const ToLogin({Key? key}) : super(key: key);

  @override
  State<ToLogin> createState() => _ToLoginState();
}

class _ToLoginState extends State<ToLogin> {
  bool isVisible = true;
  bool isVisible2 = true;
  double containerOffset = 0.0;
  double containerOffset2 = 0.0;
  bool showUserLogin = false;
  bool showDriverLogin = false;

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
      containerOffset = isVisible ? 0.0 : MediaQuery.of(context).size.width;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        showUserLogin = !isVisible; // Corrected to reflect the actual state
      });
    });
  }

  void toggleVisibility2() {
    setState(() {
      isVisible2 = !isVisible2;
      containerOffset2 = isVisible2 ? 0.0 : MediaQuery.of(context).size.width;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        showDriverLogin = !isVisible2; // Corrected to reflect the actual state
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Stack(
      children: [
        if (!isVisible && showUserLogin)
          UserLogin(
            onBack: toggleVisibility,
            context: context,
          ),
        if (!isVisible2 && showDriverLogin)
          DriverLogin(
            onBack: toggleVisibility2,
            context: context,
          ),
        AnimatedOpacity(
          opacity: (isVisible && isVisible2) ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInCubic,
          child: Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        LoginButtons(
                          text: "Login as User",
                          onTap: toggleVisibility,
                        ),
                        LoginButtons(
                          text: "Login as Driver",
                          onTap: toggleVisibility2,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    const NewAccount(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
