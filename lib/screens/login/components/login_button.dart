import 'package:Mowasil/screens/frieght/frieght_page.dart';
import 'package:Mowasil/screens/oder_info/orderinfo.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class LoginButton extends StatelessWidget {
  final String type;
  final Function()? function;
  const LoginButton({super.key, required this.type, this.function});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      height: 60,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xff060644), //) Set text color to white
            elevation: 5,
          ), // Set button elevation (shadow),
          onPressed: function,
          child: Text(
            type,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}
