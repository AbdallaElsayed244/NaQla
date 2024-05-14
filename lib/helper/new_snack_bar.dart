import 'package:flutter/material.dart';

void showWarningSnackBar(BuildContext context, String message) {
// Find the Scaffold in the widget tree and use it to show a SnackBar.
  ScaffoldMessengerState _scaffold = ScaffoldMessenger.of(context);

  // Find the Scaffold in the widget tree and use it to show a SnackBar.
  _scaffold.showSnackBar(SnackBar(
    content: InkWell(
      onTap: () {
        _scaffold.hideCurrentSnackBar();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(
              "",
              fit: BoxFit.contain,
              width: 20,
              color: Colors.amber),
          const SizedBox(
            width: 10,
          ),
          Text(
            '$message',
            maxLines: 2,
          ),
        ],
      ),
    ),
    duration: const Duration(seconds: 10),
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
  ));
}