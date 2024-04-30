import 'package:flutter/material.dart';

PreferredSize? customAppBarProfile() {
  return PreferredSize(
    preferredSize: Size.fromHeight(0),
    child: AppBar(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    ),
  );
}
