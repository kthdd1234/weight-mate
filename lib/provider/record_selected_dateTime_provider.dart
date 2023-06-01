import 'package:flutter/material.dart';

class ImportDateTimeProvider with ChangeNotifier {
  late DateTime importDateTime;

  DateTime getImportDateTime() {
    return importDateTime;
  }

  setImportDateTime(DateTime dataTime) {
    importDateTime = dataTime;
    notifyListeners();
  }
}
