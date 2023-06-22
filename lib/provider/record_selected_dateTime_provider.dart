import 'package:flutter/material.dart';

class ImportDateTimeProvider with ChangeNotifier {
  DateTime importDateTime = DateTime.now();

  DateTime getImportDateTime() {
    return importDateTime;
  }

  setImportDateTime(DateTime dataTime) {
    importDateTime = dataTime;
    notifyListeners();
  }
}
