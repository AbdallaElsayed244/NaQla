import 'package:flutter/material.dart';

class ProgressProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void incrementIndex() {
    if (_selectedIndex < 3) {
      _selectedIndex++;
      notifyListeners();
    }
  }

  void resetProgress() {
    _selectedIndex = 0;
    notifyListeners();
  }
}