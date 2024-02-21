import 'package:flutter/material.dart';

class HistoryImportDateTimeProvider with ChangeNotifier {
  DateTime historyimportDateTime = DateTime.now();

  DateTime getHistoryImportDateTime() {
    return historyimportDateTime;
  }

  setHistoryImportDateTime(DateTime dataTime) {
    historyimportDateTime = dataTime;
    notifyListeners();
  }
}
