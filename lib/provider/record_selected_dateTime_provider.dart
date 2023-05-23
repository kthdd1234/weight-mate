import 'package:flutter/material.dart';

class RecordSelectedDateTimeProvider with ChangeNotifier {
  late DateTime selectedDateTime;

  DateTime getSelectedDateTime() {
    return selectedDateTime;
  }

  setSelectedDateTime(DateTime dataTime) {
    selectedDateTime = dataTime;
    notifyListeners();
  }
}
