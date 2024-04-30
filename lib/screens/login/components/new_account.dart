import 'package:Mowasil/screens/login/driver_registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/animations/scale_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../user_registration.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class NewAccount extends StatefulWidget {
  const NewAccount({super.key});

  @override
  State<NewAccount> createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccount> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Obtain the device's screen width for responsive sizing.
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust font size based on screen width.
    double fontSize = screenWidth < 800 ? 22 : 20;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
        GestureDetector(
          child: Text(
            'Create an account',
            style: TextStyle(
              fontSize: fontSize,
              color: _isPressed
                  ? const Color.fromARGB(255, 6, 124, 214)
                  : Colors.lightBlueAccent,
              fontWeight: FontWeight.bold, // Added for emphasis
            ),
          ),
          onTapDown: (TapDownDetails details) =>
              setState(() => _isPressed = true),
          onTapUp: (TapUpDetails details) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: () {
            AwesomeDialog(
              context: context,
              keyboardAware: true,
              dismissOnBackKeyPress: false,
              dialogType: DialogType.noHeader,
              animType: AnimType.topSlide,
              dialogBackgroundColor: Color.fromARGB(255, 232, 232, 233),
              btnCancelText: "Become a User",
              btnOkText: "Become a Driver",
              title: 'Create new account?',
              // padding: const EdgeInsets.all(5.0),
              desc: 'choose to be a Driver or User.',
              descTextStyle: TextStyle(fontSize: 20),
              btnOkColor: Color(0xff060644),
              btnCancelColor: Color(0xff393e46),

              btnCancelOnPress: () {
                Navigator.of(context).push(PageAnimationTransition(
                    page: const UserReg(),
                    pageAnimationType: ScaleAnimationTransition()));
              },
              btnOkOnPress: () {
                Navigator.of(context).push(PageAnimationTransition(
                    page: const DriverReg(),
                    pageAnimationType: ScaleAnimationTransition()));
              },
            ).show();
          },
        ),
      ],
    );
  }
}
