import 'package:flutter/material.dart';

Widget buildLoadingIndicator() {
  return Container(
    width: 40, // Adjust width/height as needed
    height: 40,
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey), // Customize color
    ),
  );
}