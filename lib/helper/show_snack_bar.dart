import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    backgroundColor: Color.fromARGB(255, 57, 130, 224),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(50),
  ));
}
