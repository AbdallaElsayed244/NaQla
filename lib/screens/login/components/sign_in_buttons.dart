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
    double devicehieght = MediaQuery.of(context).size.height;

    // Responsive width and margins
    double buttonWidth = deviceWidth * 0.6; // 80% of screen width
    double buttonhieght = devicehieght * 0.6;

    return GestureDetector(
      onTapDown: (TapDownDetails details) => setState(() => _isPressed = true),
      onTapUp: (TapUpDetails details) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: Opacity(
        opacity: 0.7,
        child: AnimatedContainer(
          width: buttonWidth / 1.5,
          height:
              buttonhieght / 10, // Consider making this responsive if needed

          decoration: BoxDecoration(
            color: _isPressed
                ? Colors.lightBlueAccent
                : const Color.fromARGB(255, 155, 154, 154),
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
                  fontSize: 0.09 * buttonWidth // Responsive text size
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
