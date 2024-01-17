import 'package:flutter/material.dart';

class HistoryDateTimeProvider with ChangeNotifier {
  DateTime historyDateTime = DateTime.now();

  DateTime dateTime() {
    return historyDateTime;
  }

  setHistoryDateTime(DateTime dateTime) {
    historyDateTime = dateTime;
    notifyListeners();
  }
}
