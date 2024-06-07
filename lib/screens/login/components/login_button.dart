import 'package:flutter/material.dart';


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
            backgroundColor: const Color(0xff060644), //) Set text color to white
            elevation: 5,
          ), 
          onPressed: function,
          child: Text(
            type,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}
