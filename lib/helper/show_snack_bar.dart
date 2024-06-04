import 'package:Mowasil/helper/app_colors.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String? text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Center(child: Text(text!)),
      backgroundColor: Color.fromARGB(255, 179, 37, 27),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 770, left: 50, right: 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      )));
}
