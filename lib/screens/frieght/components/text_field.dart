import 'package:flutter/material.dart';

class TextFrieght extends StatelessWidget {
  final String name;
  final Function()? navigate;
  final TextInputType type;
  const TextFrieght(
      {super.key, required this.name, this.navigate, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 21),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      width: 350,
      height: 70,
      child: TextField(
          textInputAction: TextInputAction.done,
          keyboardType: type,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: name,
            hintStyle: TextStyle(fontSize: 18),
            labelStyle: TextStyle(fontSize: 33),
            suffixIcon: IconButton(
              icon: Icon(Icons.keyboard_arrow_right_outlined),
              iconSize: 40,
              onPressed: navigate,
            ),
          )),
    );
  }
}
