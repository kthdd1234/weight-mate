import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class RecordIconTypeProvider with ChangeNotifier {
  RecordIconTypes seletedRecordIconType = RecordIconTypes.none;

  RecordIconTypes getSeletedRecordIconType() {
    return seletedRecordIconType;
  }

  setSeletedRecordIconType(RecordIconTypes enumId) {
    seletedRecordIconType = enumId;
    notifyListeners();
  }
}
