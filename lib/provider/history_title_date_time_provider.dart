import 'package:flutter/material.dart';

class HistoryTitleDateTimeProvider with ChangeNotifier {
  DateTime historyTitleDateTime = DateTime.now();

  DateTime dateTime() {
    return historyTitleDateTime;
  }

  setHistoryTitleDateTime(DateTime dateTime) {
    historyTitleDateTime = dateTime;
    notifyListeners();
  }
}
