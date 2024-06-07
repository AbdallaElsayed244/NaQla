// Function to handle back button press
import 'package:flutter/material.dart';

Future<bool> _onWillPop(context) async {
  if (Navigator.canPop(context)) {
    return true; // Allow normal back button behavior
  } else {
    final shouldExit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to exit?'),
        content: const Text('Press back button again to confirm.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Exit
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    return shouldExit ?? false; // Handle null case for clarity
  }
}
