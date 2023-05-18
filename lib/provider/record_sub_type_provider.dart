import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class RecordSubTypeProvider with ChangeNotifier {
  RecordSubTypes seletedRecordSubType = RecordSubTypes.none;

  RecordSubTypes getSeletedRecordSubType() {
    return seletedRecordSubType;
  }

  setSeletedRecordSubType(RecordSubTypes enumId) {
    seletedRecordSubType = enumId;
    notifyListeners();
  }
}
