import 'package:Mowasil/screens/login/driver_registration.dart';
import 'package:Mowasil/screens/oder_info/orderinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/animations/scale_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class HaveOrder extends StatefulWidget {
  final void Function()? function;
  const HaveOrder({super.key, required this.function});

  @override
  State<HaveOrder> createState() => _HaveOrderState();
}

class _HaveOrderState extends State<HaveOrder> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Obtain the device's screen width for responsive sizing.
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust font size based on screen width.
    double fontSize = screenWidth < 70 ? 32 : 18;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "already have an Order? ",
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
        GestureDetector(
          child: Text(
            'YourOrder',
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
          onTap: widget.function,
        ),
      ],
    );
  }
}
