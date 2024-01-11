import 'package:flutter/material.dart';

class EnabledProvider extends ChangeNotifier {
  bool isEnabled = false;

  setEnabled(enabled) {
    isEnabled = enabled;
    notifyListeners();
  }
}
