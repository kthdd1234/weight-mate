import 'package:flutter/material.dart';

class TitleDateTimeProvider with ChangeNotifier {
  DateTime titleDateTime = DateTime.now();

  DateTime dateTime() {
    return titleDateTime;
  }

  setTitleDateTime(DateTime dateTime) {
    titleDateTime = dateTime;
    notifyListeners();
  }
}
