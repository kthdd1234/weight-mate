import 'package:flutter/material.dart';

class YearDateTimeProvider with ChangeNotifier {
  DateTime yearDateTime = DateTime.now();

  DateTime dateTime() {
    return yearDateTime;
  }

  setYearDateTime(DateTime dateTime) {
    yearDateTime = dateTime;
    notifyListeners();
  }
}
