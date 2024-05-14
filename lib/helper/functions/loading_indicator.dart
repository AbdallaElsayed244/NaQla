import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildLoadingIndicator() {
  return Container(
    width: 40, // Adjust width/height as needed
    height: 40,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey), // Customize color
    ),
  );
}