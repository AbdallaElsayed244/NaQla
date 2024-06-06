import 'package:flutter/material.dart';

class TextFrieght extends StatelessWidget {
  final String name;
  final Function()? ontap;
  final TextInputType type;
  final TextEditingController? controller;
  final Icon icon;
   final void Function(String)? onChanged;
     final String? Function(String?)? validator;
  const TextFrieght(
      {super.key,
      required this.name,
      this.ontap,
      required this.type,
      this.controller, required this.icon, this.onChanged, this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 21),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      width: 350,
      height: 70,
      child: TextFormField(
         validator: validator,
           onChanged: onChanged,
          controller: controller,
          textInputAction: TextInputAction.done,
          keyboardType: type,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: name,
            hintStyle: TextStyle(fontSize: 18),
            labelStyle: TextStyle(fontSize: 33),
            suffixIcon: IconButton(
              icon: icon,
              iconSize: 40,
              onPressed: ontap,
            ),
          )),
    );
  }
}
