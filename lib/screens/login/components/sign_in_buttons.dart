import 'package:flutter/material.dart';

// To ensure better practices, I'll rename classes to follow Dart's naming conventions
class LoginButtons extends StatefulWidget {
  final String? text;
  final Function()? onTap;

  const LoginButtons({
    Key? key,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  State<LoginButtons> createState() => _LoginButtonsState();
}

class _LoginButtonsState extends State<LoginButtons> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery to get device dimensions
    double deviceWidth = MediaQuery.of(context).size.width;

    // Responsive width and margins
    double buttonWidth = deviceWidth * 0.6; // 80% of screen width
    double horizontalMargin = deviceWidth * 0.1; // 10% margin on each side

    return GestureDetector(
      onTapDown: (TapDownDetails details) => setState(() => _isPressed = true),
      onTapUp: (TapUpDetails details) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        width: buttonWidth,
        height: 80, // Consider making this responsive if needed
        margin: EdgeInsets.only(
            top: 47, right: horizontalMargin, left: horizontalMargin),
        decoration: BoxDecoration(
          color: _isPressed ? Colors.lightBlueAccent : const Color(0xffD8D8D8),
          borderRadius: BorderRadius.circular(28),
        ),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        child: Center(
          child: Text(
            widget.text ?? "Button", // Provide a default text if null
            style: TextStyle(
                fontFamily: "noyh-bold",
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 38 *
                    MediaQuery.of(context)
                        .textScaleFactor // Responsive text size
                ),
          ),
        ),
      ),
    );
  }
}
