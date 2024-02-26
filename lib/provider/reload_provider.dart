import 'package:flutter/material.dart';

class ReloadProvider extends ChangeNotifier {
  bool isReload = false;

  setReload(state) {
    isReload = state;
    notifyListeners();
  }
}
