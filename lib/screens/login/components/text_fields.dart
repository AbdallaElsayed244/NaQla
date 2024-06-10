import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  final String text;
  final Icon icon;
  final bool hide;
  final TextInputType type;
  final TextEditingController? controller;
  final String? valid;
  final Function(String)? onChanged;

  TextFields({
    Key? key,
    required this.text,
    required this.icon,
    required this.hide,
    required this.type,
    this.controller,
    this.valid,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery to obtain device dimensions
    double deviceWidth = MediaQuery.of(context).size.width;

    // Responsive width calculation
    double containerWidth = deviceWidth * 0.8; // 80% of screen width
    double marginHorizontal = deviceWidth * 0.1; // 10% margin on each side

    return Container(
      width: containerWidth,
      height: 65,
      margin: EdgeInsets.only(
          top: 27, right: marginHorizontal, left: marginHorizontal),
      decoration: BoxDecoration(
        color: const Color(0xffD8D8D8),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Center(
        child: TextFormField(
          onChanged: onChanged,
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "field is requierd";
            }
            return null;
          },
          obscureText: hide,
          keyboardType: type,
          style: TextStyle(
            fontFamily: "noyh-bold",
            fontSize:
                34 * MediaQuery.of(context).textScaleFactor, // Scale text size
            color: const Color.fromARGB(255, 0, 0, 0),
            overflow: TextOverflow.ellipsis,
          ),
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            labelStyle: TextStyle(
              fontFamily: "noyh-bold",
              fontSize: 54 *
                  MediaQuery.of(context).textScaleFactor, // Scale text size
              color: const Color.fromARGB(255, 0, 0, 0),
              overflow: TextOverflow.ellipsis,
            ),
            hintText: text,
            suffixIcon: icon,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 17),
          ),
        ),
      ),
    );
  }
}
