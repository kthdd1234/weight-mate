import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class BottomNavigationProvider with ChangeNotifier {
  BottomNavigationEnum selectedEnumId = BottomNavigationEnum.record;

  setBottomNavigation({required BottomNavigationEnum enumId}) {
    selectedEnumId = enumId;
    notifyListeners();
  }
}
